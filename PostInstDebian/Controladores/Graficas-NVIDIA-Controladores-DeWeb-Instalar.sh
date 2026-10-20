#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los controladores de NVIDIA en Debian
# de forma que se pueda dar uso a los núcleos CUDA de la tarjeta gráfica
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Instalar.sh | sudo 's-sudo--g' | bash
#
# Para ver el número de la última versión disponible:
#  https://www.nvidia.com/es-es/drivers/unix/
# ----------

# Determinar la última versión estable
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install curl
      echo ""
    fi
  vNroUltVersEstable=$(curl -fsSL 'https://www.nvidia.com/es-es/drivers/unix/' | grep -m2 'Linux x86_64/AMD64/EM64T' | grep roducc | grep -oP '<span class="PB">.*?<a[^>]*>\K[0-9]+(\.[0-9]+)+')

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 13 (x)...${cFinColor}"
  echo ""

  # Instalar paquetes para compilar
    echo ""
    echo "    Instalando paquetes para compilar..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install build-essential
    sudo apt-get -y install linux-headers-$(dpkg --print-architecture)
    sudo apt-get -y install dkms
    sudo apt-get -y install pkg-config
    sudo apt-get -y install libglvnd-dev
    sudo apt-get -y install initramfs-tools

  # Blacklistear nouveau
    echo ""
    echo "    Blacklistear nouveau..."
    echo ""
    echo "blacklist nouveau"         | sudo tee    /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u -k all
    #sudo reboot

  # Descargar el instalador
    echo ""
    echo "    Descargando el instalador..."
    echo ""
    curl -L https://es.download.nvidia.com/XFree86/Linux-x86_64/"$vNroUltVersEstable"/NVIDIA-Linux-x86_64-"$vNroUltVersEstable".run -o /tmp/nVidiaWebDriverInstall.run
    chmod +x /tmp/nVidiaWebDriverInstall.run

  # Parar entorno gráfico
    echo ""
    echo "    Parando entorno gráfico..."
    echo ""
    sudo systemctl stop gdm
    sudo systemctl stop sddm
    sudo systemctl stop lightdm

  # Ejecutar el instalador
    echo ""
    echo "    Ejecutando el instalador..."
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
          1 "Propietario           (Obligatorio para GPUs Maxwell, Pascal y Volta antiguas, opcional para tarjetas nuevas)" off
          2 "Abierto, Dual MIT/GPL (Sólo funciona con GPUs Touring y superiores: RTX 20xx en adelante)"                     off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando el driver propietario..."
              echo ""
              sudo sh /tmp/nVidiaWebDriverInstall.run --ui=none --no-questions --accept-license --disable-nouveau --rebuild-initramfs --dkms --no-install-compat32-libs --kernel-module-type=proprietary

            ;;

            2)

              echo ""
              echo "  Instalando el driver Abierto, Dual MIT/GPL..."
              echo ""
              sudo sh /tmp/nVidiaWebDriverInstall.run --ui=none --no-questions --accept-license --disable-nouveau --rebuild-initramfs --dkms --no-install-compat32-libs --kernel-module-type=open

            ;;

        esac

    done

  # Comprobar la gráfica
    nvidia-smi

  # Instalar CUDA Toolkit
    #curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInst/Controladores/Graficas-NVIDIA-Controladores-CUDAToolkit-DeWeb-Instalar.sh | sudo bash

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Instalar paquetes para compilar
    echo ""
    echo "    Instalando paquetes para compilar..."
    echo ""
    sudo apt-get -y update
    sudo apt-get -y install build-essential
    sudo apt-get -y install linux-headers-$(dpkg --print-architecture)
    sudo apt-get -y install dkms
    sudo apt-get -y install pkg-config
    sudo apt-get -y install libglvnd-dev

  # Blacklistear nouveau
    echo ""
    echo "    Blacklistear nouveau..."
    echo ""
    echo "blacklist nouveau"         | sudo tee    /etc/modprobe.d/blacklist-nouveau.conf
    echo "options nouveau modeset=0" | sudo tee -a /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u -k all
    #sudo reboot

  # Descargar el instalador
    echo ""
    echo "    Descargando el instalador..."
    echo ""
    curl -L https://es.download.nvidia.com/XFree86/Linux-x86_64/"$vNroUltVersEstable"/NVIDIA-Linux-x86_64-"$vNroUltVersEstable".run -o /tmp/nVidiaWebDriverInstall.run
    chmod +x /tmp/nVidiaWebDriverInstall.run

  # Parar entorno gráfico
    echo ""
    echo "    Parando entorno gráfico..."
    echo ""
    sudo systemctl stop gdm
    sudo systemctl stop sddm
    sudo systemctl stop lightdm

  # Ejecutar el instalador
    echo ""
    echo "    Ejecutando el instalador..."
    echo ""
    sudo sh /tmp/nVidiaWebDriverInstall.run

  # Comprobar la grñafica
    nvidia-smi

  # Instalar CUDA Toolkit
    #curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInst/Controladores/Graficas-NVIDIA-Controladores-CUDAToolkit-DeWeb-Instalar.sh | sudo bash

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
