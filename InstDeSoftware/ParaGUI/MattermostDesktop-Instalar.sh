#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Mattermost Desktop en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaGUI/MattermostDesktop-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaGUI/MattermostDesktop-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaGUI/MattermostDesktop-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaGUI/MattermostDesktop-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaGUI/MattermostDesktop-Instalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 13 (x)...${cFinColor}"
    echo ""

    # Obtener el tag de la última release del repo de Github
      echo ""
      echo "    Obteniendo el tag de la última release del repo de Github..."
      echo ""
      vUsuario='mattermost'
      vNombreDelRepo='desktop'
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      vTagName=$(curl -s https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/latest | jq -r '.tag_name')
    curl -s https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/latest | jq -r '.tag_name'

   # Obtener assets
      vURLDelAsset=$(curl -sL https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/tags/"$vTagName" | jq -r '.assets[].browser_download_url' | grep '\.gz$')
      # Descargar todos los assets que acaban en .zip
        cd /tmp/
        curl -sL https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/tags/"$vTagName" | jq -r '.assets[] | select(.name | endswith(".gz")) | .browser_download_url' | grep -v arm | xargs -n1 wget -c

    # Descomprimir
      mkdir -p ~/AppsPortables/ 2> /dev/null
      vTagNumber=$(echo $vTagName | cut -d'v' -f2)
      rm -rf ~/AppsPortables/mattermost-desktop-"$vTagNumber"-linux-x64/ 2> /dev/null
      tar -xzf /tmp/mattermost-desktop-"$vTagNumber"-linux-x64.tar.gz -C ~/AppsPortables/
      rm -rf ~/AppsPortables/MattermostDesktop/ 2> /dev/null
      mv ~/AppsPortables/mattermost-desktop-"$vTagNumber"-linux-x64/ ~/AppsPortables/MattermostDesktop/

    # Crear el icono para lanzar la aplicación desde el menú gráfico
      echo ""
      echo "    Creando el lanzador gráfico..."
      echo ""
      mkdir -p ~/.local/share/applications/ 2> /dev/null
      echo '[Desktop Entry]'                                                   | tee    ~/.local/share/applications/Mattermost.desktop
      echo 'Name=Mattermost'                                                   | tee -a ~/.local/share/applications/Mattermost.desktop
      echo 'Categories=Network;InstantMessaging;Chat;'                         | tee -a ~/.local/share/applications/Mattermost.desktop
      echo "Exec=$HOME/AppsPortables/MattermostDesktop/com.Mattermost.Desktop" | tee -a ~/.local/share/applications/Mattermost.desktop
      echo "Icon=$HOME/AppsPortables/MattermostDesktop/app_icon.png"           | tee -a ~/.local/share/applications/Mattermost.desktop
      echo 'Type=Application'                                                  | tee -a ~/.local/share/applications/Mattermost.desktop
      echo 'Terminal=false'                                                    | tee -a ~/.local/share/applications/Mattermost.desktop

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost Desktop para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
