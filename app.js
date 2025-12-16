import express from 'express';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Middlewares básicos
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

// Cargar middlewares dinámicamente si existen
const middlewarePath = path.join(__dirname, 'middleware');
if (fs.existsSync(middlewarePath)) {
  const middlewareFiles = fs.readdirSync(middlewarePath).filter(file => file.endsWith('.js'));
  for (const file of middlewareFiles) {
    const middleware = await import(`./middleware/${file}`);
    if (middleware.default) app.use(middleware.default);
  }
}

// Cargar rutas dinámicamente si existen
const routesPath = path.join(__dirname, 'routes');
if (fs.existsSync(routesPath)) {
  const routeFiles = fs.readdirSync(routesPath).filter(file => file.endsWith('.js'));
  for (const file of routeFiles) {
    const route = await import(`./routes/${file}`);
    const routeName = file.replace('.js', '');
    if (route.default) app.use(`/${routeName}`, route.default);
  }
}

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({
    status: 'online',
    message: '🚀 Proyecto Galáctico está VIVO! 🚀',
    environment: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString()
  });
});

// Ruta de health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', uptime: process.uptime() });
});

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

// Manejo de errores general
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

export default app;
