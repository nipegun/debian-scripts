#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Mattermost en Debian
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/master/SoftInst/ParaCLI/Mattermost-InstalarYConfigurar.sh | nano -
# ----------

vDominioMM="mattermost.dominio.com"

# -------------------------
# NO TOCAR A PARTIR DE AQUÍ
# -------------------------
# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then
  if [[ $EUID -ne 0 ]]; then
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    echo ""
    exit
  fi

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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar PostgreSQL
      echo ""
      echo "    Instalando PostgreSQL..."
      echo ""
      sudo apt-get update
      sudo apt-get -y install postgresql
      sudo apt-get -y install postgresql-contrib
      sudo systemctl enable postgresql --now
      # Crear la base de datos y el usuario para Mattermost
        echo ""
        echo "      Creando el usuario y la base de datos para mattermost..."
        echo ""
        # Cambiar momentáneamente la autenticación del usuario postres
          # Obtener la versión de PostgreSQL instalada
            vVersPostgreInst=$(ls /etc/postgresql/ | tail -n1)
          cp /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf.bak
          sudo sed -i -e 's|local   all             all                                     peer|local all postgres trust|g' /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf
          sudo systemctl restart postgresql
        vUsuarioMMPostgreSQL="mmuser"
        vPasswordMMPostgreSQL='P@ssw0rd!'
        vNombreBDPostgreSQL="mattermost"
        sudo psql -U postgres -c "CREATE USER $vUsuarioMMPostgreSQL WITH PASSWORD '$vPasswordMMPostgreSQL';"
        sudo psql -U postgres -c "CREATE DATABASE $vNombreBDPostgreSQL OWNER $vUsuarioMMPostgreSQL;"
        sudo psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $vNombreBDPostgreSQL TO $vUsuarioMMPostgreSQL;"
        # Restaurar la autenticación del usuario postres
          sudo cp /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf.bak
          sudo sed -i -e 's|local all postgres trust|local all postgres peer|g' /etc/postgresql/$vVersPostgreInst/main/pg_hba.conf
          sudo systemctl restart postgresql


    # Obtener el tag de la última release del repo de Github
      echo ""
      echo "    Obteniendo el tag de la última release del repo de Github..."
      echo ""
      vUsuario='mattermost'
      vNombreDelRepo='mattermost'
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
      vNumUltVers=$(curl -s https://api.github.com/repos/"$vUsuario"/"$vNombreDelRepo"/releases/latest | jq -r '.tag_name' | cut -d'v' -f2)

    # Descargar el archivo comprimido de la última versión
      echo ""
      echo "    Descargando el archivo comprimido de la última versión..."
      echo ""
      rm -rf   /tmp/SoftInst/Mattermost/* 2> /dev/null
      mkdir -p /tmp/SoftInst/Mattermost/  2> /dev/null
      cd       /tmp/SoftInst/Mattermost/
      curl -L https://releases.mattermost.com/$vNumUltVers/mattermost-$vNumUltVers-linux-amd64.tar.gz -o Mattermost.tar.gz
      echo ""

    # Descomprimir el archivo
      echo ""
      echo "    Descomprimiendo el archivo..."
      echo ""
      tar -xvzf Mattermost.tar.gz
      echo ""

    # Agregar el usuario mattermost
      echo ""
      echo "    Agregando el usuario mattermost..."
      echo ""
      sudo useradd --system --user-group mattermost

    # Preparar la carpeta final
      echo ""
      echo "    Preparando la carpeta final..."
      echo ""
      sudo mv mattermost /opt
      sudo mkdir /opt/mattermost/data
      sudo chown -R mattermost:mattermost /opt/mattermost
      sudo chmod -R g+w /opt/mattermost

    # Preparar el servicio de systemd
      echo ""
      echo "    Preparando el servicio de systemd..."
      echo ""
      echo "[Unit]"                                   | sudo tee    /etc/systemd/system/mattermost.service
      echo "Description=Mattermost"                   | sudo tee -a /etc/systemd/system/mattermost.service
      echo "After=network.target"                     | sudo tee -a /etc/systemd/system/mattermost.service
      echo "After=postgresql.service"                 | sudo tee -a /etc/systemd/system/mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
      echo "BindsTo=postgresql.service"               | sudo tee -a /etc/systemd/system/mattermost.service # Aconsejable al instalar mattermost en la misma máquina que PosgreSQL
      echo ""                                         | sudo tee -a /etc/systemd/system/mattermost.service
      echo "[Service]"                                | sudo tee -a /etc/systemd/system/mattermost.service
      echo "Type=notify"                              | sudo tee -a /etc/systemd/system/mattermost.service
      echo "ExecStart=/opt/mattermost/bin/mattermost" | sudo tee -a /etc/systemd/system/mattermost.service
      echo "TimeoutStartSec=3600"                     | sudo tee -a /etc/systemd/system/mattermost.service
      echo "KillMode=mixed"                           | sudo tee -a /etc/systemd/system/mattermost.service
      echo "Restart=always"                           | sudo tee -a /etc/systemd/system/mattermost.service
      echo "RestartSec=10"                            | sudo tee -a /etc/systemd/system/mattermost.service
      echo "WorkingDirectory=/opt/mattermost"         | sudo tee -a /etc/systemd/system/mattermost.service
      echo "User=mattermost"                          | sudo tee -a /etc/systemd/system/mattermost.service
      echo "Group=mattermost"                         | sudo tee -a /etc/systemd/system/mattermost.service
      echo "LimitNOFILE=49152"                        | sudo tee -a /etc/systemd/system/mattermost.service
      echo ""                                         | sudo tee -a /etc/systemd/system/mattermost.service
      echo "[Install]"                                | sudo tee -a /etc/systemd/system/mattermost.service
      echo "WantedBy=multi-user.target"               | sudo tee -a /etc/systemd/system/mattermost.service

    # Configurar Mattermost
      echo ""
      echo "    Configurando la aplicación..."
      echo ""
      # Hacer copia de seguridad del archivo de configuración
        sudo cp /opt/mattermost/config/config.json /opt/mattermost/config/config.json.bak.ori
      # Modificar el DataSource
        # Comprobar si el paquete jq está instalado. Si no lo está, instalarlo.
          if [[ $(dpkg-query -s jq 2>/dev/null | grep installed) == "" ]]; then
            echo ""
            echo -e "${cColorRojo}      El paquete jq no está instalado. Iniciando su instalación...${cFinColor}"
            echo ""
            sudo apt-get -y update
            sudo apt-get -y install jq
            echo ""
          fi
        sudo jq '.SqlSettings.DataSource = "postgres://'"$vUsuarioMMPostgreSQL:$vPasswordMMPostgreSQL@localhost:5432/$vNombreBDPostgreSQL?sslmode=disable&connect_timeout=10"'"' /opt/mattermost/config/config.json > /tmp/mmconfig.json && mv /tmp/mmconfig.json /opt/mattermost/config/config.json
      # Modificar el SiteURL
        sudo jq '.ServiceSettings.SiteURL = "http://'"$vDominioMM"'"' /opt/mattermost/config/config.json > /tmp/mmconfig.json && mv /tmp/mmconfig.json /opt/mattermost/config/config.json
      # Corregir propietario de los archivos
        sudo chown mattermost:mattermost /opt/mattermost -R

    # Activar e iniciar el servicio
      echo ""
      echo "    Activando e iniciando el servicio..."
      echo ""
      sudo systemctl daemon-reload
      sudo systemctl enable mattermost.service --now

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada."
      echo "      Puedes acceder al servicio en:"
      echo "        http://localhost:8065"
      echo ""

#Depending on your configuration, there are several important folders in /opt/mattermost to backup.
#These are config, logs, plugins, client/plugins, and data. We strongly recommend you back up these locations before running the rm command.

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Mattermost para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
