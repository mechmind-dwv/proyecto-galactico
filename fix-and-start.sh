#!/bin/bash

# Encuentra puerto libre empezando desde 4000
PORT=4000
while netstat -tuln | grep -q ":$PORT "; do
    echo "Puerto $PORT ocupado, probando $((PORT + 1))..."
    PORT=$((PORT + 1))
done

echo "✅ Puerto libre encontrado: $PORT"

# Actualiza .env
if grep -q "^PORT=" .env; then
    sed -i "s/^PORT=.*/PORT=$PORT/" .env
else
    echo "PORT=$PORT" >> .env
fi

echo "📝 .env actualizado con PORT=$PORT"
cat .env | grep PORT

echo "🚀 Iniciando servidor..."
npm start
