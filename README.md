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

3. Torne os scripts auxiliares executáveis:
```bash
chmod +x flutter.sh
chmod +x flutter-android-studio.sh
```

4. Configure o ambiente com um único comando:
```bash
./flutter.sh setup
```

Este comando irá:
- Criar a pasta workspace se não existir
- Iniciar o container Docker
- Garantir que o Flutter SDK seja copiado corretamente

5. Verifique se a instalação está correta:
```bash
./flutter.sh doctor
```

## Usando com IDEs

### VSCode (Abordagem recomendada para novos desenvolvedores)

O VSCode com a extensão Remote Containers proporciona a melhor experiência:

1. Instale o VSCode
2. Instale a extensão "Remote - Containers"
3. Abra a pasta raiz deste projeto no VSCode
4. Clique em "Reopen in Container" quando perguntado (ou use a paleta de comandos)
5. O VSCode será reaberto dentro do container com todas as extensões e configurações prontas

### Android Studio 

Há uma integração especial para o Android Studio que permite desenvolver sem precisar instalar o Flutter localmente:

1. Certifique-se de que o script `flutter-android-studio.sh` esteja com permissão de execução
2. Configure as ferramentas externas no Android Studio conforme o guia [android-studio-integration.md](android-studio-integration.md)
3. Use o menu Tools > External Tools ou os atalhos configurados para executar comandos Flutter

Essa integração permite:
- Abrir projetos Flutter do diretório `projects` no Android Studio
- Executar comandos Flutter diretamente do Android Studio
- Tudo funciona através do Docker sem precisar instalar Flutter localmente

Para instruções detalhadas, consulte [android-studio-integration.md](android-studio-integration.md).

## Executando comandos Flutter

Você tem várias opções para executar comandos Flutter:

### 1. Usando o script `flutter.sh`:
```bash
# Verificar ambiente Flutter
./flutter.sh doctor

# Criar um novo projeto
./flutter.sh create meu_app

# Obter dependências
cd projects/meu_app
../../flutter.sh pub get
```

### 2. A partir do Android Studio:
Depois de configurar as ferramentas externas, use:
- Menu Tools > External Tools > [comando desejado]
- Ou os atalhos de teclado configurados

### 3. No VSCode com Remote Containers:
- Use o terminal integrado ou
- Use as tarefas e extensões Flutter

### 4. Execução direta no container:
```bash
docker-compose exec flutter flutter [comando]
```

## Estrutura de diretórios

- `workspace/`: Contém o Flutter SDK (gerenciado pelo Docker)
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

### Erro de binários incompatíveis

Se encontrar erros como "cannot execute binary file", você está tentando executar os binários Linux diretamente no macOS/Windows. Use sempre:

- O script `flutter.sh` 
- O Android Studio com as ferramentas externas configuradas
- VSCode com Remote Containers

### Nenhum arquivo aparece na pasta workspace

Se o Flutter não estiver sendo copiado para a pasta workspace:

```bash
# Reconfigurar o ambiente
./flutter.sh setup

# Verificar os logs para diagnóstico
docker-compose logs flutter
```

### Erro ao executar comandos pelo Android Studio

Verifique:
1. Se o container Docker está rodando (`docker-compose ps`)
2. Se o caminho para o script `flutter-android-studio.sh` está correto
3. Se o script tem permissão de execução

## Diagnóstico avançado

```bash
# Ver logs do container
docker-compose logs flutter

# Acessar o shell do container
docker-compose exec flutter bash

# Verificar o conteúdo do volume Flutter
docker-compose exec flutter ls -la /home/developer/flutter
```

## Contribuição

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request.
