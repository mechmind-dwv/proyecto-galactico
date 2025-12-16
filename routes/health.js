// routes/health.js
router.get('/health', (req, res) => {
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
