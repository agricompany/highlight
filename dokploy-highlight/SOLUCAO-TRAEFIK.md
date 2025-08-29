# 🚨 ERRO TRAEFIK NETWORK - SOLUÇÕES

## ❌ **ERRO:**
```
Error response from daemon: failed to set up container networking: Could not attach to network traefik-network: rpc error: code = NotFound desc = network traefik-network not found
```

## 🎯 **CAUSA:**
O DOKPLOY ainda não criou a rede `traefik-network` ou ela não existe no servidor.

## 🔧 **SOLUÇÕES:**

### **SOLUÇÃO 1: USAR ARQUIVO SEM TRAEFIK (RECOMENDADO)**

1. **Use o arquivo**: `docker-compose-sem-traefik.yml`
2. **Este arquivo**:
   - ✅ Remove todas as referências ao Traefik
   - ✅ Expõe portas diretamente (3000, 8082)
   - ✅ Funciona sem depender do Traefik do DOKPLOY
   - ✅ Permite testar a aplicação primeiro

3. **Como usar**:
   - Renomeie `docker-compose-sem-traefik.yml` para `docker-compose.yml`
   - Ou use diretamente no DOKPLOY

### **SOLUÇÃO 2: CRIAR A REDE TRAEFIK MANUALMENTE**

Se quiser usar o arquivo original com Traefik:

```bash
# No servidor DOKPLOY, execute:
docker network create traefik-network
```

### **SOLUÇÃO 3: CONFIGURAR DOKPLOY PRIMEIRO**

1. **Configure o Traefik no DOKPLOY**:
   - Vá em Settings → Traefik
   - Ative o Traefik
   - Isso criará a rede automaticamente

2. **Depois faça o deploy** com o arquivo original

## 🎯 **RECOMENDAÇÃO:**

**Use a SOLUÇÃO 1 primeiro:**

1. ✅ **Teste com `docker-compose-sem-traefik.yml`**
2. ✅ **Verifique se tudo funciona**
3. ✅ **Acesse via IP:porta diretamente**
4. ✅ **Depois configure Traefik + domínios**

## 📋 **DIFERENÇAS DOS ARQUIVOS:**

| **Aspecto** | **Original** | **Sem Traefik** |
|-------------|--------------|------------------|
| **Rede** | `traefik-network` | Só `highlight-network` |
| **Labels** | Labels Traefik | Sem labels |
| **Portas** | Sem portas expostas | Portas 3000, 8082 |
| **SSL** | Automático via Traefik | Manual depois |
| **Acesso** | Via domínio | Via IP:porta |

## 🚀 **PRÓXIMOS PASSOS:**

1. **Renomeie o arquivo**:
   ```
   docker-compose-sem-traefik.yml → docker-compose.yml
   ```

2. **Faça o deploy**

3. **Teste via**:
   - Frontend: `http://SEU_IP:3000`
   - Backend: `http://SEU_IP:8082/health`

4. **Depois configure Traefik + domínios**

**💡 É mais fácil testar sem Traefik primeiro e depois adicionar SSL + domínios!**
