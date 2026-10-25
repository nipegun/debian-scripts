#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para limpiar Codex en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/Codex-Limpiar.sh | bash
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/Codex-Limpiar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/Codex-Limpiar.sh | nano -
# ----------

# Definir la constante con la carpeta base
  cBaseDir="$HOME/.codex"

# Borrado de carpetas

  # Definir el array con el nombre de las carpetas a borrar
    aCarpetasABorrar=(
      "app-server-control"
      "app-server-daemon"
      "archived_sessions"
      "attachments"
      "cache"
      "code-review-plugin"
      "computer-use"
      "dictation-history"
      "generated_images"
      "ipc"
      "log"
      "memories"
      "node_repl"
      "packages"
      "pets"
      "plugins"
      "rules"
      "sessions"
      "shell_snapshots"
      "skills"
      "sqlite"
      "thread-writer-locks"
      "tui-thread-reference-capabilities"
      "tmp"
      "vendor_imports"
      "visualizations"
      ".tmp"
    )

# Terminar todos los procesos de codex
  echo ""
  echo "  Intentando terminar todos los posibles procesos activos de codex..."
  echo ""
  # Proceso principal de la app de escritorio y todos sus hijos (si no se mata, relanza el app-server)
    pkill -TERM -f '^/usr/lib/chatgpt/' 2> /dev/null
  # CLI de codex instalado con npm
    ps -aux | grep .codex | grep -v grep | awk '{print $2}' | xargs -r -t kill 2> /dev/null
  # Esperar a que terminen de verdad (máximo 10 segundos) y, si no, matarlos a la fuerza
    for i in $(seq 10); do
      pgrep -f '^/usr/lib/chatgpt/' > /dev/null || break
      sleep 1
    done
    pkill -KILL -f '^/usr/lib/chatgpt/' 2> /dev/null
    sleep 1


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
      ".codex-global-state.json.bak"
      ".personality_migration"
      ".sandbox_migration"
      ".sqlite-maintenance.lock"
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
    )

  # Ejecutar el bucle de borrado
    echo ""
    echo "  Ejecutando el bucle de borrado..."
    echo ""
    for vArchivo in "${aArchivosABorrar[@]}"; do
      vRutaAlArchivo="$cBaseDir/$vArchivo"
      if [ -f "$vRutaAlArchivo" ]; then
        rm -fv "$vRutaAlArchivo"
      fi
    done

# Recrear el archivo config.toml
  echo ""
  echo "  Re-creando el archivo config.toml..."
  echo ""
  mkdir -p "$cBaseDir" 2> /dev/null
  echo 'model = "gpt-6-astra"'                    | tee    "$cBaseDir"/config.toml
  echo 'model_reasoning_effort = "xhigh"'         | tee -a "$cBaseDir"/config.toml
  echo 'plan_mode_reasoning_effort = "max"'       | tee -a "$cBaseDir"/config.toml
  echo 'model_context_window = 1000000'           | tee -a "$cBaseDir"/config.toml
  echo 'model_auto_compact_token_limit = 900000'  | tee -a "$cBaseDir"/config.toml
  echo 'service_tier = "default"'                 | tee -a "$cBaseDir"/config.toml

# Terminar todos los procesos de codex
  echo ""
  echo "  Intentando terminar todos los posibles procesos activos de codex..."
  echo ""
  ps -aux | grep .codex | grep -v grep | awk '{print $2}' | xargs -t kill 2> /dev/null

# Actualizar Codex
  echo ""
  echo "  Actualizando Codex a la última versión..."
  echo ""
  sudo apt-get -y update && sudo apt-get -y install npm
  sudo npm install -g @openai/codex

# Listar los archivos remanentes de la carpeta
  echo ""
  echo "  Archivos remanentes en la carpeta $cBaseDir/ :"
  echo ""
  ls -lha "$cBaseDir"/
  echo ""
