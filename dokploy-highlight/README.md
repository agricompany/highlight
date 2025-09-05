# 🚀 HIGHLIGHT.IO PARA DOKPLOY

## 📁 **ESTRUTURA DOS ARQUIVOS**

```
dokploy-highlight/
├── docker-compose.yml          ← Arquivo principal do Docker Compose
├── environment.env             ← Variáveis de ambiente
├── collector.yml               ← Configuração OpenTelemetry Collector
├── clickhouse-config/
│   └── config.xml             ← Configuração servidor ClickHouse
├── clickhouse-users/
│   └── users.xml              ← Configuração usuários ClickHouse
└── README.md                  ← Este arquivo
```
 
## 🔧 **PARA QUE SERVE CADA ARQUIVO:**

### **docker-compose.yml**
- **O QUE É:** Arquivo principal que define todos os serviços
- **O QUE FAZ:** Docker lê este arquivo e cria todos os containers
- **CONTÉM:** Definições de imagens, volumes, redes, variáveis de ambiente

### **environment.env** 
- **O QUE É:** Arquivo com variáveis de ambiente
- **O QUE FAZ:** Define senhas, URLs, configurações que mudam entre ambientes
- **DOKPLOY:** Você pode colar essas variáveis na interface do DOKPLOY

### **collector.yml**
- **O QUE É:** Configuração do OpenTelemetry Collector
- **O QUE FAZ:** Define como coletar e processar telemetria (logs, métricas, traces)
- **DOCKER USA:** Container do collector monta este arquivo como volume

### **clickhouse-config/config.xml**
- **O QUE É:** Configuração do servidor ClickHouse
- **O QUE FAZ:** Define portas, limites, configurações de performance
- **DOCKER USA:** Container do ClickHouse monta este arquivo como volume
- **POR QUE XML:** ClickHouse usa XML para configuração (padrão da ferramenta)

### **clickhouse-users/users.xml**
- **O QUE É:** Configuração de usuários do ClickHouse  
- **O QUE FAZ:** Define usuários, senhas, permissões, quotas
- **DOCKER USA:** Container do ClickHouse monta este arquivo como volume
- **SEM SENHA:** Configurado para não pedir senha (modo hobby)

## 🎯 **COMO O DOCKER USA OS ARQUIVOS:**

1. **Docker Compose** lê `docker-compose.yml`
2. **Cria containers** baseado nas imagens definidas
3. **Monta volumes** que "colam" os arquivos XML/YML dentro dos containers
4. **Containers leem** esses arquivos e se configuram automaticamente

## 📋 **DEPLOY NO DOKPLOY:**

1. **Upload todos os arquivos** mantendo a estrutura de pastas
2. **Configure as variáveis** do `environment.env` no DOKPLOY
3. **Configure domínios:**
   - Frontend: `highlight.agricompany-dev.com.br`
   - Backend: `api-highlight.agricompany-dev.com.br`
4. **Deploy!**

## 🔐 **CREDENCIAIS:**

- **URL:** https://highlight.agricompany-dev.com.br
- **Email:** qualquer email válido (ex: admin@agricompany.com.br)  
- **Senha:** `password`

## ✅ **ARQUIVOS NECESSÁRIOS:**

- ✅ **docker-compose.yml** - OBRIGATÓRIO
- ✅ **environment.env** - OBRIGATÓRIO  
- ✅ **collector.yml** - OBRIGATÓRIO
- ✅ **clickhouse-config/config.xml** - OBRIGATÓRIO
- ✅ **clickhouse-users/users.xml** - OBRIGATÓRIO

## ❌ **ARQUIVOS NÃO NECESSÁRIOS:**

Todos os outros arquivos do projeto original não são necessários para o deploy:
- Scripts .bat (só para Windows local)
- Dockerfiles customizados (usamos imagens prontas)
- Arquivos de teste e debug
- Documentação extra

---

**💡 Esta pasta contém APENAS o essencial para rodar o Highlight.io no DOKPLOY!**
