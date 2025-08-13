module.exports = {
  jwt: {
    secret: process.env.JWT_SECRET || 'chave_super_secreta_12345',
    expiresIn: '7d',
    algorithm: 'HS256'
  },
  encryption: {
    key: process.env.ENCRYPTION_KEY || 'chave_de_criptografia_67890',
    algorithm: 'aes-256-cbc'
  },
  rateLimit: {
    windowMs: 15 * 60 * 1000, // 15 minutos
    max: 100 // Limite de requisições
  },
  cors: {
    origin: ['http://localhost:3000'],
    credentials: true
  }
};