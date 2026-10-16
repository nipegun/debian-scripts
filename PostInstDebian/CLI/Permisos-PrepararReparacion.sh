#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear el archivo con las instrucciones de reparación de permisos del sistema
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Permisos-PrepararReparacion.sh | bash
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
  echo -e "${cColorAzulClaro}  Iniciando script para crear el script de reparación de permisos...${cFinColor}"
  echo ""

# Crear el script de reparación de permisos
  mkdir -p /root/scripts/ParaEsteDebian/ 2> /dev/null
  echo '#!/bin/bash'                                                                                    > /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'vFechaDeEjecucion=$(date +a%Ym%md%d@%T)'                                                       >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo "La reparación de permisos se ejecutó el $vFechaDeEjecucion" >> /var/log/RepPermisos.log' >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "#  ESCRIBE ABAJO, UNA POR LÍNEA, LAS TAREAS DE REPARACIÓN DE PERMISOS A EJECUTAR"              >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "#▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼"            >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo ""                                                                                              >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo "  Reparando permisos..."'                                                                >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo "    Reparando permisos web..."'                                                          >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo 'echo ""'                                                                                       >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "chown -R www-data:www-data /var/www"                                                           >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "find /var/www -type d -exec chmod 755 {} \;"                                                   >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "find /var/www -type f -exec chmod 644 {} \;"                                                   >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  echo "chown root:root /var/www # Necesario para enjaular las cuentas"                                >> /root/scripts/ParaEsteDebian/RepararPermisos.sh
  chmod 700                                                                                               /root/scripts/ParaEsteDebian/RepararPermisos.sh

