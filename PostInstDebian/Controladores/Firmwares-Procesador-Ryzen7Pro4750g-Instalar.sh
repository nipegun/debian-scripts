#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar el firmware para el procesador Ryzen 7 Pro 4750G en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Firmwares-Procesador-Ryzen7Pro4750g-Instalar.sh | bash
# ----------

cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ $cVerSO == "7" ]; then

  echo ""
  echo "  Iniciando el script de instalación del firmware para el procesador Ryzen 7 Pro 4750G en Debian 7 (Wheezy)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo "  Iniciando el script de instalación del firmware para el procesador Ryzen 7 Pro 4750G en Debian 8 (Jessie)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo "  Iniciando el script de instalación del firmware para el procesador Ryzen 7 Pro 4750G en Debian 9 (Stretch)..."
  echo ""

  echo ""
  echo "  Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian."
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo "  Iniciando el script de instalación del firmware para el procesador Ryzen 7 Pro 4750G en Debian 10 (Buster)..."
  echo ""

  # Gráficos integrados Vega7
  cd /lib/firmware/amdgpu
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_me.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_pfp.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_ce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/raven_kicker_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_me.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_pfp.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_ce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_me.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_pfp.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_ce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_mec2_wks.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_mec_wks.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_me_wks.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_pfp_wks.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_ce_wks.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_me.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_pfp.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_ce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_sdma1.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_sdma1.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_sdma1.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_uvd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_vce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/vega20_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/raven_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/raven2_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/picasso_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi14_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_me.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_pfp.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_ce.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_sdma1.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_mes.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_smc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi12_dmcu.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/renoir_dmcub.bin

  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_gpu_info.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_ta.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_asd.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_sos.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_rlc.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_mec2.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_mec.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_sdma.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/navi10_mes.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_vcn.bin
  wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/amdgpu/arcturus_smc.bin

  # Possible missing firmware /lib/firmware/amdgpu/navi12_gpu_info.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_gpu_info.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/raven_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/raven2_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/picasso_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_asd.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_sos.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_asd.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_sos.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi14_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi10_ta.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_rlc.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_mec2.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_mec.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_rlc.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_mec2.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_mec.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_me.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_pfp.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_ce.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_sdma.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_sdma1.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_sdma.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi10_mes.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_vcn.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_vcn.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_smc.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/arcturus_smc.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/navi12_dmcu.bin for module amdgpu
  # Possible missing firmware /lib/firmware/amdgpu/renoir_dmcub.bin for module amdgpu

  apt-get install firmware-linux
  apt-get install firmware-linux-free
  apt-get install firmware-linux-nonfree

  update-initramfs -u

elif [ $cVerSO == "11" ]; then

  echo ""
  echo "  Iniciando el script de instalación del firmware para el procesador Ryzen 7 Pro 4750G en Debian 11 (Bullseye)..."
  echo ""

  echo ""
  echo "  No hace falta instalar firmware. Debian 11 ya viene preparado para el Ryzen 7 Pro 4750G"
  echo ""

fi

