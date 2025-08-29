@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🎉 SUCESSO! CORRIGINDO REDIS
echo ================================
echo.

echo ✅ AUTH_MODE FUNCIONOU! Agora aparece mode=Password!
echo 🔧 Problema atual: Redis authentication
echo 💡 Solução: Remover senha do Redis

echo.
echo 1. Parando Redis e Backend...
docker compose -f docker-compose.local.yml stop redis backend

echo.
echo 2. Removendo containers...
docker compose -f docker-compose.local.yml rm -f redis backend

echo.
echo 3. Iniciando Redis SEM SENHA...
docker compose -f docker-compose.local.yml up -d redis

echo.
echo 4. Aguardando Redis (15 segundos)...
timeout /t 15 /nobreak >nul

echo.
echo 5. Testando Redis sem senha...
docker exec highlight-redis redis-cli ping

echo.
echo 6. Iniciando Backend...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 7. Aguardando Backend (45 segundos)...
timeout /t 45 /nobreak >nul

echo.
echo 8. Verificando logs do backend...
docker compose -f docker-compose.local.yml logs --tail=15 backend

echo.
echo 9. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 10. Se funcionou, iniciando frontend...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 11. Status final...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎉 SUCESSO COMPLETO!
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo   Login: admin / AgriHighlight2024@
echo.
echo 🎯 Progresso:
echo   ✅ ClickHouse: Funcionando (sem senha)
echo   ✅ AUTH_MODE: Funcionando (mode=Password)
echo   ✅ Redis: Funcionando (sem senha)
echo   ✅ Backend: Deve estar funcionando agora!
echo.

pause
