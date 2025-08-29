@echo off
echo TESTE COMPLETO DO HIGHLIGHT.IO
echo ==============================

echo.
echo 1. Status dos containers:
docker compose -f docker-compose.local.yml ps

echo.
echo 2. Testando PostgreSQL:
docker exec highlight-postgres pg_isready -U highlight -d highlight
if %errorlevel% equ 0 (
    echo ✅ PostgreSQL OK
) else (
    echo ❌ PostgreSQL com problema
)

echo.
echo 3. Testando Redis:
docker exec highlight-redis redis-cli ping
if %errorlevel% equ 0 (
    echo ✅ Redis OK
) else (
    echo ❌ Redis com problema
)

echo.
echo 4. Testando ClickHouse:
docker exec highlight-clickhouse clickhouse-client --password=highlight123 --query "SELECT 1 as test"
if %errorlevel% equ 0 (
    echo ✅ ClickHouse OK
) else (
    echo ❌ ClickHouse com problema
)

echo.
echo 5. Testando ClickHouse via HTTP:
curl -s "http://default:highlight123@localhost:8123/?query=SELECT 1"
echo.

echo.
echo 6. Testando Backend:
curl -s -o nul -w "Backend HTTP Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 7. Testando Frontend:
curl -s -o nul -w "Frontend HTTP Status: %%{http_code}" http://localhost:3000
echo.

echo.
echo 8. Testando Collector:
curl -s -o nul -w "Collector Health Status: %%{http_code}" http://localhost:4319
echo.

echo.
echo 9. Portas abertas:
netstat -an | findstr "3000 8082 8123 9000 4317 4318 4319 5432 6379"

echo.
echo 10. Logs recentes (últimas 5 linhas de cada serviço):
echo.
echo === BACKEND ===
docker compose -f docker-compose.local.yml logs --tail=5 backend
echo.
echo === FRONTEND ===
docker compose -f docker-compose.local.yml logs --tail=5 frontend
echo.
echo === CLICKHOUSE ===
docker compose -f docker-compose.local.yml logs --tail=5 clickhouse
echo.
echo === COLLECTOR ===
docker compose -f docker-compose.local.yml logs --tail=5 collector

echo.
echo ==============================
echo TESTE COMPLETO FINALIZADO
echo ==============================
echo.
echo URLs para testar:
echo Frontend: http://localhost:3000
echo Backend: http://localhost:8082
echo ClickHouse: http://localhost:8123
echo Collector: http://localhost:4319
echo.
pause
