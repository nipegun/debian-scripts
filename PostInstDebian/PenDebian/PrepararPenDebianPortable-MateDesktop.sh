#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar el Pendrive de Debian Portable con el escritorio Mate
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/PenDebian/PrepararPenDebianPortable-MateDesktop.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

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
  echo "  Iniciando el script de preparación del Pendrive con Debian 7 (Wheezy) Portable..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de preparación del Pendrive con Debian 8 (Jessie) Portable..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de preparación del Pendrive con Debian 9 (Stretch) Portable..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de preparación del Pendrive con Debian 10 (Buster) Portable..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""
  
elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de preparación del Pendrive con Debian 11 (Bullseye) Portable..." 
  echo ""

  echo ""
  echo "  Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "12" ]; then

  echo ""
  echo "  Iniciando el script de preparación del Pendrive con Debian 12 (Bookworm) Portable..." 
  echo ""

  # Poner nomenclatura antigua de nombre de interfaces de red
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/InterfacesDeRed-ViejaNomenclatura.sh | bash

  # Agregar repositorios
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Repositorios-PonerTodos.sh | bash

  # Instalar software
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-InstalarSoftware.sh | bash
  
  # Desinstalar software extra instalado
    apt-get -y autoremove subtitleeditor
    apt-get -y autoremove easytag
    apt-get -y autoremove openshot
    apt-get -y autoremove mumble
    apt-get -y autoremove obs-studio
    apt-get -y autoremove telegram-desktop
    apt-get -y autoremove discord
    apt-get -y autoremove scid
    apt-get -y autoremove scid-rating-data
    apt-get -y autoremove scid-spell-data
    apt-get -y autoremove stockfish
    apt-get -y autoremove dosbox
    apt-get -y autoremove scummvm

  # Herramientas para manejar volúmenes
    # FAT
      apt-get -y install dosfstools
      apt-get -y install mtools
    # EXT2/3/4
      apt-get -y install e2fsprogs
      apt-get -y install e2fsprogs-l10n
    # LVM
      apt-get -y install lvm2
    # BTRFS
      apt-get -y install btrfs-progs
      apt-get -y install btrfs-tools
    # RAID
      apt-get -y install mdadm
      apt-get -y install dmraid
    # ZFS
      apt-get -y install zfsutils-linux
    # F2FS
      apt-get -y install f2fs-tools
    # MTD JFFS JFFS2
      apt-get -y install mtd-utils

  # Firmwares
    apt-get -y install firmware-linux-free
    apt-get -y install firmware-ath9k-htc
    #apt-get -y install firmware-ath9k-htc-dbgsym
    apt-get -y install firmware-b43-installer
    apt-get -y install firmware-b43legacy-installer
    apt-get -y install atmel-firmware
    apt-get -y install bluez-firmware
    apt-get -y install firmware-amd-graphics
    apt-get -y install firmware-atheros
    apt-get -y install firmware-bnx2
    apt-get -y install firmware-bnx2x
    apt-get -y install firmware-brcm80211
    apt-get -y install firmware-cavium
    # apt-get -y install firmware-intelwimax
    #ACCEPT_EULA=Y apt-get -y install firmware-ipw2x00
    apt-get -y install firmware-iwlwifi
    apt-get -y install firmware-linux
    apt-get -y install firmware-linux-nonfree
    apt-get -y install firmware-misc-nonfree
    apt-get -y install firmware-myricom
    apt-get -y install firmware-netronome
    apt-get -y install firmware-netxen
    apt-get -y install firmware-qcom-media
    apt-get -y install firmware-ralink
    apt-get -y install firmware-realtek
    apt-get -y install firmware-ti-connectivity
    apt-get -y install firmware-zd1211

  # Herramientas para listar hardware
    apt-get -y install hwloc # Tiene el comando lstopo

  # Otros cambios
    mkdir -p /Particiones/LVM/G1/            2> /dev/null
    mkdir -p /Particiones/LVM/G2/            2> /dev/null
    mkdir -p /Particiones/LVM/G3/            2> /dev/null
    mkdir -p /Particiones/LVM/G4/            2> /dev/null

  # ComandosPostArranque
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/ComandosPostArranque-Preparar.sh | bash

  # Cortafuegos
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Cortafuegos-Preparar.sh | bash

  # Tareas cron
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/TareasCron-Preparar.sh | bash

  # Agregar automontaje de particiones
    echo '# Automontaje de todas las particiones'               >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo "  /root/scripts/debian-scripts/Particiones-IDE-Montar.sh"  >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo "  /root/scripts/debian-scripts/Particiones-SATA-Montar.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo "  /root/scripts/debian-scripts/Particiones-NVMe-Montar.sh" >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

    echo "# Montar LVM de Proxmox"                                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo '  vgchange --activate y pve'                                 >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo ''                                                            >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo '  mount -t auto /dev/$vLVMg1/root /Particiones/LVM/G1/root/' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
    echo '  mount -t auto /dev/$vLVMg1/root /Particiones/LVM/G1/root/' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  # debian-scripts
    curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/main/DScripts-Sincronizar.sh | bash

  # Permitir caja como root
    mkdir -p /root/.config/autostart/ 2> /dev/null
    echo "[Desktop Entry]"                > /root/.config/autostart/caja.desktop
    echo "Type=Application"              >> /root/.config/autostart/caja.desktop
    echo "Exec=caja --force-desktop"     >> /root/.config/autostart/caja.desktop
    echo "Hidden=false"                  >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-enabled=true" >> /root/.config/autostart/caja.desktop
    echo "Name[es_ES]=Caja"              >> /root/.config/autostart/caja.desktop
    echo "Name=Caja"                     >> /root/.config/autostart/caja.desktop
    echo "Comment[es_ES]="               >> /root/.config/autostart/caja.desktop
    echo "Comment="                      >> /root/.config/autostart/caja.desktop
    echo "X-MATE-Autostart-Delay=0"      >> /root/.config/autostart/caja.desktop
    gio set /root/.config/autostart/caja.desktop "metadata::trusted" yes

  # Documentos

    mkdir -p /root/Documentos/ 2> /dev/null

      # Chameleon desde Grub
        echo "gedit /boot/grub/grub.cfg"         > /root/DocumentostalarSoftware.sh/BootearChameleonDesdeGrub.txt
        echo ""                                 >> /root/Documentos/BootearChameleonDesdeGrub.txt
        echo 'menuentry "macOS" {'              >> /root/Documentos/BootearChameleonDesdeGrub.txt
        echo "  insmod hfsplus"                 >> /root/Documentos/BootearChameleonDesdeGrub.txt
        echo "  search --file --set=root /boot" >> /root/Documentos/BootearChameleonDesdeGrub.txt
        echo "  multiboot /boot"                >> /root/Documentos/BootearChameleonDesdeGrub.txt
        echo "}"                                >> /root/Documentos/BootearChameleonDesdeGrub.txt

      # Actualizar ClamTK
        echo '#!/bin/bash' > /root/Documentos/ActualizarClamAV.txt
        echo "freshclam"  >> /root/Documentos/ActualizarClamAV.txt

      # Borrar SSD
        echo '#!/bin/bash'                                                              > /root/Documentos/BorrarSSD.txt
        echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
        echo "# Cerrar la tapa del portátil (para hibernar Linux) y volver a abrirla." >> /root/Documentos/BorrarSSD.txt
        echo "# Cuando rearranque ejecutar"                                            >> /root/Documentos/BorrarSSD.txt
        echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
        echo "hdparm -I /dev/sda | grep frozen"                                        >> /root/Documentos/BorrarSSD.txt
        echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
        echo "# BORRAR /dev/sda"                                                       >> /root/Documentos/BorrarSSD.txt
        echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sda"         >> /root/Documentos/BorrarSSD.txt
        echo "hdparm --user-master u --security-erase hacks4geeks /dev/sda"            >> /root/Documentos/BorrarSSD.txt
        echo ""                                                                        >> /root/Documentos/BorrarSSD.txt
        echo "# BORRAR /dev/sdb"                                                       >> /root/Documentos/BorrarSSD.txt
        echo "hdparm --user-master u --security-set-pass hacks4geeks /dev/sdb"         >> /root/Documentos/BorrarSSD.txt
        echo "hdparm --user-master u --security-erase hacks4geeks /dev/sdb"            >> /root/Documentos/BorrarSSD.txt

  # Actualizar el sistema
    apt-get -y upgrade
    apt-get -y dist-upgrade

  # Personalizar escritorio mate
    curl -sLhttps://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/EscritorioMate-Personalizar.sh| bash

  # Agregar el usuario a sudo
    echo "usuariox ALL=(ALL:ALL) ALL" >> /etc/sudoers

fi
