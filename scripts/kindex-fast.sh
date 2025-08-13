#!/usr/bin/env bash
set -euo pipefail

# Carrega variáveis de ambiente se existir
if [ -f ".env" ]; then
  export $(cat .env | xargs)
fi

# Configurações rápidas com sanitização inteligente
export EMBED_PAYLOAD="${EMBED_PAYLOAD:-input}"
export EMBED_MODEL="${EMBED_MODEL:-all-minilm}"
export QDRANT_COLLECTION="$QDRANT_COLLECTION"  # REMOVIDO o valor padrão
export INDEX_ROOT="${INDEX_ROOT:-.}"
# Mantém configurações de performance
export CHUNK_SIZE="${CHUNK_SIZE:-1200}"
export CHUNK_OVERLAP="${CHUNK_OVERLAP:-200}"
export BATCH="${BATCH:-64}"
export MAX_FILE_MB="${MAX_FILE_MB:-1.5}"
export MAX_CHARS_FILE="${MAX_CHARS_FILE:-200000}"

# Verifica se a collection foi definida
if [ -z "$QDRANT_COLLECTION" ]; then
  echo "❌ Erro: QDRANT_COLLECTION não está definida"
  echo "Por favor, defina no .env ou como variável de ambiente"
  exit 1
fi

echo "🔍 Usando collection: $QDRANT_COLLECTION"

node scripts/index_simple_fast.mjs "$@"