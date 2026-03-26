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
    git \
    ros-humble-joint-state-publisher-gui \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-xacro \
    ros-humble-tf-transformations \
    python3-transforms3d \
    ros-humble-moveit \
    ros-humble-moveit-ros-visualization \
    ros-humble-moveit-servo \
    ros-humble-moveit-configs-utils \
    ros-humble-moveit-setup-assistant \
    python3-lark \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*


    WORKDIR /opt/unitree
    RUN git clone https://github.com/unitreerobotics/unitree_sdk2_python.git && \
        cd unitree_sdk2_python && \
        pip install -e .


# 5. Configurar variables de entorno clave (ROS y DDS)
ENV ROS_DOMAIN_ID=0
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/opt/ros/fastdds.xml

# 6. Directorio de trabajo
WORKDIR /workspace

# 7. Cargar ROS 2 automáticamente
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo 'if [ -f "/workspace/install/setup.bash" ]; then source "/workspace/install/setup.bash"; fi' >> ~/.bashrc

CMD ["bash"]
