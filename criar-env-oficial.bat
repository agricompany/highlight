@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🎯 CRIANDO .ENV OFICIAL HOBBY
echo ================================
echo.

echo 🔥 Problema: Frontend ainda usa Firebase
echo 💡 Solução: Criar .env igual ao exemplo oficial

echo.
echo 1. Removendo .env antigo...
if exist .env del .env

echo.
echo 2. Criando .env oficial para HOBBY MODE...
(
echo # HIGHLIGHT.IO HOBBY MODE - CONFIGURAÇÃO OFICIAL
echo # docker compose config
echo COMPOSE_PATH_SEPARATOR=:
echo COMPOSE_PROJECT_NAME=highlight
echo COMPOSE_FILE=compose.yml
echo.
echo # docker images for highlight app
echo BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:docker-v0.5.2
echo FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:docker-v0.5.2
echo.
echo # docker images for dependencies
echo CLICKHOUSE_IMAGE_NAME=clickhouse/clickhouse-server:24.3.15.72-alpine
echo KAFKA_IMAGE_NAME=confluentinc/cp-kafka:7.7.0
echo OTEL_COLLECTOR_BUILD_IMAGE_NAME=alpine:3.21.3
echo OTEL_COLLECTOR_IMAGE_NAME=otel/opentelemetry-collector-contrib:0.128.0
echo POSTGRES_IMAGE_NAME=ankane/pgvector:v0.5.1
echo REDIS_IMAGE_NAME=redis:8.0.2
echo ZOOKEEPER_IMAGE_NAME=confluentinc/cp-zookeeper:7.7.0
echo.
echo # environment variables
echo CLICKHOUSE_ADDRESS=clickhouse:9000
echo CLICKHOUSE_DATABASE=default
echo CLICKHOUSE_PASSWORD=
echo CLICKHOUSE_USERNAME=default
echo CONSUMER_SPAN_SAMPLING_FRACTION=
echo DOPPLER_CONFIG=docker
echo EMAIL_OPT_OUT_SALT=salt
echo ENVIRONMENT=dev
echo GOMEMLIMIT=16GiB
echo IN_DOCKER=true
echo IN_DOCKER_GO=true
echo KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
echo KAFKA_ENV_PREFIX=
echo KAFKA_SERVERS=kafka:9092
echo KAFKA_TOPIC=dev
echo OAUTH_REDIRECT_URL=https://localhost:8082/private/oauth/callback
echo OBJECT_STORAGE_FS=/highlight-data
echo ON_PREM=true
echo OTLP_DOGFOOD_ENDPOINT=https://otel.highlight.io:4318
echo OTLP_ENDPOINT=http://collector:4318
echo PSQL_DB=postgres
echo PSQL_DOCKER_HOST=postgres
echo PSQL_HOST=postgres
echo PSQL_PASSWORD=
echo PSQL_PORT=5432
echo PSQL_USER=postgres
echo REACT_APP_DISABLE_ANALYTICS=false
echo REACT_APP_FRONTEND_ORG=1
echo REACT_APP_FRONTEND_URI=http://localhost:3000
echo REACT_APP_IN_DOCKER=true
echo REACT_APP_PRIVATE_GRAPH_URI=http://localhost:8082/private
echo REACT_APP_PUBLIC_GRAPH_URI=http://localhost:8082/public
echo REACT_APP_OTLP_ENDPOINT=http://localhost:4318
echo REDIS_EVENTS_STAGING_ENDPOINT=redis:6379
echo REDIS_PASSWORD=redispassword
echo RENDER_PREVIEW=true
echo SESSION_FILE_PATH_PREFIX=/tmp/
echo SESSION_RETENTION_DAYS=
echo TZ=America/Los_Angeles
echo WORKER_MAX_MEMORY_THRESHOLD=
echo.
echo # CONFIGURAÇÃO CRÍTICA PARA HOBBY MODE
echo SSL=false
echo DISABLE_CORS=false
echo REACT_APP_AUTH_MODE=password
echo ADMIN_PASSWORD=password
echo LICENSE_KEY=
echo.
echo # JWT Secrets
echo JWT_ACCESS_SECRET=highlight-jwt-secret-key
) > .env

echo.
echo 3. Verificando .env criado...
echo Variáveis críticas:
findstr "REACT_APP_AUTH_MODE\|ADMIN_PASSWORD\|SSL" .env

echo.
echo 4. Parando todos os serviços...
docker compose -f docker-compose.local.yml down

echo.
echo 5. Usando o compose OFICIAL do Highlight...
cd docker
echo Copiando compose.hobby.yml para o diretório atual...
copy compose.hobby.yml ..\docker-compose.hobby-oficial.yml
cd ..

echo.
echo 6. Iniciando infraestrutura primeiro...
docker compose -f docker-compose.local.yml up -d zookeeper redis postgres clickhouse kafka collector

echo.
echo 7. Aguardando infraestrutura (60 segundos)...
timeout /t 60 /nobreak >nul

echo.
echo 8. Iniciando backend e frontend com .env oficial...
docker compose -f docker\compose.hobby.yml up -d

echo.
echo 9. Aguardando aplicação (45 segundos)...
timeout /t 45 /nobreak >nul

echo.
echo 10. Verificando logs do backend...
docker compose -f docker\compose.hobby.yml logs backend | findstr "mode="

echo.
echo 11. Status final...
docker compose -f docker\compose.hobby.yml ps

echo.
echo 🎉 CREDENCIAIS OFICIAIS:
echo   URL: http://localhost:3000
echo   Usuário: admin
echo   Senha: password
echo.
echo 🎯 Agora usa o .env oficial igual ao exemplo!
echo.

pause
