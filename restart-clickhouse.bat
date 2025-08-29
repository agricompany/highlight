@echo off
echo REINICIANDO CLICKHOUSE
echo ====================

echo Parando ClickHouse...
docker compose -f docker-compose.local.yml stop clickhouse

echo Removendo container ClickHouse...
docker compose -f docker-compose.local.yml rm -f clickhouse

echo Removendo volume ClickHouse...
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul

echo Iniciando ClickHouse...
docker compose -f docker-compose.local.yml up -d clickhouse

echo Aguardando ClickHouse inicializar...
timeout /t 30 /nobreak >nul

echo Verificando logs do ClickHouse...
docker compose -f docker-compose.local.yml logs clickhouse

echo.
echo ClickHouse reiniciado!
pause
