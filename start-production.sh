#!/bin/bash
export NODE_OPTIONS="--max-old-space-size=4096 --max-http-header-size=16384"
export UV_THREADPOOL_SIZE=16
npm run start:cluster

# Dale permisos de ejecución
chmod +x scripts/start-production.sh
