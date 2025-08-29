@echo off
echo REINICIANDO COLLECTOR
echo ====================

echo Parando Collector...
docker compose -f docker-compose.local.yml stop collector

echo Removendo container Collector...
docker compose -f docker-compose.local.yml rm -f collector

echo Fazendo rebuild do Collector...
docker compose -f docker-compose.local.yml build --no-cache collector

echo Iniciando Collector...
docker compose -f docker-compose.local.yml up -d collector

echo Aguardando Collector inicializar...
timeout /t 15 /nobreak >nul

echo Verificando logs do Collector...
docker compose -f docker-compose.local.yml logs collector

echo.
echo Status do Collector:
docker compose -f docker-compose.local.yml ps collector

echo.
echo Collector reiniciado!
pause
