#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar los controladores de las tarjetas inalámbricas Broadcom BCM4360 en Debian
#   Ejemplos:
#     - PCIe Fenvi T919 (Hackintosh)
#     - etc
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/WiFi-Broadcom-BCM4360.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/WiFi-Broadcom-BCM4360.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL x | bash -s Parámetro1 Parámetro2
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Actualizar la lista de paquetes disponibles en los repositorios activados..."
  echo ""
  echo "  Actualizando la lista de paquetes disponibles en los repositorios activados..."
  echo ""
  apt-get -y update

# Instalar el -ultimo kernel
  echo ""
  echo "  Instalando el último kernel..."
  echo ""
  apt-get -y install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,')

# Instalar las cabeceras del último kernel
  echo ""
  echo "  Instalando las cabeceras del último kernel..."
  echo ""
  apt-get -y install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')

# Instalar el paquete broadcom-sta-dkms
  echo ""
  echo "  Instalando el paquete broadcom-sta-dkms..."
  echo ""
  apt-get -y install broadcom-sta-dkms

# Notificar fin de ejecución del script
  echo ""
  echo "  Para desinstalar el controlador ejecuta:"
  echo ""
  echo "    apt-get -y autoremove broadcom-sta-dkms"
  echo "    apt-get -y purge broadcom-sta-dkms"
  echo "    update-initramfs -u -k all"
  echo ""

