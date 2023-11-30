#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repos

apt update -y

#apt upgrade -y

# Importación de las variables

source .env

#Instalación de extensiones de PHP:
#--------------------------------------------------
#1. BCMath Arbitrary Precision Mathematics (Recommended)

apt install php-bcmath -y 

#2. Image Processing and GD (Required and Recommended)

apt install php-gd -y 

#3. Internationalization Functions (Intl) (Required and Recommended)

apt install php-intl -y 

#4. Zip (Required and Recommended)

apt install php-zip -y

#5. Memcached y algunas tools (Recommended)

apt install memcached -y

apt install libmemcached-tools -y

#6. Curl

apt install php-curl -y

#7. Cadena multibyte (Mbstring)

apt install php-mbstring -y

#8. 

apt-get install php-dom php-xml


systemctl restart apache2

#---------------------------------------------------

#Modificación de configuración PHP:
#--------------------------------------------------------------------------------
sed -i "s/memory_limit = 128M/$MEMORY_LIMIT/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$UPLOAD_MAX_FILESIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/max_input_vars = 1000/$MAX_INPUT_VARS/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$POST_MAX_SIZE/" /etc/php/8.1/apache2/php.ini
#-------------------------------------------------------------------------------

#Reinciar el siguiente archivo para que se aplique la configuración:

systemctl restart apache2

# Instalación de Prestashop

#Borrar 

rm -rf /tmp/prestashop_8.1.2.zip

# Traigo el codigo fuente de Prestashop

wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp

rm -rf /var/www/html/*

# Lo descomprimo en /var/www/html

unzip /tmp/prestashop_8.1.2.zip -d /var/www/html

chown  www-data:www-data /var/www/html/* -R

#Creacion de usuario para la base de datos de Prestashop
#----------------------------------------------------------------------------------------------------
mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS '$PRESTASHOP_DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$PRESTASHOP_DB_USER'@'%'IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO '$PRESTASHOP_DB_USER'@'%'"
#----------------------------------------------------------------------------------------------------

systemctl restart mysql.service

unzip -u /var/www/html/prestashop.zip /var/www/html/prestashop