#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar OpenAI Tunnel Client en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/OpenAI-TunnelClient-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/OpenAI-TunnelClient-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/OpenAI-TunnelClient-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/OpenAI-TunnelClient-Instalar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/OpenAI-TunnelClient-Instalar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org.
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # Para linuxbase.org.
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release.
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD).
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

# Ejecutar comandos dependiendo de la versión de Debian detectada

  if [ $cVerSO == "13" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 13 (x)...${cFinColor}"
    echo ""

    sudo apt-get -y update
    sudo apt-get -y install curl unzip ca-certificates
    sudo mkdir -p ~/tunnel-client-install
    sudo cd ~/tunnel-client-install

    # Obtener el tag de la última release del repo de Github
      echo ""
      echo "    Obteniendo el tag de la última release del repo de Github..."
      echo ""
      vUsuario='openai'
      vNombreDelRepo='tunnel-client'
      # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete curl no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install curl
          echo ""
        fi
      # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install jq
          echo ""
        fi
      vTagName=$(curl -s https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/latest | jq -r '.tag_name')

    # Obtener assets
      vURLDelAsset=$(curl -sL https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/tags/"$vTagName" | jq -r '.assets[].browser_download_url' | grep '\.zip$')
      # Descargar todos los assets que acaban en .zip
        cd /tmp/
        curl -sL https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/tags/"$vTagName" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url' | xargs -n1 wget -c

    # Descargar
      vVersion="$(echo $vTagName)"
      vArch=$(dpkg --print-architecture)
      vArchivo="tunnel-client-${vVersion}-linux-${vArch}.zip"
      vURL="https://github.com/openai/tunnel-client/releases/download/${vVersion}"
      cd /tmp
      curl -fL --retry 3 -o "$vArchivo" "$vURL/$vArchivo"

    # Comprobar integridad de la descarga
      curl -fL -o SHA256SUMS.txt "$vURL/SHA256SUMS.txt"
      grep -F "  $vArchivo" SHA256SUMS.txt | sha256sum -c -

    # Instalar a nivel de sistema
      sudo mkdir -p /opt/tunnel-client
      sudo unzip -o "$vArchivo" -d /opt/tunnel-client

    # Asignar permisos de ejecución
      sudo chmod +x /opt/tunnel-client/tunnel-client
      sudo chmod +x /opt/tunnel-client/cloudflared

    # Crear un enlace para poder ejecutar el cliente desde cualquier directorio:
      sudo ln -sfn /opt/tunnel-client/tunnel-client /usr/local/bin/tunnel-client

    # Verificar instalación
      tunnel-client --version

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de OpenAI Tunnel Client para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
