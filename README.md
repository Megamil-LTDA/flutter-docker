# Flutter Docker Development Environment

Este projeto fornece um ambiente de desenvolvimento Flutter completo dentro de um container Docker, permitindo desenvolvimento consistente em diferentes sistemas operacionais (macOS, Windows e Linux).

## Benefícios

- **Configuração única**: O mesmo ambiente funciona em qualquer sistema operacional
- **Sem instalação local**: Não é necessário instalar Flutter, Dart ou Android SDK no seu sistema
- **Consistência entre equipes**: Todos os desenvolvedores usam exatamente o mesmo ambiente
- **Portabilidade**: Fácil migração entre computadores diferentes

## Pré-requisitos

- Docker
- Docker Compose
- Android Studio ou VSCode

## Configuração inicial

1. Clone este repositório:
```bash
git clone https://github.com/Megamil-LTDA/flutter-docker.git
cd flutter-docker
```

2. Crie um arquivo .env baseado no .env-sample:
```bash
cp .env-sample .env
```

3. Torne o script auxiliar executável:
```bash
chmod +x flutter.sh
```

4. Inicie o container:
```bash
docker-compose up -d
```

5. Aguarde até que o Flutter SDK seja copiado para a pasta `workspace`

## IMPORTANTE: Como executar comandos Flutter

Como os binários Flutter/Dart são compilados para Linux dentro do container, você NÃO pode executá-los diretamente do seu sistema operacional host (macOS, Windows). Você deve sempre executar os comandos Flutter dentro do container.

### Usando o script auxiliar

Use o script `flutter.sh` incluído neste projeto para executar qualquer comando Flutter:

```bash
# Verificar ambiente Flutter
./flutter.sh doctor

# Criar um novo projeto
./flutter.sh create meu_app

# Obter dependências
cd projects/meu_app
../../flutter.sh pub get
```

### Método alternativo: execução direta no container

```bash
docker-compose exec flutter flutter [comando]
```

Por exemplo:
```bash
docker-compose exec flutter flutter doctor
docker-compose exec flutter flutter pub get
```

## Usando com IDEs

### VSCode (Recomendado)

O VSCode tem melhor suporte para este tipo de ambiente:

1. Instale a extensão "Remote - Containers" no VSCode
2. Abra a pasta raiz deste projeto no VSCode
3. Clique em "Reopen in Container" quando perguntado (ou use a paleta de comandos)
4. O VSCode será reaberto dentro do container com todas as extensões e configurações prontas

### Android Studio

Como o Android Studio não tem suporte nativo para desenvolvimento dentro de containers, você precisará configurá-lo para usar o script auxiliar:

1. Abra o Android Studio
2. Vá em `Preferences > Tools > External Tools`
3. Adicione uma nova ferramenta:
   - Name: Flutter
   - Program: /caminho/para/seu/projeto/flutter.sh
   - Arguments: $FilePathRelativeToProjectRoot$
   - Working directory: $ProjectFileDir$

4. Para abrir um projeto, use `File > Open` e navegue até a pasta `projects` deste projeto

## Estrutura de diretórios

- `workspace/`: Contém o Flutter SDK
- `projects/`: Seus projetos Flutter
- `.devcontainer/`: Configuração para desenvolvimento com VSCode
- `Dockerfile`: Definição do ambiente de desenvolvimento
- `docker-compose.yml`: Configuração do container e volumes

## Executando aplicativos Flutter Web

Para executar um aplicativo Flutter Web acessível do host:

```bash
cd projects/meu_app
../../flutter.sh run -d web-server --web-port=8080 --web-hostname=0.0.0.0
```

Acesse o app pela URL: http://localhost:8080

## Solução de problemas

### Erro: "cannot execute binary file"

Se você ver um erro como:
```
cannot execute binary file
```

Isso significa que você está tentando executar os binários Flutter/Dart diretamente do seu sistema host. Estes binários são compilados para Linux e só funcionam dentro do container.

Solução: Use sempre o script auxiliar (`./flutter.sh`) ou execute os comandos diretamente no container (`docker-compose exec flutter flutter comando`).

## Contribuição

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request.
