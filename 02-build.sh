#!/bin/bash

clone_repository() {
    if [ ! -d "bootcamp-devops-2023" ]; then
        git clone https://github.com/dsantafe/bootcamp-devops-2023
    else
        cd bootcamp-devops-2023
        git checkout clase2-linux-bash
        git pull
    fi
}

copy_application() {

    # Mover al directorio donde se guardarán los archivos de configuración de Apache
    cd /var/www/html

    # Testear la existencia del código de la aplicación
    if [ -d "app-295devops-travel" ]; then
        echo "El código de la aplicación existe. Realizando copia de seguridad..."
        backup_dir="app-295devops-travel_$(date +'%Y%m%d_%H%M%S')"
        mv app-295devops-travel "$backup_dir"
    fi

    # Copiar archivos de la aplicación a la carpeta web
    sudo cp -r /app-295devops-travel /var/www/html/
}

configure_mariadb() {
    echo "Configurando MariaDB..."
    local db_password="$1"

    # Configura MariaDB (crea la base de datos, el usuario y establece la contraseña)
    mysql <<EOF
CREATE DATABASE devopstravel;
CREATE USER 'codeuser'@'localhost' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
FLUSH PRIVILEGES;
EOF

    # Iniciar MariaDB
    # Habilitar el inicio automático de MariaDB en el arranque del sistema
    # Comprobar el estado de MariaDB
    systemctl start mariadb
    systemctl enable mariadb
    systemctl status mariadb

    # Agrega datos a la base de datos desde el archivo SQL
    sudo mysql devopstravel </app-295devops-travel/database/devopstravel.sql

    check_status $?
}

configure_php() {

    # Mover archivos de configuración de Apache
    sudo mv /var/www/html/index.html /var/www/html/index.html.bkp

    # Ajustar la configuración de PHP para admitir archivos dinámicos
    sudo sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf

    # Actualizar el archivo config.php con la contraseña de la base de datos
    local db_password="$1"
    sed -i "s/\$dbPassword = \".*\";/\$dbPassword = \"$db_password\";/" /var/www/html/config.php

    # Recargar Apache para que los cambios surtan efecto
    sudo systemctl reload apache2

    # Prueba la compatibilidad con PHP
    echo "<?php phpinfo(); ?>" | tee /var/www/html/info.php

    # Verifica si PHP está funcionando correctamente
    php -v
}

# STAGE 2: [Build]
# Clonar el repositorio de la aplicación
# Validar si el repositorio de la aplicación no existe realizar un git clone. y si existe un git pull
# Mover al directorio donde se guardar los archivos de configuración de apache /var/www/html/
# Testear existencia del codigo de la aplicación
# Ajustar el config de php para que soporte los archivos dinamicos de php agreganfo index.php
# Testear la compatibilidad -> ejemplo http://localhost/info.php
# Si te muestra resultado de una pantalla informativa php , estariamos funcional para la siguiente etapa.

# Solicitar al usuario la contraseña de la base de datos en tiempo de despliegue
read -s -p "Ingrese la contraseña de la base de datos: " db_password

# Deploy and Configure Database
# Deploy and Configure Web
clone_repository
copy_application
configure_mariadb "$db_password"
configure_php "$db_password"
