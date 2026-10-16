#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.


# Script de NiPeGun para instalar y configurar el controlador AMDGPU-Pro en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Grafica-AMDGPU-Pro-Instalar.sh | bash


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

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 10 (Buster)..."
  echo ""

  vURL="http://drivers.amd.com/drivers/linux/"

  # 20.30
  #
  #Archivo="amdgpu-pro-20.30-1109583-ubuntu-18.04.tar.xz"
  vArchivo="amdgpu-pro-20.30-1109583-ubuntu-20.04.tar.xz"
  # AMD Radeon™ RX 5700/5600/5500 Series Graphics
  # AMD Radeon™ Pro WX-series
  # AMD Radeon™ VII Series Graphics
  # AMD Radeon™ Pro WX 9100
  # AMD Radeon™ RX Vega Series Graphics
  # AMD Radeon™ Pro WX 8200
  # AMD Radeon™ Vega Frontier Edition
  # AMD FirePro™ W9100
  # AMD Radeon™ RX 550/560/570/580/590 Series Graphics
  # AMD FirePro™ W8100
  # AMD Radeon™ RX 460/470/480 Graphics
  # AMD FirePro™ W7100
  # AMD Radeon™ Pro Duo
  # AMD FirePro™ W5100
  # AMD Radeon™ R9 Fury/Fury X/Nano Graphics
  # AMD FirePro™ W4300
  # AMD Radeon™ R9 380/380X/390/390X Graphics
  # AMD Radeon™ R9 285/290/290X Graphics
  # AMD Radeon™ R9 360 Graphics


  # 20.40
  #
  #Archivo="amdgpu-pro-20.40-1147287-ubuntu-18.04.tar.xz"
  #Archivo="amdgpu-pro-20.40-1147286-ubuntu-20.04.tar.xz"
  # AMD Radeon™ RX 5700/5600/5500 Series Graphics
  # AMD Radeon™ Pro WX-series
  # AMD Radeon™ VII Series Graphics
  # AMD Radeon™ Pro WX 9100
  # AMD Radeon™ RX Vega Series Graphics
  # AMD Radeon™ Pro WX 8200
  # AMD Radeon™ Vega Frontier Edition
  # AMD FirePro™ W9100
  # AMD Radeon™ RX 550/560/570/580/590 Series Graphics
  # AMD FirePro™ W8100
  # AMD Radeon™ RX 460/470/480 Graphics
  # AMD FirePro™ W7100
  # AMD Radeon™ Pro Duo
  # AMD FirePro™ W5100
  # AMD Radeon™ R9 Fury/Fury X/Nano Graphics
  # AMD FirePro™ W4300
  # AMD Radeon™ R9 380/380X/390/390X Graphics
  # AMD Radeon™ R9 285/290/290X Graphics
  # AMD Radeon™ R9 360 Graphics

  amdgpu-uninstall -y

  echo ""
  echo "  Quitando arquitectura i386"
  echo ""
  dpkg --remove-architecture i386
  apt-get -y update

  apt-get -y install wget
  mkdir -p /root/paquetes/amdgpu-pro
  rm -rf /root/paquetes/amdgpu-pro/*
  wget --referer https://www.amd.com/es/support $URL$Archivo -O /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz
  tar -xvf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz -C  /root/paquetes/amdgpu-pro/
  rm -rf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz

  echo ""
  echo "  Agregando arquitectura i386"
  echo ""
  dpkg --add-architecture i386
  apt-get -y update

  echo ""
  echo "  Listo para instalar..."
echo ""

  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms-firmware_5.6.5.24-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-core_20.30-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms_5.6.5.24-1109583_all.deb

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 11 (Bullseye)..."
  echo ""

  vURL="http://drivers.amd.com/drivers/linux/"
  vArchivo="amdgpu-pro-20.50-1234664-ubuntu-20.04.tar.xz"
  amdgpu-uninstall -y

  echo ""
  echo "  Quitando arquitectura i386"
  echo ""
  dpkg --remove-architecture i386
  apt-get -y update

  apt-get -y install wget
  mkdir -p /root/paquetes/amdgpu-pro
  rm -rf /root/paquetes/amdgpu-pro/*
  wget --referer https://www.amd.com/es/support $vURL$vArchivo -O /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz
  tar -xvf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz -C  /root/paquetes/amdgpu-pro/
  rm -rf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz


  echo ""
  echo "  Agregando arquitectura i386"
  echo ""
  dpkg --add-architecture i386
  apt-get -y update

  echo ""
  echo "  Listo para instalar..."
  echo ""

  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms-firmware_5.6.5.24-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-core_20.30-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms_5.6.5.24-1109583_all.deb

  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-dkms-firmware_5.9.10.69-1234664_all.deb
  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-core_20.50-1234664_all.deb
  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-dkms_5.9.10.69-1234664_all.deb

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de instalación del controlador AMDGPU-Pro para Debian 12 (Bookworm)..."
  echo ""
  apt update
  mkdir -p /root/Controladores/AMDGPUPro
  vURLArchivo="https://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/focal/amdgpu-install_6.0.60003-1_all.deb"
  vURLArchivo="https://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/jammy/amdgpu-install_6.0.60003-1_all.deb"
  wget $vURLArchivo -O /root/Controladores/AMDGPUPro/AMDGPUPro.deb
  apt install /root/Controladores/AMDGPUPro/AMDGPUPro.deb
  amdgpu-install -y --usecase=graphics,rocm
  usermod -a -G render,video nipegun





ttps://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/jammy/amdgpu-install_6.0.60002-1_all.deb
# Instalar ROCm
apt-get -y install librocm-smi-dev
apt-get -y install librocm-smi64-1
apt-get -y install rocm-cmake
apt-get -y install rocm-device-libs
apt-get -y install rocm-smi
apt-get -y install rocminfo
apt-get -y install libamd-comgr2
apt-get -y install librocsparse0
apt-get -y install libspfft1 



  
  amdgpu-uninstall -y

  echo ""
  echo "  Quitando arquitectura i386"
  echo ""
  dpkg --remove-architecture i386
  apt-get -y update

  #apt-get -y install wget
  #mkdir -p /root/paquetes/amdgpu-pro
  #rm -rf /root/paquetes/amdgpu-pro/*
  #wget --referer https://www.amd.com/es/support $vURL$vArchivo -O /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz
  #tar -xvf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz -C  /root/paquetes/amdgpu-pro/
  #rm -rf /root/paquetes/amdgpu-pro/amdgpu-pro.tar.xz


  echo ""
  echo "  Agregando arquitectura i386"
  echo ""
  dpkg --add-architecture i386
  apt-get -y update

  echo ""
  echo "  Listo para instalar..."
  echo ""

  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms-firmware_5.6.5.24-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-core_20.30-1109583_all.deb
  dpkg -i /root/paquetes/amdgpu-pro/amdgpu-pro-20.30-1109583-ubuntu-20.04/amdgpu-dkms_5.6.5.24-1109583_all.deb

  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-dkms-firmware_5.9.10.69-1234664_all.deb
  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-core_20.50-1234664_all.deb
  apt -y install /root/paquetes/amdgpu-pro/amdgpu-pro-20.50-1234664-ubuntu-20.04/amdgpu-dkms_5.9.10.69-1234664_all.deb
fi

