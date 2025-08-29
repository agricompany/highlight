@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔍 DEBUG AUTH_MODE COMPLETO
echo ================================
echo.

echo 🔥 AINDA MOSTRA mode=Firebase MESMO COM HARDCODE!
echo 💡 Vamos investigar ONDE está vindo esse Firebase!

echo.
echo 1. Parando backend...
docker compose -f docker-compose.local.yml stop backend

echo.
echo 2. Verificando TODAS as variáveis de ambiente do container:
echo Criando container temporário para debug...
docker compose -f docker-compose.local.yml run --rm backend env | findstr -i "auth\|firebase\|mode"

echo.
echo 3. Verificando se existe .env no diretório:
if exist .env (
    echo .env EXISTE! Conteúdo:
    echo ========================
    type .env | findstr -i "auth\|firebase"
    echo ========================
) else (
    echo .env NÃO EXISTE
)

echo.
echo 4. Verificando se existe env_file no docker-compose:
findstr -i "env_file" docker-compose.local.yml

echo.
echo 5. Verificando variáveis AUTH no docker-compose:
findstr -i "auth" docker-compose.local.yml

echo.
echo 6. Testando container com variável explícita:
echo Forçando AUTH_MODE=password via -e...
docker run --rm -e AUTH_MODE=password ghcr.io/highlight/highlight-backend:docker-v0.5.2 env | findstr -i "auth"

echo.
echo 7. Verificando se o backend tem valor padrão hardcoded:
echo Executando container SEM variáveis para ver o padrão...
docker run --rm ghcr.io/highlight/highlight-backend:docker-v0.5.2 env | findstr -i "auth\|firebase"

echo.
pause
