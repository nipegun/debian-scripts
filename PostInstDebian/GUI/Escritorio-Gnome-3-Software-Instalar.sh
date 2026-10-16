#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar software en el escritorio Gnome de Debian
#
# Ejecución remota (Puede requeriir permisos sudo:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-3-Software-Instalar.sh | bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-3-Software-Instalar.sh | sudo 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-3-Software-Instalar.sh | nano -
# ----------

# Definir el usuario NoRoot
  vUsuarioNoRoot="nipegun"

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
    echo -e "${cColorAzulClaro}  Iniciando el script instalación de software para el escritorio Gnome en Debian 13 (x)...${cFinColor}"
    echo ""

    # Actualizar la lista de paquetes disponibles en los repositorios...
      echo ""
      echo "  Actualizando la lista de paquetes disponibles en los repositorios..."
      echo ""
      sudo apt-get -y update

    # Instalar herramientas de terminal
      curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Software-CLI-Instalar.sh | bash

    # Ofimática y documentos
      sudo apt-get -y install libreoffice-help-es
      sudo apt-get -y install pdfarranger
      sudo apt-get -y install papers
      sudo apt-get -y install foliate              # Para leer libros en ePub
      sudo apt-get -y install xpad                 # Para sticky notes
      sudo apt-get -y install simple-scan
      sudo apt-get -y install apostrophe           # Para markdown y otros formatos

    # Eliminación de archivos duplicados
      sudo apt-get -y install czkawka-gui
      sudo apt-get -y install dupeguru

    # Fuentes
      sudo apt-get -y install fonts-ubuntu
      sudo apt-get -y install fonts-ubuntu-console
      sudo apt-get -y install fonts-freefont-ttf
      sudo apt-get -y install fonts-freefont-otf
      sudo apt-get -y install ttf-mscorefonts-installer

    # Instalar herramientas para poder conectar dispositivos Android
      echo ""
      echo "  Instalando herramientas para poder conectar dispositivos Android..."
      echo ""
      sudo apt-get -y install android-tools-adb # Para poder operar con el contenido de los móviles y relojes android
      sudo apt-get -y install android-tools-fastboot

    # Apps de Sistema
      echo ""
      echo "  Instalando aplicaciones de sistema..."
      echo ""
      sudo apt-get -y install gparted
        sudo apt-get -y install dosfstools
        sudo apt-get -y install mtools
      sudo apt-get -y install hardinfo
      sudo apt-get -y install bleachbit

    # Apps de seguridad
      echo ""
      echo "  Instalando aplicaciones de seguridad..."
      echo ""
      sudo apt-get -y install keepassxc

    # Apps Multimedia
      echo ""
      echo "  Instalando aplicaciones multimedia..."
      echo ""
      sudo apt-get -y install vlc
      #sudo apt-get -y install vlc-plugin-vlsub
      sudo apt-get -y install audacity
      sudo apt-get -y install subtitleeditor
      sudo apt-get -y install easytag
      #sudo apt-get -y install openshot
      sudo apt-get -y install gnome-network-displays

    # Apps de redes e internet
      echo ""
      echo "  Instalando aplicaciones de redes e internet..."
      echo ""
      sudo apt-get -y install wireshark
        #sudo dpkg-reconfigure wireshark-common
        sudo usermod -aG wireshark $USER
      sudo apt-get -y install etherape
        sudo setcap CAP_NET_RAW=pe /usr/bin/etherape 
      sudo apt-get -y install virt-viewer
      sudo apt-get -y install remmina
      sudo apt-get -y install firefox-esr-l10n-es-es
      sudo apt-get -y install thunderbird
      sudo apt-get -y install thunderbird-l10n-es-es
      #sudo apt-get -y install lightning-l10n-es-es
      sudo apt-get -y install eiskaltdcpp
      sudo apt-get -y install amule
      sudo apt-get -y install chromium
      sudo apt-get -y install chromium-l10n
      sudo apt-get -y install filezilla
      sudo apt-get -y install mumble
      sudo apt-get -y install obs-studio
      #sudo apt-get -y install telegram-desktop
      #sudo apt-get -y install discord
      sudo apt-get -y install transmission-gtk

    # Aplicaciones de módems y telefonía
      sudo apt-get -y install gnome-calls
      sudo apt-get -y install modem-manager-gui

    # Juegos
      echo ""
      echo "  Instalando juegos..."
      echo ""
      sudo apt-get -y install scid
      sudo apt-get -y install scid-rating-data
      sudo apt-get -y install scid-spell-data
      sudo apt-get -y install stockfish
      sudo apt-get -y install dosbox
      sudo apt-get -y install scummvm

    # apps de programación
      echo ""
      echo "  Instalando apps de programación..."
      echo ""
      sudo apt-get -y install ghex
      sudo apt-get -y install dia
      sudo apt-get -y install xmlcopyeditor

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
      sudo systemctl enable --now clamav-freshclam

    # SmartCards
      sudo apt-get -y install pcscd
      sudo apt-get -y install opensc-pkcs11 
      sudo apt-get -y install libpam-pkcs11

    # Huellas dactilares
      #sudo apt-get -y install libpam-fprintd
      # Borrar todas las huellas registradas en el usuario root (por las dudas)
        #echo ""
        #echo "    Borrando todas las huellas digitales registradas para el usuario root..."
        #echo ""
        #sudo fprintd-delete root --finger right-index-finger
        #sudo fprintd-delete root --finger right-thumb
        #sudo fprintd-delete root --finger right-middle-finger
        #sudo fprintd-delete root --finger right-ring-finger
        #sudo fprintd-delete root --finger right-little-finger
        #sudo fprintd-delete root --finger left-index-finger
        #sudo fprintd-delete root --finger left-thumb
        #sudo fprintd-delete root --finger left-middle-finger
        #sudo fprintd-delete root --finger left-ring-finger
        #sudo fprintd-delete root --finger left-little-finger
      # Registrar las huellas nuevas
        #echo ""
        #echo "    Registrando nuevas huellas digitales..."
        #echo ""
        #sudo fprintd-enroll -f right-index-finger
        #sudo fprintd-enroll -f right-thumb
        #sudo fprintd-enroll -f right-middle-finger
        #sudo fprintd-enroll -f right-ring-finger
        #sudo fprintd-enroll -f right-little-finger
        #sudo fprintd-enroll -f left-index-finger
        #sudo fprintd-enroll -f left-thumb
        #sudo fprintd-enroll -f left-middle-finger
        #sudo fprintd-enroll -f left-ring-finger
        #sudo fprintd-enroll -f left-little-finger
      # Activar autenticación PAM con huella dactilar
        #echo ""
        #echo "    Activando la autenticación PAM mediante huellas digitales..."
        #echo ""
        #sudo pam-auth-update # Marcar fingerprint authentication
        # Comprobar que la autenticación por huella se activó correctamente
        #grep fprint /etc/pam.d/common-auth
        # En caso de que no funcione la autenticación por huella habría entrar como root y purgar fprint 
        # sudo apt-get purge fprintd

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

    # Tor browser
      echo ""
      echo "  Instalando TOR browser..."
      echo ""
      sudo apt-get -y install torbrowser-launcher

    # Tarjetas AMD
      #sudo apt-get -y install radeontop  # Para ver la utilización de proceso y VRAM de las tarjetas amd, en vivo
      #sudo apt-get -y install rocm-smi   # Para lo mismo que radeontop, pero con drivers rocm instalados

    # Específicos para gnome
      #

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script instalación de software para el escritorio Gnome en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

