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

# Desplegamos prestashop con las configuraciones necesarias para instalarlo.
## Actualizamos los reposositorios

```
apt update -y
```
Actualizamos repositorios para, a la hora de instalar paquetes no haya fallos en la instalación.

## Importación de las variables

```
source .env
```
Cargamos las variables en deploy_prestashop.

## Instalación de extensiones de PHP:
```
apt install php-curl -y

apt install php-bcmath -y 

apt install php-gd -y 

apt install php-intl -y 

apt install php-zip -y

apt install memcached -y

apt install libmemcached-tools -y

apt install php-mbstring -y

apt install php-dom php-xml
```
Instalamos las extensiones para prestashop.

## Reiniciamos el servicio de apache2
```
systemctl restart apache2
```
Reiniciamos prestashop para que se carguen los cambios.

## Configuración en php
```
sed -i "s/memory_limit = 128M/$MEMORY_LIMIT/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$UPLOAD_MAX_FILESIZE/" /etc/php/8.1/apache2/php.ini
sed -i "s/max_input_vars = 1000/$MAX_INPUT_VARS/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$POST_MAX_SIZE/" /etc/php/8.1/apache2/php.ini
```

Cargamos en el archivo de configuración de php --> php.ini las siguientes variables mediante el comando sed.

## Reinciar el siguiente archivo para que se aplique la configuración:
```
systemctl restart apache2
```

Reiniciamos apache2 para que carguen las actualizaciones de ese fichero.

## Borramos el instalador de prestashop.

```
rm -rf /tmp/prestashop_8.1.2.zip
```
Borramos el instalador del directorio /tmp
## Descargo el codigo fuente de prestashop en /tmp

```
wget https://github.com/PrestaShop/PrestaShop/releases/download/8.1.2/prestashop_8.1.2.zip -P /tmp
```
Obtenemos el instalador en el directorio tmp.

## Borramos el contenido de html

```
rm -rf /var/www/html/*
```

Borramos todo el contenido para instalaciones futuras.

## Descomprimos  el instalador de prestashop en /var/www/html

```
unzip /tmp/prestashop_8.1.2.zip -d /var/www/html
```
Descomprimimos en /var/www/html el archivo de instalación de prestashop.

## Cambiamos el propietario de forma recursiva para el contenido de html

```
chown  www-data:www-data /var/www/html/* -R
```
Cambiamos de forma recursiva los propietarios del contenido de html.

## Creacion de usuario para la base de datos de Prestashop y creación de la base de datos.

```
mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS '$PRESTASHOP_DB_USER'@'%'"
mysql -u root <<< "CREATE USER '$PRESTASHOP_DB_USER'@'%'IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO '$PRESTASHOP_DB_USER'@'%'"
```

Creamos la base de datos para prestashop.

## Reiniciamos el servicio de mysql.
```
systemctl restart mysql.service
```

Es necesario reiniciar el servicio para que se carguen los cambios de la creación de la base de datos.

## Copio el contenido de phpinfo.php con el dashboard de configuraciones de prestashop.

```
cp ../php/phpinfo.php /var/www/html
```

Copiamos el contenido de phpinfo.php a /var/www/html para cargar el contenido de la visualizacion de las configuraciones en /var/www/html y poder visualizarlo desde internet.

## Reinicio el servicio de apache2

```
systemctl restart apache2
```

Reiniciamos el servicio de apache2.

## Tras instalar el deploy, descomprimo prestashop.zip en /var/www/html. --> sudo unzip prestashop.zip *Automatizar*

```
sudo apt install composer -y
```

## Instalamos el compose.phar en el directorio html 
```
cp ../php/composer.phar /var/www/html
```

## Instalamos el composer.json en el directorio html 

```
cp ../php/composer.json /var/www/html
```

## Crear el .json

```
sudo nano composer.json
```
Para crear un archivo .json necesario para instalar prestashop por comandos.

## E instalamos el contenido de ese archivo. 

```
sudo php composer.phar install
```
Necesitamos instalar composer para poder instalar prestashop mas adelante, para ello tenemos que situarnos en el directorio /var/www/html y ejecutar la sentencia desde ahí.

## Instalación de prestashop.

