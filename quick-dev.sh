#!/bin/bash
cat > .env << 'ENVFILE'
NODE_ENV=development
PORT=3001
HOST=0.0.0.0
MONGO_URL=mongodb://localhost:27017/galaxy
DATABASE_URL=postgresql://user:password@localhost:5432/galaxydb
REDIS_URL=redis://localhost:6379
JWT_SECRET=$(openssl rand -base64 64)
API_KEY=$(cat /proc/sys/kernel/random/uuid)
SESSION_SECRET=$(openssl rand -base64 32)
LOG_LEVEL=debug
ENVFILE
chmod 600 .env
echo "✓ .env creado para desarrollo"
npm start
