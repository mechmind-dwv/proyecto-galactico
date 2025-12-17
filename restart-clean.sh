#!/bin/bash

echo "🧹 Limpiando procesos anteriores..."
pkill -9 node 2>/dev/null || true
sleep 1

echo "🔍 Buscando puerto libre (3111-3130)..."
PORT=3111
while [ $PORT -le 3130 ]; do
    if ! lsof -i :$PORT > /dev/null 2>&1; then
        break
    fi
    PORT=$((PORT + 1))
done

if [ $PORT -gt 3130 ]; then
    echo "❌ No hay puertos libres"
    exit 1
fi

echo "✅ Puerto libre: $PORT"

# Actualiza .env
sed -i "s/^PORT=.*/PORT=$PORT/" .env

echo "🚀 Iniciando servidor..."
echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║                                           ║"
echo "║  🌐 Abre tu navegador en:                ║"
echo "║                                           ║"
echo "║     http://localhost:$PORT               ║"
echo "║                                           ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

npm start
