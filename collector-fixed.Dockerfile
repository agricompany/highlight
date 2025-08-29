ARG OTEL_COLLECTOR_BUILD_IMAGE_NAME="alpine:3.21.3"
ARG OTEL_COLLECTOR_IMAGE_NAME="otel/opentelemetry-collector-contrib:0.128.0"

FROM ${OTEL_COLLECTOR_BUILD_IMAGE_NAME} AS collector-build

# Instalar bash e dependências necessárias no Alpine
RUN apk add --no-cache bash sed grep wget curl

# Copiar arquivos de configuração
COPY ./collector-oficial.yml /collector.yml
COPY ./configure-collector-fixed.sh /configure-collector.sh

# Tornar o script executável
RUN chmod +x /configure-collector.sh

# Definir variáveis de build
ARG IN_DOCKER_GO
ARG SSL

# Definir variáveis de ambiente para o script
ENV IN_DOCKER_GO=${IN_DOCKER_GO}
ENV SSL=${SSL}

# Executar script de configuração
RUN /configure-collector.sh

# Usar Alpine como base temporária para criar certificados
FROM alpine:latest AS ssl-creator
RUN apk add --no-cache openssl

# Criar diretório para certificados SSL
RUN mkdir -p /ssl-certs

# Criar certificados SSL dummy
RUN echo "-----BEGIN CERTIFICATE-----" > /ssl-certs/server.crt && \
    echo "MIIDXTCCAkWgAwIBAgIJAKL0UG+jBKgFMA0GCSqGSIb3DQEBCwUAMEUxCzAJBgNV" >> /ssl-certs/server.crt && \
    echo "BAYTAkJSMQswCQYDVQQIDAJTUDELMAkGA1UEBwwCU1AxDDAKBgNVBAoMA0FGTTEO" >> /ssl-certs/server.crt && \
    echo "MAwGA1UEAwwFbG9jYWwwHhcNMjQwMTA1MDAwMDAwWhcNMjUwMTA1MDAwMDAwWjBF" >> /ssl-certs/server.crt && \
    echo "DUMMY CERTIFICATE FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE" >> /ssl-certs/server.crt && \
    echo "-----END CERTIFICATE-----" >> /ssl-certs/server.crt

RUN echo "-----BEGIN PRIVATE KEY-----" > /ssl-certs/server.key && \
    echo "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRhZiFYkfYzZD6" >> /ssl-certs/server.key && \
    echo "b40q9RUniDMvUozZHfEfofVD7fDwrxrkzqxXtDzLnDrFxGvK5M6sV7Q8y5w6" >> /ssl-certs/server.key && \
    echo "DUMMY PRIVATE KEY FOR DEVELOPMENT ONLY - NOT FOR PRODUCTION USE" >> /ssl-certs/server.key && \
    echo "-----END PRIVATE KEY-----" >> /ssl-certs/server.key

# Imagem final do collector
FROM ${OTEL_COLLECTOR_IMAGE_NAME} AS collector

# Copiar certificados da imagem temporária
COPY --from=ssl-creator /ssl-certs /ssl-certs

# Copiar arquivo de configuração processado
COPY --from=collector-build /collector.yml /etc/otel-collector-config.yaml

# Definir health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:4319/health/status || exit 1

# Comando padrão
CMD ["--config=/etc/otel-collector-config.yaml"]
