# Ajustes de Node.js para producción
export NODE_OPTIONS="--max-old-space-size=4096 --max-http-header-size=16384"
export UV_THREADPOOL_SIZE=16

# Iniciar con clustering
npm run start:cluster
