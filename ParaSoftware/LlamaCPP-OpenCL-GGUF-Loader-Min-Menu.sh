#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para lanzar desde un menú modelos GGUF de bajo footprint de memoria
#
# Ejecución remota (puede requerir permisos sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/LlamaCPP-OpenCL-GGUF-Loader-Min-Menu.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/LlamaCPP-OpenCL-GGUF-Loader-Min-Menu.sh | sed 's-sudo--g'| bash
# ----------

# ----------
#
# --batch-size 2048      : Determina cuántos tokens puede agrupar llama.cpp en una operación de procesamiento.
# --ubatch-size 1024     : Determina cuántos tokens procesa realmente el motor de inferencia en cada sublote.
# --spec-draft-n-max 2   : Permite generar hasta 2 tokens especulativos.
# --spec-draft-p-min 0.7 : Detiene la predicción especulativa cuando la probabilidad estimada baja del 70%. Puede evitar cálculos inútiles y mejorar la velocidad, especialmente cuando generamos código con fragmentos repetidos.
#
# --cache-prompt         : Reutiliza tokens del prompt ya procesados, evitando recalcularlos.
# --cache-ram 8192       : Permite almacenar estados de prompts en la RAM del sistema para reutilizarlos posteriormente.
#
# --n-gpu-layers auto  : Distribuye automáticamente las capas entre CPU y GPU para ajustarse a la memoria disponible.
# --cpu-moe            : Mantiene todos los pesos de expertos MoE en RAM.
# --moe-cache-mib 2048 : Esto configura una caché de expertos, destinando hasta 2GiB de VRAM en GPU para esos expertos.
# ----------

vDispositivo='OpenCL0'
vContexto='16384'
vRazonamiento='1024'
vCantMaxTokMTP='2'
vNroGPULayers='auto'

# Crear el menú
  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install dialog
      echo ""
    fi
  menu=(dialog --radiolist "Elige el modelo que quieres cargar:" 12 56 16)
    opciones=(

      1 "Qwen3.5-0.8B-MTP-Abliterated-Q4_K_M" off
      2 "Qwen3.5-0.8B-MTP-Abliterated-Q5_K_M" off
      3 "Qwen3.5-0.8B-MTP-Abliterated-Q6_K"   off
      4 "Qwen3.5-0.8B-MTP-Abliterated-Q8_0"   off

      5 "Qwen3.5-2B-MTP-Abliterated-Q4_K_M"   off
      6 "Qwen3.5-2B-MTP-Abliterated-Q5_K_M"   off
      7 "Qwen3.5-2B-MTP-Abliterated-Q6_K"     off
      8 "Qwen3.5-2B-MTP-Abliterated-Q8_0"     off

      9 "Granite4.2-3B-Abliterated-Q4_K_M"    off
     10 "Granite4.2-3B-Abliterated-Q5_K_M"    off
     11 "Granite4.2-3B-Abliterated-Q6_K"      off
     12 "Granite4.2-3B-Abliterated-Q8_0"      off

     13 "Qwen3.5-4B-MTP-Abliterated-Q4_K_M"   off
     14 "Qwen3.5-4B-MTP-Abliterated-Q5_K_M"   off
     15 "Qwen3.5-4B-MTP-Abliterated-Q6_K"     off
     16 "Qwen3.5-4B-MTP-Abliterated-Q8_0"     off

    )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Cargando Qwen3.5-0.8B-MTP-Abliterated-Q4_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-0.8B-MTP-Abliterated-Q4_K_M.gguf

            ;;

            2)

              echo ""
              echo "  Cargando Qwen3.5-0.8B-MTP-Abliterated-Q5_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-0.8B-MTP-Abliterated-Q5_K_M.gguf

            ;;

            3)

              echo ""
              echo "  Cargando Qwen3.5-0.8B-MTP-Abliterated-Q6_K.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-0.8B-MTP-Abliterated-Q6_K.gguf

            ;;

            4)

              echo ""
              echo "  Cargando Qwen3.5-0.8B-MTP-Abliterated-Q8_0.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-0.8B-MTP-Abliterated-Q8_0.gguf

            ;;

            5)

              echo ""
              echo "  Cargando Qwen3.5-2B-MTP-Abliterated-Q4_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 1.0                           \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 2.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-2B-MTP-Abliterated-Q4_K_M.gguf

            ;;

            6)

              echo ""
              echo "  Cargando Qwen3.5-2B-MTP-Abliterated-Q5_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 1.0                           \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 2.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-2B-MTP-Abliterated-Q5_K_M.gguf

            ;;

            7)

              echo ""
              echo "  Cargando Qwen3.5-2B-MTP-Abliterated-Q6_K.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 1.0                           \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 2.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-2B-MTP-Abliterated-Q6_K.gguf

            ;;

            8)

              echo ""
              echo "  Cargando Qwen3.5-2B-MTP-Abliterated-Q8_0.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 1.0                           \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 2.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-2B-MTP-Abliterated-Q8_0.gguf

            ;;

            9)

              echo ""
              echo "  Cargando Granite4.2-3B-Abliterated-Q4_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 0                             \
                  --min-p 0.0                           \
                  --presence-penalty 0.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model /home/usuariox/IA/Modelos/GGUF/Granite4.2-3B-Abliterated-Q4_K_M.gguf

            ;;

           10)

              echo ""
              echo "  Cargando Granite4.2-3B-Abliterated-Q5_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 0                             \
                  --min-p 0.0                           \
                  --presence-penalty 0.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model /home/usuariox/IA/Modelos/GGUF/Granite4.2-3B-Abliterated-Q4_K_M.gguf

            ;;

           11)

              echo ""
              echo "  Cargando Granite4.2-3B-Abliterated-Q6_K.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 0                             \
                  --min-p 0.0                           \
                  --presence-penalty 0.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model /home/usuariox/IA/Modelos/GGUF/Granite4.2-3B-Abliterated-Q4_K_M.gguf

            ;;

           12)

              echo ""
              echo "  Cargando Granite4.2-3B-Abliterated-Q8_0.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 0                             \
                  --min-p 0.0                           \
                  --presence-penalty 0.0                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model /home/usuariox/IA/Modelos/GGUF/Granite4.2-3B-Abliterated-Q4_K_M.gguf

            ;;

           13)

              echo ""
              echo "  Cargando Qwen3.5-4B-MTP-Abliterated-Q4_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-4B-MTP-Abliterated-Q4_K_M.gguf

            ;;

           14)

              echo ""
              echo "  Cargando Qwen3.5-4B-MTP-Abliterated-Q5_K_M.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-4B-MTP-Abliterated-Q5_K_M.gguf

            ;;

           15)

              echo ""
              echo "  Cargando Qwen3.5-4B-MTP-Abliterated-Q6_K.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-4B-MTP-Abliterated-Q6_K.gguf

            ;;

           16)

              echo ""
              echo "  Cargando Qwen3.5-4B-MTP-Abliterated-Q8_0.gguf..."
              echo ""
              # Lanzar el servidor
                ~/IA/Apps/llama.cpp-opencl/llama-server \
                                                        \
                  --temp 1.0                            \
                  --top-p 0.95                          \
                  --top-k 20                            \
                  --min-p 0.0                           \
                  --presence-penalty 1.5                \
                  --repeat-penalty 1.0                  \
                                                        \
                  --ctx-size "$vContexto"               \
                  --reasoning-budget "$vRazonamiento"   \
                                                        \
                  --cache-type-k q8_0                   \
                  --cache-type-v q8_0                   \
                                                        \
                  --parallel 1                          \
                  --ubatch-size 1024                    \
                  --batch-size 2048                     \
                                                        \
                  --spec-type draft-mtp                 \
                  --spec-draft-n-max "$vCantMaxTokMTP"  \
                  --spec-draft-p-min 0.7                \
                                                        \
                  --flash-attn on                       \
                  --cache-prompt                        \
                  --cache-ram 8192                      \
                                                        \
                  --device "$vDispositivo"              \
                  --n-gpu-layers "$vNroGPULayers"       \
                  --model ~/IA/Modelos/GGUF/Qwen3.5-4B-MTP-Abliterated-Q8_0.gguf

            ;;

        esac

    done
