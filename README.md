# Instalación Docker de ROS2 Humble + Isaac Sim / Isaac Lab

## 1. Resumen general

Este repo incluye tres componentes principales:

1. `ROS2_Humble/` 
   - Dockerfile para ROS 2 Humble Desktop (basado en `osrf/ros:humble-desktop-full`).
   - `fastdds.xml` con perfil DDS personalizado.
   - Script `run_humble.sh` para levantar el contenedor.

2. `TutorialesIsaacLab/` 
   - `is_setup.sh` + `run_is.sh` para Isaac Sim (v5.1.0).
   - `il_setup.sh` + `run_il.sh` para Isaac Lab (v2.3.2).

3. Uso de volúmenes: la carpeta desde donde ejecutas el script local se monta en el contenedor.

---

## 2. ROS2 Humble en Docker

### 2.1 Ubicaciones y versiones

- `ROS2` base image: `osrf/ros:humble-desktop-full`
- `ROS_DOMAIN_ID=0`
- `RMW_IMPLEMENTATION=rmw_fastrtps_cpp`
- `FASTRTPS_DEFAULT_PROFILES_FILE=/opt/ros/fastdds.xml` 
- `WORKDIR` interno en contenedor: `/workspace`

### 2.2 Dockerfile (ruta `ROS2_Humble/Dockerfile`)

- Copia `fastdds.xml` a `/opt/ros/fastdds.xml`. Necesario para la comunicación con docker de Isaac Sim.
- Instala paquetes ROS relevantes (`joint-state-publisher-gui`, `ros2-control`, `moveit`, etc.).
- Auto-sourcing de ROS 2 Humble y del workspace en `~/.bashrc`. Las terminales que se abren nuevas tienen el source a ROS2. Pero no a los paquetes del workspace.

### 2.3 Construcción de la imagen

Desde `ROS2_Humble/`:

```bash
cd repositorio/ROS2_Humble
docker build -t "Nombre de la Imagen" .
```

### 2.4 Ejecución con `run_humble.sh`

Script: `ROS2_Humble/run_humble.sh`.

```bash
cd repositorio/ROS2_Humble
chmod +x run_humble.sh #Dar permisos de ejecución al archivo   
./run_humble.sh
```

Comportamiento clave:

- `LOCAL_WORKSPACE=$(pwd)` -> directorio actual donde se lanza script.
- Se monta local en `/workspace` dentro del contenedor (`-v "$LOCAL_WORKSPACE":/workspace:rw`).
- `--network=host` y `--ipc=host` para comunicación con Isaac Sim/Isaac Lab.
- Variables X11 para mostrar GUI (`rviz`, etc.).

---

## 3. Isaac Sim (v5.1.0)

### 3.1 Setup inicial: `TutorialesIsaacLab/is_setup.sh`

Ejecútalo una sola vez para preparar carpetas locales:

```bash
cd repositorio/TutorialesIsaacLab
chmod +x is_setup.sh
./is_setup.sh
```

Crea y fija permisos (777) en:

- `$HOME/docker/isaac-sim/cache/kit`
- `$HOME/docker/isaac-sim/cache/ov`
- `$HOME/docker/isaac-sim/cache/pip`
- `$HOME/docker/isaac-sim/cache/glcache`
- `$HOME/docker/isaac-sim/cache/computecache`
- `$HOME/docker/isaac-sim/logs`
- `$HOME/docker/isaac-sim/data`
- `$HOME/docker/isaac-sim/documents`

 Si estas carpetas ya están creadas, dará error el cambio de permisos pero significa que ya estaba realizado. Se puede ignorar.

También ejecuta:

```bash
docker pull nvcr.io/nvidia/isaac-sim:5.1.0
```

### 3.2 Ejecutar el docker de Isaac Sim:

```bash
cd repositorio/TutorialesIsaacLab
chmod +x run_is.sh #Dar permisos de ejecución al archivo.  
./run_is.sh
```

Opciones importantes:

- `--gpus all`
- `--network=host`
- `-e "ACCEPT_EULA=Y"` y `-e "PRIVACY_CONSENT=Y"`
- Montaje del Workspace: `$CURRENT_DIR` (desde donde ejecutas) → `/isaac-sim/$DIR_NAME`

- `-u 1234:1234` para correr con UID/GID 1234 dentro del contenedor.

### 3.3 Rutas dentro del contenedor (Isaac Sim)

- Workdir local con tu carpeta actual: `/isaac-sim/<nombre-carpeta-local>`.
- Caché de paquetes y logs vinculados con `$HOME/docker/isaac-sim` para persistencia.

### 3.4 Ejecutar Isaac Sim

Para lanzar la aplicación de Isaac Sim desde el docker con la interfaz gráfica ejecutar: 


```bash
./runapp.sh
```
Este comando carga la aplicación de Isaac Sim con la interfaz gráfica.

> **Aviso**: Puede tardar bastante en cargar y que salgan mensajes de que la aplicación no responde.

---

## 4. Isaac Lab (v2.3.2)

### 4.1 Setup inicial: `TutorialesIsaacLab/il_setup.sh`

Ejecutar una sola vez:

```bash
cd repositorio/TutorialesIsaacLab
chmod +x il_setup.sh
./il_setup.sh
```

- `docker pull nvcr.io/nvidia/isaac-lab:2.3.2`
- Crea las mismas carpetas que en Isaac Sim (cache, logs, data, documents) con permisos 777. Si estas carpetas ya están creadas, dará error el cambio de permisos pero significa que ya estaba realizado. Se puede ignorar.

### 4.2 Ejecutar Isaac Lab: `TutorialesIsaacLab/run_il.sh`

```bash
cd repositorio/TutorialesIsaacLab
chmod +x run_il.sh
./run_il.sh
```

- `--ipc=host` además de `--network=host` para ROS2/omni comunicaciones.
- Montajes clave:
  - `$ISAAC_SIM_DIR/cache/kit` → `/isaac-sim/kit/cache`
  - `$ISAAC_SIM_DIR/cache/ov` → `/root/.cache/ov`
  - `$ISAAC_SIM_DIR/cache/pip` → `/root/.cache/pip`
  - `$ISAAC_SIM_DIR/data` → `/root/.local/share/ov/data`
  - `$ISAAC_SIM_DIR/documents` → `/root/Documents`
  - `$CURRENT_DIR` → `/workspace/isaaclab/<nombre-carpeta-local>`

### 4.3 Rutas dentro del contenedor (Isaac Lab)

- Workdir local se monta en `/workspace/isaaclab/$DIR_NAME`.
- Caché y datos se persisten en `$HOME/docker/isaac-sim`.

### 4.4 Ejecutar un ejemplo

Para probar el correcto funcionamiento del docker de Isaac Lab, puedes ejecutar:


```bash
python scripts/reinforcement_learning/rsl_rl/train.py --task Isaac-Cartpole-v0
```
Debería abrirse un entrenamiento en paralelo del péndulo invertido.

---

## 5. Notas y consejos prácticos

- Ejecuta siempre el `run_*` desde la carpeta que quieres montar; `$(pwd)` es la ruta mapeada.

- Para evitar problemas de permisos en contenedores que usan UID/GID distinto, se usa `chmod -R 777` en `$HOME/docker/isaac-sim`.
- La combinación `--network=host --ipc=host` es especialmente útil para ROS2 (DDS) y para que Isaac Sim/Lab se comuniquen con ROS desde el host.
- Si quieres entrar en shell bash y no iniciar el software, puedes añadir `--entrypoint bash` (como ya viene en los scripts) y ejecutar manualmente el comando de Isaac dentro.

---

## 6. Atajos de comandos

- Construir ROS2:
  - `cd ROS2_Humble && docker build -t ros2_humble:base .`
- Iniciar ROS2:
  - `cd ROS2_Humble && ./run_humble.sh`
- Configurar Isaac Sim:
  - `cd TutorialesIsaacLab && ./is_setup.sh`
- Ejecutar Isaac Sim:
  - `cd TutorialesIsaacLab && ./run_is.sh`
- Configurar Isaac Lab:
  - `cd TutorialesIsaacLab && ./il_setup.sh`
- Ejecutar Isaac Lab:
  - `cd TutorialesIsaacLab && ./run_il.sh`
