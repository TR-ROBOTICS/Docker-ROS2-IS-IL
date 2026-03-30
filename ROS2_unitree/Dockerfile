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

# 4. Instalar herramientas necesarias
RUN apt-get update && apt-get install -y \
    sudo\
    gosu \  
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
    libyaml-cpp-dev \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-rosidl-generator-dds-idl \
    python3-lark \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 5. Instalación de la SDK de python de Unitree
WORKDIR /opt/unitree
RUN git clone https://github.com/unitreerobotics/unitree_sdk2_python.git && \
    cd unitree_sdk2_python && \
    pip install cyclonedds==0.10.2 numpy opencv-python && \
    pip install -e .
    
# 6. Compilar e instalar los paquetes de ROS de unitree
COPY cyclonedds_ws/ /opt/unitree_ros2_libs
WORKDIR /opt/unitree_ros2_libs
RUN source /opt/ros/humble/setup.bash && \
    colcon build --packages-select unitree_api unitree_go unitree_hg


# 7. Configurar SUDO universal (sin contraseña para cualquier usuario)
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers   

# 8. Configurar variables de entorno clave (ROS y DDS), Fast DDS para Isaac Sim
ENV ROS_DOMAIN_ID=0
ENV RMW_IMPLEMENTATION=rmw_fastrtps_cpp
ENV FASTRTPS_DEFAULT_PROFILES_FILE=/opt/ros/fastdds.xml

# SDK de Unitree tiene su propia configuración de CycloneDDS
ENV CYCLONEDDS_URI=file:///workspace/cyclonedds_ws/src/cyclonedds.xml

# 9. Copiar y preparar el script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 10. Directorio de trabajo
WORKDIR /workspace

# 11. Cargar ROS 2 y los mensajes de unitree automáticamente
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc && \
    echo "source /opt/unitree_ros2_libs/install/setup.bash" >> ~/.bashrc && \
    echo 'if [ -f "/workspace/install/setup.bash" ]; then source "/workspace/install/setup.bash"; fi' >> ~/.bashrc

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash"]
