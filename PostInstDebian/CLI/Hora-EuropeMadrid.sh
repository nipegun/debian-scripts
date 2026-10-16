#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para poner la hora de Europe/Madrid en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Hora-EuropeMadrid.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Hora-EuropeMadrid.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Hora-EuropeMadrid.sh | nano -
# ----------

set -e

vZonaHoraria="Europe/Madrid"

if [ "$(id -u)" -ne 0 ]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

echo "Configurando zona horaria: ${vZonaHoraria}"

if command -v timedatectl >/dev/null 2>&1; then
  timedatectl set-timezone "${vZonaHoraria}"
else
  ln -snf "/usr/share/zoneinfo/${vZonaHoraria}" /etc/localtime
  echo "${vZonaHoraria}" > /etc/timezone
fi

if systemd-detect-virt -q --container 2>/dev/null; then
  echo "Detectado contenedor LXC: se omite NTP porque el reloj lo controla el host."
else
  echo "Activando sincronización NTP"

  if timedatectl set-ntp true 2>/dev/null; then
    echo "NTP activado correctamente."
  else
    echo "NTP no soportado por timedatectl en este sistema."
  fi

  if systemctl list-unit-files systemd-timesyncd.service >/dev/null 2>&1; then
    systemctl restart systemd-timesyncd.service || true
  fi

  if command -v chronyc >/dev/null 2>&1; then
    chronyc -a makestep || true
  fi

  if command -v ntpdig >/dev/null 2>&1; then
    ntpdig -S 0.debian.pool.ntp.org || true
  fi
fi

echo
timedatectl || true
echo
date

