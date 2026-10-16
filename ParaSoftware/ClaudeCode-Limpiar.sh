#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para limpiar Claude Code en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Limpiar.sh | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/ParaSoftware/ClaudeCode-Limpiar.sh | nano -
# ----------

# Definir la constante con la carpeta base
  cBaseDir="$HOME/.claude"

# Borrado de carpetas

  # Definir el array con el nombre de las carpetas a borrar
    aCarpetasABorrar=(
      "backups"
      "cache"
      "chrome"
      "daemon"
      "debug"
      "downloads"
      "file-history"
      "ide"
      "jobs"
      "paste-cache"
      "plans"
      "plugins"
      "projects"
      "session-env"
      "sessions"
      "shell-snapshots"
      "skills"
      "state"
      "tasks"
      "telemetry"
      ".cc-writes"
    )

  # Ejecutar el bucle de borrado
    for vCarpeta in "${aCarpetasABorrar[@]}"; do
      vRutaALaCarpeta="$cBaseDir/$vCarpeta"
      if [ -d "$vRutaALaCarpeta" ]; then
        rm -rfv "$vRutaALaCarpeta"
      fi
    done

# Borrado de archivos

  aArchivosABorrar=(
    "daemon.lock"
    "daemon.log"
    "daemon.status.json"
    "history.jsonl"
    "mcp-needs-auth-cache.json"
    "stats-cache.json"
    ".last-cleanup"
    ".last-update-result.json"
  )

  for vArchivo in "${aArchivosABorrar[@]}"; do
    vRutaAlArchivo="$cBaseDir/$vArchivo"
    if [ -f "$vRutaAlArchivo" ]; then
      rm -fv "$vRutaAlArchivo"
    fi
  done

# Configurar parámetros por defecto (idioma, modelo y fuerza de razonamiento)
  # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install curl
      echo ""
    fi
  mkdir -p "$HOME"/.claude
  if [ -f "$HOME"/.claude/settings.json ]; then
    jq '."$schema"="https://json.schemastore.org/claude-code-settings.json" | .attribution.coauthored=false | .language="spanish" | .model="opus" | .effortLevel="xhigh" | .showTips=false | .permissions.defaultMode="auto"' "$HOME"/.claude/settings.json > /tmp/claude-settings.json && mv /tmp/claude-settings.json "$HOME"/.claude/settings.json
  else
    echo '{'                                            | tee    "$HOME"/.claude/settings.json
    echo '  "attribution": {'                           | tee -a "$HOME"/.claude/settings.json
    echo '    "coauthored": false'                      | tee -a "$HOME"/.claude/settings.json
    echo '  },'                                         | tee -a "$HOME"/.claude/settings.json
    echo '  "permissions": {'                           | tee -a "$HOME"/.claude/settings.json
    echo '    "defaultMode": "auto"'                    | tee -a "$HOME"/.claude/settings.json
    echo '  },'                                         | tee -a "$HOME"/.claude/settings.json
    echo '  "model": "opus[1m]",'                       | tee -a "$HOME"/.claude/settings.json
    echo '  "language": "Spanish",'                     | tee -a "$HOME"/.claude/settings.json
    echo '  "modelSettings": {'                         | tee -a "$HOME"/.claude/settings.json
    echo '    "claude-opus-5-5": {'                     | tee -a "$HOME"/.claude/settings.json
    echo '      "effortLevel": "xhigh"'                 | tee -a "$HOME"/.claude/settings.json
    echo '    },'                                       | tee -a "$HOME"/.claude/settings.json
    echo '    "claude-fable-5-1": {'                    | tee -a "$HOME"/.claude/settings.json
    echo '      "effortLevel": "xhigh"'                 | tee -a "$HOME"/.claude/settings.json
    echo '    },'                                       | tee -a "$HOME"/.claude/settings.json
    echo '    "claude-sonnet-5": {'                     | tee -a "$HOME"/.claude/settings.json
    echo '      "effortLevel": "xhigh"'                 | tee -a "$HOME"/.claude/settings.json
    echo '    },'                                       | tee -a "$HOME"/.claude/settings.json
    echo '    "claude-haiku-4-5": {'                    | tee -a "$HOME"/.claude/settings.json
    echo '      "effortLevel": "xhigh"'                 | tee -a "$HOME"/.claude/settings.json
    echo '    }'                                        | tee -a "$HOME"/.claude/settings.json
    echo '  },'                                         | tee -a "$HOME"/.claude/settings.json
    echo '  "promptSuggestionEnabled": false,'          | tee -a "$HOME"/.claude/settings.json
    echo '  "awaySummaryEnabled": false,'               | tee -a "$HOME"/.claude/settings.json
    echo '  "timeFormat": "24-hour",'                   | tee -a "$HOME"/.claude/settings.json
    echo '  "editorMode": "normal",'                    | tee -a "$HOME"/.claude/settings.json
    echo '  "switchModelsOnFlag": false,'               | tee -a "$HOME"/.claude/settings.json
    echo '  "agentPushNotifEnabled": true,'             | tee -a "$HOME"/.claude/settings.json
    echo '  "skipDangerousModePermissionPrompt": true,' | tee -a "$HOME"/.claude/settings.json
    echo '  "autoContinueAtUsageLimit": false,'         | tee -a "$HOME"/.claude/settings.json
    echo '  "remoteControlAtStartup": false,'           | tee -a "$HOME"/.claude/settings.json
    echo '  "showTips": false'                          | tee -a "$HOME"/.claude/settings.json
    echo '}'                                            | tee -a "$HOME"/.claude/settings.json
  fi

# Listar los archivos remanentes de la carpeta
  echo ""
  echo "  Archivos remanentes en la carpeta $HOME/.claude/ :"
  echo ""
  ls -lha "$HOME"/.claude/
  echo ""
