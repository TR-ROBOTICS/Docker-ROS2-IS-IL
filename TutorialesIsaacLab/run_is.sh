#!/bin/bash

# 1. Definir las mismas rutas que ya comprobamos que funcionan
ISAAC_SIM_DIR="$HOME/docker/isaac-sim"
IMAGE="nvcr.io/nvidia/isaac-sim:5.1.0"
CURRENT_DIR="$(pwd)"
DIR_NAME=$(basename "$CURRENT_DIR")

# 2. Dar permisos locales para la ventana gráfica
xhost +local:

# 3. Lanzar el contenedor y ejecutar Isaac Sim directamente
docker run --name "$USER"-isaac-sim --entrypoint bash -it --rm \
    --gpus all \
    --network=host \
    -e "ACCEPT_EULA=Y" \
    -e "PRIVACY_CONSENT=Y" \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/.Xauthority:/isaac-sim/.Xauthority \
    -v $ISAAC_SIM_DIR/cache/main:/isaac-sim/.cache:rw \
    -v $ISAAC_SIM_DIR/cache/computecache:/isaac-sim/.nv/ComputeCache:rw \
    -v $ISAAC_SIM_DIR/logs:/isaac-sim/.nvidia-omniverse/logs:rw \
    -v $ISAAC_SIM_DIR/config:/isaac-sim/.nvidia-omniverse/config:rw \
    -v $ISAAC_SIM_DIR/data:/isaac-sim/.local/share/ov/data:rw \
    -v $ISAAC_SIM_DIR/pkg:/isaac-sim/.local/share/ov/pkg:rw \
    -v "$CURRENT_DIR":/"$DIR_NAME":rw \
    -u 1234:1234 \
    $IMAGE \


echo "Restaurando permisos de los archivos generados por Isaac Sim..."
docker run --rm --entrypoint bash -v "$CURRENT_DIR":/"$DIR_NAME" -u root $IMAGE -c "chown -R $(id -u):$(id -g) /\"$DIR_NAME\""
echo "¡Listo! Ya puedes editar todos los archivos en tu PC sin problemas de permisos."