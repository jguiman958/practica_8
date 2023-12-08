# Práctica_8.- Instalación de prestashop.
## Primero tenemos que instalar la pila lamp.
### Aquí hemos contado con la creación de una pila lamp, la cual contiene linux (S.O), apache, mysql, php:

Donde, como base de la pila lamp vamos a instalar wordpress, desde la raiz hasta en un directorio propio.
#
![Alt text](imagenes/Captura.PNG)
### Con esto, buscamos hacer un despligue de aplicaciones.

# Muestra todos los comandos que se han ejeutado.
```
set -ex
```
<p>Se interrumpe el script si hay algún fallo a lo largo de la ejecución del código</p>

# Actualización de repositorios
```
 sudo apt update
```
# Actualización de paquetes
# sudo apt upgrade  

# Instalamos el servidor Web apache
```
apt install apache2 -y
```
### Con esto instalamos el servidor web apache2.

### Estructura de directorios del servicio apache2.

```
 1. Directorios
  1.1 conf-available --> donde se aplican los hosts virtuales.
  1.2 conf-enabled --> donde se encuentran enlaces simbolicos a los archivos de configuracion           
  de conf-available.
  1.3 mods-available --> para añadir funcionalidades al servidor.
  1.4 mods-enabled --> enlaces simbolicos a esas funcionalidades.
  1.5 sites-available --> archivos de configuración de hosts virtuales.
  1.6 sites-enabled --> enlaces simbolicos a sites-available.
 2. Ficheros
  2.1 apache2.conf --> Archivo de configuración principal.
  2.3 envvars --> Define las variables de entorno, que se usan en el archivo principal.
  2.3 magic --> Para determinar el tipo de contenido, por defecto es MIME.
  2.4 ports.conf --> archivo donde se encuentran los puertos de escucha de apache.
```

### En /etc/apache2 se almacenan los archivos y directorios de apache2.

## Contenido del fichero /conf/000-default.conf.
Este archivo contiene la configuración del host virtual el cual debe contener las siguientes directivas para que funcione la aplicación web.

En la ruta del repositorio ``/conf/000-default.conf``, encontramos la configuración que se emplea para este despliegue.

```python
ServerSignature Off
ServerTokens Prod
<VirtualHost *:80>
    #ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html 
    
    <Directory "/var/www/html/">
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
Aquí podemos comprobar lo que contiene el fichero de configuración del ``VirtualHost``, donde todas las conexiones pasaran por el puerto 80, el ``DocumentRoot``, donde mostrará el contenido será desde ``/var/www/html`` y podemos ver los archivos de error y acceso para comprobar errores y ver quien ha accedido, Tambien, tenemos la directiva ``Directory index`` la cual establece una prioridad en el orden que se establezca.

Podemos comprobar que hemos añadido ``directory`` el cual almacena las directivas asignadas al virtualhost, mas las que se encuentran en el archivo principal de apache. 

La ruta donde se ejecuta el contenido que vamos a mostrar por internet y la directiva ``AllowOverride All`` mas adelante se explica el porque esto está aquí, como información puedo ofrecer que tiene que ver con el archivo ``.htaccess``.

### También se hace uso de las siguientes directivas 
``ServerSignature OFF `` --> Esto es por si nos interesa incorporar la versión de apache, en páginas de error e indice de directorios, lo dejamos en OFF por seguridad. Se debe aplicar a todo el servidor.

``ServerTokens Prod `` --> Esta se puede aplicar a un único servidor virtual. Aquí se muestran información sobre las cabeceras, es decir, respuestas que se mandan al cliente, es conveniente tenerlo quitado.

# Instalar mysql server
```
apt install mysql-server -y
```

### Con esto instalamos mysql-server.

# Instalar php
```
apt install php libapache2-mod-php php-mysql -y
```
### Instalamos php junto con unos modulos necesarios.
<------------------------------------------------------>
### ``libapache2-mod-php`` --> para mostrar paginas web desde un servidor web apache y ``php-mysql``, nos permite conectar una base de datos de MySQL desde PHP.

# Copiar el archivo de configuracion de apache.
```
cp ../conf/000-default.conf /etc/apache2/sites-available
```
### En este caso, no haría falta emplear el comando ``a2ensite``, ya que se habilita por defecto debido a que apache2 toma por defecto la configuración de ese archivo para desplegar las opciones que hemos hecho en la web.

### Este script posee un archivo de configuración en la carpeta ``conf `` por el cual configura el host virtual que muestra el contenido de la aplicación web.

```
ServerSignature Off
ServerTokens Prod
<VirtualHost *:80>
    #ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    
    <Directory "/var/www/html/">
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

# Reiniciamos el servicio apache
```
systemctl restart apache2
```
### Reiniciamos apache para que obtenga los cambios.

# Copiamos el arhivo de prueba de php
### La finalidad de esto va a ser que muestre el contenido de la página index.php la cual se inserta en la carpeta html, con objetivo de que muestre el contenido de esa página, por defecto, si vemos el archivo de configuración de 000-default.conf veremos que:
 <p> DocumentRoot ``/var/www/html`` --> Toma como raiz, los archivos en html.</p>
 <p> ``DirectoryIndex`` --> index.php index.html --> Muestra en orden los archivo situados.</p>    

```
cp ../php/index.php /var/www/html
```
### Sabiendo lo anterior copiamos el archivo index.php a ``/var/www/html``.

# Modificamos el propietario y el grupo del directo /var/www/html
```
chown -R www-data:www-data /var/www/html
```

# Despliegue de prestashop.
Ahora toca realizar el despliegue de prestashop, el cual harán falta satisfacer ciertas configuraciones previas a la instalación de prestashop.
## Actualizamos los repositorios

```
apt update
```
Necesario para evitar errores a la hora de instalar programas.

## Incluimos las variables env

```
source .env
```

Incorporamos las variables:
```
# Configuramos variables
#-----------------------------#
#Base de datos
PS_DB_HOST=localhost

PS_DB_NAME=prestashop

PS_DB_USER=pr_user

PS_DB_PASSWORD=pr_pass

IP_CLIENTE_MYSQL=localhost

#--------------------------------#

# Instalación de prestashop.
#-----------------------
PS_NAME=Prestashop

PS_COUNTRY=ES
#-----------------------
PS_FIRSTNAME=Juanjo

PS_LASTNAME="Guirado Mañas"

PS=prestashop@prestashop.com
#-------------------------
PS_PREFIX=PSJG_

PS_PASSWORD=prestashop
#-----------------------------------#

# Variables para el certificado.
CERTIFICATE_EMAIL=demo@demo.es

CERTIFICATE_DOMAIN=hipherion.ddns.net

# Variables para la configuración de php del archivo php.ini

MEMORY_LIMIT="memory_limit = 256M"
UPLOAD_MAX_FILESIZE="upload_max_filesize = 128M"
POST_MAX_SIZE="post_max_size = 128M"
MAX_INPUT_VARS=";max_input_vars = 5000"
```

Variables necesarías para la instalación de prestashop.

## Creamos la base de datos y el usuario para prestashop

```
mysql -u root <<< "DROP DATABASE IF EXISTS $PS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $PS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $PS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$PS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PS_DB_NAME.* TO $PS_DB_USER@$IP_CLIENTE_MYSQL"
```

Creamos la base de datos de prestashop, donde conectará a la misma máquina, es decir, al localhost.

Se usan estas variables:

```
#Base de datos
PS_DB_HOST=localhost

PS_DB_NAME=prestashop

PS_DB_USER=pr_user

PS_DB_PASSWORD=pr_pass

IP_CLIENTE_MYSQL=localhost
```

## Borramos descargas previas

```
rm -rf /tmp/prestashop_8.1.2.zip
```

Borramos descargas previas de prestashop.

## Descargamos el instalador de prestashop.

```
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp
```

Obtenemos el codigo fuente de prestashop, y lo mandamos al directorio tmp.

## Instalar unzip

```
apt install unzip -y
```

Instalamos unzip para descomprimir el instalador.

## Eliminamos instalaciones previas

```
rm -rf /var/www/html/*
```

Eliminamos instalaciones previas del directorio html.

## Copiamos el phppsinfo para comprobaciones

```
cp ../php/phpinfo.php /var/www/html
```
Copiamos el fichero phpinfo.php al directorio html para visualizar si esta bien configurado el servidor, para la instalación de prestashop.
```
<?php

class PhpPsInfo
{
    protected $login;
    protected $password;

    const DEFAULT_PASSWORD = 'prestashop';
    const DEFAULT_LOGIN = 'prestashop';

    const TYPE_OK = true;
    const TYPE_ERROR = false;
    const TYPE_WARNING = null;
            ...
```

Este es el contenido que presenta ese fichero.

## Descomprimimos el archivo y movemos su contenido

```
unzip -u /tmp/prestashop_8.1.2.zip -d /tmp
```

Descomprimimos el fichero de instalación en tmp.

## Y muevo el contenido que contiene el instalador de prestashop, llamado prestashop.zip a /var/www/html

```
unzip -u /tmp/prestashop.zip -d /var/www/html
```

Y descomprimimos el contenido de prestashop.zip ubicado en el instalador, mandandolo al directorio html, mediante la opcion -d.

## Instalamos los paquetes necesarios de php

```
apt install php-bcmath -y 
apt install php-gd -y
apt install php-intl -y
apt install php-zip -y
apt install php-curl -y
apt install php-mbstring -y
apt install php-dom php-xml -y
```

Instalamos los paquetes de php para que funcione prestashop.

## Cambiamos las variables del fichero php.ini de apache 2 por estas variables.

```
sed -i "s/;max_input_vars = 1000/max_input_vars = 5000/" /etc/php/8.1/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 128M/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 128M/" /etc/php/8.1/apache2/php.ini
```

## Reiniciamos apache

```
systemctl restart apache2
```

## Cambiamos los permisos

```
chown -R www-data:www-data /var/www/html/*
```

## Instalamos Prestashop ubicandonos en la ruta donde se encuentra dicho fichero de instalacion

```
php /var/www/html/install/index_cli.php \
    --name=$PS_NAME \
    --country=$PS_COUNTRY \
    --firstname=$PS_FIRSTNAME \
    --lastname=$PS_LASTNAME\
    --password=$PS_PASSWORD \
    --prefix=$PS_PREFIX \
    --db_server=$PS_DB_HOST \
    --db_name=$PS_DB_NAME \
    --db_user=$PS_DB_USER \
    --db_password=$PS_DB_PASSWORD \
    --domain=$CERTIFICATE_DOMAIN \
    --email=$CERTIFICATE_EMAIL \
    --language=es \
    --ssl=1
```
## Borramos directorio install por seguridad

```
rm -rf /var/www/html/install/
```
