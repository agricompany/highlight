@echo off
echo TESTANDO CLICKHOUSE
echo ===================

echo Verificando se ClickHouse está rodando...
docker compose -f docker-compose.local.yml ps clickhouse

echo.
echo Testando conexão HTTP (porta 8123)...
curl -s http://localhost:8123/ping

echo.
echo Testando query simples...
curl -s "http://localhost:8123/?query=SELECT 1"

echo.
echo Logs recentes do ClickHouse:
docker compose -f docker-compose.local.yml logs --tail=10 clickhouse

echo.
echo Health check manual (usando clickhouse-client):
docker exec highlight-clickhouse clickhouse-client --password=highlight123 --query "SELECT 1 as test"
if %errorlevel% equ 0 (
    echo ✅ ClickHouse está funcionando
) else (
    echo ❌ ClickHouse não está respondendo
)

echo.
echo Testando conexao HTTP externa:
curl -s "http://default:highlight123@localhost:8123/?query=SELECT 'ClickHouse funcionando!' as status"

echo.
echo Verificando usuario default:
curl -s "http://default:highlight123@localhost:8123/?query=SELECT user() as current_user"

echo.
echo Testando query simples:
curl -s "http://default:highlight123@localhost:8123/?query=SELECT 1 as test"

pause
