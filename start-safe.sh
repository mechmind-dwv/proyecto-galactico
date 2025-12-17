#!/bin/bash
PORT=3001
while lsof -i :$PORT > /dev/null 2>&1; do
    echo "⚠️  Puerto $PORT ocupado, intentando $((PORT + 1))..."
    PORT=$((PORT + 1))
done
echo "✅ Usando puerto $PORT"
sed -i "s/PORT=.*/PORT=$PORT/g" .env
npm start
