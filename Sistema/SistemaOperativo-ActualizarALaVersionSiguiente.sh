#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian a la versión inmediatamente posterior
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/master/Sistema/SistemaOperativo-ActualizarALaVersionSiguiente.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
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
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 13 (Trixie) a Debian 14 (x)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 12 (Bookworm) a Debian 13 (Trixie)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb12
    echo 'deb     http://deb.debian.org/debian trixie main contrib non-free non-free-firmware'                        | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://deb.debian.org/debian trixie main contrib non-free non-free-firmware'                        | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                                           | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware'                | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware'                | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                                           | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 11 (Bullseye) a Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb11
    echo 'deb     http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware'                        | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware'                        | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                                             | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware'                | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware'                | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                                             | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 10 (Buster) a Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb10
    echo 'deb     http://archive.debian.org/debian bullseye main contrib non-free'                   | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian bullseye main contrib non-free'                   | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                          | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://archive.debian.org/debian bullseye-updates main contrib non-free'           | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian bullseye-updates main contrib non-free'           | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                          | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-bullseye stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-bullseye stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 9 (Stretch) a Debian 10 (Buster)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb9
    echo 'deb     http://archive.debian.org/debian buster main contrib non-free'                   | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian buster main contrib non-free'                   | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                        | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://archive.debian.org/debian buster-updates main contrib non-free'           | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian buster-updates main contrib non-free'           | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                        | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-buster stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-buster stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 8 (Jessie) a Debian 9 (Stretch)..${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb8
    echo 'deb     http://archive.debian.org/debian stretch main contrib non-free'                    | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian stretch main contrib non-free'                    | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                          | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://archive.debian.org/debian stretch-updates main contrib non-free'            | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian stretch-updates main contrib non-free'            | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                          | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-security stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-security stretch-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script para actualizar Debian 7 (Wheezy) a Debian 8 (Jessie)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo dpkg -C
    sudo apt-mark showhold
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.deb7
    echo 'deb     http://archive.debian.org/debian jessie main contrib non-free'                    | sudo tee    /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian jessie main contrib non-free'                    | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                         | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://archive.debian.org/debian jessie-updates main contrib non-free'            | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://archive.debian.org/debian jessie-updates main contrib non-free'            | sudo tee -a /etc/apt/sources.list
    echo ''                                                                                         | sudo tee -a /etc/apt/sources.list
    echo 'deb     http://security.debian.org/debian-security jessie-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    echo 'deb-src http://security.debian.org/debian-security jessie-security main contrib non-free' | sudo tee -a /etc/apt/sources.list
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    # Fase 2
      sudo apt-get -y autoremove
      sudo apt-get -y autoclean
      sudo shutdown -r now

  fi

