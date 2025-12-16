import express from 'express';
const router = express.Router();

// Funciones de chequeo simuladas (arregla estas según tu setup real)
const checkDatabase = () => true; // Implementa tu lógica de DB
const checkRedis = () => true;    // Implementa tu lógica de Redis
const checkExternalAPI = () => true; // Implementa tu lógica de API

router.get('/', (req, res) => {
  const healthcheck = {
    uptime: process.uptime(),
    message: 'OK',
    timestamp: Date.now(),
    checks: {
      database: checkDatabase(),
      redis: checkRedis(),
      external_api: checkExternalAPI()
    }
  };
  
  const isHealthy = Object.values(healthcheck.checks).every(check => check);
  
  res.status(isHealthy ? 200 : 503).json(healthcheck);
});

export default router;
