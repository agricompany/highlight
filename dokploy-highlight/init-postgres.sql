-- Script de inicialização do PostgreSQL para Highlight.io
-- Este script garante que as extensões necessárias estejam instaladas

-- Instalar extensão pgcrypto (necessária para o Highlight)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Instalar extensão vector (já incluída na imagem ankane/pgvector)
CREATE EXTENSION IF NOT EXISTS vector;

-- Criar schema se não existir
CREATE SCHEMA IF NOT EXISTS public;

-- Garantir permissões
GRANT ALL ON SCHEMA public TO highlight;
GRANT ALL PRIVILEGES ON DATABASE highlight TO highlight;
