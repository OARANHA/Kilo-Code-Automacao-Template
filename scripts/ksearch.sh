#!/usr/bin/env bash
set -euo pipefail

# Carrega variáveis de ambiente se existir
if [ -f ".env" ]; then
  export $(cat .env | xargs)
fi

export EMBED_MODEL="${EMBED_MODEL:-all-minilm}"
export QDRANT_COLLECTION="$QDRANT_COLLECTION"  # REMOVIDO o valor padrão

# Verifica se a collection foi definida
if [ -z "$QDRANT_COLLECTION" ]; then
  echo "❌ Erro: QDRANT_COLLECTION não está definida"
  echo "Por favor, defina no .env ou como variável de ambiente"
  exit 1
fi

echo "🔎 Usando collection: $QDRANT_COLLECTION"

node scripts/search_repo.mjs "$@"