@echo off
echo CORRIGINDO AUTENTICACAO CLICKHOUSE
echo ===================================

echo 1. Parando backend e clickhouse...
docker compose -f docker-compose.local.yml stop backend clickhouse

echo.
echo 2. Removendo containers...
docker compose -f docker-compose.local.yml rm -f backend clickhouse

echo.
echo 3. Removendo volumes do ClickHouse para reset completo...
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul

echo.
echo 4. Iniciando ClickHouse com nova configuracao (sem senha)...
docker compose -f docker-compose.local.yml up -d clickhouse

echo.
echo 5. Aguardando ClickHouse inicializar...
timeout /t 30 /nobreak >nul

echo.
echo 6. Testando ClickHouse com senha simples...
docker exec highlight-clickhouse clickhouse-client --password=highlight123 --query "SELECT 'ClickHouse funcionando com senha!' as status"

echo.
echo 7. Verificando configuracao de usuarios:
docker exec highlight-clickhouse cat /etc/clickhouse-server/users.d/highlight-users.xml

echo.
echo 8. Iniciando backend...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 9. Aguardando backend...
timeout /t 20 /nobreak >nul

echo.
echo 10. Verificando logs do backend:
docker compose -f docker-compose.local.yml logs --tail=10 backend

echo.
echo 11. Status final:
docker compose -f docker-compose.local.yml ps clickhouse backend

echo.
echo ClickHouse e Backend reiniciados!
pause
