#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para personalizar el escritorio Gnome en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-2-Personalizar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-2-Personalizar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-2-Personalizar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 13 (x)...${cFinColor}"
    echo ""

    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-1-Software-Desinstalar.sh | sudo bash

    echo ""
    echo "    Instalando la app de retoques (gnome-tweaks)..."
    echo ""
    sudo apt-get -y install gnome-tweaks

    echo ""
    echo "    Instalando la app de extensiones y algunas extensiones..."
    echo ""
    sudo apt-get -y install gnome-shell-extensions
    sudo apt-get -y install gnome-shell-extension-desktop-icons-ng
    sudo apt-get -y install gnome-shell-extension-impatience
    sudo apt-get -y install gnome-shell-extension-hide-activities
    sudo apt-get -y install gnome-shell-extension-easyscreencast
    sudo apt-get -y install gnome-shell-extension-dashtodock

    echo ""
    echo "    Instalando atajos de teclado personalizados..."
    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install curl
        echo ""
      fi
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-AtajosDeTeclado.txt -o /tmp/Escritorio-Gnome-AtajosDeTeclado.txt
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < /tmp/Escritorio-Gnome-AtajosDeTeclado.txt

      echo ""
      echo "  Haciendo que el editor de texto abra cada archivo en una nueva ventana, en vez de una nueva pestaña..."
      echo ""
      cp -fv /usr/share/applications/org.gnome.TextEditor.desktop ~/.local/share/applications/
      sed -i -e 's|Exec=gnome-text-editor %U|Exec=gnome-text-editor --new-window %U|g' ~/.local/share/applications/org.gnome.TextEditor.desktop
      update-desktop-database ~/.local/share/applications/

    # Theme de íconos
      echo ""
      echo "  Instalando y activando el theme de íconos Papirus..."
      echo ""
      sudo apt-get -y install papirus-icon-theme
      gsettings set org.gnome.desktop.interface icon-theme "Papirus"

    # Reiniciar el sistema
      echo ""
      echo "  Reiniciando el sistema..."
      echo ""
      sudo shutdown -r now

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-1-Software-Desinstalar.sh | sudo bash

    echo ""
    echo "    Instalando la app de retoques (gnome-tweaks)..."
    echo ""
    sudo apt-get -y install gnome-tweaks

    echo ""
    echo "    Instalando la app de extensiones y algunas extensiones..."
    echo ""
    sudo apt-get -y install gnome-shell-extensions
    sudo apt-get -y install gnome-shell-extension-desktop-icons-ng
    sudo apt-get -y install gnome-shell-extension-impatience
    sudo apt-get -y install gnome-shell-extension-hide-activities
    sudo apt-get -y install gnome-shell-extension-easyscreencast
    sudo apt-get -y install gnome-shell-extension-dashtodock

    echo ""
    echo "    Instalando atajos de teclado personalizados..."
    echo ""
    # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install curl
        echo ""
      fi
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/main/PostInst/GUI/Escritorio-Gnome-AtajosDeTeclado.txt -o /tmp/Escritorio-Gnome-AtajosDeTeclado.txt
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < /tmp/Escritorio-Gnome-AtajosDeTeclado.txt

      echo ""
      echo "  Haciendo que el editor de texto abra cada archivo en una nueva ventana, en vez de una nueva pestaña..."
      echo ""
      sudo sed -i -e 's|Exec=gnome-text-editor %U|Exec=gnome-text-editor --new-window %U|g' /usr/share/applications/org.gnome.TextEditor.desktop
      cp -fv /usr/share/applications/org.gnome.TextEditor.desktop ~/.local/share/applications/
      update-desktop-database ~/.local/share/applications/

    # Theme de íconos
      echo ""
      echo "  Instalando y activando el theme de íconos Papirus..."
      echo ""
      sudo apt-get -y install papirus-icon-theme
      gsettings set org.gnome.desktop.interface icon-theme "Papirus"

    # Reiniciar el sistema
      echo ""
      echo "  Reiniciando el sistema..."
      echo ""
      sudo shutdown -r now

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Gnome en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

