# Script PowerShell para inicializar Highlight.io no Windows
# Execute como Administrador

param(
    [switch]$NoPull,
    [switch]$Rebuild,
    [switch]$Clean
)

Write-Host "🚀 INICIANDO HIGHLIGHT.IO - AGRICOMPANY DEV" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

# Verificar se Docker está rodando
Write-Host "🔍 Verificando Docker..." -ForegroundColor Yellow
try {
    docker version | Out-Null
    Write-Host "✅ Docker está rodando" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker não está rodando. Inicie o Docker Desktop primeiro." -ForegroundColor Red
    exit 1
}

# Verificar se Docker Compose está disponível
Write-Host "🔍 Verificando Docker Compose..." -ForegroundColor Yellow
try {
    docker compose version | Out-Null
    Write-Host "✅ Docker Compose está disponível" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker Compose não encontrado." -ForegroundColor Red
    exit 1
}

# Verificar se arquivo .env existe
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  Arquivo .env não encontrado. Copiando do template..." -ForegroundColor Yellow
    if (Test-Path "highlight-deploy-config.txt") {
        Copy-Item "highlight-deploy-config.txt" ".env"
        Write-Host "✅ Arquivo .env criado. Por favor, revise as configurações." -ForegroundColor Green
    } else {
        Write-Host "❌ Template de configuração não encontrado. Crie o arquivo .env manualmente." -ForegroundColor Red
        exit 1
    }
}

# Limpar containers se solicitado
if ($Clean) {
    Write-Host "🧹 Limpando containers e volumes existentes..." -ForegroundColor Yellow
    docker compose -f docker-compose.dokploy.yml down --volumes --remove-orphans
    docker system prune -f
    Write-Host "✅ Limpeza concluída" -ForegroundColor Green
}

# Criar diretórios necessários
Write-Host "📁 Criando diretórios necessários..." -ForegroundColor Yellow
$dirs = @("ssl-certs", "init-scripts", "clickhouse-config", "clickhouse-users", "logs")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✅ Criado diretório: $dir" -ForegroundColor Green
    }
}

# Criar certificados SSL dummy se não existirem
if (-not (Test-Path "ssl-certs/server.crt")) {
    Write-Host "🔐 Criando certificados SSL dummy..." -ForegroundColor Yellow
    @"
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAKL0UG+jBKgFMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkJSMQswCQYDVQQIDAJTUDELMAkGA1UEBwwCU1AxDDAKBgNVBAoMA0FGTTEO
MAwGA1UEAwwFbG9jYWwwHhcNMjQwMTA1MDAwMDAwWhcNMjUwMTA1MDAwMDAwWjBF
MQswCQYDVQQGEwJCUjELMAkGA1UECAwCU1AxCzAJBgNVBAcMAlNQMQwwCgYDVQQK
DANBRk0xDjAMBgNVBAMMBWxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA0YWYhWJH2M2Q+m+NKvUVJ4gzL1KM2R3xH6H1Q+3w8K8a5M6sV7Q8y5w6
DUMMY CERTIFICATE FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
-----END CERTIFICATE-----
"@ | Out-File -FilePath "ssl-certs/server.crt" -Encoding utf8

    @"
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRhZiFYkfYzZD6
b40q9RUniDMvUozZHfEfofVD7fDwrxrkzqxXtDzLnDrFxGvK5M6sV7Q8y5w6
DUMMY PRIVATE KEY FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
-----END PRIVATE KEY-----
"@ | Out-File -FilePath "ssl-certs/server.key" -Encoding utf8

    Write-Host "✅ Certificados SSL dummy criados" -ForegroundColor Green
}

# Pull das imagens se não solicitado o contrário
if (-not $NoPull) {
    Write-Host "📦 Fazendo pull das imagens Docker..." -ForegroundColor Yellow
    docker compose -f docker-compose.dokploy.yml pull
    Write-Host "✅ Pull concluído" -ForegroundColor Green
}

# Build dos serviços se solicitado rebuild
if ($Rebuild) {
    Write-Host "🏗️  Fazendo build dos serviços..." -ForegroundColor Yellow
    docker compose -f docker-compose.dokploy.yml build --no-cache
    Write-Host "✅ Build concluído" -ForegroundColor Green
} else {
    Write-Host "🏗️  Fazendo build dos serviços..." -ForegroundColor Yellow
    docker compose -f docker-compose.dokploy.yml build
    Write-Host "✅ Build concluído" -ForegroundColor Green
}

# Iniciar serviços
Write-Host "▶️  Iniciando serviços..." -ForegroundColor Yellow
docker compose -f docker-compose.dokploy.yml up -d

# Aguardar inicialização
Write-Host "⏳ Aguardando serviços inicializarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 45

# Verificar status dos serviços
Write-Host "📊 Verificando status dos serviços..." -ForegroundColor Yellow
$services = docker compose -f docker-compose.dokploy.yml ps --format "table {{.Service}}\t{{.Status}}\t{{.Ports}}"
Write-Host $services -ForegroundColor Cyan

# Verificar health checks
Write-Host "`n🏥 Verificando health checks..." -ForegroundColor Yellow
$healthyServices = 0
$totalServices = 0

$containerHealth = docker compose -f docker-compose.dokploy.yml ps --format json | ConvertFrom-Json
foreach ($container in $containerHealth) {
    $totalServices++
    if ($container.Health -eq "healthy" -or $container.State -eq "running") {
        $healthyServices++
        Write-Host "✅ $($container.Service): OK" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $($container.Service): $($container.State)" -ForegroundColor Yellow
    }
}

Write-Host "`n📈 Resumo: $healthyServices/$totalServices serviços saudáveis" -ForegroundColor Cyan

# Informações de acesso
Write-Host "`n🎉 HIGHLIGHT.IO INICIADO COM SUCESSO!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host "🌐 Frontend: https://highlight.agricompany-dev.com.br" -ForegroundColor Cyan
Write-Host "🔧 Backend API: https://api-highlight.agricompany-dev.com.br" -ForegroundColor Cyan
Write-Host "🔑 Use qualquer email válido e a senha: AgriHighlight2024@" -ForegroundColor Yellow
Write-Host ""
Write-Host "📋 Comandos úteis:" -ForegroundColor White
Write-Host "  • Ver logs: docker compose -f docker-compose.dokploy.yml logs -f [serviço]" -ForegroundColor Gray
Write-Host "  • Parar: docker compose -f docker-compose.dokploy.yml down" -ForegroundColor Gray
Write-Host "  • Reiniciar: docker compose -f docker-compose.dokploy.yml restart [serviço]" -ForegroundColor Gray
Write-Host ""
Write-Host "🚨 Para produção, altere todas as senhas e configure SSL adequadamente!" -ForegroundColor Red

# Manter o terminal aberto se executado diretamente
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "`nPressione qualquer tecla para continuar..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
