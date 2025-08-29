@echo off
chcp 65001 >nul
echo.
echo ================================
echo  💥 CORRIGINDO .ENV DEFINITIVO
echo ================================
echo.

echo 🔥 PROBLEMA: O container está lendo AUTH_MODE=firebase do .env
echo 💡 SOLUÇÃO: Vamos recriar o .env com AUTH_MODE=password

echo.
echo 1. Parando tudo...
docker compose -f docker-compose.local.yml down

echo.
echo 2. Verificando .env atual...
if exist .env (
    echo Conteúdo atual do .env:
    echo ========================
    type .env | findstr "AUTH_MODE"
    echo ========================
) else (
    echo .env não existe
)

echo.
echo 3. Criando .env CORRETO para HOBBY...
(
echo # HIGHLIGHT.IO HOBBY MODE - CONFIGURAÇÃO CORRETA
echo AUTH_MODE=password
echo ADMIN_PASSWORD=AgriHighlight2024@
echo REACT_APP_FRONTEND_URI=http://localhost:3000
echo REACT_APP_PRIVATE_GRAPH_URI=http://localhost:8082/private
echo REACT_APP_PUBLIC_GRAPH_URI=http://localhost:8082/public
echo SSL=false
echo REDIS_PASSWORD=AgriRedis2024SecurePass!
echo POSTGRES_DB=highlight
echo POSTGRES_USER=highlight
echo POSTGRES_PASSWORD=AgriPostgres2024Secure!
echo CLICKHOUSE_USER=default
echo BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:docker-v0.5.2
echo FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:docker-v0.5.2
echo OTEL_COLLECTOR_IMAGE_NAME=otel/opentelemetry-collector-contrib:0.128.0
echo OTEL_COLLECTOR_ALPINE_IMAGE_NAME=alpine:3.21.3
echo CLICKHOUSE_IMAGE_NAME=clickhouse/clickhouse-server:24.3.15.72-alpine
echo POSTGRES_IMAGE_NAME=ankane/pgvector:v0.5.1
echo REDIS_IMAGE_NAME=redis:8.0.2
echo KAFKA_IMAGE_NAME=confluentinc/cp-kafka:7.7.0
echo ZOOKEEPER_IMAGE_NAME=confluentinc/cp-zookeeper:7.7.0
echo IN_DOCKER=true
echo IN_DOCKER_GO=true
echo ON_PREM=true
echo KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
echo KAFKA_SERVERS=kafka:9092
echo CLICKHOUSE_ADDRESS=clickhouse:9000
echo PSQL_HOST=postgres
echo PSQL_DB=highlight
echo PSQL_USER=highlight
echo PSQL_PASSWORD=AgriPostgres2024Secure!
echo PSQL_PORT=5432
echo REDIS_EVENTS_STAGING_ENDPOINT=redis:6379
echo OTLP_ENDPOINT=http://collector:4318
echo OTLP_DOGFOOD_ENDPOINT=https://otel.highlight.io:4318
echo BACKEND_HEALTH_URI=http://localhost:8082/health
echo SESSION_SECRET=AgriSession2024SuperSecretKey!
echo JWT_SECRET=AgriJWT2024SuperSecretSigningKey!
echo JWT_ACCESS_SECRET=AgriJWT2024SuperSecretSigningKey!
echo STORAGE_TYPE=filesystem
echo LOG_LEVEL=info
echo ENVIRONMENT=dev
echo OBJECT_STORAGE_FS=/highlight-data
echo CLICKHOUSE_USERNAME=default
echo CLICKHOUSE_DATABASE=default
echo METRICS_ENABLED=true
echo RATE_LIMIT_ENABLED=true
echo RATE_LIMIT_REQUESTS_PER_MINUTE=1000
echo LICENSE_KEY=
echo DISABLE_ENTERPRISE_FEATURES=true
) > .env

echo.
echo 4. Verificando .env novo...
echo Novo conteúdo do .env:
echo ========================
type .env | findstr "AUTH_MODE"
echo ========================

echo.
echo 5. Iniciando serviços...
docker compose -f docker-compose.local.yml up -d

echo.
echo 6. Aguardando backend (60 segundos)...
timeout /t 60 /nobreak >nul

echo.
echo 7. Verificando logs do backend...
docker compose -f docker-compose.local.yml logs --tail=10 backend

echo.
echo 8. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 9. Status final...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎉 Se funcionou:
echo   Frontend: http://localhost:3000
echo   Backend:  http://localhost:8082/health
echo   Login: admin / AgriHighlight2024@
echo.

pause
