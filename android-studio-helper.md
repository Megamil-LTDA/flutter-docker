# Configurando o Android Studio com Flutter Docker

Este guia explica como configurar o Android Studio para trabalhar com o ambiente Flutter Docker.

## Problema

O problema comum é que os binários Flutter/Dart dentro da pasta `workspace` são compilados para Linux e não funcionam diretamente no macOS ou Windows. Se você tentar configurar o Android Studio para apontar para essa pasta, verá erros como:

```
cannot execute binary file
/bin/cache/dart-sdk/bin/dart: Undefined error: 0
```

## Solução 1: Instalar Flutter localmente para o Android Studio (Recomendado)

A abordagem mais simples é ter uma instalação do Flutter no seu macOS apenas para o Android Studio usar para análise de código, enquanto a execução real acontece no Docker.

1. Instale o Flutter localmente seguindo as instruções em [flutter.dev](https://flutter.dev/docs/get-started/install)

2. Configure o Android Studio para usar essa instalação local do Flutter:
   - Abra o Android Studio
   - Vá em Preferences > Languages & Frameworks > Flutter
   - Defina o Flutter SDK path para sua instalação local (por exemplo: `/Users/seu_usuario/flutter`)

3. Para abrir projetos:
   - Use File > Open para abrir projetos da pasta `projects`
   - Para executar, use o script `flutter.sh` em vez dos botões do Android Studio

## Solução 2: Configurar External Tools no Android Studio

Você pode configurar comandos Flutter como ferramentas externas:

1. Abra o Android Studio
2. Vá em Preferences > Tools > External Tools
3. Adicione uma nova ferramenta:
   - Name: Flutter Run
   - Program: `/caminho/completo/para/flutter.sh`
   - Arguments: `run`
   - Working directory: `$ProjectFileDir$`

4. Repita para outros comandos como `pub get`, `doctor`, etc.

## Solução 3: Usar o VSCode (Melhor suporte)

O VSCode com a extensão Remote Containers tem melhor suporte para desenvolvimento em containers:

1. Instale o VSCode
2. Instale a extensão "Remote - Containers"
3. Abra a pasta do projeto no VSCode
4. Clique em "Reopen in Container"

## Fluxo de trabalho híbrido

Um fluxo de trabalho eficiente seria:

1. Usar o Android Studio com Flutter local para:
   - Edição de código
   - Análise estática
   - Navegação no código
   
2. Usar o script `flutter.sh` para:
   - Execução de aplicativos
   - Instalação de dependências
   - Compilação
   - Testes

Isso combina as vantagens do IDE com a consistência do ambiente Docker.

## Lembretes importantes

- NUNCA tente executar os binários da pasta `workspace` diretamente
- Sempre use `./flutter.sh` ou `docker-compose exec flutter flutter [comando]`
- Certifique-se de que o container Docker está rodando antes de executar comandos
- Se precisar atualizar o Flutter, faça isso através do Docker, não localmente 