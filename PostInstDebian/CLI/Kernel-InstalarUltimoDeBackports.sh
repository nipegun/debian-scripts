#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el último kernel disponible en backports
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/main/PostInst/CLI/Kernel-InstalarUltimoDeBackports.sh | bash
# ----------

RepoActual="bullseye"

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

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

if [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del último kernel disponible en backports para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del último kernel disponible en backports para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del último kernel disponible en backports para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del último kernel disponible en backports para Debian 10 (Buster)...${cFinColor}"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación del último kernel disponible en backports para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  apt-get -y install -t $RepoActual-backports linux-image-amd64
  apt-get -y install -t $RepoActual-backports linux-headers-amd64

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script ... Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

