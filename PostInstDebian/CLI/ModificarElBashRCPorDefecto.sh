#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar Debian sin entorno gráfico a gusto de NiPeGun
#
# Ejecución remota (puede requerir privilegios sudo):
#   curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/ModificarElBashRCPorDefecto.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/ModificarElBashRCPorDefecto.sh | sed 's-sudo--g' | bash
# ----------

echo ""
echo "  Iniciando el script de modificación de .bashrc..."
echo ""
  # /root/.bashrc
    curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/.bashrc | sudo tee /root/.bashrc
    echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' | sudo tee -a /root/.bashrc
    #sudo su root -c "echo 'export PATH=$PATH' | sudo tee -a /root/.bashrc"
    echo "" | sudo tee -a /root/.bashrc
  # Plantilla de skel
    curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/.bashrc | sudo tee /etc/skel/.bashrc
  # 50 primeros usuarios
    for vIDdeUsuario in {1000..1050}; do
      vNombreDelUsuario=$(getent passwd $vIDdeUsuario | cut -d: -f1)
      if [ -f /home/"$vNombreDelUsuario"/.bashrc ]; then
        echo -e "\n  Modificando /home/"$vNombreDelUsuario"/.bashrc ...\n"
        curl -sLk https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/.bashrc | sudo tee /home/"$vNombreDelUsuario"/.bashrc 2> /dev/null
        echo 'export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games' | sudo tee -a /home/"$vNombreDelUsuario"/.bashrc 2> /dev/null
        sudo chown "$vNombreDelUsuario":"$vNombreDelUsuario" /home/"$vNombreDelUsuario"/.bashrc
      fi
    done
