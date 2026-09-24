#!/bin/bash

# Script de Inicialização - Travel Agency Document Processor
# Uso: ./start.sh [dev|prod|docker]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir com cores
print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Modo padrão
MODE="${1:-dev}"

print_step "Iniciando sistema em modo: $MODE"

# Verifica se Python está instalado
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 não está instalado"
    exit 1
fi

print_success "Python encontrado: $(python3 --version)"

case $MODE in
    "dev")
        print_step "Modo Desenvolvimento"
        
        # Cria ambiente virtual se não existir
        if [ ! -d "venv" ]; then
            print_step "Criando ambiente virtual..."
            python3 -m venv venv
        fi
        
        # Ativa ambiente virtual
        print_step "Ativando ambiente virtual..."
        source venv/bin/activate
        
        # Instala dependências
        print_step "Instalando dependências..."
        pip install -q -r requirements.txt
        print_success "Dependências instaladas"
        
        # Inicia servidor
        print_success "Iniciando servidor em http://localhost:8000"
        print_warning "Pressione Ctrl+C para parar"
        python3 app.py
        ;;
        
    "prod")
        print_step "Modo Produção"
        
        if [ ! -d "venv" ]; then
            python3 -m venv venv
        fi
        
        source venv/bin/activate
        
        print_step "Instalando dependências..."
        pip install -q -r requirements.txt
        
        print_success "Iniciando servidor em produção"
        uvicorn app:app --host 0.0.0.0 --port 8000 --workers 4
        ;;
        
    "docker")
        print_step "Modo Docker"
        
        if ! command -v docker &> /dev/null; then
            print_error "Docker não está instalado"
            exit 1
        fi
        
        print_success "Docker encontrado: $(docker --version)"
        
        print_step "Construindo imagem..."
        docker-compose build
        
        print_success "Iniciando containers..."
        docker-compose up
        ;;
        
    *)
        print_error "Modo desconhecido: $MODE"
        echo "Uso: ./start.sh [dev|prod|docker]"
        exit 1
        ;;
esac
