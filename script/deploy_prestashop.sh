#!/bin/bash

# Muestra todos los comandos que se han ejeutado.

set -ex

# Actualización de repositorios
apt update

# Incluimos las variables del archivo .env.
source .env

# Borramos el contenido de /tmp
rm -rf /tmp/prestashop_8.1.2.zip

# Descargamos el codigo fuente de prestashop
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

# Borramos el contenid de html
rm -rf /var/www/html/*

# Descomprimimos el .zip en /var/www/html
unzip -u /tmp/prestashop_8.1.2.zip -d /var/www/html

# Eliminamos instalaciones previas de prestashop
rm -rf /var/www/html/*

# Movemos el contenido de prestashop a /var/www/html
mv -f /tmp/PrestaShop-8.1.2  /var/www/html/

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

# Damos permisos a www-data.
chown www-data:www-data /var/www/html

# Reiniciamos apache2
systemctl restart apache2