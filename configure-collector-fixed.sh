#!/bin/bash
set -e

COLLECTOR_CONFIG="./collector.yml"

echo "=== CONFIGURANDO COLLECTOR (SIMPLES) ==="
echo "SSL=$SSL, IN_DOCKER_GO=$IN_DOCKER_GO"

# A configuração minimal já está correta para Docker
# Apenas mostrar o conteúdo final
echo "=== CONFIGURAÇÃO FINAL ==="
cat "$COLLECTOR_CONFIG"
echo "=========================="
