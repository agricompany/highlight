@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔐 TESTANDO LOGIN CORRETO
echo ================================
echo.

echo 🎉 DESCOBRI COMO FUNCIONA O LOGIN!
echo.
echo No modo Password do Highlight.io:
echo   ✅ Qualquer EMAIL válido pode fazer login
echo   ✅ A senha tem que ser igual ao ADMIN_PASSWORD
echo   ✅ Não precisa criar usuário no banco!

echo.
echo 1. Verificando ADMIN_PASSWORD atual...
findstr "ADMIN_PASSWORD" .env

echo.
echo 2. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 3. Verificando logs do backend para confirmar mode=Password...
docker compose -f docker-compose.local.yml logs backend | findstr "mode=" | tail -1

echo.
echo 🎯 CREDENCIAIS PARA TESTAR:
echo.
echo   URL: http://localhost:3000
echo   Email: admin@highlight.io  (ou qualquer email válido)
echo   Senha: password  (valor do ADMIN_PASSWORD)
echo.
echo   OU:
echo   Email: teste@agricompany.com.br
echo   Senha: password
echo.
echo   OU:
echo   Email: user@example.com
echo   Senha: password
echo.
echo 💡 IMPORTANTE:
echo   - O EMAIL tem que ter formato válido (com @)
echo   - A SENHA tem que ser exatamente "password"
echo   - Qualquer email funciona, não precisa existir no banco!
echo.
echo 🚀 Agora vá em http://localhost:3000 e teste!
echo.

pause
