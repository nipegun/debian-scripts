#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar los comandos post-arranque (antiguo rc.local)
#
# Ejecución remota:
#   curl -sLhttps://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/ComandosPostArranque-Preparar.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 13 (Trixie)...${cFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                  | sudo tee    /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" | sudo tee -a /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       | sudo tee -a /etc/systemd/system/rc-local.service
  echo ""                                        | sudo tee -a /etc/systemd/system/rc-local.service
  echo "[Service]"                               | sudo tee -a /etc/systemd/system/rc-local.service
  echo "Type=forking"                            | sudo tee -a /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           | sudo tee -a /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            | sudo tee -a /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      | sudo tee -a /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     | sudo tee -a /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    | sudo tee -a /etc/systemd/system/rc-local.service
  echo ""                                        | sudo tee -a /etc/systemd/system/rc-local.service
  echo "[Install]"                               | sudo tee -a /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              | sudo tee -a /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local ..."
  echo ""
  echo '#!/bin/bash'                                          | sudo tee    /etc/rc.local
  echo ""                                                     | sudo tee -a /etc/rc.local
  echo "/root/scripts/ParaEsteDebian/ComandosPostArranque.sh" | sudo tee -a /etc/rc.local
  echo "exit 0"                                               | sudo tee -a /etc/rc.local
  sudo chmod +x                                                             /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                         | sudo tee    /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                  | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    | sudo tee -a /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  sudo chmod 700                                                                                                           /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  sudo systemctl enable rc-local
  sudo systemctl start rc-local.service

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local ..."
  echo ""
  echo '#!/bin/bash'                                           > /etc/rc.local
  echo ""                                                     >> /etc/rc.local
  echo "/root/scripts/ParaEsteDebian/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                               >> /etc/rc.local
  chmod +x                                                       /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                  >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  chmod 700                                                                                                     /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local..."
  echo ""
  echo '#!/bin/bash'                                            > /etc/rc.local
  echo ""                                                     >> /etc/rc.local
  echo "/root/scripts/ParaEsteDebian/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                               >> /etc/rc.local
  chmod +x                                                       /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  chmod 700                                                                                                     /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local ..."
  echo ""
  echo '#!/bin/bash'                                           > /etc/rc.local
  echo ""                                                     >> /etc/rc.local
  echo "/root/scripts/ParaEsteDebian/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                               >> /etc/rc.local
  chmod +x                                                       /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  chmod 700                                                                                                     /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo "    Configurando el servicio..."
  echo ""
  echo "[Unit]"                                   > /etc/systemd/system/rc-local.service
  echo "Description=/etc/rc.local Compatibility" >> /etc/systemd/system/rc-local.service
  echo "ConditionPathExists=/etc/rc.local"       >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Service]"                               >> /etc/systemd/system/rc-local.service
  echo "Type=forking"                            >> /etc/systemd/system/rc-local.service
  echo "ExecStart=/etc/rc.local start"           >> /etc/systemd/system/rc-local.service
  echo "TimeoutSec=0"                            >> /etc/systemd/system/rc-local.service
  echo "StandardOutput=tty"                      >> /etc/systemd/system/rc-local.service
  echo "RemainAfterExit=yes"                     >> /etc/systemd/system/rc-local.service
  echo "SysVStartPriority=99"                    >> /etc/systemd/system/rc-local.service
  echo ""                                        >> /etc/systemd/system/rc-local.service
  echo "[Install]"                               >> /etc/systemd/system/rc-local.service
  echo "WantedBy=multi-user.target"              >> /etc/systemd/system/rc-local.service

  echo ""
  echo "    Creando el archivo /etc/rc.local..."
  echo ""
  echo '#!/bin/bash'                                           > /etc/rc.local
  echo ""                                                     >> /etc/rc.local
  echo "/root/scripts/ParaEsteDebian/ComandosPostArranque.sh" >> /etc/rc.local
  echo "exit 0"                                               >> /etc/rc.local
  chmod +x                                                       /etc/rc.local

  echo ""
  echo "    Creando el archivo para meter los comandos..."
  echo ""
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                          > /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'vFechaDeEjec=$(date +A%YM%mD%d@%T)'                                                                  >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo 'echo "Iniciada la ejecución del script post-arranque el $vFechaDeEjec" >> /var/log/PostArranque.log' >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR DESPUÉS DE CADA ARRANQUE"                     >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"                   >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  echo ""                                                                                                    >> /root/scripts/ParaEsteDebian/ComandosPostArranque.sh
  chmod 700                                                                                                     /root/scripts/ParaEsteDebian/ComandosPostArranque.sh

  echo ""
  echo "    Activando y arrancando el servicio..."
  echo ""
  systemctl enable rc-local
  systemctl start rc-local.service

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script para preparar los comandos post-arranque en Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

