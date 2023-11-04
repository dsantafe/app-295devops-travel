#!/bin/bash

# Actualizar repositorios
apt-get update

# Ejecutar la etapa 1: [Init]
./01-init.sh

# Ejecutar la etapa 2: [Build]
./02-build.sh

# STAGE 3: [Deploy]
# Es momento de probar la aplicación, recuerda hacer un reload de apache y acceder a la aplicacion DevOps Travel
# Aplicación disponible para el usuario final.
# Accede a la aplicación
echo "Puedes acceder a la aplicación en http://localhost/info.php"
