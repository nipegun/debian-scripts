#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el servidor web con apache2 en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ServWeb/Apache2-ParaWordPress.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ServWeb/Apache2-ParaWordPress.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes
  cCarpetaDeLogs='/var/www/html-logs'

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi


if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 13 (Trixie)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog esté instalado. SI no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  # Crear el menú
    cmd=(dialog --checklist "Script de NiPeGun para instalar un servidor Web con Apache:" 10 94 10)
    options=(
      1 "Instalar con certificado SSL autofirmado."                                      on
      2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)."                        off
      3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso." off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "    Instalando servidor web con certificado SSL autofirmado..."
            echo ""

            # Actualizar sistema
              echo ""
              echo "      Actualizando el sistema..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y upgrade
              sudo apt-get -y dist-upgrade
              sudo apt-get -y autoremove
        
            # Instalar paquetes de apache y relacionados
              echo ""
              echo "      Instalando paquetes de apache y relacionados..."
              echo ""
              sudo apt-get -y install apache2
              sudo apt-get -y install apache2-utils
              sudo apt-get -y install redis-server
              sudo apt-get -y install imagemagick
            # Activar módulos de Apache
              echo ""
              echo "      Activando módulos de Apache..."
              echo ""
              sudo a2enmod rewrite
              sudo a2enmod ssl
              sudo a2enmod headers
              sudo a2enmod env
              sudo a2enmod dir
              sudo a2enmod mime
            # Activar sitio SSL por defecto
              echo ""
              echo "      Activando sitio SSL por defecto en Apache..."
              echo ""
              sudo a2ensite default-ssl
              sudo systemctl reload apache2
            # Configurar carpeta de logs del sitio por defecto
              echo ""
              echo "      Configurando carpeta de logs del sitio por defecto..."
              echo ""
              sudo cp /etc/apache2/sites-available/000-default.conf     /etc/apache2/sites-available/000-default.conf.bak.ori
              sudo mkdir -p "$cCarpetaDeLogs"
              sudo sed -i -e 's|${APACHE_LOG_DIR}|'"$cCarpetaDeLogs"'|g' /etc/apache2/sites-available/000-default.conf
              echo "RewriteEngine On"                                  | sudo tee    "$cCarpetaDeLogs"/.htaccess
              echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' | sudo tee -a "$cCarpetaDeLogs"/.htaccess
              echo "  RewriteRule .*\.(log)$ http://google.com [NC]"   | sudo tee -a "$cCarpetaDeLogs"/.htaccess
            # Instalar paquetes de PHP
              # Determinar la última versión de PHP
                vUltVersPHP=$(apt-cache search php | grep etapackage | grep php | cut -d' ' -f1 | sed 's|[^0-9.]*||g')
              echo ""
              echo "      Instalando paquetes de PHP $vUltVersPHP..."
              echo ""
              # Instalar paquetes
                sudo apt-get -y install php"$vUltVersPHP"-common
                sudo apt-get -y install php"$vUltVersPHP"-gd
                sudo apt-get -y install php"$vUltVersPHP"-curl
                sudo apt-get -y install php"$vUltVersPHP"-cli
                sudo apt-get -y install php"$vUltVersPHP"-dev
                sudo apt-get -y install php"$vUltVersPHP"-mysql
                sudo apt-get -y install php"$vUltVersPHP"-mcrypt
                sudo apt-get -y install php"$vUltVersPHP"-mbstring
                sudo apt-get -y install php-json
                sudo apt-get -y install php-intl
                sudo apt-get -y install php-redis
                sudo apt-get -y install php-imagick
                sudo apt-get -y install php-pear
                sudo apt-get -y install libapache2-mod-php"$vUltVersPHP"
            # Activar módulos de PHP
              echo ""
              echo "      Activando módulos de PHP..."
              echo ""
              sudo phpenmod gd
                php -m | grep gd
              sudo phpenmod curl
                php -m | grep curl
              sudo phpenmod mbstring
                php -m | grep mbstring
              sudo phpenmod intl
                php -m | grep intl
              sudo phpenmod redis
                php -m | grep redis
              sudo phpenmod imagick
                php -m | grep imagick
              sudo phpenmod mcrypt
                php -m | grep mcrypt
            # Modificar php.ini
              echo ""
              echo "      Modificando php.ini..."
              echo ""
              sudo cp /etc/php/"$vUltVersPHP"/apache2/php.ini /etc/php/"$vUltVersPHP"/apache2/php.ini.bak.ori
              sudo sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g'   /etc/php/"$vUltVersPHP"/apache2/php.ini
              sudo sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g'            /etc/php/"$vUltVersPHP"/apache2/php.ini
              sudo sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g'             /etc/php/"$vUltVersPHP"/apache2/php.ini
              sudo sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/"$vUltVersPHP"/apache2/php.ini
            # Modificar el servidor SSH
              echo ""
              echo "      Modificando el servidor SSH..."
              echo ""
              sudo apt-get -y install openssh-server
              sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.ori
              echo ""                             | sudo tee -a /etc/ssh/sshd_config
              echo "Match Group webmasters"       | sudo tee -a /etc/ssh/sshd_config
              echo "  ChrootDirectory /var/www"   | sudo tee -a /etc/ssh/sshd_config
              echo "  AllowTCPForwarding no"      | sudo tee -a /etc/ssh/sshd_config
              echo "  X11Forwarding no"           | sudo tee -a /etc/ssh/sshd_config
              echo "  ForceCommand internal-sftp" | sudo tee -a /etc/ssh/sshd_config
            # Preparar el usuario www-data para conectarse mediante sftp
              echo ""
              echo "      Preparando el usuario www-data para conectarse sólo mediante sftp..."
              echo ""
              echo ""
              echo "        Ahora tendrás que ingresar veces en nuevo password para el usuario www-data."
              echo "        Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp."
              echo ""
              sudo passwd www-data
              sudo usermod -s /bin/bash www-data
              sudo groupadd webmasters
              sudo usermod -a -G webmasters www-data
              sudo chown root:root /var/www
              sudo systemctl restart ssh
              sudo systemctl restart sshd
            # Crear el archivo intermedio nuevawebvar.conf
              echo ""
              echo "      Creando el archivo intermedio nuevawebvar.conf..."
              echo ""
              echo ""                                                              | sudo tee    /etc/apache2/sites-available/nuevawebvar.conf
              echo "<VirtualHost *:80>"                                            | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerName nuevawebvar.com"                                  | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAlias www.nuevawebvar.com"                             | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  DocumentRoot /var/www/nuevawebvar.com"                       | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  #Redirect permanent / https://nuevawebvar.com/"              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo '  <Directory "/var/www/nuevawebvar.com">'                      | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Require all granted"                                       | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Options FollowSymLinks"                                    | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "    AllowOverride All"                                         | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  </Directory>"                                                | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAdmin webmaster@nuevawebvar.com"                       | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ErrorLog /var/www/nuevawebvar.com-logs/error.log"            | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "  CustomLog /var/www/nuevawebvar.com-logs/access.log combined" | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo "</VirtualHost>"                                                | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                              | sudo tee -a /etc/apache2/sites-available/nuevawebvar.conf
            # Instalar el certificado SSL autofirmado para https...
              echo ""
              echo "      Instalando el certificado SSL autofirmado para https..."
              echo ""
              sudo mkdir -p /etc/apache2/ssl/
              sudo openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
              sudo chmod 600 /etc/apache2/ssl/*
              sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak.ori
              sudo sed -i -e 's|${APACHE_LOG_DIR}|'"$cCarpetaDeLogs"'|g'                         /etc/apache2/sites-available/default-ssl.conf
              sudo sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              sudo sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
              sudo systemctl restart apache2
            # Instalar el servidor de bases de datos
              echo ""
              echo "      Instalando el servidor de bases de datos..."
              echo ""
              sudo apt-get -y install mariadb-server
            # Instalar phpmyadmin
              echo ""
              echo "      Instalando phpmyadmin..."
              echo ""
              vPhpMyAdminPass='P@ssw0rd'
              echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'        | sudo debconf-set-selections
              echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true'                    | sudo debconf-set-selections
              echo "phpmyadmin phpmyadmin/mysql/app-pass password ${vPhpMyAdminPass}"       | sudo debconf-set-selections
              echo "phpmyadmin phpmyadmin/app-password-confirm password ${vPhpMyAdminPass}" | sudo debconf-set-selections
              sudo DEBIAN_FRONTEND=noninteractive apt-get install -y phpmyadmin
              echo ''
              echo "        Se ha instalado phpmyadmin. La contraseña admin que se puso es: $vPhpMyAdminPass"
              echo ''
            # Instalar memcached
              echo ""
              echo "      Instalando MemCacheD..."
              echo ""
              sudo apt-get -y install memcached
              sudo apt-get -y install php-memcached
              sudo phpenmod memcached
              sudo systemctl restart apache2
            # Instalar el cortafuegos NFTables
              echo ""
              echo "      Preparando el cortafuegos NFTables..."
              echo ""
              echo "# Reglas NFTables para servidor Web"                   | sudo tee -a /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft chain inet filter input { policy drop \; }"      | sudo tee -a /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 22 accept"  | sudo tee -a /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 80 accept"  | sudo tee -a /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 443 accept" | sudo tee -a /root/scripts/ParaEsteDebian/ComandosNFTables.sh
            # Notificar el fin de la ejecución de la parte 1 del script
              echo ""
              echo -e "${cColorVerde}      Fin de ejecución de la parte 1 del script.${cFinColor}"
              echo ""

          ;;

          2)

            # Agregar el certificado de letsencrypt
              echo ""
              echo "    Agregando el certificado SSL de letsencrypt y configurando Apache para que lo use..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install certbot
              sudo apt-get -y install python3-certbot-apache
              #iptables -A INPUT -p tcp --dport 443 -j ACCEPT
              #service apache2 stop
              sudo certbot --apache
              dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
              echo ""
              echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
              echo ""
              sudo sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
              sudo sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              sudo chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
              sudo sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
              sudo systemctl restart apache2
            # Creando el script para renovar el certificado
              echo ""
              echo "  Creando el script para renovar el certificado de LetsEncrypt de forma automática.,.."
              echo ""
              mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
              echo '#!/bin/bash'                   | sudo tee    /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Parar el servidor Apache"    | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 stop"          | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Renovar certificados"        | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "certbot renew"                 | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Arrancar el servidor Apache" | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 start"         | sudo tee -a /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              chmod +x                                           /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "/root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh" | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronPorSemana.sh

          ;;

          3)

            # Activar módulos para remoteip
              echo ""
              echo "    Activando módulos para RemoteIP..."
              echo ""
              sudo a2enmod remoteip
              sudo a2enmod headers
            # Modificar la configuración de apache
              echo ""
              echo "    Modificando el archivo remoteip.conf en Apache..."
              echo ''
              echo '<IfModule remoteip_module>'                                                                 | sudo tee    /etc/apache2/conf-available/remoteip.conf
              echo '  RemoteIPHeader X-Forwarded-For'                                                           | sudo tee -a /etc/apache2/conf-available/remoteip.conf
              echo '  #RemoteIPInternalProxy 0.0.0.0'                                                           | sudo tee -a /etc/apache2/conf-available/remoteip.conf
              echo '  #RemoteIPTrustedProxy 0.0.0.0'                                                            | sudo tee -a /etc/apache2/conf-available/remoteip.conf
              echo '  LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" remote_combined' | sudo tee -a /etc/apache2/conf-available/remoteip.conf
              echo '</IfModule>'                                                                                | sudo tee -a /etc/apache2/conf-available/remoteip.conf
              # Modificar los logs
                sudo sed -i -e 's| combined| remote_combined|g' /etc/apache2/sites-available/000-default.conf
                sudo sed -i -e 's| combined| remote_combined|g' /etc/apache2/sites-available/default-ssl.conf

            # Activar la configuración de remoteip
              echo ""
              echo "    Activando la configuración de apache de remoteip..."
              echo ""
              sudo a2enconf remoteip
            # Reiniciar el servidor apache
              echo ""
              echo "    Reiniciando el servidor apache..."
              echo ""
              sudo systemctl restart apache2
            # Notificar fin del script
              echo ""
              echo -e "${cColorVerde}      El módulo remoteip está activado. Para configurarlo edita el archivo:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        /etc/apache2/conf-available/remoteip.conf${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      descomenta la línea que te interese de las dos que están comentadas,${cFinColor}"
              echo -e "${cColorVerde}      reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso${cFinColor}"
              echo -e "${cColorVerde}      y reinicia apache 2 ejecutando:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      sudo systemctl restart apache2${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      Para más información sobre este punto, revisa:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        http://hacks4geeks.com/hack/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache/${cFinColor}"
              echo ""

          ;;

        esac

      done


elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog esté instalado. SI no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi
  # Crear el menú
    cmd=(dialog --checklist "Script de NiPeGun para instalar un servidor Web con Apache:" 10 94 10)
    options=(
      1 "Instalar con certificado SSL autofirmado." on
      2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)." off
      3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso." off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "    Instalando servidor web con certificado SSL autofirmado..."
            echo ""

            # Actualizar sistema
              echo ""
              echo "      Actualizando el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            # Determinar la última versión de PHP
              vUltVersPHP=$(apt-cache search php | grep etapackage | grep php | cut -d' ' -f1 | sed 's|[^0-9.]*||g')
        
            # Instalar paquetes de apache y relacionados
              echo ""
              echo "      Instalando paquetes de apache y relacionados..."
              echo ""
              apt-get -y install apache2
              apt-get -y install apache2-utils
              apt-get -y install redis-server
              apt-get -y install imagemagick
            # Activar módulos de Apache
              echo ""
              echo "      Activando módulos de Apache..."
              echo ""
              a2enmod rewrite
              a2enmod ssl
              a2enmod headers
              a2enmod env
              a2enmod dir
              a2enmod mime
            # Activar sitio SSL por defecto
              echo ""
              echo "      Activando sitio SSL por defecto en Apache..."
              echo ""
              a2ensite default-ssl
            # Configurar carpeta de logs del sitio por defecto
              echo ""
              echo "      Configurando carpeta de logs del sitio por defecto..."
              echo ""
              cp /etc/apache2/sites-available/000-default.conf     /etc/apache2/sites-available/000-default.conf..bak.ori
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g' /etc/apache2/sites-available/000-default.conf
              mkdir -p /var/www/html/_/logs/
              echo "RewriteEngine On"                                   > /var/www/html/_/logs/.htaccess
              echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/_/logs/.htaccess
              echo "  RewriteRule .*\.(log)$ http://google.com [NC]"   >> /var/www/html/_/logs/.htaccess
            # Instalar paquetes de PHP
              echo ""
              echo "      Instalando paquetes de PHP $vUltVersPHP..."
              echo ""
              apt-get -y install php"$vUltVersPHP"-common
              apt-get -y install php"$vUltVersPHP"-gd
              apt-get -y install php"$vUltVersPHP"-curl
              apt-get -y install php"$vUltVersPHP"-cli
              apt-get -y install php"$vUltVersPHP"-dev
              apt-get -y install php"$vUltVersPHP"-mysql
              apt-get -y install php"$vUltVersPHP"-mcrypt
              apt-get -y install php"$vUltVersPHP"-mbstring
              apt-get -y install php-json
              apt-get -y install php-intl
              apt-get -y install php-redis
              apt-get -y install php-imagick
              apt-get -y install php-pear
              apt-get -y install libapache2-mod-php"$vUltVersPHP"
            # Activar módulos de PHP
              echo ""
              echo "      Activando módulos de PHP..."
              echo ""
              phpenmod gd
                php -m | grep gd
              phpenmod curl
                php -m | grep curl
              #phpenmod json
                #php -m | grep json
              phpenmod mbstring
                php -m | grep mbstring
              phpenmod intl
                php -m | grep intl
              phpenmod redis
                php -m | grep redis
              phpenmod imagick
                php -m | grep imagick
              phpenmod mcrypt
                php -m | grep mcrypt
            # Modificar php.ini
              echo ""
              echo "      Modificando php.ini..."
              echo ""
              cp /etc/php/"$vUltVersPHP"/apache2/php.ini /etc/php/"$vUltVersPHP"/apache2/php.ini.bak.ori
              sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g'   /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g'            /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g'             /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/"$vUltVersPHP"/apache2/php.ini
            # Modificar el servidor SSH
              echo ""
              echo "      Modificando el servidor SSH..."
              echo ""
              #apt-get -y install tasksel
              #tasksel install ssh-server
              cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.ori
              echo ""                             >> /etc/ssh/sshd_config
              echo "Match Group webmasters"       >> /etc/ssh/sshd_config
              echo "  ChrootDirectory /var/www"   >> /etc/ssh/sshd_config
              echo "  AllowTCPForwarding no"      >> /etc/ssh/sshd_config
              echo "  X11Forwarding no"           >> /etc/ssh/sshd_config
              echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
            # Preparar el usuario www-data para conectarse mediante sftp
              echo ""
              echo "      Preparando el usuario www-data para conectarse sólo mediante sftp..."
              echo ""
              echo ""
              echo "        Ahora tendrás que ingresar veces en nuevo password para el usuario www-data."
              echo "        Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp."
              echo ""
              passwd www-data
              usermod -s /bin/bash www-data
              groupadd webmasters
              usermod -a -G webmasters www-data
              chown root:root /var/www
              service ssh restart
            # Crear el archivo intermedio nuevawebvar.conf
              echo ""
              echo "      Creando el archivo intermedio nuevawebvar.conf..."
              echo ""
              echo ""                                                                 > /etc/apache2/sites-available/nuevawebvar.conf
              echo "<VirtualHost *:80>"                                              >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerName nuevawebvar.com"                                    >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAlias www.nuevawebvar.com"                               >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  DocumentRoot /var/www/nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  #Redirect permanent / https://nuevawebvar.com/"                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo '  <Directory "/var/www/nuevawebvar.com">'                        >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Require all granted"                                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Options FollowSymLinks"                                      >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    AllowOverride All"                                           >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  </Directory>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAdmin webmaster@nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ErrorLog /var/www/nuevawebvar.com/_/logs/error.log"            >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  CustomLog /var/www/nuevawebvar.com/_/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "</VirtualHost>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
            # Instalar el certificado SSL autofirmado para https...
              echo ""
              echo "      Instalando el certificado SSL autofirmado para https..."
              echo ""
              mkdir -p /etc/apache2/ssl/
              openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
              chmod 600 /etc/apache2/ssl/*
              cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak.ori
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g'                        /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
              service apache2 restart
            # Instalar el servidor de bases de datos
              echo ""
              echo "      Instalando el servidor de bases de datos..."
              echo ""
              curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts//refs/heads/main/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash

            # Instalar memcached
              echo ""
              echo "      Instalando MemCacheD..."
              echo ""
              apt-get -y install memcached
              apt-get -y install php-memcached
              phpenmod memcached
              service apache2 restart
            # Instalar el cortafuegos NFTables
              echo ""
              echo "      Instalando el cortafuegos NFTables..."
              echo ""
              apt-get -y install nftables
              systemctl enable nftables.service
              echo "# Reglas NFTables para servidor Web"                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft chain inet filter input { policy drop \; }"      >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 22 accept"  >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 80 accept"  >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 443 accept" >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
            # Notificar el fin de la ejecución de la parte 1 del script
              echo ""
              echo -e "${cColorVerde}      Fin de ejecución de la parte 1 del script.${cFinColor}"
              echo ""

          ;;

          2)

            # Instalar el cortafuegos NFTables
              echo ""
              echo "    Agregando el certificado SSL de letsencrypt y configurando Apache para que lo use..."
              echo ""
              apt-get update
              apt-get -y install certbot
              apt-get -y install python3-certbot-apache
              #iptables -A INPUT -p tcp --dport 443 -j ACCEPT
              #service apache2 stop
              certbot --apache
              dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
              echo ""
              echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
              echo ""
              sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
              sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
              service apache2 start
            # Creando el script para renovar el certificado
              echo ""
              echo "  Creando el script para renovar el certificado de LetsEncrypt de forma automática.,.."
              echo ""
              mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
              echo '#!/bin/bash'                    > /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Parar el servidor Apache"    >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 stop"          >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Renovar certificados"        >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "certbot renew"                 >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "# Arrancar el servidor Apache" >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 start"         >> /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              chmod +x                                /root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh
              echo "/root/scripts/ParaEsteDebian/RenovarCertificadosSSL.sh" >> /root/scripts/ParaEsteDebian/TareasCronPorSemana.sh

          ;;

          3)

            # Activar módulos para remoteip
              echo ""
              echo "    Activando módulos para RemoteIP..."
              echo ""
              a2enmod remoteip
              a2enmod headers
            # Modificar la configuración de apache
              echo ""
              echo "    Modificando el archivo remoteip.conf en Apache..."
              echo ""
              echo "RemoteIPHeader X-Forwarded-For"                                                     > /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPInternalProxy 0.0.0.0"                                                    >> /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPTrustedProxy 0.0.0.0"                                                     >> /etc/apache2/conf-available/remoteip.conf
              echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
            # Activar la configuración de remoteip
              echo ""
              echo "    Activando la configuración de apache de remoteip..."
              echo ""
              a2enconf remoteip
            # Reiniciar el servidor apache
              echo ""
              echo "    Reiniciando el servidor apache..."
              echo ""
              service apache2 restart
            # Notificar fin del script
              echo ""
              echo -e "${cColorVerde}      El módulo remoteip está activado. Para configurarlo edita el archivo:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        /etc/apache2/conf-available/remoteip.conf${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      descomenta la línea que te interese de las dos que están comentadas,${cFinColor}"
              echo -e "${cColorVerde}      reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso${cFinColor}"
              echo -e "${cColorVerde}      y reinicia apache 2 ejecutando:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      service apache2 restart${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      Para más información sobre este punto, revisa:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache${cFinColor}"
              echo ""

          ;;

        esac

      done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Comprobar si el paquete dialog esté instalado. SI no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update
      apt-get -y install dialog
      echo ""
    fi
  # Crear el menú
    cmd=(dialog --checklist "Script de NiPeGun para instalar un servidor Web con Apache:" 10 94 10)
    options=(
      1 "Instalar con certificado SSL autofirmado." on
      2 "Agregar certificado LetsEncrypt encima (Requiere DDNS)." off
      3 "Configurar y activar el módulo remoteip para estar detrás de un proxy inverso." off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "    Instalando servidor web con certificado SSL autofirmado..."
            echo ""

            # Actualizar sistema
              echo ""
              echo "      Actualizando el sistema..."
              echo ""
              apt-get -y update
              apt-get -y upgrade
              apt-get -y dist-upgrade
              apt-get -y autoremove

            # Determinar la última versión de PHP
              vUltVersPHP=$(apt-cache search php | grep etapackage | grep php | cut -d' ' -f1 | sed 's|[^0-9.]*||g' )
        
            # Instalar paquetes de apache y relacionados
              echo ""
              echo "      Instalando paquetes de apache y relacionados..."
              echo ""
              apt-get -y install apache2
              apt-get -y install apache2-utils
              apt-get -y install redis-server
              apt-get -y install imagemagick
            # Activar módulos de Apache
              echo ""
              echo "      Activando módulos de Apache..."
              echo ""
              a2enmod rewrite
              a2enmod ssl
              a2enmod headers
              a2enmod env
              a2enmod dir
              a2enmod mime
            # Activar sitio SSL por defecto
              echo ""
              echo "      Activando sitio SSL por defecto en Apache..."
              echo ""
              a2ensite default-ssl
            # Configurar carpeta de logs del sitio por defecto
              echo ""
              echo "      Configurando carpeta de logs del sitio por defecto..."
              echo ""
              cp /etc/apache2/sites-available/000-default.conf     /etc/apache2/sites-available/000-default.conf.ori
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g' /etc/apache2/sites-available/000-default.conf
              mkdir -p /var/www/html/_/logs/
              echo "RewriteEngine On"                                   > /var/www/html/_/logs/.htaccess
              echo '  RewriteCond %{REQUEST_URI} !hotlink\.(log) [NC]' >> /var/www/html/_/logs/.htaccess
              echo "  RewriteRule .*\.(log)$ http://google.com [NC]"   >> /var/www/html/_/logs/.htaccess
            # Instalar paquetes de PHP
              echo ""
              echo "      Instalando paquetes de PHP $vUltVersPHP..."
              echo ""
              apt-get -y install php"$vUltVersPHP"-common
              apt-get -y install php"$vUltVersPHP"-gd
              apt-get -y install php"$vUltVersPHP"-curl
              apt-get -y install php"$vUltVersPHP"-cli
              apt-get -y install php"$vUltVersPHP"-dev
              apt-get -y install php"$vUltVersPHP"-json
              apt-get -y install php"$vUltVersPHP"-mysql
              #apt-get -y install php"$vUltVersPHP"-mcrypt
              apt-get -y install php"$vUltVersPHP"-mbstring
              apt-get -y install php-intl
              apt-get -y install php-redis
              apt-get -y install php-imagick
              apt-get -y install php-pear
              apt-get -y install libapache2-mod-php"$vUltVersPHP"
            # Activar módulos de PHP
              echo ""
              echo "      Activando módulos de PHP..."
              echo ""
              phpenmod gd
                php -m | grep gd
              phpenmod curl
                php -m | grep curl
              phpenmod json
                php -m | grep json
              phpenmod mbstring
                php -m | grep mbstring
              phpenmod intl
                php -m | grep intl
              phpenmod redis
                php -m | grep redis
              phpenmod imagick
                php -m | grep imagick
              #phpenmod mcrypt
                #php -m | grep mcrypt
            # Modificar php.ini
              echo ""
              echo "      Modificando php.ini..."
              echo ""
              cp /etc/php/"$vUltVersPHP"/apache2/php.ini /etc/php/"$vUltVersPHP"/apache2/php.ini.ori
              sed -i -e 's|max_execution_time = 30|max_execution_time = 300|g'   /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|memory_limit = 128M|memory_limit = 300M|g'            /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|post_max_size = 8M|post_max_size = 64M|g'             /etc/php/"$vUltVersPHP"/apache2/php.ini
              sed -i -e 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php/"$vUltVersPHP"/apache2/php.ini
            # Modificar el servidor SSH
              echo ""
              echo "      Modificando el servidor SSH..."
              echo ""
              #apt-get -y install tasksel
              #tasksel install ssh-server
              cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
              echo ""                             >> /etc/ssh/sshd_config
              echo "Match Group webmasters"       >> /etc/ssh/sshd_config
              echo "  ChrootDirectory /var/www"   >> /etc/ssh/sshd_config
              echo "  AllowTCPForwarding no"      >> /etc/ssh/sshd_config
              echo "  X11Forwarding no"           >> /etc/ssh/sshd_config
              echo "  ForceCommand internal-sftp" >> /etc/ssh/sshd_config
            # Preparar el usuario www-data para conectarse mediante sftp
              echo ""
              echo "      Preparando el usuario www-data para conectarse sólo mediante sftp..."
              echo ""
              echo ""
              echo "        Ahora tendrás que ingresar veces en nuevo password para el usuario www-data."
              echo "        Acuérdate de apuntarlo en un lugar seguro porque tendrás que loguearte con él mediante sftp."
              echo ""
              passwd www-data
              usermod -s /bin/bash www-data
              groupadd webmasters
              usermod -a -G webmasters www-data
              chown root:root /var/www
              service ssh restart
            # Crear el archivo intermedio nuevawebvar.conf
              echo ""
              echo "      Creando el archivo intermedio nuevawebvar.conf..."
              echo ""
              echo ""                                                                 > /etc/apache2/sites-available/nuevawebvar.conf
              echo "<VirtualHost *:80>"                                              >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerName nuevawebvar.com"                                    >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAlias www.nuevawebvar.com"                               >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  DocumentRoot /var/www/nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  #Redirect permanent / https://nuevawebvar.com/"                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo '  <Directory "/var/www/nuevawebvar.com">'                        >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Require all granted"                                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    Options FollowSymLinks"                                      >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "    AllowOverride All"                                           >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  </Directory>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ServerAdmin webmaster@nuevawebvar.com"                         >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  ErrorLog /var/www/nuevawebvar.com/_/logs/error.log"            >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "  CustomLog /var/www/nuevawebvar.com/_/logs/access.log combined" >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
              echo "</VirtualHost>"                                                  >> /etc/apache2/sites-available/nuevawebvar.conf
              echo ""                                                                >> /etc/apache2/sites-available/nuevawebvar.conf
            # Instalar el certificado SSL autofirmado para https...
              echo ""
              echo "      Instalando el certificado SSL autofirmado para https..."
              echo ""
              mkdir -p /etc/apache2/ssl/
              openssl req -x509 -nodes -days 365 -newkey rsa:8192 -out /etc/apache2/ssl/autocertssl.pem -keyout /etc/apache2/ssl/autocertssl.key
              chmod 600 /etc/apache2/ssl/*
              cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
              sed -i -e 's|${APACHE_LOG_DIR}|/var/www/html/_/logs|g'                        /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/certs/ssl-cert-snakeoil.pem|apache2/ssl/autocertssl.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|ssl/private/ssl-cert-snakeoil.key|apache2/ssl/autocertssl.key|g' /etc/apache2/sites-available/default-ssl.conf
              service apache2 restart
            # Instalar el servidor de bases de datos
              echo ""
              echo "      Instalando el servidor de bases de datos..."
              echo ""
              #curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh | bash
              /root/scripts/d-scripts/SoftInst/ParaCLI/Servidor-BBDD-MariaDB-InstalarYConfigurar.sh
            # Instalar memcached
              echo ""
              echo "      Instalando MemCacheD..."
              echo ""
              apt-get -y install memcached
              apt-get -y install php-memcached
              phpenmod memcached
              service apache2 restart
            # Instalar el cortafuegos NFTables
              echo ""
              echo "      Instalando el cortafuegos NFTables..."
              echo ""
              apt-get -y install nftables
              systemctl enable nftables.service
              echo "# Reglas NFTables para servidor Web"                   >> /root/scripts/ComandosNFTables.sh
              echo "# nft chain inet filter input { policy drop \; }"      >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 22 accept"  >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 80 accept"  >> /root/scripts/ComandosNFTables.sh
              echo "# nft add rule inet filter input tcp dport 443 accept" >> /root/scripts/ComandosNFTables.sh
            # Notificar el fin de la ejecución de la parte 1 del script
              echo ""
              echo -e "${cColorVerde}      Fin de ejecución de la parte 1 del script.${cFinColor}"
              echo ""

          ;;

          2)

            # Instalar el cortafuegos NFTables
              echo ""
              echo "    Agregando el certificado SSL de letsencrypt y configurando Apache para que lo use..."
              echo ""
              apt-get update
              apt-get -y install certbot
              apt-get -y install python3-certbot-apache
              #iptables -A INPUT -p tcp --dport 443 -j ACCEPT
              #service apache2 stop
              certbot --apache
              dominio_servidor=$(dialog --title "Actualizar la configuración de default-ssl.conf" --inputbox "Ingresa el nombre de dominio exactamente como se lo pusiste a LetsEncrypt:" 8 60 3>&1 1>&2 2>&3 3>&- )
              echo ""
              echo "SE ACTUALIZARÁ EL ARCHIVO default-ssl.conf con el dominio $dominio_servidor"
              echo ""
              sed -i -e 's|apache2/ssl/autocertssl.pem|letsencrypt/live/'"$dominio_servidor"'/fullchain.pem|g' /etc/apache2/sites-available/default-ssl.conf
              sed -i -e 's|apache2/ssl/autocertssl.key|letsencrypt/live/'"$dominio_servidor"'/privkey.pem|g'   /etc/apache2/sites-available/default-ssl.conf
              chmod 600 /etc/letsencrypt/live/$dominio_servidor/*
              sed -i -e 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html\n        Redirect permanent / https://'"$dominio_servidor"'/|g' /etc/apache2/sites-available/000-default.conf
              service apache2 start
            # Creando el script para renovar el certificado
              echo ""
              echo "  Creando el script para renovar el certificado de LetsEncrypt de forma automática.,.."
              echo ""
              mkdir -p /root/scripts/EsteDebian/ 2> /dev/null
              echo '#!/bin/bash'                    > /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Parar el servidor Apache"    >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 stop"          >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Renovar certificados"        >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "certbot renew"                 >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo ""                              >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "# Arrancar el servidor Apache" >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "service apache2 start"         >> /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              chmod +x                                /root/scripts/EsteDebian/RenovarCertificadosSSL.sh
              echo "/root/scripts/EsteDebian/RenovarCertificadosSSL.sh" >> /root/scripts/TareasCronPorSemana.sh

          ;;

          3)

            # Activar módulos para remoteip
              echo ""
              echo "    Activando módulos para RemoteIP..."
              echo ""
              a2enmod remoteip
              a2enmod headers
            # Modificar la configuración de apache
              echo ""
              echo "    Modificando el archivo remoteip.conf en Apache..."
              echo ""
              echo "RemoteIPHeader X-Forwarded-For"                                                     > /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPInternalProxy 0.0.0.0"                                                    >> /etc/apache2/conf-available/remoteip.conf
              echo "#RemoteIPTrustedProxy 0.0.0.0"                                                     >> /etc/apache2/conf-available/remoteip.conf
              echo 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\"" combined' >> /etc/apache2/conf-available/remoteip.conf
            # Activar la configuración de remoteip
              echo ""
              echo "    Activando la configuración de apache de remoteip..."
              echo ""
              a2enconf remoteip
            # Reiniciar el servidor apache
              echo ""
              echo "    Reiniciando el servidor apache..."
              echo ""
              service apache2 restart
            # Notificar fin del script
              echo ""
              echo -e "${cColorVerde}      El módulo remoteip está activado. Para configurarlo edita el archivo:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        /etc/apache2/conf-available/remoteip.conf${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      descomenta la línea que te interese de las dos que están comentadas,${cFinColor}"
              echo -e "${cColorVerde}      reemplaza la ip que aparece como 0.0.0.0 con la ip del host del proxy inverso${cFinColor}"
              echo -e "${cColorVerde}      y reinicia apache 2 ejecutando:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      service apache2 restart${cFinColor}"
              echo ""
              echo -e "${cColorVerde}      Para más información sobre este punto, revisa:${cFinColor}"
              echo ""
              echo -e "${cColorVerde}        http://hacks4geeks.com/pasar-ips-reales-de-clientes-http-de-haproxy-a-backends-con-apache${cFinColor}"
              echo ""

          ;;

        esac

      done

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del servidor web con Apache2 para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutar el script en otra versión de Debian.${cFinColor}"
  echo ""

fi

