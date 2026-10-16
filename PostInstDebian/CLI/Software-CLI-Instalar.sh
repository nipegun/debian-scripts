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
  sed -i -e 's|# set linenumbers|set linenumbers|g' /etc/nanorc

# Instalar Midnight Commander
  sudo apt-get -y install mc

# Permitir que el sistema sin NetworkManager pueda pedir configuración por DHCP
  sudo apt-get -y install isc-dhcp-client

# Instalar shellcheck
  sudo apt-get -y install shellcheck

# jp2a (Pasar visualizar imagenes en código ascii
  sudo apt-get -y install jp2a
  # Uso:
  #   Para ver en terminal:
  #     jp2a --color ~/Descargas/Imagen.jpg
  #   Para exportar a un archivo:
  #     jp2a --width=200 ~/Descargas/Imagen.jpg > Archivo.txt

# Servidor SSH
  sudo apt-get -y install openssh-server

# Otras
  sudo apt-get -y install sshpass
  sudo apt-get -y install whois

  sudo apt-get -y install grub2
  sudo apt-get -y install wget
  sudo apt-get -y install curl
  sudo apt-get -y install nmap
  sudo apt-get -y install smartmontools
  sudo apt-get -y install coreutils
  sudo apt-get -y install unrar
  sudo apt-get -y install usbutils
  sudo apt-get -y install htop
