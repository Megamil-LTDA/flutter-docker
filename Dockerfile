FROM ubuntu:18.04
   
# Prerequisites
RUN apt update && apt install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-8-jdk \
    wget \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    openssh-client \
    ca-certificates \
    adb
   
# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Configuração Git para evitar erros de dubious ownership
RUN git config --global --add safe.directory '*'
   
# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
   
# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager --verbose \
    "build-tools;29.0.2" \
    "platform-tools" \
    "platforms;android-29" \
    "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK to a temp location inside the image
USER root
RUN git clone https://github.com/flutter/flutter.git -b stable /home/developer/flutter_sdk
RUN chown -R developer:developer /home/developer/flutter_sdk

# Configuração Git para o usuário root também
RUN git config --global --add safe.directory '*'

# Create a script to copy Flutter to the mounted volume with debug info
RUN echo '#!/bin/bash\n\
set -x\n\
\n\
# Verificar montagem do volume\n\
echo "Verificando pasta de destino..."\n\
ls -la /home/developer/\n\
touch /home/developer/flutter/test_write_permission.txt 2>/dev/null\n\
if [ $? -ne 0 ]; then\n\
    echo "ERRO: Não foi possível escrever na pasta /home/developer/flutter!"\n\
    echo "Tentando criar a pasta..."\n\
    mkdir -p /home/developer/flutter\n\
    if [ $? -ne 0 ]; then\n\
        echo "ERRO CRÍTICO: Não foi possível criar a pasta /home/developer/flutter!"\n\
        exit 1\n\
    fi\n\
fi\n\
\n\
# Configuração Git para evitar erros de propriedade\n\
git config --global --add safe.directory "*"\n\
\n\
# Sempre forçar a cópia do Flutter para o workspace\n\
echo "Copiando Flutter SDK para o workspace..."\n\
\n\
# Remover conteúdo anterior se existir\n\
rm -rf /home/developer/flutter/*\n\
rm -rf /home/developer/flutter/.git\n\
\n\
# Copiar SDK para o volume montado\n\
cp -r /home/developer/flutter_sdk/. /home/developer/flutter/\n\
\n\
# Verificar se a cópia foi bem-sucedida\n\
if [ -d "/home/developer/flutter/bin" ]; then\n\
    echo "SUCESSO: Flutter SDK copiado para workspace!"\n\
else\n\
    echo "ERRO: Falha ao copiar Flutter SDK. Verificando permissões:"\n\
    ls -la /home/developer/flutter/\n\
fi\n\
\n\
# Ajustar permissões\n\
chown -R developer:developer /home/developer/flutter\n\
chmod -R 755 /home/developer/flutter\n\
\n\
# Verificar resultado final\n\
echo "Conteúdo final da pasta flutter:"\n\
ls -la /home/developer/flutter/\n\
\n\
# Configurar Git no diretório Flutter\n\
cd /home/developer/flutter\n\
git config --global --add safe.directory "/home/developer/flutter"\n\
\n\
# Configurar flutter no PATH\n\
export PATH="/home/developer/flutter/bin:$PATH"\n\
echo "Flutter environment ready!"\n\
echo "Para executar Flutter, use sempre o container Docker!"\n\
echo "Exemplo: docker-compose exec flutter flutter doctor"\n\
\n\
# Verificar se o Flutter está funcionando\n\
echo "Verificando instalação do Flutter:"\n\
/home/developer/flutter/bin/flutter --version\n\
\n\
# Mudar para o usuário developer para operações normais\n\
su - developer -c "cd /home/developer/projects && tail -f /dev/null"\n\
' > /usr/local/bin/init-flutter.sh

RUN chmod +x /usr/local/bin/init-flutter.sh

# Set Flutter in PATH for both users
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dart SDK with the temp SDK
USER developer
ENV PATH "$PATH:/home/developer/flutter_sdk/bin"
RUN /home/developer/flutter_sdk/bin/flutter doctor