@echo off
chcp 65001 >nul
echo.
echo ================================
echo  💥 SOLUÇÃO FINAL CLICKHOUSE
echo ================================
echo.

echo 1. PARANDO TUDO...
docker compose -f docker-compose.local.yml down

echo.
echo 2. REMOVENDO VOLUMES (FORÇADO)...
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul
docker volume prune -f

echo.
echo 3. REMOVENDO IMAGEM DO CLICKHOUSE...
docker image rm clickhouse/clickhouse-server:24.3.15.72-alpine 2>nul

echo.
echo 4. LIMPEZA GERAL...
docker system prune -f

echo.
echo 5. INICIANDO SÓ O CLICKHOUSE (SEM SENHA)...
docker compose -f docker-compose.local.yml up -d clickhouse

echo.
echo 6. AGUARDANDO 60 SEGUNDOS...
timeout /t 60 /nobreak >nul

echo.
echo 7. TESTANDO CLICKHOUSE SEM SENHA...
docker exec highlight-clickhouse clickhouse-client --query "SELECT 'FUNCIONOU SEM SENHA!' as resultado"

if %errorlevel% equ 0 (
    echo ✅ CLICKHOUSE FUNCIONANDO SEM SENHA!
    echo.
    echo 8. INICIANDO O RESTO...
    docker compose -f docker-compose.local.yml up -d
    
    echo.
    echo 9. AGUARDANDO BACKEND...
    timeout /t 30 /nobreak >nul
    
    echo.
    echo 10. STATUS FINAL:
    docker compose -f docker-compose.local.yml ps
    
    echo.
    echo 🎉 SUCESSO! URLs:
    echo   Frontend: http://localhost:3000
    echo   Backend:  http://localhost:8082
    echo   ClickHouse: http://localhost:8123
    
) else (
    echo ❌ AINDA COM PROBLEMA!
    echo.
    echo LOGS DO CLICKHOUSE:
    docker compose -f docker-compose.local.yml logs clickhouse
)

pause
