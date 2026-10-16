#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear la tarea cron de actualización y reinicio cada lunes a las 05:30 de la mañana
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Tarea-ActualizacionAutomaticaDeDebian-Crear.sh | bash
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
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de creación de la tarea de actualización automática de Debian...${cFinColor}"
  echo ""

# Exportar las tareas cron actuales al CronTemporal 
  crontab -l > /root/CronTemporal

# Cargar la nueva tarea dentro del CronTemporal
  echo "30 05 * * 1 /root/scripts/debian-scripts/Sistema/SistemaOperativo-ActualizarYReiniciar.sh" >> /root/CronTemporal

#      *  * * * * "Comando a ejecutar"
#      -  - - - -
#      |  | | | |
#      |  | | | ----- Día de la semana (0 - 7) (Doming=0, Lunes=1, etc...)
#      |  | | ------- Mes (1 - 12)
#      |  | --------- Día del mes (1 - 31)
#      |  ----------- Hora (0 - 23)
#      -------------- Minuto (0 - 59)

# Instalar los cambios
  crontab /root/CronTemporal

# Borrar el archivo temporal
  rm /root/CronTemporal

# Cada minuto                       * * * * *	
# Cada 1 minuto                     * * * * *	
# Cada 2 minutos                  */2 * * * *	
# En los minutos pares            */2 * * * *	
# En los minutos impares       1-59/2 * * * *	
# Cada 3 minutos                  */3 * * * *	
# Cada 4 minutos                  */4 * * * *	
# Cada 5 minutos                  */5 * * * *	
# Cada 6 minutos                  */6 * * * *	
# Cada 10 minutos                */10 * * * *	
# Cada 15 minutos                */15 * * * *	
# Cada 30 minutos                */30 * * * *

# Cada hora                       0 */1 * * *	
# Cada 2 horas                    0 */2 * * *	
# En horas pares                  0 */2 * * *	
# En horas impares             0 1-23/2 * * *		

# Cada día                          0 0 * * *
# Cada día a la 1                   0 1 * * *
# Cada día a las 8                  0 8 * * *

# Cada Domingo                      0 0 * * 0
# Cada Lunes                        0 0 * * 1
# Cada Martes                       0 0 * * 2
# Cada Miercoles                    0 0 * * 3
# Cada Jueves                       0 0 * * 4
# Cada Viernes                      0 0 * * 5
# Cada Sábado                       0 0 * * 6
# Días laborales                    0 0 * * 1-5
# Fines de semana                   0 0 * * 6,0
# Cada 7 días                       0 0 * * 0

# El día 1 de cada mes              0 0 1 * *
# El día uno cada dos meses       0 0 */2 * *
# Cada trimestre                  0 0 */3 * *
# Cada 6 meses                    0 0 */6 * *

