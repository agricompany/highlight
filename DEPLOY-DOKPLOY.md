# 🚀 DEPLOY HIGHLIGHT.IO NO DOKPLOY

## 📋 **ARQUIVOS NECESSÁRIOS**

Você precisa fazer upload destes arquivos para o DOKPLOY:

### **1. Arquivo Principal**
- `docker-compose.dokploy.yml` ← **Arquivo principal do Docker Compose**

### **2. Configurações ClickHouse**
- `clickhouse-config/config-simples.xml`
- `clickhouse-users/users-sem-senha-nenhuma.xml`

### **3. Configurações OpenTelemetry**
- `collector-oficial.yml`
- `collector-fixed.Dockerfile`
- `configure-collector-fixed.sh`

## 🔧 **PASSO A PASSO NO DOKPLOY**

### **PASSO 1: Criar Novo Projeto**
1. Acesse seu DOKPLOY
2. Clique em **"New Project"**
3. Nome: `highlight-io`
4. Descrição: `Highlight.io Self-Hosted Analytics`

### **PASSO 2: Criar Service Compose**
1. Dentro do projeto, clique **"Add Service"**
2. Escolha **"Compose"**
3. Nome: `highlight-stack`
4. Descrição: `Highlight.io Complete Stack`

### **PASSO 3: Upload dos Arquivos**
1. **Upload do Docker Compose:**
   - Cole o conteúdo de `docker-compose.dokploy.yml`
   - Ou faça upload do arquivo

2. **Upload das Configurações:**
   - Crie a estrutura de pastas:
   ```
   /
   ├── docker-compose.yml (conteúdo do dokploy.yml)
   ├── clickhouse-config/
   │   └── config-simples.xml
   ├── clickhouse-users/
   │   └── users-sem-senha-nenhuma.xml
   ├── collector-oficial.yml
   ├── collector-fixed.Dockerfile
   └── configure-collector-fixed.sh
   ```

### **PASSO 4: Configurar Variáveis de Ambiente**
No DOKPLOY, adicione estas variáveis de ambiente:

```env
# AUTENTICAÇÃO
ADMIN_PASSWORD=password
AUTH_MODE=password
REACT_APP_AUTH_MODE=password

# POSTGRESQL
POSTGRES_DB=highlight
POSTGRES_USER=highlight
POSTGRES_PASSWORD=AgriPostgres2024Secure!

# CLICKHOUSE (SEM SENHA)
CLICKHOUSE_USER=default

# SEGURANÇA
SESSION_SECRET=AgriSession2024SuperSecretKey!
JWT_SECRET=AgriJWT2024SuperSecretSigningKey!

# URLs (DOKPLOY vai configurar automaticamente)
REACT_APP_FRONTEND_URI=https://highlight.agricompany-dev.com.br
REACT_APP_PRIVATE_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/private
REACT_APP_PUBLIC_GRAPH_URI=https://api-highlight.agricompany-dev.com.br/public
```

### **PASSO 5: Configurar Domínios**
1. **Frontend Domain:**
   - Domain: `highlight.agricompany-dev.com.br`
   - Port: `3000`
   - SSL: ✅ Enabled (Let's Encrypt)

2. **Backend Domain:**
   - Domain: `api-highlight.agricompany-dev.com.br`
   - Port: `8082`
   - SSL: ✅ Enabled (Let's Encrypt)

### **PASSO 6: Deploy**
1. Clique **"Deploy"**
2. Aguarde o build (pode demorar 5-10 minutos)
3. Monitore os logs para verificar se tudo está subindo

## 🎯 **ORDEM DE INICIALIZAÇÃO**

O Docker Compose está configurado com `depends_on` para garantir a ordem:

1. **Zookeeper** → **Kafka**
2. **PostgreSQL** → **Backend**
3. **ClickHouse** → **Backend**
4. **Redis** → **Backend**
5. **Backend** → **Frontend**
6. **Backend** → **Collector**

## 🔐 **CREDENCIAIS DE ACESSO**

Após o deploy:

- **URL Frontend:** https://highlight.agricompany-dev.com.br
- **URL Backend:** https://api-highlight.agricompany-dev.com.br
- **Email:** qualquer email válido (ex: admin@agricompany.com.br)
- **Senha:** `password`

## 📊 **MONITORAMENTO**

### **Health Checks Configurados:**
- **PostgreSQL:** `pg_isready`
- **ClickHouse:** `SELECT 1`
- **Redis:** `redis-cli ping`
- **Backend:** `GET /health`
- **Frontend:** `GET /health`
- **Collector:** `GET /health/status`

### **Logs para Monitorar:**
```bash
# Backend
docker logs highlight-backend

# Frontend  
docker logs highlight-frontend

# ClickHouse
docker logs highlight-clickhouse

# PostgreSQL
docker logs highlight-postgres
```

## 🚨 **TROUBLESHOOTING**

### **Se o Backend não subir:**
1. Verifique logs: `docker logs highlight-backend`
2. Confirme PostgreSQL: `docker logs highlight-postgres`
3. Teste ClickHouse: `docker exec highlight-clickhouse clickhouse-client --query "SELECT 1"`

### **Se o Frontend der erro Firebase:**
1. Confirme `REACT_APP_AUTH_MODE=password` nas variáveis
2. Reinicie o frontend: `docker restart highlight-frontend`

### **Se ClickHouse der erro de autenticação:**
1. Confirme que está usando `users-sem-senha-nenhuma.xml`
2. Verifique se não tem `CLICKHOUSE_PASSWORD` definido

## ✅ **CHECKLIST FINAL**

- [ ] Docker Compose atualizado com configurações que funcionaram
- [ ] Variáveis de ambiente configuradas no DOKPLOY
- [ ] Domínios configurados com SSL
- [ ] Arquivos de configuração uploadados
- [ ] Deploy realizado com sucesso
- [ ] Health checks passando
- [ ] Login funcionando com email + password

## 🎉 **SUCESSO!**

Se tudo estiver funcionando:
1. Acesse https://highlight.agricompany-dev.com.br
2. Faça login com qualquer email válido + senha "password"
3. Comece a usar o Highlight.io!

---

**💡 Dica:** Mantenha os logs do DOKPLOY abertos durante o primeiro deploy para monitorar o processo!
