#!/bin/bash
PORT=$(lsof -i -P | grep node | grep LISTEN | grep -o ':\d\+' | head -1 | tr -d ':')
if [ -n "$PORT" ]; then
    echo ""
    echo "╔═══════════════════════════════════════════╗"
    echo "║                                           ║"
    echo "║  ✅ Servidor funcionando en:             ║"
    echo "║                                           ║"
    echo "║     http://localhost:$PORT               ║"
    echo "║                                           ║"
    echo "╚═══════════════════════════════════════════╝"
    echo ""
    curl -s http://localhost:$PORT/ | head -c 200
    echo ""
else
    echo "❌ No hay servidor corriendo"
fi
