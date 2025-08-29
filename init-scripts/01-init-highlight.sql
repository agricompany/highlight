-- Script de inicialização do banco de dados Highlight
-- Este script será executado automaticamente quando o PostgreSQL inicializar

-- Criar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Criar usuário específico para Highlight se não existir
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'highlight') THEN

      CREATE ROLE highlight LOGIN PASSWORD 'AgriPostgres2024Secure!';
   END IF;
END
$do$;

-- Garantir que o usuário tenha as permissões necessárias
GRANT ALL PRIVILEGES ON DATABASE highlight TO highlight;

-- Configurações específicas para Highlight
ALTER DATABASE highlight SET timezone TO 'UTC';

-- Log de inicialização
INSERT INTO pg_catalog.pg_stat_statements_info (dealloc) VALUES (0)
ON CONFLICT DO NOTHING;
