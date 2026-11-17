@echo off
setlocal EnableExtensions
title Automacao de Certificados - Schulz

cd /d "%~dp0"

REM Configuracoes de armazenamento e consulta publica.
REM O computador precisa ter credenciais AWS configuradas (AWS CLI/perfil IAM).
set "S3_BUCKET_NAME=calibracao-certificados-cristian-2026"
set "AWS_REGION=us-east-2"
set "PUBLIC_BASE_URL=https://dt3rbp3b7wgmoroeeqwwpfqsqa0jywxy.lambda-url.us-east-2.on.aws"

echo =====================================================
echo   AUTOMACAO DA EMISSAO DE CERTIFICADOS - SCHULZ S.A.
echo =====================================================
echo.

REM Verifica Python no PATH e exige versao 3.10 ou superior.
where py >nul 2>nul
if %errorlevel%==0 (
    set "PYTHON_CMD=py"
) else (
    where python >nul 2>nul
    if %errorlevel%==0 (
        set "PYTHON_CMD=python"
    ) else (
        echo ERRO: Python nao foi encontrado no PATH.
        echo Instale Python 3.10 ou superior e marque "Add Python to PATH".
        pause
        exit /b 1
    )
)

for /f "tokens=2 delims= " %%V in ('%PYTHON_CMD% --version 2^>^&1') do set "PYVER=%%V"
for /f "tokens=1,2 delims=." %%A in ("%PYVER%") do (
    set "PYMAJOR=%%A"
    set "PYMINOR=%%B"
)
if not defined PYMAJOR (
    echo ERRO: Nao foi possivel identificar a versao do Python.
    pause
    exit /b 1
)
if %PYMAJOR% LSS 3 (
    echo ERRO: Python 3.10 ou superior e obrigatorio. Versao detectada: %PYVER%
    pause
    exit /b 1
)
if %PYMAJOR% EQU 3 if %PYMINOR% LSS 10 (
    echo ERRO: Python 3.10 ou superior e obrigatorio. Versao detectada: %PYVER%
    pause
    exit /b 1
)

if not exist "app.py" (
    echo ERRO: app.py nao foi encontrado na pasta do projeto.
    pause
    exit /b 1
)
if not exist "requirements.txt" (
    echo ERRO: requirements.txt nao foi encontrado na pasta do projeto.
    pause
    exit /b 1
)

echo [1/4] Criando ambiente virtual, se necessario...
if not exist "venv\Scripts\python.exe" (
    %PYTHON_CMD% -m venv venv
    if errorlevel 1 (
        echo ERRO ao criar o ambiente virtual.
        pause
        exit /b 1
    )
)

echo [2/4] Atualizando pip e instalando dependencias...
"venv\Scripts\python.exe" -m pip install --upgrade pip
if errorlevel 1 (
    echo ERRO ao atualizar o pip.
    pause
    exit /b 1
)
"venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo ERRO ao instalar as dependencias de requirements.txt.
    pause
    exit /b 1
)

echo [3/4] Iniciando a aplicacao...
echo A interface sera aberta em http://127.0.0.1:5000
echo Para encerrar, feche a janela do servidor.
start "" cmd /k ""%CD%\venv\Scripts\python.exe" app.py"

echo [4/4] Abrindo a interface no navegador...
timeout /t 4 /nobreak >nul
start "" "http://127.0.0.1:5000"

echo.
echo Inicializacao solicitada. Se a aplicacao utilizar outra porta,
echo ajuste o endereco acima para corresponder ao app.py.
echo.
pause
endlocal
