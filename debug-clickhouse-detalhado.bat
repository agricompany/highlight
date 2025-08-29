@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔍 DEBUG CLICKHOUSE DETALHADO
echo ================================
echo.

echo 1. Status dos containers:
docker compose -f docker-compose.local.yml ps

echo.
echo 2. Verificando arquivo de configuração LOCAL:
echo =====================================
if exist "clickhouse-users\users-com-senha.xml" (
    echo Arquivo users-com-senha.xml:
    type "clickhouse-users\users-com-senha.xml"
) else (
    echo ❌ Arquivo users-com-senha.xml NÃO ENCONTRADO!
)
echo =====================================

echo.
echo 3. Verificando arquivo DENTRO do container:
echo =====================================
docker exec highlight-clickhouse cat /etc/clickhouse-server/users.d/highlight-users.xml
echo =====================================

echo.
echo 4. Verificando configuração ativa do ClickHouse:
echo =====================================
docker exec highlight-clickhouse clickhouse-client --query "SELECT name, value FROM system.settings WHERE name LIKE '%user%' OR name LIKE '%password%' OR name LIKE '%auth%'" 2>nul
echo =====================================

echo.
echo 5. Listando todos os usuários:
echo =====================================
docker exec highlight-clickhouse clickhouse-client --query "SELECT name FROM system.users" 2>nul
echo =====================================

echo.
echo 6. Testando diferentes formas de autenticação:
echo.
echo 6a. Sem senha:
docker exec highlight-clickhouse clickhouse-client --query "SELECT 'Sem senha' as teste" 2>nul

echo.
echo 6b. Com senha vazia:
docker exec highlight-clickhouse clickhouse-client --password="" --query "SELECT 'Senha vazia' as teste" 2>nul

echo.
echo 6c. Com senha 'highlight123':
docker exec highlight-clickhouse clickhouse-client --password=highlight123 --query "SELECT 'Com senha' as teste" 2>nul

echo.
echo 6d. Com usuário e senha explícitos:
docker exec highlight-clickhouse clickhouse-client --user=default --password=highlight123 --query "SELECT 'User+Pass' as teste" 2>nul

echo.
echo 7. Logs recentes do ClickHouse:
echo =====================================
docker compose -f docker-compose.local.yml logs --tail=20 clickhouse
echo =====================================

echo.
echo 8. Verificando variáveis de ambiente do container:
echo =====================================
docker exec highlight-clickhouse env | grep -i click
echo =====================================

pause
