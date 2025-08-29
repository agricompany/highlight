@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔄 RESET COMPLETO CLICKHOUSE
echo ================================
echo.

echo 1. Parando todos os serviços...
docker compose -f docker-compose.local.yml down

echo.
echo 2. Removendo TODOS os volumes do ClickHouse...
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul
docker volume ls | findstr clickhouse
if %errorlevel% equ 0 (
    echo ⚠️  Ainda existem volumes do ClickHouse!
    docker volume ls | findstr clickhouse
    echo Removendo manualmente...
    for /f "tokens=2" %%i in ('docker volume ls ^| findstr clickhouse') do docker volume rm %%i 2>nul
)

echo.
echo 3. Removendo imagem do ClickHouse para forçar re-download...
docker image rm clickhouse/clickhouse-server:24.3.15.72-alpine 2>nul

echo.
echo 4. Limpando sistema Docker...
docker system prune -f

echo.
echo 5. Verificando arquivo de configuração de usuários...
echo Conteúdo do users-com-senha.xml:
echo =====================================
type "clickhouse-users\users-com-senha.xml"
echo =====================================

echo.
echo 6. Iniciando apenas o ClickHouse primeiro...
docker compose -f docker-compose.local.yml up -d clickhouse

echo.
echo 7. Aguardando ClickHouse inicializar (60 segundos)...
timeout /t 60 /nobreak >nul

echo.
echo 8. Verificando logs do ClickHouse...
docker compose -f docker-compose.local.yml logs clickhouse

echo.
echo 9. Testando autenticação com senha...
echo Tentando conectar com senha 'highlight123':
docker exec highlight-clickhouse clickhouse-client --password=highlight123 --query "SELECT 'ClickHouse funcionando com senha!' as status"

if %errorlevel% equ 0 (
    echo ✅ ClickHouse está funcionando com senha!
    echo.
    echo 10. Iniciando o resto dos serviços...
    docker compose -f docker-compose.local.yml up -d
    
    echo.
    echo 11. Aguardando backend inicializar...
    timeout /t 30 /nobreak >nul
    
    echo.
    echo 12. Verificando status final...
    docker compose -f docker-compose.local.yml ps
    
    echo.
    echo ✅ RESET COMPLETO CONCLUÍDO!
    echo.
    echo 📊 URLs de acesso:
    echo   Frontend: http://localhost:3000
    echo   Backend:  http://localhost:8082
    echo   ClickHouse HTTP: http://default:highlight123@localhost:8123
    echo.
) else (
    echo ❌ ClickHouse ainda não está funcionando!
    echo.
    echo Verificando configuração interna:
    docker exec highlight-clickhouse cat /etc/clickhouse-server/users.d/highlight-users.xml
    echo.
    echo Logs recentes:
    docker compose -f docker-compose.local.yml logs --tail=20 clickhouse
)

echo.
pause
