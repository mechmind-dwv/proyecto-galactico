#!/bin/bash

echo "🚀 CONFIGURACIÓN RÁPIDA - PROYECTO GALÁCTICO"
echo "=============================================="
echo

# Generar secretos
JWT_SECRET=$(openssl rand -base64 64 | tr -d '\n')
API_KEY=$(cat /proc/sys/kernel/random/uuid)
SESSION_SECRET=$(openssl rand -base64 32 | tr -d '\n')

# Leer datos básicos
read -p "Puerto [3001]: " PORT
PORT=${PORT:-3001}

read -p "MongoDB URL (o Enter para default): " MONGO_URL
MONGO_URL=${MONGO_URL:-mongodb://localhost:27017/galaxy}

# Crear .env
cat > .env << EOF
# Proyecto Galáctico - Configuración
NODE_ENV=development
PORT=$PORT
HOST=0.0.0.0

# Bases de datos
MONGO_URL=$MONGO_URL
DATABASE_URL=postgresql://user:password@localhost:5432/galaxydb
REDIS_URL=redis://localhost:6379

# Seguridad (generados automáticamente)
JWT_SECRET=$JWT_SECRET
API_KEY=$API_KEY
SESSION_SECRET=$SESSION_SECRET

# Logging
LOG_LEVEL=info
EOF

# Permisos seguros
chmod 600 .env

echo
echo "✅ Configuración completada!"
echo
echo "📁 Archivo .env creado con permisos seguros"
echo "🔐 Secretos generados automáticamente"
echo
echo "Para iniciar el servidor: npm start"
