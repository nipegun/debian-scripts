#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar controladores de mandos de juegos en Debian
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Mandos-Instalar.sh | bash
# ----------

cColorVerde="\033[1;32m"
cFinColor="\033[0m"

apt-get -y update 2> /dev/null
apt-get -y install dialog 2> /dev/null

menu=(dialog --timeout 5 --checklist "Elección del mando a instalar:" 22 76 16)
  opciones=(
  1 "XBox One USB Wireless Adapter" off
            2 "2" off
            3 "3" off
            4 "4" off
)
  choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

  for choice in $choices
    do
      case $choice in

        1)
          echo ""
          echo -e "${cColorVerde}  Instalando controladores para el adaptador USB de los mandos de la XBox One...${cFinColor}"
          echo ""
          mkdir /root/Controladores/
          cd /root/Controladores/
          apt-get -y install git cabextract
          git clone https://github.com/medusalix/xow
          mv /root/Controladores/xow/ /root/Controladores/XBoxOneWirelessAdapter/
          /root/Controladores/XBoxOneWirelessAdapter/
          cd /root/Controladores/XBoxOneWirelessAdapter/
          make BUILD=RELEASE
          make install
          systemctl enable xow
          systemctl start xow
        ;;

        2)
        ;;

        3)
        ;;

        4)
        ;;

      esac

done

    
