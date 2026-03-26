#!/bin/bash

# Archivo de configuración inicial para Isaac Sim (Ejecutar solo una vez)

# 1. Definir la ruta base. Requerido para la instalación
ISAAC_SIM_DIR="$HOME/docker/isaac-sim"

echo "Descargando la imagen oficial de Isaac Sim..."
docker pull nvcr.io/nvidia/isaac-sim:5.1.0

echo "Creando estructura de carpetas locales..."
# 2. Crear las carpetas locales previamente para que pertenezcan a tu usuario
# y no al root de Docker. Así evitamos futuros problemas de permisos.
mkdir -p $ISAAC_SIM_DIR/cache/kit
mkdir -p $ISAAC_SIM_DIR/cache/ov
mkdir -p $ISAAC_SIM_DIR/cache/pip
mkdir -p $ISAAC_SIM_DIR/cache/glcache
mkdir -p $ISAAC_SIM_DIR/cache/computecache
mkdir -p $ISAAC_SIM_DIR/logs
mkdir -p $ISAAC_SIM_DIR/data
mkdir -p $ISAAC_SIM_DIR/documents
mkdir -p $ISAAC_SIM_DIR/cache/main
 

echo "Aplicando permisos..."
# Abrimos los permisos  para poder modificarlas desde docker. Esto se hace para
# no usar sudo durante la instalación de IS.
chmod -R 777 $ISAAC_SIM_DIR

echo "¡Configuración terminada con éxito! Ya puedes usar run_is.sh"
