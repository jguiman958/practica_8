# practica_8
Tras instalar el deploy, descomprimo prestashop.zip en /var/www/html. --> sudo unzip prestashop.zip *Automatizar*

Instalar composer -y

Instalamos el compose.phar en el directorio html cp ../php/composer.phar /var/www/html

Instalamos el composer.json en el directorio html cp ../php/composer.json /var/www/html

Crear el .json
nano composer.json

E instalamos el contenido de ese archivo. php composer.phar install

composer self-update