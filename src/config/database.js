module.exports = {
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'admin',
  password: process.env.DB_PASS || 'senha_segura',
  database: process.env.DB_NAME || 'meu_banco',
  pool: {
    max: 20, // Máximo de conexões
    min: 5,  // Mínimo de conexões
    idle: 30000 // Tempo de inatividade
  },
  // Otimização de queries
  indexes: ['users.email', 'products.id'],
  batch: {
    size: 1000 // Tamanho do lote para inserções
  }
};