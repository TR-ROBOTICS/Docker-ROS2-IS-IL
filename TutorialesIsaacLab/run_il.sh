#!/bin/bash

# 1. Definir la ruta base y la imagen
ISAAC_SIM_DIR="$HOME/docker/isaac-sim"
IMAGE_NAME="nvcr.io/nvidia/isaac-lab:2.3.2"
CURRENT_DIR="$(pwd)"
DIR_NAME=$(basename "$CURRENT_DIR")


# 3. Dar permisos al entorno gráfico
xhost +local:

# 4. Lanzar el contenedor de Isaac Lab

docker run --name "$USER"-isaac-lab --entrypoint bash -it --rm \
    --gpus all \
    --network=host \
    --ipc=host \
    -e "ACCEPT_EULA=Y" \
    -e "PRIVACY_CONSENT=Y" \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/root/.Xauthority:rw \
    -v $ISAAC_SIM_DIR/cache/kit:/isaac-sim/kit/cache:rw \
    -v $ISAAC_SIM_DIR/cache/ov:/root/.cache/ov:rw \
    -v $ISAAC_SIM_DIR/cache/pip:/root/.cache/pip:rw \
    -v $ISAAC_SIM_DIR/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v $ISAAC_SIM_DIR/cache/computecache:/root/.nv/ComputeCache:rw \
    -v $ISAAC_SIM_DIR/logs:/root/.nvidia-omniverse/logs:rw \
    -v $ISAAC_SIM_DIR/data:/root/.local/share/ov/data:rw \
    -v $ISAAC_SIM_DIR/documents:/root/Documents:rw \
    -v "$CURRENT_DIR":/"$DIR_NAME":rw \
    $IMAGE_NAME
