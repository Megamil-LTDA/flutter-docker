#!/bin/bash

# Script para executar comandos Flutter dentro do container Docker
# Uso: ./flutter.sh [comando flutter]
# Exemplo: ./flutter.sh doctor

# Setup para garantir que tudo está configurado corretamente
setup() {
    # Verifica se a pasta workspace existe
    if [ ! -d "workspace" ]; then
        echo "Criando pasta workspace..."
        mkdir -p workspace
    fi

    # Garante permissão de escrita para a pasta workspace
    chmod -R 777 workspace

    # Verifica se o container está rodando
    CONTAINER_ID=$(docker-compose ps -q flutter)
    if [ -z "$CONTAINER_ID" ]; then
        echo "Container Flutter não está rodando. Iniciando..."
        docker-compose up -d
        echo "Aguardando o container iniciar..."
        sleep 10
    fi

    # Verifica se o Flutter foi copiado para o volume
    if ! docker-compose exec flutter ls -la /home/developer/flutter/bin/flutter > /dev/null 2>&1; then
        echo "Flutter não encontrado no container. Recriando o ambiente..."
        
        # Para os containers
        docker-compose down -v
        
        # Remove a pasta workspace e recria
        rm -rf workspace
        mkdir -p workspace
        chmod -R 777 workspace
        
        # Inicia o container novamente
        docker-compose up -d
        
        # Aguarda o container iniciar e copiar o Flutter
        echo "Aguardando o container iniciar e copiar o Flutter SDK..."
        sleep 15
        
        # Verifica se o Flutter foi copiado com sucesso
        if ! docker-compose exec flutter ls -la /home/developer/flutter/bin/flutter > /dev/null 2>&1; then
            echo "ERRO CRÍTICO: Flutter não foi copiado para o volume."
            echo "Verificando logs do container..."
            docker-compose logs flutter
            exit 1
        fi
    fi
}

# Verificação de argumentos
if [ $# -eq 0 ]; then
    echo "Uso: ./flutter.sh [comando flutter]"
    echo "Exemplo: ./flutter.sh doctor"
    exit 1
fi

# Se o comando for "setup", apenas configura o ambiente e sai
if [ "$1" = "setup" ]; then
    setup
    echo "Ambiente configurado com sucesso!"
    exit 0
fi

# Configura o ambiente
setup

# Configuração adicional do Git
docker-compose exec flutter git config --global --add safe.directory '/home/developer/flutter'

# Mensagem informativa
echo "Executando: flutter $@"

# Executa o comando Flutter dentro do container
docker-compose exec flutter flutter "$@"

# Verifica se o comando foi executado com sucesso
if [ $? -ne 0 ]; then
    echo "Ocorreu um erro ao executar o comando Flutter."
    echo "Tentando configurar o Git e executar novamente..."
    
    # Tenta configurar o Git e executar novamente
    docker-compose exec flutter bash -c "git config --global --add safe.directory '*' && git config --global --add safe.directory /home/developer/flutter && flutter $*"
fi 