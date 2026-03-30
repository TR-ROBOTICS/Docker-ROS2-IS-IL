#!/bin/bash


# Imprimir traza para comprobar visualmente que el script arranca
echo ">>> [Entrypoint] Iniciando script personalizado..."

#Desactivamos set -e para que no muera el proceso con algún error.
set +e


USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
USER_NAME=${LOCAL_USER:-developer}

# Si el usuario no existe, lo configuramos
if ! id -u "$USER_NAME" >/dev/null 2>&1; then
    EXISTING_USER=$(getent passwd "$USER_ID" | cut -d: -f1)
    
    # Si el UID ya existe (ej. usuario 'ubuntu' por defecto), lo renombramos. Si no, lo creamos.
    if [ -n "$EXISTING_USER" ]; then
        echo ">>> [Entrypoint] Renombrando usuario existente $EXISTING_USER a $USER_NAME..."
        usermod -l "$USER_NAME" -d "/home/$USER_NAME" -m "$EXISTING_USER"
        usermod -d "/home/$USER_NAME" -m "$USER_NAME" 2>/dev/null
    else
        echo ">>> [Entrypoint] Creando nuevo usuario $USER_NAME..."
        groupadd -g "$GROUP_ID" "$USER_NAME"
        useradd -s /bin/bash -u "$USER_ID" -g "$GROUP_ID" -m "$USER_NAME"
    fi
    
    # Sudo sin contraseña
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER_NAME
    chmod 0440 /etc/sudoers.d/$USER_NAME

    # Configuración ROS
    echo "source /opt/ros/humble/setup.bash" >> "/home/$USER_NAME/.bashrc"
    echo 'if [ -f "/workspace/install/setup.bash" ]; then source "/workspace/install/setup.bash"; fi' >> "/home/$USER_NAME/.bashrc"
fi

# Ajuste de permisos del workspace
chown "$USER_NAME:$USER_NAME" /workspace

echo ">>> [Entrypoint] Configuración terminada. Entregando control a ROS y VS Code..."


# Ejecución final
exec gosu "$USER_NAME" /ros_entrypoint.sh "$@"