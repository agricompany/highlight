@echo off
echo LIMPANDO E REINICIANDO HIGHLIGHT.IO
echo ===================================

echo Parando todos os containers...
docker compose -f docker-compose.local.yml down --volumes

echo Removendo imagens antigas...
docker rmi confluentinc/cp-kafka:latest 2>nul
docker rmi confluentinc/cp-zookeeper:latest 2>nul
docker rmi confluentinc/cp-kafka:7.4.0 2>nul
docker rmi confluentinc/cp-zookeeper:7.4.0 2>nul
docker rmi ghcr.io/highlight/highlight-backend:latest 2>nul
docker rmi ghcr.io/highlight/highlight-frontend:latest 2>nul
docker rmi redis:7-alpine 2>nul
docker rmi pgvector/pgvector:pg15 2>nul
docker rmi clickhouse/clickhouse-server:latest 2>nul
docker rmi otel/opentelemetry-collector-contrib:latest 2>nul
docker rmi alpine:latest 2>nul

echo Limpando cache do Docker...
docker system prune -f

echo Removendo volumes antigos...
docker volume rm highlight_kafka-data 2>nul
docker volume rm highlight_zoo-data 2>nul
docker volume rm highlight_zoo-log 2>nul
docker volume rm highlight_clickhouse-data 2>nul
docker volume rm highlight_clickhouse-logs 2>nul
docker volume rm highlight_postgres-data 2>nul
docker volume rm highlight_redis-data 2>nul
docker volume rm highlight_highlight-data 2>nul

echo Limpeza concluida!
echo.
echo Agora execute: start-highlight-windows.bat
pause
