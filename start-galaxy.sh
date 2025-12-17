#!/bin/bash

echo "🚀 PROYECTO GALÁCTICO - Iniciando..."
echo "===================================="
echo

# Rango de puertos a probar
START_PORT=3111
END_PORT=3130

# Encuentra puerto libre en el rango
PORT=$START_PORT
PORT_FOUND=false

echo "🔍 Buscando puerto libre entre $START_PORT y $END_PORT..."

while [ $PORT -le $END_PORT ]; do
    if ! netstat -tuln 2>/dev/null | grep -q ":$PORT " && ! lsof -i :$PORT > /dev/null 2>&1; then
        PORT_FOUND=true
        break
    fi
    echo "   ⚠️  Puerto $PORT ocupado"
    PORT=$((PORT + 1))
done

if [ "$PORT_FOUND" = false ]; then
    echo "❌ No hay puertos libres en el rango $START_PORT-$END_PORT"
    echo "Puertos ocupados detectados:"
    for p in $(seq $START_PORT $END_PORT); do
        if netstat -tuln 2>/dev/null | grep -q ":$p " || lsof -i :$p > /dev/null 2>&1; then
            echo "   - Puerto $p: OCUPADO"
        fi
    done
    exit 1
fi

echo "✅ Puerto libre encontrado: $PORT"
echo

# Actualiza .env
if [ -f .env ]; then
    if grep -q "^PORT=" .env; then
        sed -i "s/^PORT=.*/PORT=$PORT/" .env
    else
        echo "PORT=$PORT" >> .env
    fi
else
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

echo "📝 Configuración actualizada:"
echo "   PORT=$PORT"
echo

# Mata cualquier proceso node anterior que pueda estar corriendo
pkill -f "node server.js" 2>/dev/null || true

echo "🚀 Iniciando servidor en puerto $PORT..."
echo
echo "╔═══════════════════════════════════════════════════════╗"
echo "║                                                       ║"
echo "║  🌐 Abre tu navegador en:                            ║"
echo "║                                                       ║"
echo "║     http://localhost:$PORT/                           ║"
echo "║                                                       ║"
echo "║  O usa curl:                                          ║"
echo "║     curl http://localhost:$PORT/                      ║"
echo "║                                                       ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo

# Inicia el servidor
npm start &
SERVER_PID=$!

# Espera 2 segundos para que arranque
sleep 2

# Verifica que esté corriendo
if ps -p $SERVER_PID > /dev/null; then
    echo "✅ Servidor corriendo correctamente (PID: $SERVER_PID)"
    echo
    echo "📊 Para ver el estado:"
    echo "   curl http://localhost:$PORT/"
    echo "   curl http://localhost:$PORT/health"
    echo
    echo "⏹️  Para detener el servidor:"
    echo "   kill $SERVER_PID"
    echo "   O presiona Ctrl+C"
    echo
    
    # Mantiene el script corriendo para mostrar logs
    wait $SERVER_PID
else
    echo "❌ Error al iniciar el servidor"
    exit 1
fi
