#!/bin/bash
set -e

# Script para inicializar Highlight.io no Linux/Mac
# Highlight.io - AgriCompany Dev Environment

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# Flags
NO_PULL=false
REBUILD=false
CLEAN=false

# Parse argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
    --no-pull)
      NO_PULL=true
      shift
      ;;
    --rebuild)
      REBUILD=true
      shift
      ;;
    --clean)
      CLEAN=true
      shift
      ;;
    *)
      echo "Uso: $0 [--no-pull] [--rebuild] [--clean]"
      exit 1
      ;;
  esac
done

echo -e "${GREEN}🚀 INICIANDO HIGHLIGHT.IO - AGRICOMPANY DEV${NC}"
echo -e "${GREEN}============================================${NC}"

# Verificar se Docker está rodando
echo -e "${YELLOW}🔍 Verificando Docker...${NC}"
if docker version >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker está rodando${NC}"
else
    echo -e "${RED}❌ Docker não está rodando. Inicie o Docker primeiro.${NC}"
    exit 1
fi

# Verificar se Docker Compose está disponível
echo -e "${YELLOW}🔍 Verificando Docker Compose...${NC}"
if docker compose version >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Docker Compose está disponível${NC}"
else
    echo -e "${RED}❌ Docker Compose não encontrado.${NC}"
    exit 1
fi

# Verificar se arquivo .env existe
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Arquivo .env não encontrado. Copiando do template...${NC}"
    if [ -f "highlight-deploy-config.txt" ]; then
        cp "highlight-deploy-config.txt" ".env"
        echo -e "${GREEN}✅ Arquivo .env criado. Por favor, revise as configurações.${NC}"
    else
        echo -e "${RED}❌ Template de configuração não encontrado. Crie o arquivo .env manualmente.${NC}"
        exit 1
    fi
fi

# Limpar containers se solicitado
if [ "$CLEAN" = true ]; then
    echo -e "${YELLOW}🧹 Limpando containers e volumes existentes...${NC}"
    docker compose -f docker-compose.dokploy.yml down --volumes --remove-orphans || true
    docker system prune -f || true
    echo -e "${GREEN}✅ Limpeza concluída${NC}"
fi

# Criar diretórios necessários
echo -e "${YELLOW}📁 Criando diretórios necessários...${NC}"
for dir in ssl-certs init-scripts clickhouse-config clickhouse-users logs; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo -e "${GREEN}✅ Criado diretório: $dir${NC}"
    fi
done

# Criar certificados SSL dummy se não existirem
if [ ! -f "ssl-certs/server.crt" ]; then
    echo -e "${YELLOW}🔐 Criando certificados SSL dummy...${NC}"
    
    cat > ssl-certs/server.crt << 'EOF'
-----BEGIN CERTIFICATE-----
MIIDXTCCAkWgAwIBAgIJAKL0UG+jBKgFMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV
BAYTAkJSMQswCQYDVQQIDAJTUDELMAkGA1UEBwwCU1AxDDAKBgNVBAoMA0FGTTEO
MAwGA1UEAwwFbG9jYWwwHhcNMjQwMTA1MDAwMDAwWhcNMjUwMTA1MDAwMDAwWjBF
MQswCQYDVQQGEwJCUjELMAkGA1UECAwCU1AxCzAJBgNVBAcMAlNQMQwwCgYDVQQK
DANBRk0xDjAMBgNVBAMMBWxvY2FsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEA0YWYhWJH2M2Q+m+NKvUVJ4gzL1KM2R3xH6H1Q+3w8K8a5M6sV7Q8y5w6
DUMMY CERTIFICATE FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
-----END CERTIFICATE-----
EOF

    cat > ssl-certs/server.key << 'EOF'
-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRhZiFYkfYzZD6
b40q9RUniDMvUozZHfEfofVD7fDwrxrkzqxXtDzLnDrFxGvK5M6sV7Q8y5w6
DUMMY PRIVATE KEY FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE
-----END PRIVATE KEY-----
EOF
    
    echo -e "${GREEN}✅ Certificados SSL dummy criados${NC}"
fi

# Tornar script de configure executável
chmod +x configure-collector-fixed.sh

# Pull das imagens se não solicitado o contrário
if [ "$NO_PULL" = false ]; then
    echo -e "${YELLOW}📦 Fazendo pull das imagens Docker...${NC}"
    docker compose -f docker-compose.dokploy.yml pull
    echo -e "${GREEN}✅ Pull concluído${NC}"
fi

# Build dos serviços
if [ "$REBUILD" = true ]; then
    echo -e "${YELLOW}🏗️  Fazendo build dos serviços (sem cache)...${NC}"
    docker compose -f docker-compose.dokploy.yml build --no-cache
    echo -e "${GREEN}✅ Build concluído${NC}"
else
    echo -e "${YELLOW}🏗️  Fazendo build dos serviços...${NC}"
    docker compose -f docker-compose.dokploy.yml build
    echo -e "${GREEN}✅ Build concluído${NC}"
fi

# Iniciar serviços
echo -e "${YELLOW}▶️  Iniciando serviços...${NC}"
docker compose -f docker-compose.dokploy.yml up -d

# Aguardar inicialização
echo -e "${YELLOW}⏳ Aguardando serviços inicializarem...${NC}"
sleep 45

# Verificar status dos serviços
echo -e "${YELLOW}📊 Verificando status dos serviços...${NC}"
docker compose -f docker-compose.dokploy.yml ps

# Verificar health checks
echo -e "${YELLOW}🏥 Verificando health dos containers...${NC}"
containers=($(docker compose -f docker-compose.dokploy.yml ps --services))
healthy_count=0
total_count=${#containers[@]}

for container in "${containers[@]}"; do
    container_name="highlight-$container"
    if docker ps --filter "name=$container_name" --filter "health=healthy" | grep -q "$container_name" 2>/dev/null; then
        echo -e "${GREEN}✅ $container: SAUDÁVEL${NC}"
        ((healthy_count++))
    elif docker ps --filter "name=$container_name" --filter "status=running" | grep -q "$container_name" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  $container: RODANDO (sem health check)${NC}"
        ((healthy_count++))
    else
        echo -e "${RED}❌ $container: PROBLEMA${NC}"
    fi
done

echo -e "${CYAN}📈 Resumo: $healthy_count/$total_count serviços operacionais${NC}"

# Informações de acesso
echo -e "\n${GREEN}🎉 HIGHLIGHT.IO INICIADO COM SUCESSO!${NC}"
echo -e "${GREEN}============================================${NC}"
echo -e "${CYAN}🌐 Frontend: https://highlight.agricompany-dev.com.br${NC}"
echo -e "${CYAN}🔧 Backend API: https://api-highlight.agricompany-dev.com.br${NC}"
echo -e "${YELLOW}🔑 Use qualquer email válido e a senha: AgriHighlight2024@${NC}"
echo ""
echo -e "${WHITE}📋 Comandos úteis:${NC}"
echo -e "${GRAY}  • Ver logs: docker compose -f docker-compose.dokploy.yml logs -f [serviço]${NC}"
echo -e "${GRAY}  • Parar: docker compose -f docker-compose.dokploy.yml down${NC}"
echo -e "${GRAY}  • Reiniciar: docker compose -f docker-compose.dokploy.yml restart [serviço]${NC}"
echo ""
echo -e "${RED}🚨 Para produção, altere todas as senhas e configure SSL adequadamente!${NC}"
echo ""

# Mostrar logs em tempo real se solicitado
read -p "Deseja ver os logs em tempo real? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker compose -f docker-compose.dokploy.yml logs -f
fi
