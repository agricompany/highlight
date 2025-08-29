# 🚀 Highlight.io Deploy - DOKPLOY AgriCompany

Este repositório contém todos os arquivos necessários para fazer o deploy do Highlight.io no DOKPLOY com configurações específicas para a AgriCompany.

## 📋 Pré-requisitos

- Docker 25.0+ com Docker Compose 2.24+
- DOKPLOY configurado na VPS
- Domínios configurados:
  - `highlight.agricompany-dev.com.br` (Frontend)
  - `api-highlight.agricompany-dev.com.br` (Backend API)

## 🗂️ Estrutura de Arquivos

```
.
├── docker-compose.dokploy.yml        # Configuração principal do Docker Compose
├── highlight-deploy-config.txt       # Template das variáveis de ambiente (renomear para .env)
├── configure-collector-fixed.sh      # Script corrigido para configuração do collector
├── collector-fixed.Dockerfile        # Dockerfile corrigido para o collector
├── collector.yml                     # Configuração do OpenTelemetry Collector
├── start-highlight-windows.ps1       # Script de inicialização para Windows
├── start-highlight-linux.sh          # Script de inicialização para Linux/Mac
├── init-scripts/
│   └── 01-init-highlight.sql         # Script de inicialização do PostgreSQL
├── clickhouse-config/
│   └── highlight.xml                 # Configuração do ClickHouse
├── clickhouse-users/
│   └── highlight-users.xml           # Usuários do ClickHouse
└── README-DOKPLOY.md                 # Este arquivo
```

## 🔧 Configuração Inicial

### 1. Preparar Variáveis de Ambiente

```bash
# Copiar o template para .env
cp highlight-deploy-config.txt .env
```

**Variáveis principais configuradas:**
- `ADMIN_PASSWORD=AgriHighlight2024@`
- `REDIS_PASSWORD=AgriRedis2024SecurePass!`
- `POSTGRES_PASSWORD=AgriPostgres2024Secure!`
- `CLICKHOUSE_PASSWORD=AgriClickHouse2024!`
- `SESSION_SECRET=AgriSession2024SuperSecretKey!`
- `JWT_SECRET=AgriJWT2024SuperSecretSigningKey!`

### 2. Domínios Configurados

- **Frontend**: `https://highlight.agricompany-dev.com.br`
- **Backend API**: `https://api-highlight.agricompany-dev.com.br`
  - Private GraphQL: `/private`
  - Public GraphQL: `/public`
  - Health Check: `/health`

## 🚀 Deploy no DOKPLOY

### Opção 1: Upload Manual

1. **Criar novo projeto no DOKPLOY**
2. **Fazer upload de todos os arquivos**
3. **Configurar variáveis de ambiente**:
   - Copie todas as variáveis do arquivo `.env`
   - Configure os domínios nos labels do Traefik
4. **Iniciar deploy**

### Opção 2: Git Repository

1. **Criar repositório Git com estes arquivos**
2. **Conectar o DOKPLOY ao repositório**
3. **Configurar auto-deploy**

## 💻 Execução Local (Teste)

### Windows (PowerShell como Administrador)

```powershell
# Execução básica
.\start-highlight-windows.ps1

# Opções avançadas
.\start-highlight-windows.ps1 -Rebuild      # Force rebuild
.\start-highlight-windows.ps1 -Clean        # Limpar tudo antes
.\start-highlight-windows.ps1 -NoPull       # Não fazer pull das imagens
```

### Linux/Mac

```bash
# Tornar executável
chmod +x start-highlight-linux.sh

# Execução básica
./start-highlight-linux.sh

# Opções avançadas
./start-highlight-linux.sh --rebuild        # Force rebuild
./start-highlight-linux.sh --clean          # Limpar tudo antes
./start-highlight-linux.sh --no-pull        # Não fazer pull das imagens
```

## 🏗️ Arquitetura dos Serviços

### Infraestrutura
- **PostgreSQL** (pgvector): Base principal de dados
- **ClickHouse**: Analytics e métricas
- **Redis**: Cache e sessões
- **Kafka + Zookeeper**: Message queue
- **OpenTelemetry Collector**: Telemetria

### Aplicação
- **Backend**: API GraphQL (porta 8082)
- **Frontend**: Interface web (porta 3000)

## 🔐 Segurança

### Senhas Padrão (ALTERAR EM PRODUÇÃO!)
- **Admin**: `AgriHighlight2024@`
- **Redis**: `AgriRedis2024SecurePass!`
- **PostgreSQL**: `AgriPostgres2024Secure!`
- **ClickHouse**: `AgriClickHouse2024!`

### Certificados SSL
- Certificados dummy incluídos para desenvolvimento
- **Configure certificados reais em produção**

## 📊 Monitoramento

### Health Checks
Todos os serviços possuem health checks configurados:
- **Backend**: `http://localhost:8082/health`
- **Frontend**: `http://localhost:3000/health`
- **Collector**: `http://localhost:4319/health/status`
- **ClickHouse**: `http://localhost:8123/ping`

### Logs
```bash
# Ver logs de todos os serviços
docker compose -f docker-compose.dokploy.yml logs -f

# Ver logs de um serviço específico
docker compose -f docker-compose.dokploy.yml logs -f backend
docker compose -f docker-compose.dokploy.yml logs -f frontend
```

## 🐛 Troubleshooting

### Problemas Comuns

#### 1. Erro no Collector (`/bin/sh: illegal option -`)
**Solução**: Use o `collector-fixed.Dockerfile` que instala bash no Alpine.

#### 2. Serviços não inicializam
```bash
# Verificar status
docker compose -f docker-compose.dokploy.yml ps

# Verificar logs
docker compose -f docker-compose.dokploy.yml logs [serviço]

# Reiniciar serviço específico
docker compose -f docker-compose.dokploy.yml restart [serviço]
```

#### 3. Problemas de conectividade
- Verificar se todas as portas estão livres
- Verificar configuração de rede no DOKPLOY
- Verificar DNS dos domínios

#### 4. Banco de dados não inicializa
```bash
# Verificar logs do PostgreSQL
docker compose -f docker-compose.dokploy.yml logs postgres

# Verificar se o volume não está corrompido
docker volume ls
docker volume inspect highlight_postgres-data
```

### Comandos Úteis

```bash
# Status completo
docker compose -f docker-compose.dokploy.yml ps

# Reiniciar tudo
docker compose -f docker-compose.dokploy.yml restart

# Parar tudo
docker compose -f docker-compose.dokploy.yml down

# Limpar volumes (CUIDADO: apaga dados!)
docker compose -f docker-compose.dokploy.yml down --volumes

# Rebuild completo
docker compose -f docker-compose.dokploy.yml build --no-cache
```

## 🔄 Atualizações

### Atualizar Imagens
```bash
docker compose -f docker-compose.dokploy.yml pull
docker compose -f docker-compose.dokploy.yml up -d
```

### Atualizar Configurações
1. Modifique os arquivos necessários
2. Rebuild os serviços afetados:
```bash
docker compose -f docker-compose.dokploy.yml build [serviço]
docker compose -f docker-compose.dokploy.yml up -d [serviço]
```

## 📚 Configuração do Cliente

Para usar o Highlight.io em sua aplicação:

```javascript
import { H } from 'highlight.run';

H.init('<YOUR_PROJECT_ID>', {
  backendUrl: 'https://api-highlight.agricompany-dev.com.br/public',
  // outras configurações...
});
```

## 🎯 Próximos Passos

1. **Teste o deployment local** usando os scripts fornecidos
2. **Configure os domínios** no seu DNS
3. **Faça o upload no DOKPLOY**
4. **Altere todas as senhas** para valores seguros
5. **Configure SSL real** se necessário
6. **Monitore os logs** para garantir funcionamento

## 📞 Suporte

- Documentação oficial: [highlight.io/docs](https://www.highlight.io/docs)
- GitHub: [highlight/highlight](https://github.com/highlight/highlight)

---

**⚠️ IMPORTANTE**: Este é um ambiente de desenvolvimento. Para produção, revise todas as configurações de segurança, senhas e certificados!
