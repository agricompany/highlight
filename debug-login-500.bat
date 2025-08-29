@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔍 DEBUG LOGIN ERROR 500
echo ================================
echo.

echo 🔥 Backend retorna 500 no login!
echo 💡 Vamos investigar o erro interno

echo.
echo 1. Verificando logs do backend em tempo real...
echo Fazendo uma requisição de login para ver o erro:

echo.
echo 2. Testando endpoint de login diretamente...
curl -X POST http://localhost:8082/private/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"admin@highlight.io\",\"password\":\"password\"}" ^
  -v

echo.
echo 3. Verificando logs do backend após a requisição...
docker compose -f docker-compose.local.yml logs --tail=20 backend

echo.
echo 4. Verificando se há erros de JWT ou outras configurações...
docker exec highlight-backend env | findstr "JWT\|SECRET\|ADMIN"

echo.
echo 5. Testando endpoint de health para comparar...
curl -X GET http://localhost:8082/health -v

echo.
echo 6. Verificando se o backend está realmente em modo Password...
docker compose -f docker-compose.local.yml logs backend | findstr "configuring private graph auth client"

echo.
echo 7. Verificando variáveis de ambiente do backend...
echo ADMIN_PASSWORD no container:
docker exec highlight-backend printenv ADMIN_PASSWORD

echo REACT_APP_AUTH_MODE no container:
docker exec highlight-backend printenv REACT_APP_AUTH_MODE

echo.
echo 8. Logs completos recentes do backend...
docker compose -f docker-compose.local.yml logs --tail=50 backend

echo.
pause
