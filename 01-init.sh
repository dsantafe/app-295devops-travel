#!/bin/bash

check_status() {
  if [ $1 -eq 0 ]; then
    echo "Éxito"
  else
    echo "Error: El comando falló. Saliendo del script."
    exit 1
  fi
}

install_packages() {
  packages=("apache2" "php" "mariadb-server" "git" "curl")

  for package in "${packages[@]}"; do
    dpkg -l | grep -q $package
    if [ $? -eq 0 ]; then
      echo "$package ya está instalado."
    else
      echo "Instalando $package..."
      sudo apt-get install -y $package
      check_status $?
    fi
  done
}

# STAGE 1: [Init]
# Instalacion de paquetes en el sistema operativo ubuntu: [apache, php, mariadb, git, curl, etc]
# Validación si esta instalado los paquetes o no , de manera de no reinstalar
# Habilitar y Testear instalación de los paquetes
install_packages
