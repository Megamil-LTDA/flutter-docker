#!/bin/bash

# Script para executar comandos Flutter dentro do container Docker
# Uso: ./flutter.sh [comando flutter]
# Exemplo: ./flutter.sh doctor

if [ $# -eq 0 ]; then
    echo "Uso: ./flutter.sh [comando flutter]"
    echo "Exemplo: ./flutter.sh doctor"
    exit 1
fi

# Verifica se o container está rodando
CONTAINER_ID=$(docker-compose ps -q flutter)
if [ -z "$CONTAINER_ID" ]; then
    echo "Container Flutter não está rodando. Iniciando..."
    docker-compose up -d
    sleep 5
fi

# Executa o comando Flutter dentro do container
docker-compose exec flutter flutter "$@" 