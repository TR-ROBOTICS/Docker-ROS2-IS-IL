# 1. Base oficial de ROS Humble Desktop
FROM osrf/ros:humble-desktop-full

# Cambiamos la shell a bash
SHELL ["/bin/bash", "-c"]

# 2. Evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# 3. Crear el directorio y copiar el perfil Fast DDS
# (Asegúrate de tener el archivo fastdds.xml en la misma carpeta local que tu Dockerfile)
RUN mkdir -p /opt/ros
COPY fastdds.xml /opt/ros/fastdds.xml

# 4. Instalar herramientas limpias (sin paquetes incompatibles)    
RUN apt-get update && apt-get install -y \
    sudo \
    gosu \
    git \
    \
    # --- Core ROS tools ---
    ros-humble-xacro \
    ros-humble-joint-state-publisher-gui \
    ros-humble-teleop-twist-keyboard \
    ros-humble-twist-mux \
    ros-humble-tf-transformations \
    ros-humble-robot-state-publisher \
    ros-humble-rqt \
    ros-humble-rqt-graph \
    ros-humble-rqt-common-plugins \
    ros-humble-diagnostics \
    \
    # --- Gazebo ---
    gazebo \
    ros-humble-gazebo-ros \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-gazebo-plugins \
    \
    # --- Navigation (Nav2) ---
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-nav2-common \
    ros-humble-nav2-util \
    ros-humble-nav2-lifecycle-manager \
    ros-humble-nav2-map-server \
    ros-humble-nav2-amcl \
    \
    # --- SLAM ---
    ros-humble-slam-toolbox \
    \
    # --- Sensors & perception ---
    ros-humble-laser-filters \
    ros-humble-depthimage-to-laserscan \
    ros-humble-pointcloud-to-laserscan \
    \
    # --- MoveIt (opcional, ya lo tenías) ---
    ros-humble-moveit \
    ros-humble-moveit-ros-visualization \
    ros-humble-moveit-servo \
    ros-humble-moveit-configs-utils \
    ros-humble-moveit-setup-assistant \
    # --- ros2_control / Controller Manager ---
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-ros2-control-test-assets \
    ros-humble-controller-manager \
    ros-humble-hardware-interface \
    ros-humble-transmission-interface \
    ros-humble-control-msgs \
    ros-humble-gazebo-ros2-control \ 
    \
    # --- Controladores ---
    ros-humble-joint-state-broadcaster \
    ros-humble-joint-trajectory-controller \
    ros-humble-diff-drive-controller \
    ros-humble-velocity-controllers \
    ros-humble-effort-controllers \
    ros-humble-position-controllers \ 
        \
    # --- Python utils ---
    python3-pip \
    python3-lark \
    python3-transforms3d \
    \
 && rm -rf /var/lib/apt/lists/*

# 5. Configurar SUDO universal (sin contraseña para cualquier usuario)
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers    

# 6. Configurar variables de entorno clave (ROS y DDS)
ENV ROS_DOMAIN_ID=0
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/opt/ros/fastdds.xml

# 7. Copiar y preparar el script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 8. Directorio de trabajo
WORKDIR /workspace

# 9. Cargar ROS 2 automáticamente
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo 'if [ -f "/workspace/install/setup.bash" ]; then source "/workspace/install/setup.bash"; fi' >> ~/.bashrc

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
