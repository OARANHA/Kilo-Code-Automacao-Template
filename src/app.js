require('dotenv').config();
const express = require('express');
const kiloCode = require('kilocode');
const cacheConfig = require('./config/cache');
const dbConfig = require('./config/database');
const securityConfig = require('./config/security');
const loggingConfig = require('./config/logging');
const ErrorHandler = require('./utils/errorHandler');
const semanticSearchService = require('./services/semanticSearchService');

// Inicialização do Kilo Code
kiloCode.configure(require('../kilo.config'));

// Configurações
kiloCode.setCache(cacheConfig);
kiloCode.setDatabase(dbConfig);
kiloCode.setSecurity(securityConfig);
kiloCode.setLogger(loggingConfig);

const app = express();

// Middlewares essenciais
app.use(express.json());
app.use(kiloCode.security.cors());
app.use(kiloCode.security.rateLimit());
app.use(kiloCode.security.helmet());

// Rotas do sistema de busca semântica
app.post('/semantic-search/index', async (req, res) => {
  try {
    const { root } = req.body;
    const result = await semanticSearchService.indexFiles(root);
    res.json({ success: true, message: 'Indexação concluída', result });
  } catch (error) {
    ErrorHandler.handle(error, req, res);
  }
});

app.post('/semantic-search/search', async (req, res) => {
  try {
    const { query, options } = req.body;
    if (!query) {
      return res.status(400).json({ error: 'Query é obrigatória' });
    }
    const result = await semanticSearchService.search(query, options);
    res.json({ success: true, result });
  } catch (error) {
    ErrorHandler.handle(error, req, res);
  }
});

app.post('/semantic-search/read-file', async (req, res) => {
  try {
    const { filePath, mode } = req.body;
    if (!filePath) {
      return res.status(400).json({ error: 'filePath é obrigatório' });
    }
    const result = await semanticSearchService.readFile(filePath, mode);
    res.json({ success: true, content: result });
  } catch (error) {
    ErrorHandler.handle(error, req, res);
  }
});

app.get('/semantic-search/status', async (req, res) => {
  try {
    const status = await semanticSearchService.checkStatus();
    res.json({ success: true, status });
  } catch (error) {
    ErrorHandler.handle(error, req, res);
  }
});

// Middleware de erro
app.use(ErrorHandler.handle);

// Inicialização do servidor
const PORT = process.env.KILO_PORT || 3000;
app.listen(PORT, () => {
  kiloCode.logger.info(`Servidor rodando na porta ${PORT}`);
});