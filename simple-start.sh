#!/bin/bash

# Usa puerto 3115 fijo (probablemente libre)
PORT=3115

# Actualiza .env
sed -i "s/^PORT=.*/PORT=$PORT/" .env

# Mata procesos node anteriores
pkill -f "node server.js" || true

echo "🚀 Iniciando en http://localhost:$PORT"
echo

npm start
