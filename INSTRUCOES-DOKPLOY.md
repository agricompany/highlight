# 🚀 INSTRUÇÕES COMPLETAS - DEPLOY HIGHLIGHT.IO NO DOKPLOY

## 📋 PASSO A PASSO PARA RODAR NO WINDOWS

### 1. Preparar Ambiente Local (Teste)

```batch
# 1. Abrir PowerShell/CMD como Administrador no diretório dos arquivos

# 2. Criar arquivo .env
criar-env.bat

# 3. Iniciar Highlight.io
start-highlight-windows.bat
```

### 2. Comandos Alternativos PowerShell

Se preferir PowerShell:
```powershell
# Executar como Administrador
.\start-highlight-windows.ps1

# Com opções
.\start-highlight-windows.ps1 -Rebuild    # Force rebuild
.\start-highlight-windows.ps1 -Clean      # Limpar tudo antes
.\start-highlight-windows.ps1 -NoPull     # Não fazer pull
```

---

## 🌐 CONFIGURAÇÃO NO DOKPLOY

### Passo 1: Preparar Arquivos

1. **Faça upload de TODOS estes arquivos no seu projeto DOKPLOY:**
   ```
   ✅ docker-compose.dokploy.yml
   ✅ collector-fixed.Dockerfile
   ✅ configure-collector-fixed.sh
   ✅ collector.yml
   ✅ highlight-deploy-config.txt (renomear para .env)
   ✅ init-scripts/01-init-highlight.sql
   ✅ clickhouse-config/highlight.xml
   ✅ clickhouse-users/highlight-users.xml
   ```

### Passo 2: Configurar Variáveis de Ambiente no DOKPLOY

Vá em **Environment Variables** e adicione:

```bash
# PRINCIPAIS (ALTERAR CONFORME NECESSÁRIO)
ADMIN_PASSWORD=AgriHighlight2024@
REACT_APP_FRONTEND_URI=https://highlight.agricompany-dev.com.br
REACT_APP_PRIVATE_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/private
REACT_APP_PUBLIC_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/public

# SENHAS DOS BANCOS (ALTERAR EM PRODUÇÃO!)
REDIS_PASSWORD=AgriRedis2024SecurePass!
POSTGRES_DB=highlight
POSTGRES_USER=highlight
POSTGRES_PASSWORD=AgriPostgres2024Secure!
CLICKHOUSE_USER=default
CLICKHOUSE_PASSWORD=AgriClickHouse2024!

# SEGURANÇA
SESSION_SECRET=AgriSession2024SuperSecretKey!
JWT_SECRET=AgriJWT2024SuperSecretSigningKey!

# CONFIGURAÇÕES TÉCNICAS (NÃO ALTERAR)
SSL=false
IN_DOCKER=true
IN_DOCKER_GO=true
ON_PREM=true
AUTH_MODE=password
KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092
KAFKA_SERVERS=kafka:9092
CLICKHOUSE_ADDRESS=clickhouse:9000
PSQL_HOST=postgres
REDIS_EVENTS_STAGING_ENDPOINT=redis:6379
OTLP_ENDPOINT=http://collector:4318
OTLP_DOGFOOD_ENDPOINT=https://otel.highlight.io:4318
BACKEND_HEALTH_URI=https://api-highlight.agricompany-dev.com.br/health
STORAGE_TYPE=filesystem
LOG_LEVEL=info
METRICS_ENABLED=true
RATE_LIMIT_ENABLED=true
RATE_LIMIT_REQUESTS_PER_MINUTE=1000

# IMAGENS DOCKER
BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:latest
FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:latest
OTEL_COLLECTOR_IMAGE_NAME=otel/opentelemetry-collector-contrib:latest
OTEL_COLLECTOR_ALPINE_IMAGE_NAME=alpine:latest
CLICKHOUSE_IMAGE_NAME=clickhouse/clickhouse-server:latest
POSTGRES_IMAGE_NAME=pgvector/pgvector:pg15
REDIS_IMAGE_NAME=redis:7-alpine
KAFKA_IMAGE_NAME=confluentinc/cp-kafka:latest
ZOOKEEPER_IMAGE_NAME=confluentinc/cp-zookeeper:latest
```

### Passo 3: Configurar Domínios no DOKPLOY

1. **Adicionar domínios no seu DNS:**
   - `highlight.agricompany-dev.com.br` → IP da sua VPS
   - `api-highlight.agricompany-dev.com.br` → IP da sua VPS

2. **Configurar no DOKPLOY:**
   - Vá em **Domains** 
   - Adicione os dois domínios
   - Configure SSL automático (Let's Encrypt)

### Passo 4: Deploy

1. **Selecionar arquivo Docker Compose:**
   - Use `docker-compose.dokploy.yml`

2. **Iniciar Deploy:**
   - Clique em **Deploy**
   - Aguarde todos os serviços subirem

3. **Verificar Status:**
   - Todos os containers devem estar "healthy" ou "running"

---

## 🔧 CONFIGURAÇÃO DETALHADA DOS SERVIÇOS

### Portas Utilizadas
- **Frontend**: 3000
- **Backend**: 8082  
- **PostgreSQL**: 5432
- **ClickHouse**: 8123, 9000
- **Redis**: 6379
- **Kafka**: 9092
- **Zookeeper**: 2181
- **Collector**: 4317, 4318, 4319

### Health Checks Configurados
- ✅ Backend: `/health`
- ✅ Frontend: `/health` 
- ✅ PostgreSQL: `pg_isready`
- ✅ Redis: `redis-cli ping`
- ✅ ClickHouse: `/ping`
- ✅ Collector: `/health/status`

### Volumes Persistentes
- `postgres-data`: Dados do PostgreSQL
- `clickhouse-data`: Dados do ClickHouse  
- `redis-data`: Dados do Redis
- `kafka-data`: Dados do Kafka
- `highlight-data`: Dados da aplicação

---

## 🚨 TROUBLESHOOTING

### Problema: Collector não inicia
```bash
# Verificar logs
docker compose -f docker-compose.dokploy.yml logs collector

# Solução: Certificados SSL
# Os certificados dummy são criados automaticamente
```

### Problema: Backend não conecta no banco
```bash
# Verificar se PostgreSQL está healthy
docker compose -f docker-compose.dokploy.yml ps

# Verificar logs do banco
docker compose -f docker-compose.dokploy.yml logs postgres
```

### Problema: Serviços não ficam healthy
```bash
# Aguardar mais tempo (até 2 minutos)
# Verificar se todas as portas estão livres
netstat -an | findstr "3000 8082 5432 6379"
```

### Problema: Erro de build
```bash
# Limpar cache e rebuild
docker compose -f docker-compose.dokploy.yml build --no-cache
```

---

## 📊 COMANDOS ÚTEIS

### Verificar Status
```bash
# Status geral
docker compose -f docker-compose.dokploy.yml ps

# Logs em tempo real
docker compose -f docker-compose.dokploy.yml logs -f

# Logs de um serviço específico
docker compose -f docker-compose.dokploy.yml logs -f backend
```

### Gerenciamento
```bash
# Parar tudo
docker compose -f docker-compose.dokploy.yml down

# Reiniciar serviço
docker compose -f docker-compose.dokploy.yml restart backend

# Rebuild serviço
docker compose -f docker-compose.dokploy.yml build backend
docker compose -f docker-compose.dokploy.yml up -d backend
```

### Limpeza
```bash
# Parar e remover tudo (CUIDADO: apaga dados!)
docker compose -f docker-compose.dokploy.yml down --volumes

# Limpar cache Docker
docker system prune -f
```

---

## 🎯 CONFIGURAÇÃO DO CLIENTE

Após o deploy, configure sua aplicação:

```javascript
import { H } from 'highlight.run';

H.init('<YOUR_PROJECT_ID>', {
  backendUrl: 'https://api-highlight.agricompany-dev.com.br/public',
  // outras configurações...
});
```

---

## ✅ CHECKLIST FINAL

- [ ] Todos os arquivos foram enviados para o DOKPLOY
- [ ] Variáveis de ambiente configuradas
- [ ] Domínios apontando para a VPS
- [ ] SSL configurado no DOKPLOY
- [ ] Deploy executado com sucesso
- [ ] Todos os serviços estão healthy
- [ ] Frontend acessível em `https://highlight.agricompany-dev.com.br`
- [ ] Backend acessível em `https://api-highlight.agricompany-dev.com.br`
- [ ] Login funcionando com a senha configurada

---

## 🔐 SEGURANÇA EM PRODUÇÃO

**IMPORTANTE**: Este setup é para desenvolvimento. Em produção:

1. **Altere TODAS as senhas**
2. **Configure SSL real**  
3. **Use secrets manager**
4. **Configure firewall adequadamente**
5. **Monitore logs de segurança**
6. **Configure backups automáticos**

---

**🎉 Pronto! Seu Highlight.io está configurado e rodando!** 🚀
