#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar modsecurity2 para apache2 en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Apache2-ModSecurity-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Apache2-ModSecurity-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Apache2-ModSecurity-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Apache2-ModSecurity-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Apache2-ModSecurity-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
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

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 13 (Trixie)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --radiolist "Marca las opciones que quieras instalar:" 22 90 16)
        opciones=(
          1 "Activar la configuración para log combined (conexión directa)"        on
          2 "Activar la configuración para log remote_combined (con mod_remoteip)" off
          3 "Activar la configuración para nipegun-live-panel (conexión directa)"  off
          4 "Activar la configuración para nipegun-live-panel (con mod_remoteip)"  off
        )
      choices=$("${menu[@]}" "${opciones[@]}" </dev/tty 2>&1 >/dev/tty || true)

      # Cancelar si no se detecta ninguna opción
        if [ -z "$choices" ]; then
          echo ""
          echo -e "${cColorRojo}  No se seleccionó ninguna opción. Cancelando la configuración.${cFinColor}"
          echo ""
          exit 0
        fi

      # Actualizar la lista de paquetes disponibles en los repositorios e instalar ModSecurity2 + OWASP CRS
        sudo apt-get -y update
        sudo apt-get -y install libapache2-mod-security2
        sudo apt-get -y install modsecurity-crs

      # Activar security2 y unique_id en Apache
        sudo a2enmod security2 unique_id

      # Activar la configuración recomendada de ModSecurity (sólo la primera vez, para no pisar ajustes posteriores)
        if [ ! -f /etc/modsecurity/modsecurity.conf ]; then
          sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
          # No inspeccionar el HTML de las respuestas (evita falsos positivos como el del escritorio de WordPress)
            sudo sed -i 's/^SecResponseBodyAccess On/SecResponseBodyAccess Off/' /etc/modsecurity/modsecurity.conf
        fi
        # SecRuleEngine se queda en DetectionOnly: registra sin bloquear

      # Ajustes locales de CRS: exclusiones de WordPress y permitir la cabecera Accept-Charset
        vHeaders=$(grep -o "tx.restricted_headers=[^']*" /usr/share/modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf | head -n 1 | sed -e 's#^tx.restricted_headers=##' -e 's#/accept-charset/##' -e 's/  */ /g' -e 's/^ //' -e 's/ $//')
        if [ -n "$vHeaders" ]; then
          printf '%s\n' 'SecAction "id:900130,phase:1,nolog,pass,t:none,setvar:tx.crs_exclusions_wordpress=1"'       | sudo tee    /etc/modsecurity/crs-local.conf > /dev/null
          printf '%s\n' "SecAction \"id:900250,phase:1,nolog,pass,t:none,setvar:'tx.restricted_headers=$vHeaders'\"" | sudo tee -a /etc/modsecurity/crs-local.conf > /dev/null
        else
          echo -e "${cColorRojo}    No se encontró la lista de cabeceras prohibidas de CRS. No se creó /etc/modsecurity/crs-local.conf.${cFinColor}"
        fi

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Activando la configuración para log combined (conexión directa)..."
              echo ""

              # Retirar configuración previa de nipegun-live-panel si existía
                sudo a2disconf zz-nipegun-live-panel >/dev/null 2>&1 || true
                sudo rm -f /etc/apache2/conf-available/zz-nipegun-live-panel.conf

              # Comprobar la configuración y recargar Apache
                echo ""
                echo "  Comprobando la configuración..."
                echo ""
                sudo apache2ctl configtest && sudo systemctl reload apache2
                sudo apache2ctl -M | grep -E 'security2|unique_id'

            ;;

            2)

              echo ""
              echo "  Activando la configuración para log remote_combined (con mod_remoteip)..."
              echo ""

              # Retirar configuración previa de nipegun-live-panel si existía
                sudo a2disconf zz-nipegun-live-panel >/dev/null 2>&1 || true
                sudo rm -f /etc/apache2/conf-available/zz-nipegun-live-panel.conf

              # Activar mod_remoteip y su archivo remoteip.conf si existe
                sudo a2enmod remoteip
                if [ -f /etc/apache2/conf-available/remoteip.conf ]; then
                  sudo a2enconf remoteip
                else
                  echo -e "${cColorRojo}    Aviso: no existe /etc/apache2/conf-available/remoteip.conf. Créalo si usas RemoteIPHeader X-Forwarded-For.${cFinColor}"
                fi

              # Comprobar la configuración y recargar Apache
                echo ""
                echo "  Comprobando la configuración..."
                echo ""
                sudo apache2ctl configtest && sudo systemctl reload apache2
                sudo apache2ctl -M | grep -E 'security2|unique_id|remoteip'

            ;;

            3)

              echo ""
              echo "  Activando la configuración para nipegun-live-panel (conexión directa)..."
              echo ""

              # Sobreescribir el alias combined al final de conf-enabled sin tocar el apache2.conf de fábrica
                printf '%s\n' 'LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %v %D %{UNIQUE_ID}e" combined' | sudo tee /etc/apache2/conf-available/zz-nipegun-live-panel.conf > /dev/null
                sudo a2enconf zz-nipegun-live-panel

              # Permitir a www-data leer logs estándar del grupo adm
                #  adm es un grupo de sistema que viene de fábrica en Debian (GID 4) dedicado exclusivamente a tareas de monitorización y lectura de logs.
                #  Por defecto en Debian, muchos registros de /var/log/ (como /var/log/apache2/*.log, auth.log, syslog o el journal de systemd) se crean con propietario root, grupo adm y permisos 640 (rw-r-----).
                #  Así, cuando quieres que un usuario o servicio pueda sólo leer esos logs sin ser root ni poder modificarlos, Debian usa el grupo adm.
                #  NOTA: meter www-data en adm le da permiso de lectura no sólo sobre /var/log/apache2/, sino también sobre otros logs sensibles del sistema en /var/log/ (syslog, auth.log, journal, etc.
                # sudo usermod -aG adm www-data

              # Si los logs se guardan en una subcarpeta de /var/www/, es mucho más limpio y seguro NO meter www-data en adm y asignar directamente el grupo www-data sólo a esa carpeta de logs:
                #  De esa forma:
                # - root (el proceso maestro de Apache) es el único que puede escribir o truncar los logs.
                # - www-data (PHP / nipegun-live-panel) puede leer únicamente los logs de la web y no ve nada de /var/log/.
                # - El resto de usuarios del sistema (0) no puede ni entrar en la carpeta. (Incluso puedes quitar sudo usermod -aG adm www-data de las opciones 3 y 4 del script si siempre usas /var/www/<dominio>-logs/).
                chown -Rv root:www-data /var/www/dominio.com-logs
                chmod 750 -v /var/www/dominio.com-logs
                chmod 640 -v /var/www/dominio.com-logs/*.log

              # Comprobar la configuración y recargar Apache
                echo ""
                echo "  Comprobando la configuración..."
                echo ""
                sudo apache2ctl configtest && sudo systemctl reload apache2
                sudo apache2ctl -M | grep -E 'security2|unique_id'

              echo ""
              echo "  Recuerda configurar las rutas de access.log y error.log en wp-admin -> nipegun Live Panel"
              echo "  y verificar que el usuario www-data tenga permiso de lectura sobre la carpeta de logs de la web."

            ;;

            4)

              echo ""
              echo "  Activando la configuración para nipegun-live-panel (con mod_remoteip)..."
              echo ""

              # Activar mod_remoteip y su archivo remoteip.conf si existe
                sudo a2enmod remoteip
                if [ -f /etc/apache2/conf-available/remoteip.conf ]; then
                  sudo a2enconf remoteip
                else
                  echo -e "${cColorRojo}    Aviso: no existe /etc/apache2/conf-available/remoteip.conf. Créalo si usas RemoteIPHeader X-Forwarded-For.${cFinColor}"
                fi

              # Sobreescribir combined y remote_combined con %a + UNIQUE_ID después de apache2.conf y remoteip.conf
                printf '%s\n' 'LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %v %D %{UNIQUE_ID}e" combined'          | sudo tee    /etc/apache2/conf-available/zz-nipegun-live-panel.conf > /dev/null
                printf '%s\n' '<IfModule remoteip_module>'                                                                                     | sudo tee -a /etc/apache2/conf-available/zz-nipegun-live-panel.conf > /dev/null
                printf '%s\n' '  LogFormat "%a %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %v %D %{UNIQUE_ID}e" remote_combined' | sudo tee -a /etc/apache2/conf-available/zz-nipegun-live-panel.conf > /dev/null
                printf '%s\n' '</IfModule>'                                                                                                    | sudo tee -a /etc/apache2/conf-available/zz-nipegun-live-panel.conf > /dev/null
                sudo a2enconf zz-nipegun-live-panel

              # Permitir a www-data leer logs estándar del grupo adm
                #  adm es un grupo de sistema que viene de fábrica en Debian (GID 4) dedicado exclusivamente a tareas de monitorización y lectura de logs.
                #  Por defecto en Debian, muchos registros de /var/log/ (como /var/log/apache2/*.log, auth.log, syslog o el journal de systemd) se crean con propietario root, grupo adm y permisos 640 (rw-r-----).
                #  Así, cuando quieres que un usuario o servicio pueda sólo leer esos logs sin ser root ni poder modificarlos, Debian usa el grupo adm.
                #  NOTA: meter www-data en adm le da permiso de lectura no sólo sobre /var/log/apache2/, sino también sobre otros logs sensibles del sistema en /var/log/ (syslog, auth.log, journal, etc.
                # sudo usermod -aG adm www-data

              # Si los logs se guardan en una subcarpeta de /var/www/, es mucho más limpio y seguro NO meter www-data en adm y asignar directamente el grupo www-data sólo a esa carpeta de logs:
                #  De esa forma:
                # - root (el proceso maestro de Apache) es el único que puede escribir o truncar los logs.
                # - www-data (PHP / nipegun-live-panel) puede leer únicamente los logs de la web y no ve nada de /var/log/.
                # - El resto de usuarios del sistema (0) no puede ni entrar en la carpeta. (Incluso puedes quitar sudo usermod -aG adm www-data de las opciones 3 y 4 del script si siempre usas /var/www/<dominio>-logs/).
                chown -Rv root:www-data /var/www/dominio.com-logs
                chmod 750 -v /var/www/dominio.com-logs
                chmod 640 -v /var/www/dominio.com-logs/*.log
  
              # Comprobar la configuración y recargar Apache
                echo ""
                echo "  Comprobando la configuración..."
                echo ""
                sudo apache2ctl configtest && sudo systemctl reload apache2
                sudo apache2ctl -M | grep -E 'security2|unique_id|remoteip'

              echo ""
              echo "  Recuerda configurar las rutas de access.log y error.log en wp-admin -> nipegun Live Panel"
              echo "  y verificar que el usuario www-data tenga permiso de lectura sobre la carpeta de logs de la web."

            ;;

          esac

      done

    # Notificar cómo seguir
      echo ""
      echo "  ModSecurity está en DetectionOnly: registra lo que detecta, pero no bloquea."
      echo "  Revisa durante unos días las líneas 'ModSecurity:' de los ErrorLog de cada web y, cuando sólo salgan ataques, activa el bloqueo con:"
      echo "    sed -i 's/^SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf && systemctl reload apache2"
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

