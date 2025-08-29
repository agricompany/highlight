start-highlight-windows.bat@echo off
chcp 65001 >nul
echo.
echo 🚀 INICIANDO HIGHLIGHT.IO - AGRICOMPANY DEV
echo ============================================
echo.

:: Verificar se Docker está rodando
echo 🔍 Verificando Docker...
docker version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker não está rodando. Inicie o Docker Desktop primeiro.
    pause
    exit /b 1
)
echo ✅ Docker está rodando

:: Verificar se Docker Compose está disponível
echo 🔍 Verificando Docker Compose...
docker compose version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker Compose não encontrado.
    pause
    exit /b 1
)
echo ✅ Docker Compose está disponível

:: Criar arquivo .env se não existir
if not exist ".env" (
    echo ⚠️  Arquivo .env não encontrado. Criando automaticamente...
    (
    echo # Configurações para Highlight.io Hobby Deployment - DOKPLOY
    echo ADMIN_PASSWORD=AgriHighlight2024@
    echo REACT_APP_FRONTEND_URI=https://highlight.agricompany-dev.com.br
    echo REACT_APP_PRIVATE_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/private
    echo REACT_APP_PUBLIC_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/public
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
    echo BACKEND_HEALTH_URI=http://localhost:8082/health
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
    echo ✅ Arquivo .env criado automaticamente
) else (
    echo ✅ Arquivo .env encontrado
)

:: Criar diretórios necessários
echo 📁 Criando diretórios necessários...
if not exist "ssl-certs" mkdir ssl-certs
if not exist "init-scripts" mkdir init-scripts
if not exist "clickhouse-config" mkdir clickhouse-config
if not exist "clickhouse-users" mkdir clickhouse-users
if not exist "logs" mkdir logs
echo ✅ Diretórios criados

:: Criar certificados SSL dummy se não existirem
if not exist "ssl-certs\server.crt" (
    echo 🔐 Criando certificados SSL dummy...
    
    (
    echo -----BEGIN CERTIFICATE-----
    echo MIIDXTCCAkWgAwIBAgIJAKL0UG+jBKgFMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
    echo BAYTAkJSMQswCQYDVQQIDAJTUDELMAkGA1UEBwwCU1AxDDAKBgNVBAoMA0FGTTEO
    echo MAwGA1UEAwwFbG9jYWwwHhcNMjQwMTA1MDAwMDAwWhcNMjUwMTA1MDAwMDAwWjBF
    echo DUMMY CERTIFICATE FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
    echo -----END CERTIFICATE-----
    ) > ssl-certs\server.crt
    
    (
    echo -----BEGIN PRIVATE KEY-----
    echo MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRhZiFYkfYzZD6
    echo b40q9RUniDMvUozZHfEfofVD7fDwrxrkzqxXtDzLnDrFxGvK5M6sV7Q8y5w6
    echo DUMMY PRIVATE KEY FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
    echo -----END PRIVATE KEY-----
    ) > ssl-certs\server.key
    
    echo ✅ Certificados SSL dummy criados
)

:: Parar containers existentes se houver
echo 🛑 Parando containers existentes...
docker compose -f docker-compose.local.yml down >nul 2>&1

:: Pull das imagens
echo 📦 Fazendo pull das imagens Docker...
docker compose -f docker-compose.local.yml pull
if %errorlevel% neq 0 (
    echo ❌ Erro ao fazer pull das imagens
    pause
    exit /b 1
)
echo ✅ Pull concluído

:: Build dos serviços
echo 🏗️  Fazendo build dos serviços...
docker compose -f docker-compose.local.yml build
if %errorlevel% neq 0 (
    echo ❌ Erro no build dos serviços
    pause
    exit /b 1
)
echo ✅ Build concluído

:: Iniciar serviços
echo ▶️  Iniciando serviços...
docker compose -f docker-compose.local.yml up -d
if %errorlevel% neq 0 (
    echo ❌ Erro ao iniciar serviços
    pause
    exit /b 1
)

:: Aguardar inicialização
echo ⏳ Aguardando serviços inicializarem...
timeout /t 45 /nobreak >nul

:: Verificar status dos serviços
echo 📊 Verificando status dos serviços...
docker compose -f docker-compose.local.yml ps

:: Informações de acesso
echo.
echo 🎉 HIGHLIGHT.IO INICIADO COM SUCESSO!
echo ============================================
echo 🌐 Frontend: http://localhost:3000
echo 🔧 Backend API: http://localhost:8082
echo 🔑 Use qualquer email válido e a senha: AgriHighlight2024@
echo.
echo 📋 Comandos úteis:
echo   • Ver logs: docker compose -f docker-compose.local.yml logs -f [serviço]
echo   • Parar: docker compose -f docker-compose.local.yml down
echo   • Reiniciar: docker compose -f docker-compose.local.yml restart [serviço]
echo.
echo 🚨 Para produção, altere todas as senhas e configure SSL adequadamente!
echo.

:: Perguntar se quer ver logs
set /p choice="Deseja ver os logs em tempo real? (s/N): "
if /i "%choice%"=="s" (
    docker compose -f docker-compose.local.yml logs -f
) else (
    echo Pressione qualquer tecla para continuar...
    pause >nul
)
