import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import express from 'express';

const router = express.Router();

// Helmet middleware
router.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'", "'unsafe-eval'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.tudominio.com"]
    }
  }
}));

// Rate limiting
router.use(rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // límite por IP
  message: 'Demasiadas peticiones desde esta IP'
}));

export default router;
