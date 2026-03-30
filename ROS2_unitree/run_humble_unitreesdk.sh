#!/bin/bash

# 1. Define la ruta de tu ordenador donde tienes tu código de ROS 2
# Utiliza el directorio actual donde se ejecuta el script
USER_ID=$(id -u)
GROUP_ID=$(id -g)
USER_NAME=$(whoami)
LOCAL_WORKSPACE="$(pwd)"
DOCKER_IMAGE="ros2_humble:unitreesdk"

# 2. Dar permisos al entorno gráfico de Ubuntu para recibir ventanas (RViz, rqt, etc.)
xhost +local: > /dev/null

# 3. Lanzar el contenedor de ROS 2
# IMPORTANTE: 
# --network=host y --ipc=host son la clave absoluta para que hable con Isaac Sim
docker run -it --rm \
    --name "$USER"-ros2-humble-unitreesdk \
    --network=host \
    --ipc=host \
    -e LOCAL_UID=$USER_ID \
    -e LOCAL_GID=$GROUP_ID \
    -e LOCAL_USER=$USER_NAME \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority:rw \
    -v "$LOCAL_WORKSPACE"/workspace:/workspace:rw \
    "$DOCKER_IMAGE"
