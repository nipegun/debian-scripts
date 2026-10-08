#!/bin/bash
set -euo pipefail

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para limpiar Codex en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/master/ParaSoftware/Codex-Limpiar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/master/ParaSoftware/Codex-Limpiar.sh | nano -
# ----------

# Definir la constante con la carpeta base
  cBaseDir="$HOME/.codex"

# Borrado de carpetas

  # Definir el array con el nombre de las carpetas a borrar
    aCarpetasABorrar=(
      "app-server-control"
      "app-server-daemon"
      "attachments"
      "cache"
      "computer-use"
      "dictation-history"
      "generated_images"
      "ipc"
      "log"
      "memories"
      "packages"
      "plugins"
      "rules"
      "sessions"
      "shell_snapshots"
      "skills"
      "sqlite"
      "thread-writer-locks"
      "tmp"
      "vendor_imports"
      "visualizations"
      ".tmp"
    )

  # Ejecutar el bucle de borrado
    for vCarpeta in "${aCarpetasABorrar[@]}"; do
      vRutaALaCarpeta="$cBaseDir/$vCarpeta"
      if [ -d "$vRutaALaCarpeta" ]; then
        rm -rfv "$vRutaALaCarpeta"
      fi
    done

# Borrado de archivos

  # Definir el array con el nombre de los archivos a borrar
    aArchivosABorrar=(
      "config.toml"
      "goals_1.sqlite"
      "goals_1.sqlite-shm"
      "goals_1.sqlite-wal"
      "history.jsonl"
      "installation_id"
      "logs_2.sqlite"
      "logs_2.sqlite-shm"
      "logs_2.sqlite-wal"
      "memories_1.sqlite"
      "memories_1.sqlite-shm"
      "memories_1.sqlite-wal"
      "models_cache.json"
      "queue_1.sqlite"
      "queue_1.sqlite-shm"
      "queue_1.sqlite-wal"
      "session_index.jsonl"
      "state_5.sqlite"
      "state_5.sqlite-shm"
      "state_5.sqlite-wal"
      "thread_history_1.sqlite"
      "thread_history_1.sqlite-shm"
      "thread_history_1.sqlite-wal"
      "transcription-history.jsonl"
      "version.json"
      ".codex-global-state.json.bak"
      ".personality_migration"
      ".sandbox_migration"
    )

  # Ejecutar el bucle de borrado
    for vArchivo in "${aArchivosABorrar[@]}"; do
      vRutaAlArchivo="$cBaseDir/$vArchivo"
      if [ -f "$vRutaAlArchivo" ]; then
        rm -fv "$vRutaAlArchivo"
      fi
    done

# Recrear el archivo config.toml
  echo 'model = "gpt-6-astra"'                    | tee    "$cBaseDir"/config.toml
  echo 'model_reasoning_effort = "xhigh"'         | tee -a "$cBaseDir"/config.toml
  echo 'plan_mode_reasoning_effort = "max"'       | tee -a "$cBaseDir"/config.toml
  echo 'model_context_window = 1000000'           | tee -a "$cBaseDir"/config.toml
  echo 'model_auto_compact_token_limit = 900000'  | tee -a "$cBaseDir"/config.toml
  echo 'service_tier = "default"'                 | tee -a "$cBaseDir"/config.toml

# Listar los archivos remanentes de la carpeta
  echo ""
  echo "  Archivos remanentes en la carpeta $cBaseDir/ :"
  echo ""
  ls -lha "$cBaseDir"/
  echo ""
