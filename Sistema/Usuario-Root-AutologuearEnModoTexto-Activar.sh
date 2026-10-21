#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para activar el logueo automático del root en modo texto
#
# Compatible con:
# - Sistemas físicos con systemd.
# - Máquinas virtuales con systemd.
# - Contenedores de sistema con systemd, incluido systemd-nspawn.
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/Sistema/Usuario-Root-AutologuearEnModoTexto-Activar.sh | bash
# ----------

set -Eeuo pipefail

fObtenerExecStart() {
  local pUnidad="$1"

  SYSTEMD_PAGER=cat systemctl cat "$pUnidad" 2>/dev/null \
    | sed -n 's/^[[:space:]]*ExecStart=//p' \
    | sed '/^[[:space:]]*$/d' \
    | tail -n 1
}

fAgregarAutologinRoot() {
  local pExecStart="$1"
  local vExecStartLimpio
  local vExecStartNuevo

  # Eliminar cualquier --login-options/-o existente. Esa opción sustituye
  # los argumentos automáticos de login e impide que --autologin añada
  # automáticamente "-f root".
  #
  # También eliminamos cualquier autologin anterior para evitar duplicados.
  vExecStartLimpio="$(
    echo "$pExecStart" \
      | sed -E \
        -e "s/[[:space:]]+(-o|--login-options)(=|[[:space:]]+)'[^']*'//g" \
        -e 's/[[:space:]]+(-o|--login-options)(=|[[:space:]]+)"[^"]*"//g' \
        -e 's/[[:space:]]+(-o|--login-options)(=|[[:space:]]+)[^[:space:]]+//g' \
        -e 's/[[:space:]]+--autologin(=|[[:space:]]+)[^[:space:]]+//g' \
        -e 's/[[:space:]]+-a[[:space:]]+[^[:space:]]+//g'
  )"

  # Insertar el autologin inmediatamente después de agetty.
  # Al no existir --login-options, agetty ejecutará "login -f root".
  vExecStartNuevo="$(
    echo "$vExecStartLimpio" \
      | sed -E 's|(agetty)([[:space:]]+)|\1 --autologin root\2|'
  )"

  if [ "$vExecStartNuevo" = "$vExecStartLimpio" ]; then
    return 1
  fi

  echo "$vExecStartNuevo"
}

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: este script debe ejecutarse como root."
  exit 1
fi

if [ ! -r /proc/1/comm ] || [ "$(cat /proc/1/comm)" != "systemd" ]; then
  echo "Error: el sistema no ha sido arrancado con systemd como PID 1."
  exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
  echo "Error: no se ha encontrado systemctl."
  exit 1
fi

if ! command -v systemd-detect-virt >/dev/null 2>&1; then
  echo "Error: no se ha encontrado systemd-detect-virt."
  exit 1
fi

# Los contenedores utilizan console-getty.service para /dev/console.
if systemd-detect-virt --container --quiet; then
  vTipoVirtualizacion="$(systemd-detect-virt --container)"
  vTipoEntorno="contenedor $vTipoVirtualizacion"
  vUnidad="console-getty.service"

# Las máquinas físicas y las máquinas virtuales completas utilizan
# getty@tty1.service para la primera consola virtual.
else
  vTipoVirtualizacion="$(systemd-detect-virt --vm 2>/dev/null || true)"

  if [ -n "$vTipoVirtualizacion" ] && [ "$vTipoVirtualizacion" != "none" ]; then
    vTipoEntorno="máquina virtual $vTipoVirtualizacion"
  else
    vTipoEntorno="sistema físico"
  fi

  vUnidad="getty@tty1.service"
fi

vEstadoCarga="$(
  systemctl show "$vUnidad" \
    --property=LoadState \
    --value 2>/dev/null \
    || true
)"

if [ "$vEstadoCarga" != "loaded" ]; then
  echo "Error: la unidad $vUnidad no está disponible en este sistema."
  exit 1
fi

vExecStart="$(fObtenerExecStart "$vUnidad")"

if [ -z "$vExecStart" ]; then
  echo "Error: no se ha podido obtener ExecStart de $vUnidad."
  exit 1
fi

if ! vExecStartNuevo="$(fAgregarAutologinRoot "$vExecStart")"; then
  echo "Error: ExecStart de $vUnidad no ejecuta agetty o tiene un formato no reconocido."
  exit 1
fi

vDirectorioOverride="/etc/systemd/system/${vUnidad}.d"
vArchivoOverride="$vDirectorioOverride/50-autologin-root.conf"

mkdir -p "$vDirectorioOverride"

{
  echo '[Service]'
  echo 'ExecStart='
  echo "ExecStart=$vExecStartNuevo"
} > "$vArchivoOverride"

systemctl daemon-reload
systemctl enable "$vUnidad" >/dev/null

vEstadoCarga="$(
  systemctl show "$vUnidad" \
    --property=LoadState \
    --value 2>/dev/null \
    || true
)"

if [ "$vEstadoCarga" != "loaded" ]; then
  echo "Error: systemd no ha podido cargar correctamente $vUnidad."
  exit 1
fi

echo "Entorno detectado: $vTipoEntorno"
echo "Unidad modificada: $vUnidad"
echo "Override creado: $vArchivoOverride"
echo "El autologin de root se aplicará en el siguiente arranque."

