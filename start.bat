@echo off
REM Script de Inicialização - Travel Agency Document Processor (Windows)
REM Uso: start.bat [dev|prod|docker]

setlocal enabledelayedexpansion

REM Define modo (padrão: dev)
set MODE=%1
if "%MODE%"=="" set MODE=dev

echo.
echo ========================================
echo Travel Agency Document Processor
echo Modo: %MODE%
echo ========================================
echo.

REM Verifica se Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] Python não está instalado
    echo Por favor, instale Python 3.11+ de https://www.python.org
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo [OK] %PYTHON_VERSION% encontrado

if "%MODE%"=="dev" (
    echo.
    echo [INFO] Modo Desenvolvimento
    echo.
    
    REM Cria ambiente virtual
    if not exist "venv" (
        echo [INFO] Criando ambiente virtual...
        python -m venv venv
    )
    
    REM Ativa ambiente virtual
    echo [INFO] Ativando ambiente virtual...
    call venv\Scripts\activate.bat
    
    REM Instala dependências
    echo [INFO] Instalando dependências...
    pip install -q -r requirements.txt
    echo [OK] Dependências instaladas
    
    REM Inicia servidor
    echo.
    echo [OK] Servidor iniciando em http://localhost:8000
    echo [INFO] Pressione Ctrl+C para parar
    echo.
    python app.py
    
) else if "%MODE%"=="prod" (
    echo.
    echo [INFO] Modo Produção
    echo.
    
    if not exist "venv" (
        python -m venv venv
    )
    
    call venv\Scripts\activate.bat
    
    echo [INFO] Instalando dependências...
    pip install -q -r requirements.txt
    echo [OK] Dependências instaladas
    
    echo.
    echo [OK] Servidor iniciando em produção
    uvicorn app:app --host 0.0.0.0 --port 8000 --workers 4
    
) else if "%MODE%"=="docker" (
    echo.
    echo [INFO] Modo Docker
    echo.
    
    docker --version >nul 2>&1
    if errorlevel 1 (
        echo [ERRO] Docker não está instalado
        pause
        exit /b 1
    )
    
    for /f "tokens=*" %%i in ('docker --version') do set DOCKER_VERSION=%%i
    echo [OK] !DOCKER_VERSION! encontrado
    
    echo [INFO] Construindo imagem...
    docker-compose build
    
    echo [OK] Iniciando containers...
    docker-compose up
    
) else (
    echo [ERRO] Modo desconhecido: %MODE%
    echo.
    echo Uso: start.bat [dev^|prod^|docker]
    pause
    exit /b 1
)

pause
