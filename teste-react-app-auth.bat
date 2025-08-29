@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🎉 ACHEI O PROBLEMA!
echo ================================
echo.

echo 🔥 O backend lê REACT_APP_AUTH_MODE, não AUTH_MODE!
echo 💡 Adicionei REACT_APP_AUTH_MODE=password no docker-compose!

echo.
echo 1. Parando backend...
docker compose -f docker-compose.local.yml stop backend

echo.
echo 2. Removendo container...
docker compose -f docker-compose.local.yml rm -f backend

echo.
echo 3. Iniciando backend com REACT_APP_AUTH_MODE=password...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 4. Aguardando backend (45 segundos)...
timeout /t 45 /nobreak >nul

echo.
echo 5. Verificando logs (procurando mode=password)...
docker compose -f docker-compose.local.yml logs backend | findstr "mode="

echo.
echo 6. Logs completos:
docker compose -f docker-compose.local.yml logs --tail=10 backend

echo.
echo 7. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 8. Se funcionou, iniciando frontend...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 9. Status final...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎯 AGORA DEVE APARECER:
echo   mode=password (NÃO mais Firebase!)
echo.
echo 🎉 URLs:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo   Login: admin / AgriHighlight2024@
echo.

pause
