@echo off
chcp 65001 >nul
echo.
echo ================================
echo  🔥 VOLTANDO AO QUE FUNCIONAVA
echo ================================
echo.

echo 💥 O .env oficial quebrou o PostgreSQL!
echo ✅ Vamos voltar ao nosso docker-compose que funcionava!

echo.
echo 1. Parando tudo...
docker compose -f docker\compose.hobby.yml down 2>nul
docker compose -f docker-compose.local.yml down

echo.
echo 2. Corrigindo .env com nossas configurações que funcionavam...
(
echo # HIGHLIGHT.IO HOBBY MODE - CONFIGURAÇÃO QUE FUNCIONA
echo REACT_APP_AUTH_MODE=password
echo ADMIN_PASSWORD=password
echo SSL=false
echo DISABLE_CORS=false
echo LICENSE_KEY=
echo.
echo # PostgreSQL - CONFIGURAÇÃO QUE FUNCIONAVA
echo PSQL_HOST=postgres
echo PSQL_DB=highlight
echo PSQL_USER=highlight
echo PSQL_PASSWORD=AgriPostgres2024Secure!
echo PSQL_PORT=5432
echo POSTGRES_DB=highlight
echo POSTGRES_USER=highlight
echo POSTGRES_PASSWORD=AgriPostgres2024Secure!
echo.
echo # ClickHouse - SEM SENHA
echo CLICKHOUSE_ADDRESS=clickhouse:9000
echo CLICKHOUSE_DATABASE=default
echo CLICKHOUSE_PASSWORD=
echo CLICKHOUSE_USERNAME=default
echo CLICKHOUSE_USER=default
echo.
echo # Redis - SEM SENHA
echo REDIS_EVENTS_STAGING_ENDPOINT=redis:6379
echo REDIS_PASSWORD=
echo.
echo # Kafka
echo KAFKA_SERVERS=kafka:9092
echo KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
echo.
echo # OpenTelemetry
echo OTLP_ENDPOINT=http://collector:4318
echo.
echo # URLs
echo REACT_APP_FRONTEND_URI=http://localhost:3000
echo REACT_APP_PRIVATE_GRAPH_URI=http://localhost:8082/private
echo REACT_APP_PUBLIC_GRAPH_URI=http://localhost:8082/public
echo.
echo # Configurações gerais
echo IN_DOCKER=true
echo IN_DOCKER_GO=true
echo ON_PREM=true
echo ENVIRONMENT=dev
echo STORAGE_TYPE=filesystem
echo LOG_LEVEL=info
echo OBJECT_STORAGE_FS=/highlight-data
echo SESSION_SECRET=AgriSession2024SuperSecretKey!
echo JWT_SECRET=AgriJWT2024SuperSecretSigningKey!
echo JWT_ACCESS_SECRET=AgriJWT2024SuperSecretSigningKey!
echo.
echo # Imagens
echo BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:docker-v0.5.2
echo FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:docker-v0.5.2
echo CLICKHOUSE_IMAGE_NAME=clickhouse/clickhouse-server:24.3.15.72-alpine
echo POSTGRES_IMAGE_NAME=ankane/pgvector:v0.5.1
echo REDIS_IMAGE_NAME=redis:8.0.2
echo KAFKA_IMAGE_NAME=confluentinc/cp-kafka:7.7.0
echo ZOOKEEPER_IMAGE_NAME=confluentinc/cp-zookeeper:7.7.0
echo OTEL_COLLECTOR_IMAGE_NAME=otel/opentelemetry-collector-contrib:0.128.0
) > .env

echo.
echo 3. Verificando .env corrigido...
echo Configurações críticas:
findstr "REACT_APP_AUTH_MODE\|PSQL_HOST\|ADMIN_PASSWORD" .env

echo.
echo 4. Iniciando com nosso docker-compose que funcionava...
docker compose -f docker-compose.local.yml up -d

echo.
echo 5. Aguardando backend (60 segundos)...
timeout /t 60 /nobreak >nul

echo.
echo 6. Verificando logs do backend...
docker compose -f docker-compose.local.yml logs --tail=10 backend

echo.
echo 7. Testando backend...
curl -s -o nul -w "Backend Status: %%{http_code}" http://localhost:8082/health
echo.

echo.
echo 8. Status final...
docker compose -f docker-compose.local.yml ps

echo.
echo 🎉 CREDENCIAIS:
echo   URL: http://localhost:3000
echo   Usuário: admin
echo   Senha: password
echo.
echo 🎯 Agora deve funcionar:
echo   ✅ PostgreSQL: Com nossas configurações
echo   ✅ REACT_APP_AUTH_MODE: password
echo   ✅ Backend: mode=Password
echo   ✅ Frontend: Sem erro Firebase
echo.

pause
