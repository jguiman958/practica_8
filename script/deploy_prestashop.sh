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


