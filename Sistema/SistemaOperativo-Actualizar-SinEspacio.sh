#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para actualizar Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/main/SistemaOperativo-Actualizar-SinEspacio.sh | sudo bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/main/SistemaOperativo-Actualizar-SinEspacio.sh | bash
#
# ----------

# .
  if ! fRestaurarMarcaAutomatica "$vPaquete"; then
        vErroresAuxiliares=1
        echo -e "${cColorRojo}    No se pudo restaurar la marca automática de ${vPaquete}.${cFinColor}"
      fi

      if ! fLimpiarCache; then
        vErroresAuxiliares=1
        echo -e "${cColorRojo}    No se pudo limpiar completamente la caché de APT.${cFinColor}"
      fi
    done
  }

# Indicar inicio de ejecución del script
  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de actualización del sistema operativo...${cFinColor}"
  echo ""

# Reparar los permisos de /tmp (sin modificar su contenido)
  echo ""
  echo "    Reparando permisos de la carpeta /tmp/ ..."
  echo ""
  chmod 1777 /tmp || exit 1

# Actualizar lista de paquetes disponibles en los repositorios
  echo ""
  echo "    Actualizando lista de paquetes disponibles en los repositorios..."
  echo ""
  rm -rf /var/lib/apt/lists/* || exit 1
  apt-get clean || exit 1
  apt-get update || exit 1

# Guardar los paquetes automáticos para no convertirlos en manuales con install
  declare -A dPaquetesAutomaticos=()
  if ! vListadoAutomaticos="$(apt-mark showauto)"; then
    echo -e "${cColorRojo}    No se pudieron obtener las marcas de instalación automática.${cFinColor}"
    exit 1
  fi
  while IFS= read -r vPaquete; do
    if [ -n "$vPaquete" ]; then
      dPaquetesAutomaticos["$vPaquete"]=1
    fi
  done < <(echo "$vListadoAutomaticos")

  aPaquetesActualizables=()
  vErroresAuxiliares=0

# Ejecutar upgrade, paquete por paquete
  fEjecutarFase "upgrade" || exit 1

# Ejecutar dist-upgrade, paquete por paquete
  fEjecutarFase "dist-upgrade" || exit 1

# Borrar paquetes sobrantes innecesarios
  echo ""
  echo "    Ejecutando apt-get -y autoremove..."
  echo ""
  if ! apt-get -y autoremove; then
    vErroresAuxiliares=1
  fi

# Borrar la caché de paquetes
  echo ""
  echo "    Ejecutando la limpieza final de la caché de APT..."
  echo ""
  if ! fLimpiarCache; then
    vErroresAuxiliares=1
  fi

# Comprobar si todavía quedan paquetes pendientes
  if ! fObtenerPaquetesActualizables; then
    echo -e "${cColorRojo}    No se pudo comprobar el estado final de las actualizaciones.${cFinColor}"
    exit 1
  fi

  if [ "${#aPaquetesActualizables[@]}" -gt 0 ]; then
    echo ""
    echo -e "${cColorRojo}    Quedan ${#aPaquetesActualizables[@]} paquetes pendientes de actualizar:${cFinColor}"
    for vPaquete in "${aPaquetesActualizables[@]}"; do
      echo "      - $vPaquete"
    done
    echo ""
    exit 1
  fi

# Verificar que no quedan operaciones pendientes en un dist-upgrade global simulado
  if ! vSimulacionDistUpgrade="$(LC_ALL=C apt-get -s dist-upgrade)"; then
    echo -e "${cColorRojo}    No se pudo comprobar la simulación final de dist-upgrade.${cFinColor}"
    exit 1
  fi

  if echo "$vSimulacionDistUpgrade" | grep -Eq '^(Inst|Remv|Conf) '; then
    echo ""
    echo -e "${cColorRojo}    APT todavía propone operaciones que no se pudieron completar individualmente:${cFinColor}"
    echo "$vSimulacionDistUpgrade" | sed -n '/^Inst /p; /^Remv /p; /^Conf /p'
    echo ""
    exit 1
  fi

  if [ "$vErroresAuxiliares" -ne 0 ]; then
    echo -e "${cColorRojo}    La actualización terminó con errores auxiliares.${cFinColor}"
    exit 1
  fi

# Notificar fin de ejecución del script
  echo ""
  echo -e "${cColorVerde}    Script para actualizar el sistema operativo, finalizado.${cFinColor}"
  echo ""
