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

# Create a script to copy Flutter to the mounted volume
RUN echo '#!/bin/bash\n\
if [ -z "$(ls -A /home/developer/flutter)" ]; then\n\
    echo "Workspace is empty. Copying Flutter SDK..."\n\
    cp -r /home/developer/flutter_sdk/. /home/developer/flutter/\n\
    chown -R developer:developer /home/developer/flutter\n\
    echo "Flutter SDK copied to workspace"\n\
else\n\
    echo "Workspace already contains files. Skipping Flutter SDK copy."\n\
fi\n\
\n\
# Configurar flutter no PATH\n\
export PATH="/home/developer/flutter/bin:$PATH"\n\
echo "Flutter environment ready!"\n\
echo "Para executar Flutter, use sempre o container Docker!"\n\
echo "Exemplo: docker-compose exec flutter flutter doctor"\n\
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