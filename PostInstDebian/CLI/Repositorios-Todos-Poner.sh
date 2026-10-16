#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner todos los repos en Debian
#
# Ejecución remota (puede requeerir permisos sudo):
#   curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Repositorios-Todos-Poner.sh | sudo bash
#
# Ejecución remota como root:
#   curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Repositorios-Todos-Poner.sh | sed 's-sudo--g' | bash
#
# Ejecución remota como root:
#   curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Repositorios-Todos-Poner.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 13 (x)...${cFinColor}"
  echo ""

  # Forma antigua
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak.ori
    #echo "deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware"                        | sudo tee    /etc/apt/sources.list
    #echo "deb-src http://deb.debian.org/debian trixie main contrib non-free non-free-firmware"                    | sudo tee -a /etc/apt/sources.list
    #echo ""                                                                                                       | sudo tee -a /etc/apt/sources.list
    #echo "deb http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware"                | sudo tee -a /etc/apt/sources.list
    #echo "deb-src http://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware"            | sudo tee -a /etc/apt/sources.list
    #echo ""                                                                                                       | sudo tee -a /etc/apt/sources.list
    #echo "deb http://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware"     | sudo tee -a /etc/apt/sources.list
    #echo "deb-src http://deb.debian.org/debian-security/ trixie-security main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
    #echo ""                                                                                                       | sudo tee -a /etc/apt/sources.list
    #echo "deb http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware"              | sudo tee -a /etc/apt/sources.list
    #echo "deb-src http://deb.debian.org/debian trixie-backports main contrib non-free non-free-firmware"          | sudo tee -a /etc/apt/sources.list
    #echo ""                                                                                                       | sudo tee -a /etc/apt/sources.list

  # Forma moderna
    sudo mv /etc/apt/sources.list.d/0000debian.sources /etc/apt/sources.list.d/000debian.sources.bak.ori
    echo 'Types: deb deb-src'                                        | sudo tee    /etc/apt/sources.list.d/debian.sources
    echo 'URIs: http://deb.debian.org/debian/'                       | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Suites: trixie'                                            | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Components: main contrib non-free non-free-firmware'       | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo ''                                                          | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Types: deb deb-src'                                        | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'URIs: http://deb.debian.org/debian/'                       | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Suites: trixie-updates'                                    | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Components: main contrib non-free non-free-firmware'       | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo ''                                                          | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Types: deb deb-src'                                        | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'URIs: http://deb.debian.org/debian-security/'              | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Suites: trixie-security'                                   | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Components: main contrib non-free non-free-firmware'       | sudo tee -a /etc/apt/sources.list.d/debian.sources
    echo 'Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg' | sudo tee -a /etc/apt/sources.list.d/debian.sources

  # Actualizar la lista de paquetes disponibles en los nuevos repositorios
    sudo apt-get -y update

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://ftp.es.debian.org/debian bookworm main contrib non-free non-free-firmware"                         | sudo tee    /etc/apt/sources.list
  echo "deb-src http://ftp.es.debian.org/debian bookworm main contrib non-free non-free-firmware"                     | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                                             | sudo tee -a /etc/apt/sources.list
  echo "deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware"     | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                                             | sudo tee -a /etc/apt/sources.list
  echo "deb http://ftp.es.debian.org/debian bookworm-updates main contrib non-free non-free-firmware"                 | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://ftp.es.debian.org/debian bookworm-updates main contrib non-free non-free-firmware"             | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                                             | sudo tee -a /etc/apt/sources.list

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://deb.debian.org/debian bullseye main contrib non-free"                        | sudo tee    /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free"                    | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                       | sudo tee -a /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free"     | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                       | sudo tee -a /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free"                | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free"            | sudo tee -a /etc/apt/sources.list
  echo ""                                                                                       | sudo tee -a /etc/apt/sources.list

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 10 (Buster)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://deb.debian.org/debian/ buster main contrib non-free"             | sudo tee    /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian/ buster main contrib non-free"         | sudo tee -a /etc/apt/sources.list
  echo ""                                                                           | sudo tee -a /etc/apt/sources.list
  echo "deb http://deb.debian.org/debian/ buster-updates main contrib non-free"     | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://deb.debian.org/debian/ buster-updates main contrib non-free" | sudo tee -a /etc/apt/sources.list
  echo ""                                                                           | sudo tee -a /etc/apt/sources.list
  echo "deb http://security.debian.org/ buster/updates main contrib non-free"       | sudo tee -a /etc/apt/sources.list
  echo "deb-src http://security.debian.org/ buster/updates main contrib non-free"   | sudo tee -a /etc/apt/sources.list
  echo ""                                                                           | sudo tee -a /etc/apt/sources.list

  sudo apt update --allow-releaseinfo-change
  sudo apt-get -y update

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 9 (Stretch)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://archive.debian.org/debian/ stretch main contrib non-free"     | sudo tee    /etc/apt/sources.list
  echo "deb-src http://archive.debian.org/debian/ stretch main contrib non-free" | sudo tee -a /etc/apt/sources.list

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 8 (Jessie)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://archive.debian.org/debian/ jessie main contrib non-free"     | sudo tee    /etc/apt/sources.list
  echo "deb-src http://archive.debian.org/debian/ jessie main contrib non-free" | sudo tee -a /etc/apt/sources.list

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para agregar todos los repos de Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak.ori

  echo "deb http://archive.debian.org/debian/ wheezy main contrib non-free"     | sudo tee    /etc/apt/sources.list
  echo "deb-src http://archive.debian.org/debian/ wheezy main contrib non-free" | sudo tee -a /etc/apt/sources.list

fi

