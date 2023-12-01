#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repos
apt update -y

# Importación de las variables
source .env

# Instalación de extensiones de PHP:
apt install php-curl -y

apt install php-bcmath -y 

apt install php-gd -y 

apt install php-intl -y 

apt install php-zip -y

apt install memcached -y

apt install libmemcached-tools -y

apt install php-mbstring -y

apt install php-dom php-xml

# Reiniciamos el servicio de apache2
systemctl restart apache2


#Configuración en php
sed -i "s/memory_limit = 128M/$MEMORY_LIMIT/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$UPLOAD_MAX_FILESIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/max_input_vars = 1000/$MAX_INPUT_VARS/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$POST_MAX_SIZE/" /etc/php/8.1/apache2/php.ini


#Reinciar el siguiente archivo para que se aplique la configuración:
systemctl restart apache2

#Borramos el instalador de prestashop.
rm -rf /tmp/prestashop_8.1.2.zip

# Descargo el codigo fuente de prestashop en /tmp
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

# Borramos el contenido de html
rm -rf /var/www/html/*

# Descomprimos  el instalador de prestashop en /var/www/html
unzip /tmp/prestashop_8.1.2.zip -d /var/www/html

# Cambiamos el propietario de forma recursiva para el contenido de html
chown  www-data:www-data /var/www/html/* -R

# Creacion de usuario para la base de datos de Prestashop y creación de la base de datos.
mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS '$PRESTASHOP_DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$PRESTASHOP_DB_USER'@'%'IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO '$PRESTASHOP_DB_USER'@'%'"

# Reiniciamos el servicio de mysql.
systemctl restart mysql.service

# Copio el contenido de phpinfo.php con el dashboard de configuraciones de prestashop.
cp ../php/phpinfo.php /var/www/html

# Reinicio el servicio de apache2
systemctl restart apache2