#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar el cortafuegos
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Cortafuegos-Preparar.sh | bash
# ----------

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 13 (x)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 13 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                         > /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE NFTABLES A EJECUTAR AL ARRANQUE"   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  chmod 700                                                                                    /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "/root/scripts/ParaEsteDebian/ComandosNFTables.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                         > /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE NFTABLES A EJECUTAR AL ARRANQUE"   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  chmod 700                                                                                    /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "/root/scripts/ParaEsteDebian/ComandosNFTables.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 10 (Buster)...${cFinColor}"
  echo ""

  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                         > /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE NFTABLES A EJECUTAR AL ARRANQUE"   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  chmod 700                                                                                    /root/scripts/ParaEsteDebian/ComandosNFTables.sh
  echo "/root/scripts/ParaEsteDebian/ComandosNFTables.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 9 (Stretch)...${cFinColor}"
  echo ""

  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                         > /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  echo "#  ESCRIBE ABAJO, UNO POR LÍNEA, LOS COMANDOS DE IPTABLES A EJECUTAR AL ARRANQUE"   >> /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼" >> /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  echo ""                                                                                   >> /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  chmod 700                                                                                    /root/scripts/ParaEsteDebian/ComandosIPTables.sh
  echo "/root/scripts/ParaEsteDebian/ComandosIPTables.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar el cortafuegos de Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

