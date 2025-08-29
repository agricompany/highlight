@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🎉 CORRIGINDO LICENÇA ENTERPRISE
echo ================================
echo.

echo ✅ ClickHouse já está funcionando!
echo 🔧 Agora vamos corrigir a licença...

echo.
echo 1. Parando apenas o backend...
docker compose -f docker-compose.local.yml stop backend

echo.
echo 2. Removendo container do backend...
docker compose -f docker-compose.local.yml rm -f backend

echo.
echo 3. Recriando backend com novas variáveis...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 4. Aguardando backend inicializar...
timeout /t 30 /nobreak >nul

echo.
echo 5. Verificando logs do backend...
docker compose -f docker-compose.local.yml logs --tail=20 backend

echo.
echo 6. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 7. Status final dos serviços...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎯 URLs de acesso:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo   ClickHouse: http://localhost:8123
echo.

pause
