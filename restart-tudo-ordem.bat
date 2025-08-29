@echo off
echo REINICIANDO HIGHLIGHT.IO EM ORDEM CORRETA
echo ==========================================

echo 1. Parando todos os servicos...
docker compose -f docker-compose.local.yml down

echo.
echo 2. Removendo volumes do ClickHouse para reset...
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul

echo.
echo 3. Iniciando infraestrutura primeiro...
docker compose -f docker-compose.local.yml up -d zookeeper redis postgres

echo.
echo 4. Aguardando PostgreSQL ficar healthy...
timeout /t 15 /nobreak >nul

echo.
echo 5. Iniciando ClickHouse...
docker compose -f docker-compose.local.yml up -d clickhouse

echo.
echo 6. Aguardando ClickHouse inicializar...
timeout /t 30 /nobreak >nul

echo.
echo 7. Testando ClickHouse...
curl -s "http://localhost:8123/?query=SELECT 1 as test"

echo.
echo 8. Iniciando Kafka...
docker compose -f docker-compose.local.yml up -d kafka

echo.
echo 9. Aguardando Kafka...
timeout /t 15 /nobreak >nul

echo.
echo 10. Iniciando Backend...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 11. Aguardando Backend...
timeout /t 30 /nobreak >nul

echo.
echo 12. Iniciando Collector...
docker compose -f docker-compose.local.yml up -d collector

echo.
echo 13. Iniciando Frontend...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 14. Status final:
docker compose -f docker-compose.local.yml ps

echo.
echo 15. Testando endpoints:
echo Frontend: http://localhost:3000
echo Backend: http://localhost:8082
echo ClickHouse: http://localhost:8123

echo.
echo HIGHLIGHT.IO INICIADO EM ORDEM!
pause
