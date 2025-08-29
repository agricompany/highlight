@echo off
echo TESTANDO COLLECTOR
echo =================

echo Parando collector atual...
docker compose -f docker-compose.local.yml stop collector

echo Removendo container...
docker compose -f docker-compose.local.yml rm -f collector

echo Fazendo rebuild...
docker compose -f docker-compose.local.yml build --no-cache collector

echo Testando configuracao...
docker run --rm -v "%cd%\collector-ultra-simples.yml:/etc/otel-collector-config.yaml" otel/opentelemetry-collector-contrib:0.128.0 --config=/etc/otel-collector-config.yaml --dry-run

if %errorlevel% equ 0 (
    echo ✅ Configuracao valida!
    echo Iniciando collector...
    docker compose -f docker-compose.local.yml up -d collector
    timeout /t 10 /nobreak >nul
    echo Status:
    docker compose -f docker-compose.local.yml ps collector
    echo Logs:
    docker compose -f docker-compose.local.yml logs --tail=20 collector
) else (
    echo ❌ Configuracao invalida!
)

pause
