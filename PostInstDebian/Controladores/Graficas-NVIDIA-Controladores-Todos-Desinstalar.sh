#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para desinstalar todos los controladores de NVIDIA de Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Todos-Desinstalar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-Desinstalar.sh | bash
# ----------

# Crear archivo con lista de paquetes a desinstalador
  apt-cache search nvidia  | grep nvidia  | sort | cut -d' ' -f1 | sed 's- --g'    > /tmp/PaquetesADesinstalar.txt.sh
  apt-cache search cuda    | grep cuda    | sort | cut -d' ' -f1 | sed 's- --g'   >> /tmp/PaquetesADesinstalar.txt.sh
  apt-cache search nouveau | grep nouveau | sort | cut -d' ' -f1 | sed 's- --g'   >> /tmp/PaquetesADesinstalar.txt.sh

# Crear script de desinstalación
  # Insertar apt-get -y autoremove al principio de cada línea
    cat /tmp/PaquetesADesinstalar.txt.sh | sed 's|^|apt-get -y autoremove --purge |' > /tmp/DesinstalarControladoresNvidia.sh
  # Insertar el shebang al principio del script
    sed -i '1s|^|#!/bin/bash\n|' /tmp/DesinstalarControladoresNvidia.sh
  # Insertar la línea para autoclean:
    echo "apt-get -y autoclean" >> /tmp/DesinstalarControladoresNvidia.sh
  # Asignar permisos de ejecución al script
    chmod +x /tmp/DesinstalarControladoresNvidia.sh

# Ejecutar script
  sudo /tmp/DesinstalarControladoresNvidia.sh

# Borrar controladores web
  #curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-Desinstalar.sh | bash
  #curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Desinstalar.sh | bash

# Blacklistear nouveau
  echo 'blacklist nouveau' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
  sudo update-initramfs -u -k all

# Borrar carpetas archivos y enlaces que tengan nvidia en su nombre, sin recorrer otros sistemas de archivos
  sudo find / -xdev -depth -type d -iname '*nvidia*' -exec rm -rf -- {} +
  sudo find / -xdev \( -type f -o -type l \) -iname '*nvidia*' -exec rm -f -- {} +

# Borrar carpetas archivos y enlaces que tengan cuda en su nombre, sin recorrer otros sistemas de archivos
  sudo find / -xdev -depth -type d -iname '*cuda*' -exec rm -rf -- {} +
  sudo find / -xdev \( -type f -o -type l \) -iname '*cuda*' -exec rm -f -- {} +

# Reinstalar paquetes cuyos archivos se hayan podido desinstalar
  # Crear la lista de paquetes que tienen archivos faltantes
    sudo dpkg -V 2>&1 \
      | tee "$HOME/Verificacion-DPKG-Completa.txt" \
      | sed -n 's/^missing[[:space:]]\+\(c[[:space:]]\+\)\?//p' \
      | while IFS= read -r vRuta; do
          dpkg-query -S "$vRuta" 2>/dev/null | sed 's/: \/.*$//'
        done \
      | sort -u \
      | tee "$HOME/Paquetes-Dañados-DPKG.txt"
  # Limpiar la lista
    sed 's/,[[:space:]]*/\n/g' "$HOME/Paquetes-Dañados-DPKG.txt" | sed '/^[[:space:]]*$/d' | sort -u > "$HOME/Paquetes-Dañados-DPKG-Limpio.txt"
  # Reinstalar paquetes
    xargs -r sudo apt-get -o Dpkg::Options::="--force-confmiss" install --reinstall -- < "$HOME/Paquetes-Dañados-DPKG-Limpio.txt"
  # Borrar archivos ya no útiles
    rm -f "$HOME/Verificacion-DPKG-Completa.txt"
    rm -f "$HOME/Paquetes-Dañados-DPKG.txt"
    rm -f "$HOME/Paquetes-Dañados-DPKG-Limpio.txt"
  # Re-instalar International Components for Unicode (Obligatorio porque se borran algunos archivos con nombre cuda antes)
    cNomPaquete=$(apt-cache search libicu | grep '\- International Components for Unicode' | cut -d ' ' -f1)
    sudo apt-get -y install --reinstall "$cNomPaquete"
  # cmake-data
    sudo apt-get -y install --reinstall cmake-data

# Notificar fin de ejecución del script
  echo ""
  echo "  Ejecución del script, finalizada."
  echo ""
