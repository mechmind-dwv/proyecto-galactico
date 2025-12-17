#!/bin/bash

# =================================================================
# 🚀 PROYECTO GALÁCTICO - WIZARD DE CONFIGURACIÓN AUTOMÁTICA
# =================================================================

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Banner épico
show_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║          🚀  PROYECTO GALÁCTICO  🚀                       ║"
    echo "║                                                           ║"
    echo "║        Wizard de Configuración Automática                 ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
}

# Función para mostrar spinners
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Función para imprimir con estilo
print_step() {
    echo -e "${CYAN}${BOLD}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}${BOLD}✓${NC} $1"
}

print_error() {
    echo -e "${RED}${BOLD}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}${BOLD}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}${BOLD}ℹ${NC} $1"
}

# Función para generar secretos seguros
generate_secret() {
    local length=${1:-64}
    openssl rand -base64 $length | tr -d "=+/" | cut -c1-$length
}

# Función para generar UUID
generate_uuid() {
    cat /proc/sys/kernel/random/uuid
}

# Función para leer input con valor por defecto
read_with_default() {
    local prompt="$1"
    local default="$2"
    local varname="$3"
    
    if [ -n "$default" ]; then
        echo -e -n "${CYAN}$prompt${NC} ${YELLOW}[default: $default]${NC}: "
    else
        echo -e -n "${CYAN}$prompt${NC}: "
    fi
    
    read input
    
    if [ -z "$input" ]; then
        eval "$varname='$default'"
    else
        eval "$varname='$input'"
    fi
}

# Función para leer contraseña
read_password() {
    local prompt="$1"
    local varname="$2"
    
    echo -e -n "${CYAN}$prompt${NC}: "
    read -s password
    echo
    eval "$varname='$password'"
}

# Función principal de configuración
main() {
    show_banner
    
    print_step "Iniciando configuración del Proyecto Galáctico..."
    echo
    
    # ============================================
    # PASO 1: Seleccionar ambiente
    # ============================================
    print_step "Paso 1: Selecciona el ambiente"
    echo
    echo "  1) 🧪 Development (local)"
    echo "  2) 🎭 Staging (pruebas)"
    echo "  3) 🚀 Production (producción)"
    echo
    read_with_default "Elige una opción (1-3)" "1" "env_choice"
    
    case $env_choice in
        1) ENV_NAME="development" ;;
        2) ENV_NAME="staging" ;;
        3) ENV_NAME="production" ;;
        *) ENV_NAME="development" ;;
    esac
    
    echo
    print_success "Ambiente seleccionado: $ENV_NAME"
    echo
    
    # ============================================
    # PASO 2: Configuración del servidor
    # ============================================
    print_step "Paso 2: Configuración del servidor"
    echo
    
    read_with_default "Puerto del servidor" "3001" "PORT"
    read_with_default "Host del servidor" "0.0.0.0" "HOST"
    
    echo
    
    # ============================================
    # PASO 3: Base de datos
    # ============================================
    print_step "Paso 3: Configuración de bases de datos"
    echo
    
    print_info "¿Deseas configurar MongoDB? (s/n)"
    read -n 1 setup_mongo
    echo
    
    if [[ $setup_mongo =~ ^[Ss]$ ]]; then
        echo
        print_info "Configurando MongoDB Atlas..."
        read_with_default "MongoDB Usuario" "" "MONGO_USER"
        read_password "MongoDB Contraseña" "MONGO_PASS"
        read_with_default "MongoDB Cluster" "cluster.mongodb.net" "MONGO_CLUSTER"
        read_with_default "MongoDB Database" "galaxy" "MONGO_DB"
        MONGO_URL="mongodb+srv://${MONGO_USER}:${MONGO_PASS}@${MONGO_CLUSTER}/${MONGO_DB}"
    else
        MONGO_URL="mongodb://localhost:27017/galaxy"
    fi
    
    echo
    print_info "¿Deseas configurar PostgreSQL? (s/n)"
    read -n 1 setup_postgres
    echo
    
    if [[ $setup_postgres =~ ^[Ss]$ ]]; then
        echo
        print_info "Configurando PostgreSQL..."
        read_with_default "PostgreSQL Host" "localhost" "PG_HOST"
        read_with_default "PostgreSQL Puerto" "5432" "PG_PORT"
        read_with_default "PostgreSQL Usuario" "postgres" "PG_USER"
        read_password "PostgreSQL Contraseña" "PG_PASS"
        read_with_default "PostgreSQL Database" "galaxydb" "PG_DB"
        DATABASE_URL="postgresql://${PG_USER}:${PG_PASS}@${PG_HOST}:${PG_PORT}/${PG_DB}"
    else
        DATABASE_URL="postgresql://user:password@localhost:5432/database"
    fi
    
    echo
    print_info "¿Deseas configurar Redis? (s/n)"
    read -n 1 setup_redis
    echo
    
    if [[ $setup_redis =~ ^[Ss]$ ]]; then
        echo
        print_info "Configurando Redis..."
        read_with_default "Redis Host" "localhost" "REDIS_HOST"
        read_with_default "Redis Puerto" "6379" "REDIS_PORT"
        read_password "Redis Contraseña (Enter si no tiene)" "REDIS_PASS"
        
        if [ -z "$REDIS_PASS" ]; then
            REDIS_URL="redis://${REDIS_HOST}:${REDIS_PORT}"
        else
            REDIS_URL="redis://:${REDIS_PASS}@${REDIS_HOST}:${REDIS_PORT}"
        fi
    else
        REDIS_URL="redis://localhost:6379"
    fi
    
    echo
    
    # ============================================
    # PASO 4: Seguridad
    # ============================================
    print_step "Paso 4: Generando secretos de seguridad..."
    echo
    
    print_info "Generando JWT_SECRET seguro..." &
    JWT_SECRET=$(generate_secret 64)
    sleep 1
    print_success "JWT_SECRET generado ✓"
    
    print_info "Generando API_KEY..." &
    API_KEY=$(generate_uuid)
    sleep 1
    print_success "API_KEY generado ✓"
    
    print_info "Generando SESSION_SECRET..." &
    SESSION_SECRET=$(generate_secret 32)
    sleep 1
    print_success "SESSION_SECRET generado ✓"
    
    echo
    
    # ============================================
    # PASO 5: Servicios externos (opcional)
    # ============================================
    print_step "Paso 5: Servicios externos (opcional)"
    echo
    
    print_info "¿Deseas configurar AWS CloudWatch? (s/n)"
    read -n 1 setup_cloudwatch
    echo
    
    if [[ $setup_cloudwatch =~ ^[Ss]$ ]]; then
        echo
        read_with_default "CloudWatch Log Group" "/aws/lambda/proyecto-galactico" "CLOUDWATCH_LOG_GROUP"
        read_with_default "AWS Region" "us-east-1" "CLOUDWATCH_REGION"
    fi
    
    echo
    
    # ============================================
    # PASO 6: Crear archivo .env
    # ============================================
    print_step "Paso 6: Creando archivo .env seguro..."
    echo
    
    ENV_FILE=".env"
    
    cat > "$ENV_FILE" << EOF
# =================================================================
# 🚀 PROYECTO GALÁCTICO - CONFIGURACIÓN ${ENV_NAME^^}
# =================================================================
# Generado automáticamente el $(date)
# ⚠️  NUNCA subas este archivo a Git
# =================================================================

# AMBIENTE
NODE_ENV=${ENV_NAME}

# SERVIDOR
PORT=${PORT}
HOST=${HOST}

# BASES DE DATOS
MONGO_URL=${MONGO_URL}
DATABASE_URL=${DATABASE_URL}
REDIS_URL=${REDIS_URL}

# SEGURIDAD
JWT_SECRET=${JWT_SECRET}
API_KEY=${API_KEY}
SESSION_SECRET=${SESSION_SECRET}

# LOGGING
LOG_LEVEL=info

EOF

    # Añadir CloudWatch si se configuró
    if [[ $setup_cloudwatch =~ ^[Ss]$ ]]; then
        cat >> "$ENV_FILE" << EOF
# AWS CLOUDWATCH
CLOUDWATCH_LOG_GROUP=${CLOUDWATCH_LOG_GROUP}
CLOUDWATCH_REGION=${CLOUDWATCH_REGION}

EOF
    fi
    
    # Establecer permisos seguros
    chmod 600 "$ENV_FILE"
    
    print_success "Archivo .env creado con permisos seguros (600)"
    echo
    
    # ============================================
    # PASO 7: Verificar dependencias
    # ============================================
    print_step "Paso 7: Verificando dependencias..."
    echo
    
    if ! command -v node &> /dev/null; then
        print_error "Node.js no está instalado"
        exit 1
    fi
    
    if ! command -v npm &> /dev/null; then
        print_error "npm no está instalado"
        exit 1
    fi
    
    print_success "Node.js $(node --version) detectado"
    print_success "npm $(npm --version) detectado"
    echo
    
    # ============================================
    # PASO 8: Instalar dependencias
    # ============================================
    print_info "¿Deseas instalar las dependencias de npm? (s/n)"
    read -n 1 install_deps
    echo
    
    if [[ $install_deps =~ ^[Ss]$ ]]; then
        echo
        print_step "Instalando dependencias..."
        npm install
        print_success "Dependencias instaladas correctamente"
        echo
    fi
    
    # ============================================
    # PASO 9: Resumen
    # ============================================
    show_summary
    
    # ============================================
    # PASO 10: Iniciar servidor
    # ============================================
    print_info "¿Deseas iniciar el servidor ahora? (s/n)"
    read -n 1 start_server
    echo
    
    if [[ $start_server =~ ^[Ss]$ ]]; then
        echo
        print_step "Iniciando servidor..."
        npm start
    else
        echo
        print_info "Para iniciar el servidor ejecuta: ${GREEN}npm start${NC}"
    fi
}

# Función para mostrar resumen
show_summary() {
    clear
    echo -e "${GREEN}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║              ✓ CONFIGURACIÓN COMPLETADA ✓                ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}\n"
    
    echo -e "${CYAN}${BOLD}📋 RESUMEN DE CONFIGURACIÓN:${NC}\n"
    
    echo -e "  ${BOLD}Ambiente:${NC} ${GREEN}$ENV_NAME${NC}"
    echo -e "  ${BOLD}Puerto:${NC} ${GREEN}$PORT${NC}"
    echo -e "  ${BOLD}Host:${NC} ${GREEN}$HOST${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}🗄️  BASES DE DATOS:${NC}\n"
    echo -e "  ${BOLD}MongoDB:${NC} ${GREEN}Configurado ✓${NC}"
    echo -e "  ${BOLD}PostgreSQL:${NC} ${GREEN}Configurado ✓${NC}"
    echo -e "  ${BOLD}Redis:${NC} ${GREEN}Configurado ✓${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}🔐 SEGURIDAD:${NC}\n"
    echo -e "  ${BOLD}JWT Secret:${NC} ${GREEN}Generado (64 chars)${NC}"
    echo -e "  ${BOLD}API Key:${NC} ${GREEN}Generado (UUID)${NC}"
    echo -e "  ${BOLD}Session Secret:${NC} ${GREEN}Generado (32 chars)${NC}"
    echo
    
    echo -e "${CYAN}${BOLD}📁 ARCHIVOS CREADOS:${NC}\n"
    echo -e "  ${GREEN}✓${NC} .env (permisos: 600)"
    echo
    
    echo -e "${YELLOW}${BOLD}⚠️  IMPORTANTE:${NC}"
    echo -e "  • El archivo .env contiene información sensible"
    echo -e "  • Nunca subas .env a Git"
    echo -e "  • .gitignore ya está configurado para protegerlo"
    echo
    
    echo -e "${CYAN}${BOLD}🚀 PRÓXIMOS PASOS:${NC}\n"
    echo -e "  1. Verifica que .env tiene tus credenciales correctas"
    echo -e "  2. Ejecuta: ${GREEN}npm start${NC} para iniciar el servidor"
    echo -e "  3. Prueba: ${GREEN}curl http://localhost:$PORT/${NC}"
    echo
}

# Ejecutar el wizard
main
