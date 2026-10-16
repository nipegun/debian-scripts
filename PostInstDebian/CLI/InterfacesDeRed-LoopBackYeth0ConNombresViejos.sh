#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para re-escribir /etc/network/interfaceds con los nombres antiguos de las interfaces de red
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/InterfacesDeRed-LoopBackYeth0ConNombresViejos.sh
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

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para configurar loopback y eth0 por por DHCP...${cFinColor}"
  echo ""

# Modificar /etc/network/interfaces
  echo ""
  echo "    Modificando /etc/network/interfaces..." 
  echo ""
  echo "auto lo"                   > /etc/network/interfaces
  echo "  iface lo inet loopback" >> /etc/network/interfaces
  echo ""                         >> /etc/network/interfaces
  echo "auto eth0"                >> /etc/network/interfaces
  echo "  allow-hotplug eth0"     >> /etc/network/interfaces
  echo "  iface eth0 inet dhcp"   >> /etc/network/interfaces
  echo ""                         >> /etc/network/interfaces

