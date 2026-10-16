#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar software en el escritorio Mate de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-Software-3-Instalar-Redux.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-Software-3-Instalar-Redux.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 13 (x)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios...
      echo ""
      echo "  Actualizando la lista de paquetes disponibles en los repositorios..."
      echo ""
      sudo apt-get -y update

    # Instalar herramientas de terminal
      curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Software-CLI-Instalar-Redux.sh | bash

    # Ofimática y documentos
      sudo apt-get -y install libreoffice-help-es
      sudo apt-get -y install pdfarranger

    # Apps de Sistema
      echo ""
      echo "  Instalando aplicaciones de sistema..."
      echo ""
      sudo apt-get -y install gparted
      sudo apt-get -y install hardinfo
      sudo apt-get -y install bleachbit

    # Apps Multimedia
      echo ""
      echo "  Instalando aplicaciones multimedia..."
      echo ""
      sudo apt-get -y install vlc

    # Apps de redes e internet
      echo ""
      echo "  Instalando aplicaciones de redes e internet..."
      echo ""
      sudo apt-get -y install remmina
      sudo apt-get -y install firefox-esr-l10n-es-es
      sudo apt-get -y install thunderbird
      sudo apt-get -y install thunderbird-l10n-es-es
      sudo apt-get -y install chromium
      sudo apt-get -y install chromium-l10n
      sudo apt-get -y install filezilla
      sudo apt-get -y install transmission-gtk

    # Antivirus
      echo ""
      echo "  Instalando anti-virus ClamAV..."
      echo ""
      sudo apt-get -y install clamtk
      sudo apt-get -y install clamav
      sudo apt-get -y install clamav-freshclam
      sudo apt-get -y install clamav-daemon
      sudo mkdir /var/log/clamav/ 2> /dev/null
      #sudo touch /var/log/clamav/freshclam.log
      #sudo chown clamav:clamav /var/log/clamav/freshclam.log
      #sudo chmod 640 /var/log/clamav/freshclam.log
      sudo rm -rf /var/log/clamav/freshclam.log
      sudo freshclam

    # Lanzador de chromium para el root
      echo ""
      echo "  Preparando el lanzador de chromium para el root..."
      echo ""
      sudo mkdir -p /root/.local/share/applications/ 2> /dev/null
      echo "[Desktop Entry]"                                                                                                           | sudo tee    /root/.local/share/applications/chromiumroot.desktop
      echo "Name=Chromium (para root)"                                                                                                 | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "Comment=Accede a Internet"                                                                                                 | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "GenericName=Navegador web"                                                                                                 | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "Exec=/usr/bin/chromium --no-sandbox"                                                                                       | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "Icon=chromium"                                                                                                             | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "Type=Application"                                                                                                          | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "StartupNotify=false"                                                                                                       | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "StartupWMClass=Code"                                                                                                       | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "Categories=Network;WebBrowser;"                                                                                            | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      echo "MimeType=text/html;text/xml;application/xhtml_xml;application/x-mimearchive;x-scheme-handler/http;x-scheme-handler/https;" | sudo tee -a /root/.local/share/applications/chromiumroot.desktop
      sudo gio set /root/.local/share/applications/chromiumroot.desktop "metadata::trusted" yes

    # Específicas para mate-desktop
      sudo apt-get -y install mate-tweaks
      sudo apt-get -y install caja-open-terminal
      sudo apt-get -y install caja-admin
      sudo apt-get -y install mozo                # Editor del menúde mate
      sudo apt-get -y install caja-share         # Para compartir carpetas desde el propio caja
      sudo apt-get -y install gvfs-backends      # Para poder ver las comparticiones de red usando samba

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio mate en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
