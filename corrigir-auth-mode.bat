@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔧 CORRIGINDO AUTH_MODE HOBBY
echo ================================
echo.

echo ✅ ClickHouse: FUNCIONANDO
echo 🔧 Problema: AUTH_MODE estava como Firebase (enterprise)
echo 💡 Solução: Mudando para password (hobby)

echo.
echo 1. Parando backend...
docker compose -f docker-compose.local.yml stop backend

echo.
echo 2. Removendo container do backend...
docker compose -f docker-compose.local.yml rm -f backend

echo.
echo 3. Verificando variável AUTH_MODE no .env...
if exist .env (
    echo Arquivo .env encontrado:
    findstr "AUTH_MODE" .env
    echo.
    echo Atualizando AUTH_MODE para password...
    powershell -Command "(Get-Content .env) -replace 'AUTH_MODE=.*', 'AUTH_MODE=password' | Set-Content .env"
    echo Novo valor:
    findstr "AUTH_MODE" .env
) else (
    echo ❌ Arquivo .env não encontrado!
    echo Criando .env básico...
    echo AUTH_MODE=password > .env
)

echo.
echo 4. Recriando backend com AUTH_MODE correto...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 5. Aguardando backend inicializar (45 segundos)...
timeout /t 45 /nobreak >nul

echo.
echo 6. Verificando logs do backend...
docker compose -f docker-compose.local.yml logs --tail=15 backend

echo.
echo 7. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 8. Se backend funcionou, iniciando frontend...
docker compose -f docker-compose.local.yml up -d frontend

echo.
echo 9. Status final...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎉 URLs de acesso:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo   ClickHouse: http://localhost:8123
echo.
echo 🔐 Login:
echo   Usuário: admin
echo   Senha: %ADMIN_PASSWORD% (ou AgriHighlight2024@)
echo.

pause
