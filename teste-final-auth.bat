@echo off
chcp 65001 >nul
echo.
echo ================================
echo  💥 TESTE FINAL AUTH MODE
echo ================================
echo.

echo 🔥 REMOVI TODAS AS VARIÁVEIS ${} DO DOCKER COMPOSE!
echo 💡 Agora está tudo HARDCODED com valores corretos!

echo.
echo 1. Parando backend...
docker compose -f docker-compose.local.yml stop backend

echo.
echo 2. Removendo container do backend...
docker compose -f docker-compose.local.yml rm -f backend

echo.
echo 3. Verificando variáveis do container antes de iniciar...
echo Docker Compose vai usar estas variáveis:
echo AUTH_MODE=password
echo ADMIN_PASSWORD=AgriHighlight2024@
echo IN_DOCKER=true
echo ON_PREM=true

echo.
echo 4. Iniciando backend com variáveis HARDCODED...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 5. Aguardando backend (45 segundos)...
timeout /t 45 /nobreak >nul

echo.
echo 6. Verificando logs do backend (procurando por mode=)...
docker compose -f docker-compose.local.yml logs backend | findstr "mode="

echo.
echo 7. Logs completos do backend:
docker compose -f docker-compose.local.yml logs --tail=15 backend

echo.
echo 8. Verificando variáveis de ambiente DENTRO do container:
echo Variáveis AUTH no container:
docker exec highlight-backend env | findstr "AUTH"

echo.
echo 9. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 10. Se funcionou, iniciando frontend...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 🎯 RESULTADO:
echo Se aparecer "mode=password" nos logs = SUCESSO!
echo Se aparecer "mode=Firebase" nos logs = AINDA COM PROBLEMA!
echo.

pause
