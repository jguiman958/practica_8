#!/bin/bash

#Muestra todos los comandos ejecutados
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

#Incluimos las variables env
source .env

#Borramos descargas previas
rm -rf /tmp/prestashop_8.1.2.zip

#Descargamos wp-cli
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

#Instalar unzip
apt install unzip -y

#Eliminamos instalaciones previas
rm -rf /var/www/html/*

#Copiamos el phppsinfo para comprobaciones
cp ../php/phppsinfo.php /var/www/html

#Descomprimimos el archivo y movemos su contenido
unzip -u /tmp/prestashop_8.1.2.zip -d /tmp
unzip -u /tmp/prestashop.zip -d /var/www/html

#Instalamos los paquetes necesarios de php

apt install php-bcmath -y
apt install php-gd -y
apt install php-intl -y
apt install php-zip -y
apt install php-curl -y
apt install php-mbstring -y
apt install php-dom php-xml -y


#Configuración en php
sed -i "s/memory_limit = 128M/$MEMORY_LIMIT/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$UPLOAD_MAX_FILESIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/max_input_vars = 1000/$MAX_INPUT_VARS/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$POST_MAX_SIZE/" /etc/php/8.1/apache2/php.ini

#Reiniciamos apache
systemctl restart apache2

#Creamos la base de datos y el usuario
mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER@$PS_DB_SERVER"
mysql -u root <<< "CREATE USER $PS_DB_USER@$PS_DB_SERVER IDENTIFIED BY '$PS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@$PS_DB_SERVER"

#Cambiamos los permisos
chown -R www-data:www-data /var/www/html/*

#Instalamos Prestashop
php /var/www/html/install/index_cli.php \
    --name=$PS_NAME \
    --country=$PS_COUNTRY \
    --firstname=$PS_FIRSTNAME \
    --lastname=$PS_LASTNAME \
    --password=$PS_PASSWORD \
    --prefix=$PS_PREFIX \
    --db_server=$PS_DB_SERVER \
    --db_name=$PS_DB_NAME \
    --db_user=$PS_DB_USER \
    --db_password=$PS_DB_PASSWORD \
    --domain=$CB_DOMAIN \
    --email=$CB_EMAIL \
    --language=es \
    --ssl=1