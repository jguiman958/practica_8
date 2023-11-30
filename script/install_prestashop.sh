#!/bin/bash

#Muestra comandos que se van ejecutando por si falla
set -x

# Actualizamos los repos

apt update -y

# Actualizar paquetes 

#apt upgrade -y

source .env

php /var/www/html/install/index_cli.php \
   --domain=$DOMINIO \
   --db_server=$PRESTASHOP_DB_HOST \
   --db_name=$PRESTASHOP_DB_NAME \
   --db_user=$PRESTASHOP_DB_USER \
   --db_password=$PRESTASHOP_DB_PASSWORD \
   --email=$PRESTASHOP_EMAIL \
   --language=es \
   --ssl=1 \

