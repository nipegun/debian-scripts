#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para personalizar el escritorio Mate al acabar de instalarlo
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-2-Personalizar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-2-Personalizar.sh | sed 's-sudo--g' | bash
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
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 13 (x)...${cFinColor}"
    echo ""

    echo ""
    echo "    Borrando y reemplazando los wallpapers..."
    echo ""

    # Cosmos
      sudo rm -R '/usr/share/backgrounds/cosmos'

    # Mate abstract
      sudo rm '/usr/share/backgrounds/mate/abstract/Arc-Colors-Transparent-Wallpaper.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants_3840x2160.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants_5640x3172.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Flow.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Gulp.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Silk.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Spring.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Waves.png'

    # Mate desktop
      sudo rm '/usr/share/backgrounds/mate/desktop/Float-into-MATE.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/GreenTraditional.jpg'
      sudo rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Dark.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Light.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Stripes.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Cold-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Dark-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Radioactive-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Warm-no-logo.png'

    # Mate nature
      sudo rm '/usr/share/backgrounds/mate/nature/Aqua.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Blinds.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Dune.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/FreshFlower.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Garden.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/GreenMeadow.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/LadyBird.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/RainDrops.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Storm.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/TwoWings.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Wood.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/YellowFlower.jpg'
      sudo rm -R /usr/share/backgrounds/mate/nature

    # Themes
      sudo apt-get -y autoremove --purge arc-theme
      sudo apt-get -y autoremove --purge adapta-gtk-theme
      sudo apt-get -y autoremove --purge albatross-gtk-theme
      sudo apt-get -y autoremove --purge blackbird-gtk-theme
      sudo apt-get -y autoremove --purge bluebird-gtk-theme
      sudo apt-get -y autoremove --purge breeze-gtk-theme
      sudo apt-get -y autoremove --purge darkcold-gtk-theme
      sudo apt-get -y autoremove --purge darkmint-gtk-theme
      sudo apt-get -y autoremove --purge greybird-gtk-theme
      sudo apt-get -y autoremove --purge materia-gtk-theme
      sudo apt-get -y autoremove --purge numix-gtk-theme

    sudo rm -rf '/usr/share/themes/Blackbird'
    sudo rm -rf '/usr/share/themes/BlackMATE'
    sudo rm -rf '/usr/share/themes/Bluebird'
    sudo rm -rf '/usr/share/themes/Blue-Submarine'
    sudo rm -rf '/usr/share/themes/BlueMenta'
    sudo rm -rf '/usr/share/themes/ContrastHigh'
    sudo rm -rf '/usr/share/themes/GreenLaguna'
    sudo rm -rf '/usr/share/themes/Green-Submarine'
    sudo rm -rf '/usr/share/themes/Greybird'
    sudo rm -rf '/usr/share/themes/Greybird-accessibility'
    sudo rm -rf '/usr/share/themes/Greybird-bright'
    sudo rm -rf '/usr/share/themes/Greybird-compact'
    sudo rm -rf '/usr/share/themes/HighContrast'
    sudo rm -rf '/usr/share/themes/HighContrastInverse'
    sudo rm -rf '/usr/share/themes/Menta'
    sudo rm -rf '/usr/share/themes/TraditionalOk'

    sudo apt-get -y install gnome-icon-theme
    sudo apt-get -y install arc-theme

    sudo rm -rf '/usr/share/themes/Arc'

    sudo rm -R /usr/share/desktop-base/joy-inksplat-theme
    sudo rm -R /usr/share/desktop-base/joy-theme
    sudo rm -R /usr/share/desktop-base/lines-theme
    sudo rm -R /usr/share/desktop-base/softwaves-theme
    sudo rm -R /usr/share/desktop-base/spacefun-theme
    sudo unlink /usr/share/desktop-base/active-theme
    sudo ln -s /usr/share/desktop-base/moonlight-theme /usr/share/desktop-base/active-theme

    echo ""
    echo "    Instalando las fuentes de Ubuntu..."
    echo ""
    sudo apt-get -y install fonts-ubuntu
    echo ""

    echo ""
    echo "    Personalizando LightDM..."
    echo ""
    # Cambiar el tema
      sudo sed -i -e 's|#theme-name=|theme-name=Arc-Darker|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la imagen de fondo
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "    El paquete curl no está instalado. Iniciando su instalación..."
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      sudo curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/LightDMWallpaper.jpg --output /usr/share/pixmaps/LightDMWallpaper.jpg
      sudo chmod 777 /usr/share/pixmaps/LightDMWallpaper.jpg
      sudo sed -i -e 's|#background=|#background=#000000\nbackground=/usr/share/pixmaps/LightDMWallpaper.jpg|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la fuente
      sudo sed -i -e 's|#font-name=|font-name=ubuntu|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar el escritorio por defecto
      sudo sed -i -e 's|Exec=default|Exec=mate-session|g'         /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startxfce4|g'          /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startkde|g'            /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=gnome-session|g'       /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=enlightenment_start|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startlxde|g'           /usr/share/xsessions/lightdm-xsession.desktop
      echo ""

    # Instalar y activar el tema de iconos papirus
      sudo apt-get -y install papirus-icon-theme
      gsettings set org.mate.interface icon-theme 'Papirus'

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo "    Borrando y reemplazando los wallpapers..."
    echo ""

    # Cosmos
      sudo rm -R '/usr/share/backgrounds/cosmos'

    # Mate abstract
      sudo rm '/usr/share/backgrounds/mate/abstract/Arc-Colors-Transparent-Wallpaper.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants_3840x2160.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Elephants_5640x3172.jpg'
      sudo rm '/usr/share/backgrounds/mate/abstract/Flow.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Gulp.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Silk.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Spring.png'
      sudo rm '/usr/share/backgrounds/mate/abstract/Waves.png'

    # Mate desktop
      sudo rm '/usr/share/backgrounds/mate/desktop/Float-into-MATE.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/GreenTraditional.jpg'
      sudo rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Dark.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Light.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Stripes.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Cold-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Dark-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Radioactive-no-logo.png'
      sudo rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Warm-no-logo.png'

    # Mate nature
      sudo rm '/usr/share/backgrounds/mate/nature/Aqua.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Blinds.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Dune.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/FreshFlower.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Garden.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/GreenMeadow.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/LadyBird.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/RainDrops.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Storm.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/TwoWings.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/Wood.jpg'
      sudo rm '/usr/share/backgrounds/mate/nature/YellowFlower.jpg'
      sudo rm -R /usr/share/backgrounds/mate/nature

    # Themes
      sudo apt-get -y autoremove --purge arc-theme
      sudo apt-get -y autoremove --purge adapta-gtk-theme
      sudo apt-get -y autoremove --purge albatross-gtk-theme
      sudo apt-get -y autoremove --purge blackbird-gtk-theme
      sudo apt-get -y autoremove --purge bluebird-gtk-theme
      sudo apt-get -y autoremove --purge breeze-gtk-theme
      sudo apt-get -y autoremove --purge darkcold-gtk-theme
      sudo apt-get -y autoremove --purge darkmint-gtk-theme
      sudo apt-get -y autoremove --purge greybird-gtk-theme
      sudo apt-get -y autoremove --purge materia-gtk-theme
      sudo apt-get -y autoremove --purge numix-gtk-theme

    sudo rm -rf '/usr/share/themes/Blackbird'
    sudo rm -rf '/usr/share/themes/BlackMATE'
    sudo rm -rf '/usr/share/themes/Bluebird'
    sudo rm -rf '/usr/share/themes/Blue-Submarine'
    sudo rm -rf '/usr/share/themes/BlueMenta'
    sudo rm -rf '/usr/share/themes/ContrastHigh'
    sudo rm -rf '/usr/share/themes/GreenLaguna'
    sudo rm -rf '/usr/share/themes/Green-Submarine'
    sudo rm -rf '/usr/share/themes/Greybird'
    sudo rm -rf '/usr/share/themes/Greybird-accessibility'
    sudo rm -rf '/usr/share/themes/Greybird-bright'
    sudo rm -rf '/usr/share/themes/Greybird-compact'
    sudo rm -rf '/usr/share/themes/HighContrast'
    sudo rm -rf '/usr/share/themes/HighContrastInverse'
    sudo rm -rf '/usr/share/themes/Menta'
    sudo rm -rf '/usr/share/themes/TraditionalOk'

    sudo apt-get -y install gnome-icon-theme
    sudo apt-get -y install arc-theme

    sudo rm -rf '/usr/share/themes/Arc'

    sudo rm -R /usr/share/desktop-base/joy-inksplat-theme
    sudo rm -R /usr/share/desktop-base/joy-theme
    sudo rm -R /usr/share/desktop-base/lines-theme
    sudo rm -R /usr/share/desktop-base/softwaves-theme
    sudo rm -R /usr/share/desktop-base/spacefun-theme
    sudo unlink /usr/share/desktop-base/active-theme
    sudo ln -s /usr/share/desktop-base/moonlight-theme /usr/share/desktop-base/active-theme

    echo ""
    echo "    Instalando las fuentes de Ubuntu..."
    echo ""
    sudo apt-get -y install fonts-ubuntu
    echo ""

    echo ""
    echo "    Personalizando LightDM..."
    echo ""
    # Cambiar el tema
      sudo sed -i -e 's|#theme-name=|theme-name=Arc-Darker|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la imagen de fondo
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "    El paquete curl no está instalado. Iniciando su instalación..."
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      sudo curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/LightDMWallpaper.jpg --output /usr/share/pixmaps/LightDMWallpaper.jpg
      sudo chmod 777 /usr/share/pixmaps/LightDMWallpaper.jpg
      sudo sed -i -e 's|#background=|#background=#000000\nbackground=/usr/share/pixmaps/LightDMWallpaper.jpg|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la fuente
      sudo sed -i -e 's|#font-name=|font-name=ubuntu|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar el escritorio por defecto
      sudo sed -i -e 's|Exec=default|Exec=mate-session|g'         /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startxfce4|g'          /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startkde|g'            /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=gnome-session|g'       /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=enlightenment_start|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sudo sed -i -e 's|Exec=default|Exec=startlxde|g'           /usr/share/xsessions/lightdm-xsession.desktop
      echo ""

    # Instalar y activar el tema de iconos papirus
      sudo apt-get -y install papirus-icon-theme
      gsettings set org.mate.interface icon-theme 'Papirus'

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorVerde}  Borrando y reemplazando los wallpapers...${cFinColor}"
    echo ""

    # Cosmos
      rm -R '/usr/share/backgrounds/cosmos'

    # Mate abstract
      rm '/usr/share/backgrounds/mate/abstract/Arc-Colors-Transparent-Wallpaper.png'
      rm '/usr/share/backgrounds/mate/abstract/Elephants.jpg'
      rm '/usr/share/backgrounds/mate/abstract/Elephants_3840x2160.jpg'
      rm '/usr/share/backgrounds/mate/abstract/Elephants_5640x3172.jpg'
      rm '/usr/share/backgrounds/mate/abstract/Flow.png'
      rm '/usr/share/backgrounds/mate/abstract/Gulp.png'
      rm '/usr/share/backgrounds/mate/abstract/Silk.png'
      rm '/usr/share/backgrounds/mate/abstract/Spring.png'
      rm '/usr/share/backgrounds/mate/abstract/Waves.png'

    # Mate desktop
      rm '/usr/share/backgrounds/mate/desktop/Float-into-MATE.png'
      rm '/usr/share/backgrounds/mate/desktop/GreenTraditional.jpg'
      rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Dark.png'
      rm '/usr/share/backgrounds/mate/desktop/MATE-Stripes-Light.png'
      rm '/usr/share/backgrounds/mate/desktop/Stripes.png'
      rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Cold-no-logo.png'
      rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Dark-no-logo.png'
      rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Radioactive-no-logo.png'
      rm '/usr/share/backgrounds/mate/desktop/Ubuntu-Mate-Warm-no-logo.png'

    # Mate nature
      rm '/usr/share/backgrounds/mate/nature/Aqua.jpg'
      rm '/usr/share/backgrounds/mate/nature/Blinds.jpg'
      rm '/usr/share/backgrounds/mate/nature/Dune.jpg'
      rm '/usr/share/backgrounds/mate/nature/FreshFlower.jpg'
      rm '/usr/share/backgrounds/mate/nature/Garden.jpg'
      rm '/usr/share/backgrounds/mate/nature/GreenMeadow.jpg'
      rm '/usr/share/backgrounds/mate/nature/LadyBird.jpg'
      rm '/usr/share/backgrounds/mate/nature/RainDrops.jpg'
      rm '/usr/share/backgrounds/mate/nature/Storm.jpg'
      rm '/usr/share/backgrounds/mate/nature/TwoWings.jpg'
      rm '/usr/share/backgrounds/mate/nature/Wood.jpg'
      rm '/usr/share/backgrounds/mate/nature/YellowFlower.jpg'
      rm -R /usr/share/backgrounds/mate/nature

    # Themes
      apt-get -y purge arc-theme
      apt-get -y purge adapta-gtk-theme
      apt-get -y purge albatross-gtk-theme
      apt-get -y purge blackbird-gtk-theme
      apt-get -y purge bluebird-gtk-theme
      apt-get -y purge breeze-gtk-theme
      apt-get -y purge darkcold-gtk-theme
      apt-get -y purge darkmint-gtk-theme
      apt-get -y purge greybird-gtk-theme
      apt-get -y purge materia-gtk-theme
      apt-get -y purge numix-gtk-theme

    rm -rf '/usr/share/themes/Blackbird'
    rm -rf '/usr/share/themes/BlackMATE'
    rm -rf '/usr/share/themes/Bluebird'
    rm -rf '/usr/share/themes/Blue-Submarine'
    rm -rf '/usr/share/themes/BlueMenta'
    rm -rf '/usr/share/themes/ContrastHigh'
    rm -rf '/usr/share/themes/GreenLaguna'
    rm -rf '/usr/share/themes/Green-Submarine'
    rm -rf '/usr/share/themes/Greybird'
    rm -rf '/usr/share/themes/Greybird-accessibility'
    rm -rf '/usr/share/themes/Greybird-bright'
    rm -rf '/usr/share/themes/Greybird-compact'
    rm -rf '/usr/share/themes/HighContrast'
    rm -rf '/usr/share/themes/HighContrastInverse'
    rm -rf '/usr/share/themes/Menta'
    rm -rf '/usr/share/themes/TraditionalOk'

    apt-get -y install gnome-icon-theme
    apt-get -y install arc-theme

    rm -rf '/usr/share/themes/Arc'

    rm -R /usr/share/desktop-base/joy-inksplat-theme
    rm -R /usr/share/desktop-base/joy-theme
    rm -R /usr/share/desktop-base/lines-theme
    rm -R /usr/share/desktop-base/softwaves-theme
    rm -R /usr/share/desktop-base/spacefun-theme
    unlink /usr/share/desktop-base/active-theme
    ln -s /usr/share/desktop-base/moonlight-theme /usr/share/desktop-base/active-theme

    echo ""
    echo "  Instalando las fuentes de Ubuntu..."
    echo ""
    apt-get install fonts-ubuntu
    echo ""

    echo ""
    echo "  Personalizando LightDM..."
    echo ""
    # Cambiar el tema
      sed -i -e 's|#theme-name=|theme-name=Arc-Darker|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la imagen de fondo
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo "  curl no está instalado. Iniciando su instalación..."        echo ""
          apt-get -y update > /dev/null
          apt-get -y install curl
          echo ""
        fi
      curl --silent https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/LightDMWallpaper.jpg --output /usr/share/pixmaps/LightDMWallpaper.jpg
      chmod 777 /usr/share/pixmaps/LightDMWallpaper.jpg
      sed -i -e 's|#background=|#background=#000000\nbackground=/usr/share/pixmaps/LightDMWallpaper.jpg|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar la fuente
      sed -i -e 's|#font-name=|font-name=ubuntu|g' /etc/lightdm/lightdm-gtk-greeter.conf
    # Cambiar el escritorio por defecto
      sed -i -e 's|Exec=default|Exec=mate-session|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sed -i -e 's|Exec=default|Exec=startxfce4|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sed -i -e 's|Exec=default|Exec=startkde|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sed -i -e 's|Exec=default|Exec=gnome-session|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sed -i -e 's|Exec=default|Exec=enlightenment_start|g' /usr/share/xsessions/lightdm-xsession.desktop
      #sed -i -e 's|Exec=default|Exec=startlxde|g' /usr/share/xsessions/lightdm-xsession.desktop
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de personalización del escritorio Mate en Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi

