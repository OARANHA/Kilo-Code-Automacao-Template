# Kilo Template - Documentação Oficial

O Kilo Template é uma solução robusta para desenvolvimento full-stack com busca semântica e agente de IA integrado. Este template fornece uma base enterprise-ready para qualquer tipo de projeto.

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura](#️-arquitetura)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Uso](#-uso)
- [APIs](#-apis)
- [Desenvolvimento](#-desenvolvimento)
- [Templates](#-templates)
- [Integração VS Code](#-integração-vs-code)
- [Troubleshooting](#-troubleshooting)
- [Contribuição](#-contribuição)

---

## 🎯 Visão Geral

O Kilo Template combina:
- **Busca Semântica Avançada**: Qdrant + Ollama para indexação e busca inteligente
- **Agente de IA**: Automação de desenvolvimento com VSCode
- **Arquitetura Robusta**: Cache, segurança, logging e monitoramento
- **Setup Zero**: Funciona para projetos novos ou existentes

### 🚀 Casos de Uso
- Dashboards enterprise com KPIs e gráficos
- APIs RESTful com busca semântica
- Aplicações web com autenticação e RBAC
- Documentação técnica com busca inteligente
- Codebases grandes com navegação semântica

---

## 🏗️ Arquitetura

```
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Frontend │           │ Kilo Code │        │ Backend │
│ (Next.js) │◄────────►│ (Agente IA)│◄──────►│ (API) │
└─────────────────┘ └─────────────────┘ └─────────────────┘
      │                    │                    │
      └────────────────────┼────────────────────┘
                            │
              ┌─────────────────┐
              │ Qdrant │
              │ (Vector DB) │
              └─────────────────┘
                            │
              ┌─────────────────┐
              │ Ollama │
              │ (Embeddings) │
              └─────────────────┘
```

### Componentes Principais

1. **Agente de IA** (`.killo-workspace/agent/`)
   - Configuração do agente DeepSeek-FSA
   - Integração com VSCode
   - Automação de desenvolvimento

2. **Busca Semântica** (`scripts/`, `src/services/semanticSearchService.js`)
   - Indexação de arquivos
   - Busca vetorial
   - Processamento de linguagem natural

3. **Configuração** (`src/config/`, `kilo.config.js`)
   - Cache (Redis)
   - Banco de dados (PostgreSQL)
   - Segurança (JWT, rate limiting)
   - Logging estruturado

4. **Templates** (`.killo-workspace/templates/`)
   - Next.js Dashboard
   - Node.js API
   - React Admin
   - Universal Starter

---

## 🚀 Instalação

### Pré-requisitos
- Node.js 18+
- npm ou yarn
- Docker (opcional, para Qdrant e Ollama)
- VS Code (recomendado para integração completa)

### Para Novo Projeto:
```bash
git clone https://github.com/OARANHA/Kilo-Code-Automacao-Template.git meu-projeto
cd meu-projeto
npm install
cp .env.example .env
# Editar .env com suas configurações
npm run init
```

### Para Projeto Existente:
```bash
cd projeto-do-cliente
git clone https://github.com/OARANHA/Kilo-Code-Automacao-Template.git .killo-workspace
cd .killo-workspace
npm install
cp .env.example .env
# Editar .env com suas configurações
cd ..
npm run init
```

---

## ⚙️ Configuração

### Variáveis de Ambiente

Copie `.env.example` para `.env` e configure:

```env
# Busca Semântica
QDRANT_URL=http://localhost:6333
OLLAMA_URL=http://localhost:11434
EMBED_MODEL=bge-m3
QDRANT_COLLECTION=nome_sua_collection  # OBRIGATÓRIO: personalize
EMBED_PAYLOAD=auto
INDEX_ROOT=.
BATCH=64
CHUNK_SIZE=1200
CHUNK_OVERLAP=200
MAX_FILE_MB=1.5
MAX_CHARS_FILE=200000
SEARCH_LIMIT=8
WITH_SNIPPET=1

# Aplicação
KILO_ENV=development
KILO_PORT=3000
KILO_MAX_WORKERS=4
KILO_MEMORY_LIMIT=2GB
AUTO_SCALE=false

# Banco de Dados
DB_HOST=localhost
DB_PORT=5432
DB_NAME=kilo_app
DB_USER=postgres
DB_PASSWORD=

# Cache
CACHE_TTL=3600
CACHE_CHECK_PERIOD=600

# Segurança
JWT_SECRET=sua_chave_secreta
JWT_EXPIRES_IN=24h
RATE_LIMIT_WINDOW=15
RATE_LIMIT_MAX=100
```

### Serviços Externos

#### Qdrant (Vector Database)
```bash
# Via Docker
docker run -p 6333:6333 qdrant/qdrant

# Ou instale localmente
# https://qdrant.tech/documentation/
```

#### Ollama (Embeddings)
```bash
# Via Docker
docker run -d -p 11434:11434 --name ollama ollama/ollama

# Ou instale localmente
# https://ollama.ai/
```

---

## 📖 Uso

### Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `npm run start` | Inicia a aplicação em produção |
| `npm run dev` | Inicia em modo desenvolvimento |
| `npm run kindex [path]` | Indexa arquivos para busca semântica |
| `npm run ksearch "query"` | Realiza busca semântica |
| `npm run kread <file>` | Lê parte de um arquivo |
| `npm run init` | Inicializa o ambiente Kilo |
| `npm run health-check` | Verifica saúde do projeto |
| `npm run recover` | Recupera de falhas |
| `npm run bootstrap` | Configura projeto com template |

### Exemplos de Uso

#### Indexação de Arquivos
```bash
# Indexar todo o projeto
npm run kindex

# Indexar diretório específico
npm run kindex ./src

# Indexar com parâmetros customizados
EMBED_MODEL=nomic-embed-text npm run kindex
```

#### Busca Semântica
```bash
# Busca simples
npm run ksearch "função de autenticação"

# Busca com filtros
npm run ksearch "configuração de banco de dados" --limit 5
```

#### Leitura de Arquivos
```bash
# Ler arquivo específico
npm run kread ./src/app.js

# Ler com modo seguro
npm run kread ./config/secrets.js --mode=safe
```

---

## 🔌 APIs

### Busca Semântica

#### POST /semantic-search/index
Indexa arquivos para busca semântica.

**Request Body:**
```json
{
  "root": "./src"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Indexação concluída",
  "result": {
    "indexed_files": 150,
    "total_chunks": 2000,
    "time_taken": "2.3s"
  }
}
```

#### POST /semantic-search/search
Realiza busca semântica.

**Request Body:**
```json
{
  "query": "função de autenticação",
  "options": {
    "limit": 5,
    "withSnippet": true
  }
}
```

**Response:**
```json
{
  "success": true,
  "result": [
    {
      "file": "./src/auth.js",
      "score": 0.95,
      "snippet": "function authenticateUser(username, password) { ... }",
      "line": 45
    }
  ]
}
```

#### POST /semantic-search/read-file
Lê parte de um arquivo de forma segura.

**Request Body:**
```json
{
  "filePath": "./src/config/database.js",
  "mode": "safe"
}
```

**Response:**
```json
{
  "success": true,
  "content": "const dbConfig = { ... }"
}
```

#### GET /semantic-search/status
Verifica status do sistema de busca.

**Response:**
```json
{
  "success": true,
  "status": {
    "qdrant": "connected",
    "ollama": "connected",
    "collection": "my_project",
    "indexed_files": 150
  }
}
```

---

## 💻 Desenvolvimento

### Estrutura de Pastas

```
.
├── .killo-workspace/          # Configurações do agente
│   ├── agent/                 # Configuração do agente IA
│   ├── scripts/               # Scripts de inicialização
│   ├── templates/             # Templates de projeto
│   └── health-check/          # Ferramentas de verificação
├── scripts/                   # Scripts de busca semântica
├── src/                       # Código fonte
│   ├── config/               # Configurações
│   ├── services/             # Serviços
│   ├── utils/                # Utilitários
│   └── app.js                # App principal
├── tests/                    # Testes
├── .env.example              # Template de variáveis
├── kilo.config.js           # Configuração do Kilo
└── package.json             # Dependências
```

### Fluxo de Desenvolvimento

1. **Setup Inicial**
   ```bash
   npm install
   npm run init
   ```

2. **Desenvolvimento**
   ```bash
   npm run dev
   ```

3. **Indexar Código**
   ```bash
   npm run kindex
   ```

4. **Buscar Código**
   ```bash
   npm run ksearch "funcionalidade desejada"
   ```

5. **Testes**
   ```bash
   npm test
   ```

6. **Build**
   ```bash
   npm run build
   ```

---

## 📦 Templates

### Next.js Dashboard
Template para dashboards enterprise com:
- Next.js 14 (App Router)
- Tailwind CSS
- Chart.js/Recharts
- Autenticação integrada
- KPI cards e gráficos

### Node.js API
Template para APIs RESTful com:
- Express.js
- Prisma ORM
- PostgreSQL
- Autenticação JWT
- Validação de dados

### React Admin
Template para painéis administrativos com:
- React 18
- Material-UI
- Redux Toolkit
- Rotas protegidas
- CRUD automático

### Universal Starter
Template minimalista para:
- Projetos customizados
- Configuração flexível
- Base para qualquer stack

---

## 🔧 Integração VS Code

### Extensões Recomendadas
```json
{
  "recommendations": [
    "ms-python.python",
    "esbenp.prettier-vscode",
    "bradlc.vscode-tailwindcss",
    "ms-vscode.docker",
    "github.copilot"
  ]
}
```

### Comandos do Kilo
| Comando (Ctrl+Shift+P) | Função |
|------------------------|--------|
| `Kilo: Bootstrap Project` | Configura projeto |
| `Kilo: Health Check` | Verifica problemas |
| `Kilo: Recover Failure` | Recupera de falhas |
| `Kilo: Semantic Search` | Busca semântica |
| `Kilo: Index Files` | Indexa arquivos |

### Configuração do VS Code
Crie `.vscode/settings.json`:
```json
{
  "python.defaultInterpreterPath": ".venv/bin/python",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
```

---

## 🚨 Troubleshooting

### Problemas Comuns

#### Qdrant não conecta
```bash
# Verificar se o container está rodando
docker ps | grep qdrant

# Iniciar Qdrant
docker run -d -p 6333:6333 --name qdrant qdrant/qdrant

# Testar conexão
curl http://localhost:6333/
```

#### Ollama não conecta
```bash
# Verificar se o container está rodando
docker ps | grep ollama

# Iniciar Ollama
docker run -d -p 11434:11434 --name ollama ollama/ollama

# Testar modelos
ollama list
```

#### Erro de permissão em scripts
```bash
# Dar permissão de execução
chmod +x scripts/*.sh
chmod +x .killo-workspace/scripts/*.sh
```

#### Collection não encontrada
```bash
# Verificar nome da collection no .env
echo $QDRANT_COLLECTION

# Criar collection manualmente
curl -X PUT http://localhost:6333/collections/nome_sua_collection \
  -H "Content-Type: application/json" \
  -d '{
    "vectors": {
      "size": 1024,
      "distance": "Cosine"
    }
  }'
```

### Health Check
Execute verificação completa:
```bash
npm run health-check
```

Isso verificará:
- Conexão com Qdrant
- Conexão com Ollama
- Permissões de arquivos
- Dependências instaladas
- Configurações válidas

---

## 🤝 Contribuição

### Processo
1. Fork o repositório
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Faça commit das mudanças: `git commit -am 'Add nova funcionalidade'`
4. Push para a branch: `git push origin feature/nova-funcionalidade`
5. Submit um pull request

### Padrões de Código
- Use ESLint e Prettier
- Siga Conventional Commits
- Escreva testes para novas funcionalidades
- Atualize documentação quando necessário

### Issues
Reporte bugs ou sugira melhorias em:
- GitHub Issues
- Discord da comunidade

---

## 📄 Licença

MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🙏 Agradecimentos

- [Killo Framework](https://github.com/killoframework) pela base do sistema
- [Qdrant](https://qdrant.tech/) pelo vector database
- [Ollama](https://ollama.ai/) pelos embeddings
- [VS Code](https://code.visualstudio.com/) pela excelente IDE

---

## 📞 Suporte

Para ajuda adicional:
- Documentação: [docs.kilo-template.com](https://docs.kilo-template.com)
- Issues: [github.com/kilo-template/issues](https://github.com/kilo-template/issues)
- Discord: [kilo-template.gg/discord](https://kilo-template.gg/discord)