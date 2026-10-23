#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para eliminar líneas repetidas de .bash_history manteniendo el orden de ejecución
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/Bash-Historial-ComandosRepetidos-Purgar.sh | bash
# ----------

set -euo pipefail

vArchivoTemporal=""

fCleanup() {
  if [[ -n "${vArchivoTemporal:-}" && ( -e "${vArchivoTemporal}" || -L "${vArchivoTemporal}" ) ]]; then
    if ! rm -f -- "${vArchivoTemporal}"; then
      printf 'Aviso: no se pudo eliminar el archivo temporal: %s\n' "${vArchivoTemporal}" >&2
    fi
  fi
}

trap fCleanup EXIT

fEliminarLineasRepetidas() {
  local pArchivoOrigen="${1}"
  local pArchivoDestino="${2}"

  tac -- "${pArchivoOrigen}" |
  sed '=' |
  sed 'N;s/\n/\t/' |
  LC_ALL=C sort --stable --unique -t $'\t' -k2 |
  LC_ALL=C sort --numeric-sort -t $'\t' -k1,1 |
  cut -f2- |
  tac > "${pArchivoDestino}"
}

fMain() {
  local -r cRutaHistoria="${HOME:-}/.bash_history"
  local vArchivoHistoria=""
  local vDirectorioHistoria=""

  if [[ -z "${HOME:-}" ]]; then
    printf 'Error: la variable HOME no está definida.\n' >&2
    return 1
  fi

  if [[ ! -e "${cRutaHistoria}" ]]; then
    printf 'Error: no existe el archivo de historial: %s\n' "${cRutaHistoria}" >&2
    return 1
  fi

  if [[ ! -f "${cRutaHistoria}" ]]; then
    printf 'Error: la ruta del historial no es un archivo regular: %s\n' "${cRutaHistoria}" >&2
    return 1
  fi

  if [[ ! -r "${cRutaHistoria}" || ! -w "${cRutaHistoria}" ]]; then
    printf 'Error: no se puede leer y escribir el archivo de historial: %s\n' "${cRutaHistoria}" >&2
    return 1
  fi

  if ! vArchivoHistoria="$(readlink -f -- "${cRutaHistoria}")"; then
    printf 'Error: no se pudo resolver la ruta del archivo de historial.\n' >&2
    return 1
  fi

  vDirectorioHistoria="${vArchivoHistoria%/*}"

  if ! vArchivoTemporal="$(mktemp "${vDirectorioHistoria}/.bash_history.XXXXXX")"; then
    printf 'Error: no se pudo crear el archivo temporal.\n' >&2
    return 1
  fi

  if ! fEliminarLineasRepetidas "${vArchivoHistoria}" "${vArchivoTemporal}"; then
    printf 'Error: no se pudo procesar el archivo de historial.\n' >&2
    return 1
  fi

  if ! chmod --reference="${vArchivoHistoria}" "${vArchivoTemporal}"; then
    printf 'Error: no se pudieron conservar los permisos del archivo de historial.\n' >&2
    return 1
  fi

  if ! mv -- "${vArchivoTemporal}" "${vArchivoHistoria}"; then
    printf 'Error: no se pudo sustituir el archivo de historial.\n' >&2
    return 1
  fi

  vArchivoTemporal=""
  printf 'Historial depurado correctamente: %s\n' "${cRutaHistoria}"
}

if ! fMain; then
  printf 'Error: no se pudieron eliminar las líneas repetidas del historial.\n' >&2
  exit 1
fi
