#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar software en el escritorio Gnome de Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-1-Software-Desinstalar.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-1-Software-Desinstalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Gnome-1-Software-Desinstalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
    echo ""
    exit
  fi

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

    # Desinstalar escoria de gnome
      echo ""
      echo "  Desinstalando escoria de Gnome..."
      echo ""
      sudo apt-get -y autoremove --purge xterm
#     sudo apt-get -y autoremove --purge reportbug
#     sudo apt-get -y autoremove --purge blender
#     sudo apt-get -y autoremove --purge imagemagick
#     sudo apt-get -y autoremove --purge inkscape
#     sudo apt-get -y autoremove --purge rhythmbox
      sudo apt-get -y autoremove --purge evolution
#     sudo apt-get -y autoremove --purge gnome-2048
#     sudo apt-get -y autoremove --purge five-or-more
#     sudo apt-get -y autoremove --purge four-in-a-row
      sudo apt-get -y autoremove --purge kasumi
#     sudo apt-get -y autoremove --purge ghcal
#     sudo apt-get -y autoremove --purge hitori
#     sudo apt-get -y autoremove --purge gnome-klotski
#     sudo apt-get -y autoremove --purge lightsoff
#     sudo apt-get -y autoremove --purge gnome-mahjongg
#     sudo apt-get -y autoremove --purge gnome-mines
#     sudo apt-get -y autoremove --purge mlterm
      sudo apt-get -y autoremove --purge gnome-music
#     sudo apt-get -y autoremove --purge gnome-nibbles
#     sudo apt-get -y autoremove --purge quadrapassel
#     sudo apt-get -y autoremove --purge iagno
#     sudo apt-get -y autoremove --purge gnome-robots
#     sudo apt-get -y autoremove --purge gnome-sudoku
#     sudo apt-get -y autoremove --purge swell-foop
#     sudo apt-get -y autoremove --purge gnome-tetravex
#     sudo apt-get -y autoremove --purge gnome-taquin
#     sudo apt-get -y autoremove --purge aisleriot
#     sudo apt-get -y autoremove --purge tali
      sudo apt-get -y autoremove --purge totem
#     sudo apt-get -y autoremove --purge gnome-chess
      sudo apt-get -y autoremove --purge gnome-maps
      sudo apt-get -y autoremove --purge gnome-weather
　　   sudo apt-get -y autoremove --purge mozc*
      sudo apt-get -y autoremove --purge uim-gtk3
      sudo apt-get -y autoremove --purge showtime
      sudo apt-get -y autoremove --purge hdate-applet
      sudo apt-get -y autoremove

      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge libreoffice-draw
      sudo apt-get -y autoremove --purge libreoffice-math
      sudo apt-get -y autoremove --purge goldendict-ng
      sudo apt-get -y autoremove --purge *fcitx5*
      sudo apt-get -y autoremove --purge xiterm+thai

      sudo apt-get -y autoremove --purge gnome-text-editor && sudo apt-get -y install gedit

      sudo apt-get -y autoremove
      sudo apt-get -y autoclean

    # Desinstalar el gestor de ventanas awesome
      curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Awesome-Desinstalar.sh | bash

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de software para el escritorio Gnome en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Desinstalar escoria de gnome
      echo ""
      echo "  Desinstalando escoria de Gnome..."
      echo ""
      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge rhythmbox
      sudo apt-get -y autoremove --purge evolution
      sudo apt-get -y autoremove --purge gnome-2048
      sudo apt-get -y autoremove --purge five-or-more
      sudo apt-get -y autoremove --purge four-in-a-row
      sudo apt-get -y autoremove --purge kasumi
      sudo apt-get -y autoremove --purge ghcal
      sudo apt-get -y autoremove --purge hitori
      sudo apt-get -y autoremove --purge gnome-klotski
      sudo apt-get -y autoremove --purge lightsoff
      sudo apt-get -y autoremove --purge gnome-mahjongg
      sudo apt-get -y autoremove --purge gnome-mines
      sudo apt-get -y autoremove --purge mlterm
      sudo apt-get -y autoremove --purge gnome-music
      sudo apt-get -y autoremove --purge gnome-nibbles
      sudo apt-get -y autoremove --purge quadrapassel
      sudo apt-get -y autoremove --purge iagno
      sudo apt-get -y autoremove --purge gnome-robots
      sudo apt-get -y autoremove --purge gnome-sudoku
      sudo apt-get -y autoremove --purge swell-foop
      sudo apt-get -y autoremove --purge gnome-tetravex
      sudo apt-get -y autoremove --purge gnome-taquin
      sudo apt-get -y autoremove --purge aisleriot
      sudo apt-get -y autoremove --purge tali
      sudo apt-get -y autoremove --purge totem
      sudo apt-get -y autoremove --purge gnome-chess
      sudo apt-get -y autoremove --purge gnome-maps
      sudo apt-get -y autoremove --purge gnome-weather
 　　　sudo apt-get -y autoremove --purge mozc*
      sudo apt-get -y autoremove --purge uim-gtk3
      sudo apt-get -y autoremove --purge hdate-applet
      sudo apt-get -y autoremove

      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge libreoffice-draw
      sudo apt-get -y autoremove --purge libreoffice-math
      sudo apt-get -y autoremove --purge goldendict-ng
      sudo apt-get -y autoremove --purge *fcitx5*
      sudo apt-get -y autoremove --purge xiterm+thai
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script instalación de software para el escritorio Gnome en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Desinstalar escoria de gnome
      echo ""
      echo "  Desinstalando escoria de Gnome..."
      echo ""
      apt-get -y remove xterm
      apt-get -y remove reportbug
      apt-get -y remove blender
      apt-get -y remove imagemagick
      apt-get -y remove inkscape
      apt-get -y remove rhythmbox
      apt-get -y remove evolution
      apt-get -y remove gnome-2048
      apt-get -y remove five-or-more
      apt-get -y remove four-in-a-row
      apt-get -y remove kasumi
      apt-get -y remove ghcal
      apt-get -y remove hitori
      apt-get -y remove gnome-klotski
      apt-get -y remove lightsoff
      apt-get -y remove gnome-mahjongg
      apt-get -y remove gnome-mines
      apt-get -y remove mlterm
      apt-get -y remove gnome-music
      apt-get -y remove gnome-nibbles
      apt-get -y remove quadrapassel
      apt-get -y remove iagno
      apt-get -y remove gnome-robots
      apt-get -y remove gnome-sudoku
      apt-get -y remove swell-foop
      apt-get -y remove gnome-tetravex
      apt-get -y remove gnome-taquin
      apt-get -y remove aisleriot
      apt-get -y remove tali
      apt-get -y remove totem
      apt-get -y remove gnome-chess
      apt-get -y remove gnome-maps
      apt-get -y gnome-weather
      sudo apt-get -y autoremove --purge hdate-applet
      sudo apt-get -y autoremove

      sudo apt-get -y autoremove --purge xterm
      sudo apt-get -y autoremove --purge reportbug
      sudo apt-get -y autoremove --purge blender
      sudo apt-get -y autoremove --purge imagemagick
      sudo apt-get -y autoremove --purge inkscape
      sudo apt-get -y autoremove --purge libreoffice-draw
      sudo apt-get -y autoremove --purge libreoffice-math
      sudo apt-get -y autoremove --purge goldendict-ng
      sudo apt-get -y autoremove --purge *fcitx5*
      sudo apt-get -y autoremove --purge xiterm+thai
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean

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
