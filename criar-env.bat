@echo off
echo Criando arquivo .env para Highlight.io...

(
echo # Configuracoes para Highlight.io Hobby Deployment - DOKPLOY
echo # Configuracoes do Admin
echo ADMIN_PASSWORD=AgriHighlight2024@
echo.
echo # URLs da aplicacao - DOKPLOY AGRICOMPANY
echo REACT_APP_FRONTEND_URI=https://highlight.agricompany-dev.com.br
echo REACT_APP_PRIVATE_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/private
echo REACT_APP_PUBLIC_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/public
echo.
echo # Configuracoes de SSL
echo SSL=false
echo.
echo # Configuracoes do Redis
echo REDIS_PASSWORD=AgriRedis2024SecurePass!
echo.
echo # Database Settings
echo POSTGRES_DB=highlight
echo POSTGRES_USER=highlight
echo POSTGRES_PASSWORD=AgriPostgres2024Secure!
echo.
echo # Configuracoes do ClickHouse
echo CLICKHOUSE_USER=default
echo CLICKHOUSE_PASSWORD=AgriClickHouse2024!
echo.
echo # Imagens Docker
echo BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:latest
echo FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:latest
echo OTEL_COLLECTOR_IMAGE_NAME=otel/opentelemetry-collector-contrib:latest
echo OTEL_COLLECTOR_ALPINE_IMAGE_NAME=alpine:latest
echo CLICKHOUSE_IMAGE_NAME=clickhouse/clickhouse-server:latest
echo POSTGRES_IMAGE_NAME=pgvector/pgvector:pg15
echo REDIS_IMAGE_NAME=redis:7-alpine
echo KAFKA_IMAGE_NAME=confluentinc/cp-kafka:latest
echo ZOOKEEPER_IMAGE_NAME=confluentinc/cp-zookeeper:latest
echo.
echo # Configuracoes internas ^(nao alterar^)
echo IN_DOCKER=true
echo IN_DOCKER_GO=true
echo ON_PREM=true
echo KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
echo KAFKA_SERVERS=kafka:9092
echo CLICKHOUSE_ADDRESS=clickhouse:9000
echo PSQL_HOST=postgres
echo REDIS_EVENTS_STAGING_ENDPOINT=redis:6379
echo OTLP_ENDPOINT=http://collector:4318
echo OTLP_DOGFOOD_ENDPOINT=https://otel.highlight.io:4318
echo.
echo # Configuracao de autenticacao
echo AUTH_MODE=password
echo.
echo # Configuracoes de seguranca
echo BACKEND_HEALTH_URI=https://api-highlight.agricompany-dev.com.br/health
echo.
echo # Session settings
echo SESSION_SECRET=AgriSession2024SuperSecretKey!
echo.
echo # JWT Settings
echo JWT_SECRET=AgriJWT2024SuperSecretSigningKey!
echo.
echo # Storage
echo STORAGE_TYPE=filesystem
echo.
echo # Logging
echo LOG_LEVEL=info
echo.
echo # Metrics
echo METRICS_ENABLED=true
echo.
echo # Rate limiting
echo RATE_LIMIT_ENABLED=true
echo RATE_LIMIT_REQUESTS_PER_MINUTE=1000
) > .env

echo Arquivo .env criado com sucesso!
echo Execute agora: start-highlight-windows.bat
pause
