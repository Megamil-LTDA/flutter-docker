# Integrando o Android Studio com Flutter no Docker

Este guia mostra como configurar o Android Studio para trabalhar com o Flutter em Docker, permitindo desenvolvimento sem precisar instalar o Flutter localmente.

## Preparação

1. Certifique-se de que o script `flutter-android-studio.sh` tenha permissão de execução:
   ```bash
   chmod +x flutter-android-studio.sh
   ```

2. Verifique se o Docker e o container Flutter estão funcionando:
   ```bash
   ./flutter.sh doctor
   ```

## Configuração do Android Studio

### Configurando a Integração Básica

1. Abra o Android Studio

2. Vá para **Preferences** > **Tools** > **External Tools**

3. Adicione as seguintes ferramentas externas (clique no ícone `+`):

   #### Flutter Doctor
   - **Name**: Flutter Doctor
   - **Program**: `/caminho/completo/para/flutter-android-studio.sh`
   - **Arguments**: `doctor`
   - **Working directory**: `$ProjectFileDir$`

   #### Flutter Pub Get
   - **Name**: Flutter Pub Get
   - **Program**: `/caminho/completo/para/flutter-android-studio.sh`
   - **Arguments**: `pub get`
   - **Working directory**: `$ProjectFileDir$`

   #### Flutter Run
   - **Name**: Flutter Run
   - **Program**: `/caminho/completo/para/flutter-android-studio.sh`
   - **Arguments**: `run`
   - **Working directory**: `$ProjectFileDir$`

   #### Flutter Clean
   - **Name**: Flutter Clean
   - **Program**: `/caminho/completo/para/flutter-android-studio.sh`
   - **Arguments**: `clean`
   - **Working directory**: `$ProjectFileDir$`
   
   #### Flutter Build
   - **Name**: Flutter Build APK
   - **Program**: `/caminho/completo/para/flutter-android-studio.sh`
   - **Arguments**: `build apk`
   - **Working directory**: `$ProjectFileDir$`

### Configurando Atalhos de Teclado (Opcional)

1. Vá para **Preferences** > **Keymap**

2. Procure por "External Tools" e expanda

3. Configure atalhos para as ferramentas:
   - **Flutter Run**: Clique com o botão direito e selecione "Add Keyboard Shortcut" (ex: Ctrl+Shift+F10)
   - **Flutter Pub Get**: Adicione um atalho como Ctrl+Shift+P
   - **Flutter Doctor**: Adicione um atalho como Ctrl+Shift+D

## Como Abrir e Executar Projetos

1. Abra seus projetos Flutter da pasta `projects` usando **File** > **Open**

2. Para realizar ações Flutter:
   - Use o menu **Tools** > **External Tools** e selecione a ação desejada
   - Ou use os atalhos de teclado configurados

3. Para executar o app:
   - Selecione **Tools** > **External Tools** > **Flutter Run**
   - O aplicativo será executado dentro do container Docker

## Análise de Código e Autocompletar

Para ter recursos como análise de código e autocompletar no Android Studio, você tem duas opções:

### Opção 1: Instalar Flutter Plugin sem SDK (Mais Simples)

1. Instale o plugin Flutter no Android Studio
2. Ao ser solicitado o Flutter SDK, você pode apontar para qualquer pasta temporária
3. O autocompletar funcionará para a maioria das APIs mais comuns

### Opção 2: Instalar Flutter Localmente Apenas para Análise (Mais Completo)

1. Instale o Flutter localmente:
   ```bash
   curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.19.3-stable.zip
   unzip flutter_macos_3.19.3-stable.zip
   ```

2. Configure o Android Studio para usar essa instalação local:
   - **Preferences** > **Languages & Frameworks** > **Flutter**
   - Set SDK path: `/caminho/para/flutter/local`

3. **IMPORTANTE**: Para executar o app, continue usando as ferramentas externas configuradas, não use os botões Run padrão.

## O Que Isso Proporciona

Com esta abordagem:

- ✅ Novos desenvolvedores não precisam instalar Flutter localmente para começar
- ✅ A execução do Flutter acontece dentro do container, garantindo ambiente consistente
- ✅ O Android Studio funciona como IDE, com análise de código e autocompletar
- ✅ Não há problemas de compatibilidade de binários entre sistemas operacionais

## Solução de Problemas

Se encontrar problemas:

1. **Ferramentas externas não funcionam**: Verifique o caminho absoluto para o script `flutter-android-studio.sh`

2. **Erro ao executar o Flutter**: Verifique se o container está rodando:
   ```bash
   docker-compose ps
   ```

3. **Problemas de permissão**: Verifique se o script tem permissão de execução:
   ```bash
   chmod +x flutter-android-studio.sh
   ``` 