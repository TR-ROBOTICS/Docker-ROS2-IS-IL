#!/bin/bash

# Obtener valores de las variables de entorno o usar valores por defecto
USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}
USER_NAME=${LOCAL_USER:-developer}

# Crear el grupo si no existe
if ! getent group "$USER_NAME" >/dev/null; then
    groupadd -g "$GROUP_ID" "$USER_NAME"
fi

# Crear el usuario si no existe
if ! getent passwd "$USER_NAME" >/dev/null; then
    useradd --shell /bin/bash -u "$USER_ID" -g "$GROUP_ID" -m "$USER_NAME"
    
    # Configurar el .bashrc del nuevo usuario
    echo "source /opt/ros/humble/setup.bash" >> "/home/$USER_NAME/.bashrc"
    echo 'if [ -f "/workspace/install/setup.bash" ]; then source "/workspace/install/setup.bash"; fi' >> "/home/$USER_NAME/.bashrc"
fi

# Asegurar que el usuario tenga permisos sobre el workspace
chown "$USER_NAME:$USER_NAME" /workspace

# Ejecutar el comando solicitado (bash por defecto) usando gosu para cambiar de usuario
exec gosu "$USER_NAME" "$@"