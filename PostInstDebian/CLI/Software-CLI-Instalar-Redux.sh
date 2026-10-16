#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar software para modo CLI en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Software-CLI-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Software-CLI-Instalar.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Notificar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para instalar software para modo CLI en Debian...${cFinColor}"
  echo ""

# Actualizar lista de paquetes disponibles en los repositorios
  sudo apt-get -y update

# Instalar nano
  sudo apt-get -y install nano

# Instalar Midnight Commander
  sudo apt-get -y install mc

# Permitir que el sistema sin NetworkManager pueda pedir configuración por DHCP
  sudo apt-get -y install isc-dhcp-client

# Servidor SSH
  sudo apt-get -y install openssh-server

# Otras
  sudo apt-get -y install curl
