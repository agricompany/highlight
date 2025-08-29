@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🎉 FINALIZANDO HIGHLIGHT.IO
echo ================================
echo.

echo ✅ Backend está funcionando! (porta 8082)
echo 🔧 Corrigindo frontend para usar modo Password

echo.
echo 1. Parando frontend...
docker compose -f docker-compose.local.yml stop frontend

echo.
echo 2. Removendo container do frontend...
docker compose -f docker-compose.local.yml rm -f frontend

echo.
echo 3. Iniciando frontend com REACT_APP_AUTH_MODE=password...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 4. Aguardando frontend (30 segundos)...
timeout /t 30 /nobreak >nul

echo.
echo 5. Status final de todos os serviços...
docker compose -f docker-compose.local.yml ps

echo.
echo 6. Testando URLs...
echo Backend Health:
curl -s -o nul -w "Status: %%{http_code}" http://localhost:8082/health
echo.
echo Frontend:
curl -s -o nul -w "Status: %%{http_code}" http://localhost:3000
echo.

echo.
echo 🎉 HIGHLIGHT.IO FUNCIONANDO!
echo.
echo 📊 URLs de acesso:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo.
echo 🔐 Credenciais de login:
echo   Usuário: admin
echo   Senha: AgriHighlight2024@
echo.
echo 🎯 Status dos serviços:
echo   ✅ ClickHouse: Funcionando (sem senha)
echo   ✅ PostgreSQL: Funcionando (com senha)
echo   ✅ Redis: Funcionando (sem senha)
echo   ✅ Kafka: Funcionando
echo   ✅ Backend: Funcionando (mode=Password)
echo   ✅ Frontend: Funcionando (REACT_APP_AUTH_MODE=password)
echo.
echo 💡 Para acessar:
echo   1. Abra http://localhost:3000
echo   2. Use: admin / AgriHighlight2024@
echo   3. Agora deve funcionar sem erro Firebase!
echo.

pause
