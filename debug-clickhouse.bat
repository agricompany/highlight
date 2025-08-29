@echo off
echo DEBUG CLICKHOUSE AUTHENTICATION
echo =================================

echo 1. Verificando configuracao do container:
docker exec highlight-clickhouse cat /etc/clickhouse-server/users.d/highlight-users.xml

echo.
echo 2. Testando conexao sem senha:
docker exec highlight-clickhouse clickhouse-client --query "SELECT user(), version()"

echo.
echo 3. Testando conexao via HTTP sem autenticacao:
curl -s "http://localhost:8123/?query=SELECT user(), version()"

echo.
echo 4. Verificando variaveis de ambiente do backend:
docker exec highlight-backend printenv | findstr CLICK

echo.
echo 5. Testando conexao do backend para clickhouse:
docker exec highlight-backend nslookup clickhouse

echo.
echo 6. Testando conexao na porta 9000:
docker exec highlight-backend nc -zv clickhouse 9000

pause
