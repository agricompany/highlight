@echo off
echo REINICIANDO BACKEND
echo ===================

echo Parando backend...
docker compose -f docker-compose.local.yml stop backend

echo Removendo container backend...
docker compose -f docker-compose.local.yml rm -f backend

echo Aguardando dependencies...
echo Verificando PostgreSQL...
docker compose -f docker-compose.local.yml ps postgres

echo Verificando ClickHouse...
docker compose -f docker-compose.local.yml ps clickhouse

echo Verificando Redis...
docker compose -f docker-compose.local.yml ps redis

echo.
echo Iniciando backend...
docker compose -f docker-compose.local.yml up -d backend

echo.
echo Aguardando backend inicializar...
timeout /t 20 /nobreak >nul

echo.
echo Logs do backend:
docker compose -f docker-compose.local.yml logs --tail=15 backend

echo.
echo Status do backend:
docker compose -f docker-compose.local.yml ps backend

pause
