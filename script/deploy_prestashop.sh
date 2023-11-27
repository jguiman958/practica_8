#!/bin/bash

# Muestra todos los comandos que se han ejeutado.

set -ex

# Actualización de repositorios
apt update

# Incluimos las variables del archivo .env.
source .env

# Borramos el contenido de /tmp
rm -rf /tmp/v1.1.zip*

# Descargamos el codigo fuente de la herramienta para comprobar el estado del servidor.
wget https://github.com/PrestaShop/php-ps-info/archive/refs/tags/v1.1.zip -P /tmp

# Instalamos el programa para descomprimir unzip
apt install unzip -y

# Descomprimimos la herramienta para comprobar el estado del servidor en /var/www/html.
unzip -u /tmp/v1.1.zip -d /tmp/prestashop

# Eliminamos el contenido de la herramienta para comprobar el estado del servidor.  
rm -rf /var/www/html/prestashop

# Movemos el contenido de prestashop a /var/www/html
mv -f /tmp/prestashop /var/www/html

# Damos permisos al usuario de apache para que pueda acceder al contenido de html.
chown www-data:www-data /var/www/html

# Añadimos variables a  la configuración de php, para configurarlo..

sed -i "s/memory_limit = 128M/$MEMORY_LIMIT/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$POST_MAX_SIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$UPLOAD_MAX_FILESIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/;max_input_vars = 1000/$MAX_INPUT_VARS/" /etc/php/8.1/apache2/php.ini
sed -i "s/^\s*;\(max_input_vars = 5000\)/\1/" /etc/php/8.1/apache2/php.ini

# Reiniciamos apache2
systemctl restart apache2

# Instalamos las extensiones necesarias para prestashop.
apt install php-curl -y

apt install php-gd -y

apt install php-intl -y

apt install php-mbstring -y

apt install php-xml -y

apt install php-zip -y

# Reiniciamos el servicio de apache.
sudo systemctl restart apache2

# Creación de la base de datos para prestashop.
mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"

# Reiniciamos mysql.
systemctl restart mysql

# Instalamos prestashop.
php index_cli.php 
    --domain=$CERTIFICATE_DOMAIN \
    --db_server=$PRESTASHOP_DB_HOST \
    --db_name=$PRESTASHOP_DB_NAME \
    --db_user=$PRESTASHOP_DB_USER \
    --db_password=$PRESTASHOP_DB_PASSWORD \
    --prefix=$PRESTASHOP_PREFIX \
    --email=$PRESTASHOP_EMAIL \
    --password=$PRESTASHOP_PASSWORD 
    --ssl=1