#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar y purgar sudo de un sistema Debian
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/sudo-DesinstalarYPurgar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/sudo-DesinstalarYPurgar.sh | nano -
#
# NOTAS:
#   Loguearse como root para ejecutar este script
# ----------

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Desinstalar
  apt-get -y autoremove --purge sudo

# Limpiar
  apt-get -y autoclean

# Borrar carpetas restantes manualemnte
  rm -rfv /etc/sudoers.d/

# Corregir polkit para el entorno gráfico
  #mkdir -p /etc/polkit-1/rules.d/
  #echo 'polkit.addRule(function(action, subject) {return polkit.Result.AUTH_ADMIN;});' | tee /etc/polkit-1/rules.d/01-usar-root.rules
  #systemctl restart polkit

