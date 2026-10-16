#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el escritorio Mate al acabar de instalar Debian standard
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-0-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-0-Instalar.sh | sed 's-sudo--g' | bash
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 13 (x)...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install tasksel
    sudo tasksel -y install mate-desktop
    sudo apt-get -y install caja-open-terminal
    sudo apt-get -y install caja-admin
    sudo apt-get -y install firefox-esr-l10n-es-es
    sudo apt-get -y install libreoffice-l10n-es

    # Permitir caja como root
      sudo rm -f /root/.config/autostart/caja.desktop
      sudo mkdir -p /root/.config/autostart/
      echo "[Desktop Entry]"                    | sudo tee /root/.config/autostart/caja.desktop > /dev/null
      echo "Type=Application"                   | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "Name=Caja"                          | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "Comment=Gestor de archivos de MATE" | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "Exec=caja -n --force-desktop"       | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "OnlyShowIn=MATE;"                   | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "Terminal=false"                     | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "StartupNotify=false"                | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "Hidden=false"                       | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "X-MATE-Autostart-enabled=true"      | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      echo "X-MATE-Autostart-Delay=2"           | sudo tee -a /root/.config/autostart/caja.desktop > /dev/null
      sudo chmod 644 /root/.config/autostart/caja.desktop

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 13 (x)...${cFinColor}"
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install tasksel
    sudo tasksel -y install mate-desktop
    sudo apt-get -y install caja-open-terminal
    sudo apt-get -y install caja-admin
    sudo apt-get -y install firefox-esr-l10n-es-es
    sudo apt-get -y install libreoffice-l10n-es

    # Permitir caja como root
      sudo mkdir -p /root/.config/autostart/ 2> /dev/null
      echo "[Desktop Entry]"               | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Type=Application"              | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Exec=caja --force-desktop"     | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Hidden=false"                  | sudo tee -a /root/.config/autostart/caja.desktop
      echo "X-MATE-Autostart-enabled=true" | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Name[es_ES]=Caja"              | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Name=Caja"                     | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Comment[es_ES]="               | sudo tee -a /root/.config/autostart/caja.desktop
      echo "Comment="                      | sudo tee -a /root/.config/autostart/caja.desktop
      echo "X-MATE-Autostart-Delay=0"      | sudo tee -a /root/.config/autostart/caja.desktop
      gio set /root/.config/autostart/caja.desktop "metadata::trusted" yes

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación del escritorio Mate en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

