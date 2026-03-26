#!/bin/bash

# 1. Define la ruta de tu ordenador donde tienes tu código de ROS 2
# Utiliza el directorio actual donde se ejecuta el script
LOCAL_WORKSPACE="$(pwd)"

# 2. Dar permisos al entorno gráfico de Ubuntu para recibir ventanas (RViz, rqt, etc.)
xhost +local:

# 3. Lanzar el contenedor de ROS 2
# IMPORTANTE: 
# --network=host y --ipc=host son la clave absoluta para que hable con Isaac Sim
docker run -it --rm \
    --name ros2-humble-env-"$USER" \
    --network=host \
    --ipc=host \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority:rw \
    -v "$LOCAL_WORKSPACE":/workspace:rw \
    ros2_humble:unitreesdk
