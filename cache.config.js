// cache.config.js
export default {
  // Cache en memoria para datos frecuentes
  memoryCache: {
    ttl: 300, // 5 minutos
    max: 1000 // 1000 items máximo
  },
  
  // Cache distribuido con Redis
  redisCache: {
    host: process.env.REDIS_HOST,
    port: process.env.REDIS_PORT,
    password: process.env.REDIS_PASSWORD,
    ttl: 3600 // 1 hora
  },
  
  // Cache de CDN para assets estáticos
  cdnCache: {
    enabled: true,
    cloudflare: true,
    maxAge: 31536000 // 1 año
  }
};
