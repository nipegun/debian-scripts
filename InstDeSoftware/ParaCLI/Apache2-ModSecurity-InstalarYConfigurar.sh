#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar modsecurity2 para apache2 en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL x | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL x | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' x | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL x | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de modsecurity2 para apache2 en Debian 13 (x)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios
      sudo apt-get -y update

    # Instalar paquetes
      sudo apt-get -y install libapache2-mod-security2
      sudo apt-get -y install modsecurity-crs

    # Activar mod_unique_id para que ModSecurity 2 inspeccione cosas
      sudo a2enmod security2 unique_id

    # Activar la configuración recomendada (sólo la primera vez, para no pisar ajustes posteriores)
      if [ ! -f /etc/modsecurity/modsecurity.conf ]; then
        sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
        # No inspeccionar el HTML de las respuestas (evita falsos positivos como el del escritorio de WordPress)
          sudo sed -i 's/^SecResponseBodyAccess On/SecResponseBodyAccess Off/' /etc/modsecurity/modsecurity.conf
      fi
      # SecRuleEngine se queda en DetectionOnly: registra sin bloquear

    # Ajustes locales de CRS: exclusiones de WordPress y permitir la cabecera Accept-Charset
      vHeaders=$(grep -o "tx.restricted_headers=[^']*" /usr/share/modsecurity-crs/rules/REQUEST-901-INITIALIZATION.conf | head -n 1 | sed -e 's#^tx.restricted_headers=##' -e 's#/accept-charset/##' -e 's/  */ /g' -e 's/^ //' -e 's/ $//')
      if [ -n "$vHeaders" ]; then
        echo 'SecAction "id:900130,phase:1,nolog,pass,t:none,setvar:tx.crs_exclusions_wordpress=1"'       | sudo tee    /etc/modsecurity/crs-local.conf > /dev/null
        echo "SecAction \"id:900250,phase:1,nolog,pass,t:none,setvar:'tx.restricted_headers=$vHeaders'\"" | sudo tee -a /etc/modsecurity/crs-local.conf > /dev/null
      else
        echo -e "${cColorRojo}    No se encontró la lista de cabeceras prohibidas de CRS. No se creó /etc/modsecurity/crs-local.conf.${cFinColor}"
      fi

    # Comprobar la configuración y recargar Apache
      echo ""
      echo "  Comprobando la configuración..."
      echo ""
      sudo apache2ctl configtest && sudo systemctl reload apache2
      sudo apache2ctl -M | grep -E 'security2|unique_id'

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
