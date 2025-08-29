@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔑 VERIFICANDO JWT SECRET
================================
echo.

echo 🔥 Problema pode ser JWT_SECRET vazio ou inválido!

echo.
echo 1. Verificando JWT secrets no .env...
findstr "JWT" .env

echo.
echo 2. Verificando JWT secrets no container...
docker exec highlight-backend printenv | findstr "JWT"

echo.
echo 3. Verificando se JWT_ACCESS_SECRET está definido...
docker exec highlight-backend printenv JWT_ACCESS_SECRET

echo.
echo 4. Se JWT_ACCESS_SECRET estiver vazio, vamos corrigir...
echo Atualizando .env com JWT secrets válidos...

echo JWT_SECRET=highlight-jwt-secret-super-secure-key-2024 >> .env
echo JWT_ACCESS_SECRET=highlight-jwt-access-secret-super-secure-key-2024 >> .env

echo.
echo 5. Reiniciando backend com novos secrets...
docker compose -f docker-compose.local.yml stop backend
docker compose -f docker-compose.local.yml rm -f backend
docker compose -f docker-compose.local.yml up -d backend

echo.
echo 6. Aguardando backend reiniciar (30 segundos)...
timeout /t 30 /nobreak >nul

echo.
echo 7. Verificando se JWT secrets foram aplicados...
docker exec highlight-backend printenv JWT_ACCESS_SECRET

echo.
echo 8. Testando login novamente...
curl -X POST http://localhost:8082/private/login ^
  -H "Content-Type: application/json" ^
  -d "{\"email\":\"admin@highlight.io\",\"password\":\"password\"}"

echo.
echo 9. Verificando logs após correção...
docker compose -f docker-compose.local.yml logs --tail=10 backend

echo.
pause
