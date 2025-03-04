#!/bin/bash

# Flutter para Android Studio - Integração com Docker
# Este script permite que o Android Studio use o Flutter do Docker

# Diretório onde este script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verifica se o container está rodando
check_container() {
  CONTAINER_ID=$(docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" ps -q flutter)
  if [ -z "$CONTAINER_ID" ]; then
    echo "Container Flutter não está rodando. Iniciando..."
    docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" up -d
    sleep 5
  fi
}

# Função para executar um comando Flutter no Docker
run_flutter() {
  check_container
  
  # Caminho do projeto relativo à raiz do repositório
  local project_path=$(pwd)
  
  # Se estamos em um subdiretório do projects, usamos o caminho relativo
  if [[ "$project_path" == *"projects/"* ]]; then
    # Extrair o caminho relativo à pasta projects
    local relative_path=${project_path#*projects/}
    docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" exec flutter bash -c "cd /home/developer/projects/$relative_path && flutter $*"
  else
    # Se não estamos em um projeto específico, executamos o comando na raiz
    docker-compose -f "$SCRIPT_DIR/docker-compose.yaml" exec flutter flutter "$@"
  fi
}

# Exibe ajuda se nenhum argumento foi fornecido
if [ $# -eq 0 ]; then
  echo "Uso: $0 [comando flutter]"
  echo "Este script executa comandos Flutter dentro do container Docker."
  echo "Pode ser usado pelo Android Studio para integração."
  exit 0
fi

# Executa o comando Flutter
run_flutter "$@" 