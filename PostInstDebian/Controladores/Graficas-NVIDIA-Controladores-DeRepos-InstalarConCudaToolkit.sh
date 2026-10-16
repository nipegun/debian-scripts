#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los controladores de NVIDIA en Debian de forma que se pueda dar uso a los núcleos CUDA de la tarjeta gráfica
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeRepos-InstalarConCudaToolkit.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeRepos-InstalarConCudaToolkit.sh | sudo 's---g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Controladores/Graficas-NVIDIA-Controladores-DeRepos-InstalarConCudaToolkit.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeRepos-InstalarConCudaToolkit.sh | bash -s Parámetro1 Parámetro2
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 13 (x)...${cFinColor}"
  echo ""

  # Desinstalar nouveau
    sudo apt-get -y autoremove --purge xserver-xorg-video-nouveau
    sudo apt-get -y autoremove --purge libdrm-nouveau2
    sudo apt-get -y autoremove --purge firmware-nvidia-*
    echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u

  # Determinar el controlador a instalar
    echo ""
    echo "    Determinando el controlador a instalar..."
    echo ""
    # Comprobar si el paquete nvidia-detect está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s nvidia-detect 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete nvidia-detect no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install nvidia-detect
        echo ""
      fi
    cPaqueteControlador=$(nvidia-detect | grep "^ " | sed 's- --g')
    echo ""
    echo "      El paquete con el controlador a instalar es: $cPaqueteControlador"
    echo ""

  # Instalar el paquete del controlador
    echo ""
    echo "    Instalando el paquete del controlador..."
    echo ""
    sudo apt-get -y install $cPaqueteControlador

  # Instalar el firmware
    echo ""
    echo "    Instalando el firmware..."
    echo ""
    sudo apt-get -y install firmware-misc-nonfree

  # Instalar CUDA toolkit
    echo ""
    echo "    Instalando CUDA toolkit..."
    echo ""
    sudo apt-get -y install nvidia-cuda-toolkit

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Desinstalar nouveau
    sudo apt-get -y autoremove --purge xserver-xorg-video-nouveau
    sudo apt-get -y autoremove --purge libdrm-nouveau2
    sudo apt-get -y autoremove --purge firmware-nvidia-*
    echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
    sudo update-initramfs -u

  # Determinar el controlador a instalar
    echo ""
    echo "    Determinando el controlador a instalar..."
    echo ""
    # Comprobar si el paquete nvidia-detect está instalado. Si no lo está, instalarlo.
      if [[ $(dpkg-query -s nvidia-detect 2>/dev/null | grep installed) == "" ]]; then
        echo ""
        echo -e "${cColorRojo}      El paquete nvidia-detect no está instalado. Iniciando su instalación...${cFinColor}"
        echo ""
        sudo apt-get -y update
        sudo apt-get -y install nvidia-detect
        echo ""
      fi
    cPaqueteControlador=$(nvidia-detect | grep "^ " | sed 's- --g')
    echo ""
    echo "      El paquete con el controlador a instalar es: $cPaqueteControlador"
    echo ""

  # Instalar el paquete del controlador
    echo ""
    echo "    Instalando el paquete del controlador..."
    echo ""
    sudo apt-get -y install $cPaqueteControlador

  # Instalar el firmware
    echo ""
    echo "    Instalando el firmware..."
    echo ""
    sudo apt-get -y install firmware-misc-nonfree

  # Instalar CUDA toolkit
    echo ""
    echo "    Instalando CUDA toolkit..."
    echo ""
    sudo apt-get -y install nvidia-cuda-toolkit

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
