#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el controlador de las gráficas AMD
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Grafica-AMD-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
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
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 13 (x)..."  
  echo ""

  # Drivers
    apt-get -y update
    apt-get -y install firmware-amd-graphics
    apt-get -y install firmware-linux
    apt-get -y install firmware-linux-free
    apt-get -y install firmware-linux-nonfree
    apt-get -y install libdrm-amdgpu1

  # Mesa
    apt-get -y install mesa-utils

  # Vulkan
    apt-get -y install mesa-vulkan-drivers
    apt-get -y install libvulkan1
    apt-get -y install vulkan-tools
    apt-get -y install vulkan-utils
    apt-get -y install vulkan-validationlayers

  # OpenCL
    apt-get -y install mesa-opencl-icd

  # SMI
    apt-get -y install amd-smi

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 12 (Bookworm)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 11 (Bullseye)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 10 (Buster)..."  
  echo ""

  # Drivers
    apt-get -y update
    apt-get -y install firmware-amd-graphics
    apt-get -y install firmware-linux
    apt-get -y install firmware-linux-free
    apt-get -y install firmware-linux-nonfree
    apt-get -y install libdrm-amdgpu1

  # Vulkan
    apt-get -y install mesa-vulkan-drivers
    apt-get -y install libvulkan1
    apt-get -y install vulkan-tools
    apt-get -y install vulkan-utils
    apt-get -y install vulkan-validationlayers

  # OpenCL
    apt-get -y install mesa-opencl-icd

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 9 (Stretch)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 8 (Jessie)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador de las gráficas AMD en Debian 7 (Wheezy)..."  
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

fi

