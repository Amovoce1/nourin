<h2 align='center'>Nourin</h2>

### O que é?

O [Nourin](https://t.me:443/Niruon_bot) é um bot desenvolvido para o Telegram. Ele usa a API de login e autenticação de dados do Meu Vivo para realizar as seguintes operações:

- Consultar informações pessoais associadas ao titular de linhas Vivo Móvel
  -  As informações retornadas pela API incluem: nome, CPF, data de nascimento, endereço e plano atualmente ativo.
- Envio em massa de mensagens de texto (spam) para linhas móveis
  -  As mensagens podem ser enviadas para linhas móveis de qualquer operadora. Não há limites de envio.

### Propósitos?

Este bot tem como objetivo principal alertar usuários e não-usuários da Vivo sobre os métodos e as formas questionáveis de processamento de dados que a empresa utiliza em seus serviços online, tais como o Meu Vivo.

O Nourin é destinado apenas para fins de estudo e análise. O mau uso desse software é de total responsabilidade do usuário.

## Para desenvolvedores

O Nourin é escrito em bash, então ele usufrui de comandos/dependências geralmente disponíveis em sistemas Unix/Linux para funcionar. Abaixo estão listadas todas as dependências necessárias para executá-lo:

- `bash`
   - O bash é a base do Nourin. Ele interpreta todos os comandos presentes no script `Nourin.sh` e os executa.
- `curl`
   - O curl é usado para realizar requisições e enviar dados para as APIs do Telegram e Meu Vivo.
- `jq`
   - O jq é usado para processar as estruturas de dados json recebidos através das APIs do Telegram e Meu Vivo.
- `git`
   - O git é usado para interagir com o repositório do Nourin no GitHub.

### Instalação

#### Debian/Ubuntu

Em sistemas Debian e Ubuntu, instale todos as dependências necessárias usando o `apt`

```
# apt --assume-yes update
# apt --assume-yes install 'curl' 'jq' 'git'
```

#### Fedora/CentOS

Em sistemas Fedora e CentOS, instale todos as dependências necessárias usando o `yum`

```
# yum -y install 'curl' 'jq' 'git'
```

#### Arch Linux

No Arch Linux, instale todos as dependências necessárias usando o `pacman`

```
# pacman --sync --refresh
# pacman --sync 'curl' 'jq' 'git'
```

#### openSUSE

No openSUSE, instale todos as dependências necessárias usando o `zypper`

```
# zypper refresh
# zypper install 'curl' 'jq' 'git'
```

### Código

Para obter o código fonte do bot, clone o repositório usando o `git`:

```
$ git clone --branch 'master' 'https://github.com/Niruon/Nourin.git' ~/Nourin
```

### Configuração

No arquivo `Nourin.sh`, na linha 876, há o seguinte conteúdo:

```
init --token 'SEU_TOKEN_AQUI'
```

Substitua o `SEU_TOKEN_AQUI` pelo token do bot que você criou usando o [BotFather](https://t.me:443/BotFather)

### Execução

Para iniciar o bot, execute o seguinte no seu terminal:

```
$ bash ~/Nourin/Nourin.sh
```

A partir desse momento, o bot já deverá estar recebendo a processando as mensagens enviadas pelo usuário (caso haja alguma).

O processo de verificação de atualizações é executado em primeiro plano. As atualizações recebidas são processadas simultaneamente em segundo plano.

Para finalizar o processo principal, pressione `CTRL` + `C` no seu teclado. Para finalizar operações executando em segundo plano, descubra o PID do processo (`ps -f`) e finalize-o manualmente.

## Contato

Quer falar alguma coisa? Precisa de alguma ajuda? [Crie uma issue](https://github.com:443/Niruon/Nourin/issues) ou [envie um e-mail](mailto:nourin@telegmail.com).

## Licença

O Nourin está licenciado sobre a [GNU Lesser General Public License v3.0](LICENSE).

## Softwares de terceiros

O Nourin inclui alguns softwares de terceiros em seu código fonte. Veja-os abaixo:

- **ShellBot**
  - Desenvolvedor: Juliano Santos ([xSHAMANx](https://github.com:443/xSHAMANx))
  - Repositório: [shellscriptx/shellbot](https://github.com:443/shellscriptx/shellbot)
  - Licença: [GNU General Public License v3.0](https://github.com:443/shellscriptx/shellbot/blob/master/LICENSE.txt)

