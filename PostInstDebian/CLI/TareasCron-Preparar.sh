#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparar las tareas cron en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/TareasCron-Preparar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/TareasCron-Preparar.sh | sed 's-sudo--g' | bash
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

# Notificar inicio de ejecución del script
  echo ''
  echo -e "${cColorAzulClaro}  Iniciando script para preparar las tareas cron...${cFinColor}"
  echo ''

# Preparar el script de tareas cada minuto
  echo ''
  echo "    Creando el archivo para las tareas de cada minuto..." 
  echo ''
  sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo 'echo "Iniciada la ejecución del cron de cada minuto el $vFechaDeEjec" >> /var/log/TareasCronCadaMinuto.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MINUTO'                                         | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  sudo crontab -l > /tmp/CronTemporal
  echo "* * * * * /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh" | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Preparar el script de tareas cada hora
  echo ''
  echo "    Creando el archivo para las tareas de cada hora..." 
  echo ''
  sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                            | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ''                                                                                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora el $vFechaDeEjec" >> /var/log/TareasCronCadaHora.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ''                                                                                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA'                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  echo ''                                                                                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  sudo ln -s /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh /etc/cron.hourly/TareasCronCadaHora

# Preparar el script de tareas cada hora impar
  echo ''
  echo "    Creando el archivo para las tareas de cada hora impar..." 
  echo ''
  sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                       | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ''                                                                                                                  | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                                | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora impar el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraImpar.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ''                                                                                                                  | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA IMPAR'                                            | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                          | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  echo ''                                                                                                                  | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  sudo crontab -l > /tmp/CronTemporal
  echo "0 1-23/2 * * * /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh" | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Preparar el script de tareas cada hora par
  echo ''
  echo "    Creando el archivo para las tareas de cada hora par..." 
  echo ''
  sudo mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                                   | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ''                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                            | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo 'echo "Iniciada la ejecución del cron de cada hora par el $vFechaDeEjec" >> /var/log/TareasCronCadaHoraPar.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ''                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA HORA PAR'                                          | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                        | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  echo ''                                                                                                              | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  sudo crontab -l > /tmp/CronTemporal
  echo "0 */2 * * * /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh" | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Preparar el script de tareas cada día
  echo ''
  echo "    Creando el archivo para las tareas de cada día..." 
  echo ''
  echo '#!/bin/bash'                                                                                          | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo 'echo "Iniciada la ejecución del cron de cada día el $vFechaDeEjec" >> /var/log/TareasCronCadaDía.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA DÍA'                                      | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                    | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  sudo crontab -l > /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaDía.sh/d' /tmp/CronTemporal
  echo '50 23 * * * /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh' | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Preparar el script de tareas cada semana
  echo ''
  echo "    Creando el archivo para las tareas de cada semana..." 
  echo ''
  echo '#!/bin/bash'                                                                                                | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                         | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo 'echo "Iniciada la ejecución del cron de cada semana el $vFechaDeEjec" >> /var/log/TareasCronCadaSemana.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA SEMANA'                                         | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                       | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  echo ''                                                                                                           | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  sudo crontab -l > /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaSemana.sh/d' /tmp/CronTemporal
  echo '40 23 * * 0 /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh' | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Preparar el script de tareas cada mes
  echo ''
  echo "    Creando el archivo para las tareas de cada mes..." 
  echo ''
  echo '#!/bin/bash'                                                                                          | sudo tee    /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo 'vFechaDeEjec=$(date +a%Ym%md%d@%T)'                                                                   | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo 'echo "Iniciada la ejecución del cron de cada mes el $vFechaDeEjec" >> /var/log/TareasCronCadaMes.log' | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo '#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS A EJECUTAR CADA MES'                                      | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo '#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼'                                    | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  echo ''                                                                                                     | sudo tee -a /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  sudo chmod +x /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh
  sudo crontab -l > /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaMes.sh/d' /tmp/CronTemporal
  echo '30 23 28-31 * * [ "$(date -d tomorrow +\%d)" = "01" ] && /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh' | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal

# Dar permisos de lectura y ejecución sólo al propietario de los scripts
  echo ''
  echo "  Dando permisos de lectura y ejecución solo al propietario de los scripts..." 
  echo ''
  # Si esto no se hace las tareas no se ejecutarán.
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaMinuto.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHora.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHoraImpar.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaHoraPar.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh
  sudo chmod 700 /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh

exit

# Arreglar anteriores ejecuciones con sudo
  sudo rm -f /etc/cron.daily/TareasCronCadaDía
  sudo rm -f /etc/cron.weekly/TareasCronCadaSemana
  sudo rm -f /etc/cron.monthly/TareasCronCadaMes
  sudo crontab -l > /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaDía.sh/d' /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaSemana.sh/d' /tmp/CronTemporal
  sudo sed -i '/TareasCronCadaMes.sh/d' /tmp/CronTemporal
  echo '50 23 * * * /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh'                                              | sudo tee -a /tmp/CronTemporal
  echo '40 23 * * 0 /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh'                                           | sudo tee -a /tmp/CronTemporal
  echo '30 23 28-31 * * [ "$(date -d tomorrow +\%d)" = "01" ] && /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh' | sudo tee -a /tmp/CronTemporal
  sudo crontab /tmp/CronTemporal
  sudo rm /tmp/CronTemporal
# Arreglar anteriores ejecuciones sin sudo
  rm -f /etc/cron.daily/TareasCronCadaDía
  rm -f /etc/cron.weekly/TareasCronCadaSemana
  rm -f /etc/cron.monthly/TareasCronCadaMes
  crontab -l > /tmp/CronTemporal
  sed -i '/TareasCronCadaDía.sh/d' /tmp/CronTemporal
  sed -i '/TareasCronCadaSemana.sh/d' /tmp/CronTemporal
  sed -i '/TareasCronCadaMes.sh/d' /tmp/CronTemporal
  echo '50 23 * * * /root/scripts/ParaEsteDebian/TareasCronCadaDía.sh'                                              | tee -a /tmp/CronTemporal
  echo '40 23 * * 0 /root/scripts/ParaEsteDebian/TareasCronCadaSemana.sh'                                           | tee -a /tmp/CronTemporal
  echo '30 23 28-31 * * [ "$(date -d tomorrow +\%d)" = "01" ] && /root/scripts/ParaEsteDebian/TareasCronCadaMes.sh' | tee -a /tmp/CronTemporal
  crontab /tmp/CronTemporal
  rm /tmp/CronTemporal
