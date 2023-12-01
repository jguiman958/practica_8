#!/bin/bash

#Muestra todos los comandos ejecutados
set -ex

#Actualizamos los repositorios
apt update

#Incluimos las variables env
source .env

#Creamos la base de datos y el usuario para prestashop
mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"

#Borramos descargas previas
rm -rf /tmp/prestashop_8.1.2.zip

#Descargamos wp-cli
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

#Instalar unzip
apt install unzip -y

#Eliminamos instalaciones previas
rm -rf /var/www/html/*

#Copiamos el phppsinfo para comprobaciones
cp ../php/phppinfo.php /var/www/html

#Descomprimimos el archivo y movemos su contenido
unzip -u /tmp/prestashop_8.1.2.zip -d /tmp

#Y muevo el contenido que contiene el instalador de prestashop, llamado prestashop.zip a /var/www/html
unzip -u /tmp/prestashop.zip -d /var/www/html

#Instalamos los paquetes necesarios de php
apt install php-bcmath -y 
apt install php-gd -y
apt install php-intl -y
apt install php-zip -y
apt install php-curl -y
apt install php-mbstring -y
apt install php-dom php-xml -y

#Sustituimos las variables a las recomendadas por php
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.1/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php/8.1/apache2/php.ini

#Reiniciamos apache
systemctl restart apache2

#Cambiamos los permisos
chown -R www-data:www-data /var/www/html/*

#Instalamos Prestashop
php /var/www/html/install/index_cli.php \
    --name=$PRESTASHOP_NAME \
    --country=$PRESTASHOP_COUNTRY \
    --password=$PRESTASHOP_PASSWORD \
    --prefix=$PRESTASHOP_PREFIX \
    --db_server=$PRESTASHOP_DB_HOST \
    --db_name=$PRESTASHOP_DB_NAME \
    --db_user=$PRESTASHOP_DB_USER \
    --db_password=$PRESTASHOP_DB_PASSWORD \
    --domain=$CERTIFICATE_DOMAIN \
    --email=$CERTIFICATE_EMAIL \
    --language=es \
    --ssl=1

#Borramos directorio install por seguridad
rm -rf /var/www/html/install/