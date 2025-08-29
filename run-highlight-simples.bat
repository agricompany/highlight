@echo off
echo INICIANDO HIGHLIGHT.IO - AGRICOMPANY DEV
echo ========================================

:: Verificar Docker
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERRO: Docker nao esta rodando!
    pause
    exit /b 1
)
echo OK: Docker esta rodando

:: Criar arquivo .env automaticamente
echo Criando arquivo .env...
(
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
echo CLICKHOUSE_PASSWORD=highlight123
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
echo AUTH_MODE=password
echo SESSION_SECRET=AgriSession2024SuperSecretKey!
echo JWT_SECRET=AgriJWT2024SuperSecretSigningKey!
echo JWT_ACCESS_SECRET=AgriJWT2024SuperSecretSigningKey!
echo STORAGE_TYPE=filesystem
echo LOG_LEVEL=info
echo ENVIRONMENT=dev
echo OBJECT_STORAGE_FS=/highlight-data
echo LICENSE_KEY=
echo DISABLE_ENTERPRISE_FEATURES=true
echo CLICKHOUSE_USERNAME=default
echo CLICKHOUSE_DATABASE=default
echo METRICS_ENABLED=true
echo RATE_LIMIT_ENABLED=true
echo RATE_LIMIT_REQUESTS_PER_MINUTE=1000
) > .env
echo OK: Arquivo .env criado

:: Criar diretorios
mkdir ssl-certs 2>nul
mkdir init-scripts 2>nul
mkdir clickhouse-config 2>nul
mkdir clickhouse-users 2>nul
echo OK: Diretorios criados

:: Parar containers existentes
echo Parando containers existentes...
docker compose -f docker-compose.local.yml down >nul 2>&1

:: Fazer pull das imagens
echo Fazendo pull das imagens...
docker compose -f docker-compose.local.yml pull

:: Build dos servicos
echo Fazendo build...
docker compose -f docker-compose.local.yml build

:: Iniciar servicos
echo Iniciando servicos...
docker compose -f docker-compose.local.yml up -d

:: Aguardar
echo Aguardando inicializacao (60 segundos)...
timeout /t 60 /nobreak >nul

:: Status
echo Status dos servicos:
docker compose -f docker-compose.local.yml ps

echo.
echo HIGHLIGHT.IO INICIADO!
echo Frontend: http://localhost:3000
echo Backend: http://localhost:8082
echo Senha: AgriHighlight2024@
echo.
echo Para ver logs: docker compose -f docker-compose.local.yml logs -f
echo Para parar: docker compose -f docker-compose.local.yml down
echo.
pause
