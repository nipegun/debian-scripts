#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Flectra en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/SoftInst/ServWeb/Flectra-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Flectra-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Flectra-InstalarYConfigurar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 13 (x)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --radiolist "Cómo quieres instalar Flectra:" 22 80 16)
        opciones=(
          1 "Clonando el repo oficial de GitLab"                            on
          2 "Agregando el repositorio de la última versión"                 off
          3 "Descargando directamente el archivo .deb de la última versión" off

        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando Flectra clonando el repo oficial de gitlab..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y dist-upgrade
                sudo apt-get -y autoremove
                sudo apt-get -y autoclean

                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu
                sudo apt-get -y install postgresql
                sudo apt-get -y install postgresql-server-dev-all
                sudo apt-get -y install build-essential
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-venv
                sudo apt-get -y install npm
                sudo apt-get -y install nodejs
                sudo apt-get -y install git
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libxml2-dev
                sudo apt-get -y install libxslt1-dev
                sudo apt-get -y install libjpeg-dev
                sudo apt-get -y install unzip
                sudo apt-get -y install libsasl2-dev
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libssl-dev

              # Crear el usuario
                echo ""
                echo "    Creando el usuario del sistema..."
                echo ""
                sudo adduser --system --group --home /opt/flectra flectra
                sudo su - postgres -c "createuser -s flectra"

              # Asignar bash como terminal del usuario del sistema
                echo ""
                echo "    Asignando bash como terminal del usuario de sistema..."
                echo ""
                sudo usermod -s /bin/bash flectra
                #sudo getent passwd flectra

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f2)
                vCanalUltVers=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f3)
                echo "      La última versión disponible es la $vUltVersFlectra del canal $vCanalUltVers"
                echo ""

              # Clonar el repo
                echo ""
                echo "    Clonando el repo..."
                echo ""
                sudo rm -rf /opt/flectra/Code/
                sudo su -s /bin/bash -c "\
                  cd /opt/flectra/                                                                        && \
                  git clone --depth=1 --branch=$vUltVersFlectra https://gitlab.com/flectra-hq/flectra.git && \
                  mv /opt/flectra/flectra /opt/flectra/Code
                " flectra

              # Crear el entorno virtual
                echo ""
                echo "    Creando el entorno virtual..."
                echo ""
                sudo rm -rf /opt/flectra/venv/
                sudo su -s /bin/bash -c '\
                  mkdir /opt/flectra/venv/                                 && \
                  python3 -m venv /opt/flectra/venv/                       && \
                  source /opt/flectra/venv/bin/activate                    && \
                  export CFLAGS="-Wno-error=implicit-function-declaration" && \
                  pip install cython                                       && \
                  pip install wheel                                        && \
                  pip install -r /opt/flectra/Code/requirements.txt        && \
                  deactivate \
                ' flectra

              # Crear el archivo de configuración
                echo ""
                echo "    Creando el archivo de configuración..."
                echo ""
                echo '[options]'                              | sudo tee    /opt/flectra/flectra.conf
                echo 'admin_passwd = admin'                   | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_host = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_port = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_user = flectra'                      | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_password = False'                    | sudo tee -a /opt/flectra/flectra.conf
                echo 'addons_path = /opt/flectra/Code/addons' | sudo tee -a /opt/flectra/flectra.conf
                echo 'default_productivity_apps = True'       | sudo tee -a /opt/flectra/flectra.conf
                echo 'logfile = /var/log/flectra/flectra.log' | sudo tee -a /opt/flectra/flectra.conf
                sudo chown flectra:flectra /opt/flectra/flectra.conf

              # Crear las carpetas para los logs
                echo ""
                echo "    Creando las carpetas para los logs..."
                echo ""
                sudo mkdir -p /var/log/flectra/
                sudo chown flectra:flectra /var/log/flectra/

              # Crear el lanzador
                echo ""
                echo "    Creando el lanzador..."
                echo ""
                echo '#!/opt/flectra/venv/bin/python3'                             | sudo tee    /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import sys'                                                  | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import os'                                                   | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo '# Agrega el paquete flectra al path'                         | sudo tee -a /opt/flectra/flectra-start.py
                echo 'sys.path.insert(0, "/opt/flectra/Code")'                     | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import flectra'                                              | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'if __name__ == "__main__":'                                  | sudo tee -a /opt/flectra/flectra-start.py
                echo '  # Simula sys.argv como si ejecutaras desde consola'        | sudo tee -a /opt/flectra/flectra-start.py
                echo '  sys.argv = ["flectra", "-c", "/opt/flectra/flectra.conf"]' | sudo tee -a /opt/flectra/flectra-start.py
                echo '  flectra.cli.main()'                                        | sudo tee -a /opt/flectra/flectra-start.py
                sudo chmod +x /opt/flectra/flectra-start.py
                sudo chown flectra:flectra /opt/flectra/flectra-start.py

              # Ejecutar Flectra por primera vez
                #echo ""
                #echo "    Ejecutando Flectra por primera vez..."
                #echo ""
                #sudo -u flectra bash -c '/opt/flectra/flectra.py'

              # Quitar la terminal de bash asignada al usuario del sistema
                echo ""
                echo "    Quitando la terminal de bash asignada al usuario de sistema...."
                echo ""
                sudo usermod -s /usr/sbin/nologin flectra

              # Crear el servicio de systemd
                echo ""
                echo "    Creando el servicio de systemd..."
                echo ""
                echo '[Unit]'                                  | sudo tee    /etc/systemd/system/flectra.service
                echo 'Description=Flectra ERP'                 | sudo tee -a /etc/systemd/system/flectra.service
                echo 'After=network.target postgresql.service' | sudo tee -a /etc/systemd/system/flectra.service
                echo ''                                        | sudo tee -a /etc/systemd/system/flectra.service
                echo '[Service]'                               | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Type=simple'                             | sudo tee -a /etc/systemd/system/flectra.service
                echo 'User=flectra'                            | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Group=flectra'                           | sudo tee -a /etc/systemd/system/flectra.service
                echo 'ExecStart=/opt/flectra/flectra-start.py' | sudo tee -a /etc/systemd/system/flectra.service
                echo 'WorkingDirectory=/opt/flectra'           | sudo tee -a /etc/systemd/system/flectra.service
                echo 'StandardOutput=journal'                  | sudo tee -a /etc/systemd/system/flectra.service
                echo 'StandardError=inherit'                   | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Restart=on-failure'                      | sudo tee -a /etc/systemd/system/flectra.service
                echo 'SyslogIdentifier=flectra'                | sudo tee -a /etc/systemd/system/flectra.service
                echo ''                                        | sudo tee -a /etc/systemd/system/flectra.service
                echo '[Install]'                               | sudo tee -a /etc/systemd/system/flectra.service
                echo 'WantedBy=multi-user.target'              | sudo tee -a /etc/systemd/system/flectra.service

              # Reparar permisos
                sudo chown flectra:flectra /opt/flectra/ -R

              # Activar y lanzar el servicio
                echo ""
                echo "    Activando y lanzando el servicio..."
                echo ""
                sudo systemctl daemon-reload
                sudo systemctl enable flectra
                sudo systemctl start flectra
                sudo systemctl status flectra --no-pager -l

              # Notificar fin de ejecución del script
                echo ""
                echo "    Ejecución del script, finalizada."
                echo ""
                echo "      Flectra se ha instalado y configurado. Se ha creado e iniciado el servicio en systemd. El estado actual del servicio es:"
                echo ""
                sudo systemctl status flectra.service --no-pager
                echo ""
                vIPLocal=$(hostname -I | sed 's- --g')
                echo ""
                echo "      Para configurar la base de datos accede a http://"$vIPLocal":7073"
                echo ""

            ;;

            2)

              echo ""
              echo "  Instalando Flectra desde el repositorio oficial para Debian..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f2)
                vCanalUltVers=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f3)
                echo "      La última versión disponible es la $vUltVersFlectra del canal $vCanalUltVers"
                echo ""
                
              # Agregar el repositorio
                echo ""
                echo "    Agregando el repositorio..."
                echo ""
                wget -q -O - https://nightly.flectra.com/flectra.key | sudo gpg --dearmor -o /usr/share/keyrings/flectra-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/flectra-archive-keyring.gpg] https://nightly.flectra.com/$vUltVersFlectra/nightly/deb/ ./" | sudo tee /etc/apt/sources.list.d/flectra.list
                sudo apt-get -y update

              # Instalar
                echo ""
                echo "    Instalando..."
                echo ""
                sudo apt-get -y install flectra

            ;;

            3)

              echo ""
              echo "  Instalando Flectra desde el .deb de la última versión..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f2)
                vCanalUltVers=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f3)
                echo "      La última versión disponible es la $vUltVersFlectra del canal $vCanalUltVers"
                echo ""

              # Descargar el .deb
                echo ""
                echo "    Descargando el archivo .deb..."
                echo ""
                curl -L https://download.flectrahq.com/"$vUltVersFlectra"/"$vCanalUltVers"/deb/flectra_"$vUltVersFlectra".latest_all.deb -o /tmp/flectra.deb

              # Instalar el archivo .deb
                echo ""
                echo "    Instalando el archivo .deb..."
                echo ""
                sudo apt -y install /tmp/flectra.deb

              # Notificar fin de ejecución del script
                echo ""
                echo "    La ejecución del script ha finalizado."
                echo "    Flectra está instalada y configurada."

            ;;

        esac

    done

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    # Crear el menú
      # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install dialog
          echo ""
        fi
      menu=(dialog --checklist "Cómo quieres instalar Flectra:" 22 80 16)
        opciones=(
          1 "Clonando el repo oficial de GitLab"                            on
          2 "Agregando el repositorio de la última versión"                 off
          3 "Descargando directamente el archivo .deb de la última versión" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando Flectra clonando el repo oficial de gitlab..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y dist-upgrade
                sudo apt-get -y autoremove
                sudo apt-get -y autoclean

                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu
                sudo apt-get -y install postgresql
                sudo apt-get -y install postgresql-server-dev-all
                sudo apt-get -y install build-essential
                sudo apt-get -y install python3-dev
                sudo apt-get -y install python3-pip
                sudo apt-get -y install python3-venv
                sudo apt-get -y install npm
                sudo apt-get -y install nodejs
                sudo apt-get -y install git
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libxml2-dev
                sudo apt-get -y install libxslt1-dev
                sudo apt-get -y install libjpeg-dev
                sudo apt-get -y install unzip
                sudo apt-get -y install libsasl2-dev
                sudo apt-get -y install libldap2-dev
                sudo apt-get -y install libssl-dev

              # Crear el usuario
                echo ""
                echo "    Creando el usuario del sistema..."
                echo ""
                sudo adduser --system --group --home /opt/flectra flectra
                sudo su - postgres -c "createuser -s flectra"

              # Asignar bash como terminal del usuario del sistema
                echo ""
                echo "    Asignando bash como terminal del usuario de sistema..."
                echo ""
                sudo usermod -s /bin/bash flectra
                #sudo getent passwd flectra

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f2)
                vCanalUltVers=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f3)
                echo "      La última versión disponible es la $vUltVersFlectra del canal $vCanalUltVers"
                echo ""

              # Clonar el repo
                echo ""
                echo "    Clonando el repo..."
                echo ""
                sudo rm -rf /opt/flectra/Code/
                sudo su -s /bin/bash -c "\
                  cd /opt/flectra/                                                                        && \
                  git clone --depth=1 --branch=$vUltVersFlectra https://gitlab.com/flectra-hq/flectra.git && \
                  mv /opt/flectra/flectra /opt/flectra/Code
                " flectra

              # Crear el entorno virtual
                echo ""
                echo "    Creando el entorno virtual..."
                echo ""
                sudo rm -rf /opt/flectra/VirtualEnvironment/
                sudo su -s /bin/bash -c '\
                  mkdir /opt/flectra/VirtualEnvironment/              && \
                  python3 -m venv /opt/flectra/VirtualEnvironment/    && \
                  source /opt/flectra/VirtualEnvironment/bin/activate && \
                  pip install wheel                                   && \
                  pip install -r /opt/flectra/Code/requirements.txt   && \
                  deactivate \
                ' flectra

              # Crear el archivo de configuración
                echo ""
                echo "    Creando el archivo de configuración..."
                echo ""
                echo '[options]'                              | sudo tee    /opt/flectra/flectra.conf
                echo 'admin_passwd = admin'                   | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_host = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_port = False'                        | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_user = flectra'                      | sudo tee -a /opt/flectra/flectra.conf
                echo 'db_password = False'                    | sudo tee -a /opt/flectra/flectra.conf
                echo 'addons_path = /opt/flectra/Code/addons' | sudo tee -a /opt/flectra/flectra.conf
                echo 'default_productivity_apps = True'       | sudo tee -a /opt/flectra/flectra.conf
                echo 'logfile = /var/log/flectra/flectra.log' | sudo tee -a /opt/flectra/flectra.conf
                sudo chown flectra:flectra /opt/flectra/flectra.conf

              # Crear las carpetas para los logs
                echo ""
                echo "    Creando las carpetas para los logs..."
                echo ""
                sudo mkdir -p /var/log/flectra/
                sudo chown flectra:flectra /var/log/flectra/

              # Crear el lanzador
                echo ""
                echo "    Creando el lanzador..."
                echo ""
                echo '#!/opt/flectra/VirtualEnvironment/bin/python3'               | sudo tee    /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import sys'                                                  | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import os'                                                   | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo '# Agrega el paquete flectra al path'                         | sudo tee -a /opt/flectra/flectra-start.py
                echo 'sys.path.insert(0, "/opt/flectra/Code")'                     | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'import flectra'                                              | sudo tee -a /opt/flectra/flectra-start.py
                echo ''                                                            | sudo tee -a /opt/flectra/flectra-start.py
                echo 'if __name__ == "__main__":'                                  | sudo tee -a /opt/flectra/flectra-start.py
                echo '  # Simula sys.argv como si ejecutaras desde consola'        | sudo tee -a /opt/flectra/flectra-start.py
                echo '  sys.argv = ["flectra", "-c", "/opt/flectra/flectra.conf"]' | sudo tee -a /opt/flectra/flectra-start.py
                echo '  flectra.cli.main()'                                        | sudo tee -a /opt/flectra/flectra-start.py
                sudo chmod +x /opt/flectra/flectra-start.py
                sudo chown flectra:flectra /opt/flectra/flectra-start.py

              # Ejecutar Flectra por primera vez
                #echo ""
                #echo "    Ejecutando Flectra por primera vez..."
                #echo ""
                #sudo -u flectra bash -c '/opt/flectra/flectra.py'

              # Quitar la terminal de bash asignada al usuario del sistema
                echo ""
                echo "    Quitando la terminal de bash asignada al usuario de sistema...."
                echo ""
                sudo usermod -s /usr/sbin/nologin flectra

              # Crear el servicio de systemd
                echo ""
                echo "    Creando el servicio de systemd..."
                echo ""
                echo '[Unit]'                                  | sudo tee    /etc/systemd/system/flectra.service
                echo 'Description=Flectra ERP'                 | sudo tee -a /etc/systemd/system/flectra.service
                echo 'After=network.target postgresql.service' | sudo tee -a /etc/systemd/system/flectra.service
                echo ''                                        | sudo tee -a /etc/systemd/system/flectra.service
                echo '[Service]'                               | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Type=simple'                             | sudo tee -a /etc/systemd/system/flectra.service
                echo 'User=flectra'                            | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Group=flectra'                           | sudo tee -a /etc/systemd/system/flectra.service
                echo 'ExecStart=/opt/flectra/flectra-start.py' | sudo tee -a /etc/systemd/system/flectra.service
                echo 'WorkingDirectory=/opt/flectra'           | sudo tee -a /etc/systemd/system/flectra.service
                echo 'StandardOutput=journal'                  | sudo tee -a /etc/systemd/system/flectra.service
                echo 'StandardError=inherit'                   | sudo tee -a /etc/systemd/system/flectra.service
                echo 'Restart=on-failure'                      | sudo tee -a /etc/systemd/system/flectra.service
                echo 'SyslogIdentifier=flectra'                | sudo tee -a /etc/systemd/system/flectra.service
                echo ''                                        | sudo tee -a /etc/systemd/system/flectra.service
                echo '[Install]'                               | sudo tee -a /etc/systemd/system/flectra.service
                echo 'WantedBy=multi-user.target'              | sudo tee -a /etc/systemd/system/flectra.service

              # Reparar permisos
                sudo chown flectra:flectra /opt/flectra/ -R

              # Activar y lanzar el servicio
                echo ""
                echo "    Activando y lanzando el servicio..."
                echo ""
                sudo systemctl daemon-reload
                sudo systemctl enable flectra
                sudo systemctl start flectra
                sudo systemctl status flectra --no-pager -l

              # Notificar fin de ejecución del script
                echo ""
                echo "    Ejecución del script, finalizada."
                echo ""
                echo "      Flectra se ha instalado y configurado. Se ha creado e iniciado el servicio en systemd. El estado actual del servicio es:"
                echo ""
                sudo systemctl status flectra.service --no-pager
                echo ""
                vIPLocal=$(hostname -I | sed 's- --g')
                echo ""
                echo "      Para configurar la base de datos accede a http://"$vIPLocal":7073"
                echo ""

            ;;

            2)

              echo ""
              echo "  Instalando Flectra desde el repositorio oficial para Debian..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Agregar el repositorio
                echo ""
                echo "    Agregando el repositorio..."
                echo ""
                cd /tmp
                sudo rm -f /etc/apt/trusted.gpg.d/flectra.gpg 2> /dev/null
                wget --no-check-certificate https://download.flectrahq.com/flectra.key -O - | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/flectra.gpg
                echo "deb [trusted=yes] http://download.flectrahq.com/"$vUltVersFlectra"/pub/deb ./" | sudo tee /etc/apt/sources.list.d/flectra.list
                sudo apt-get -y update

              # Instalar
                echo ""
                echo "    Instalando..."
                echo ""
                apt-get install flectra

            ;;

            3)

              echo ""
              echo "  Instalando Flectra desde el .deb de la última versión..."
              echo ""

              # Descargar paquetes necesarios para la correcta ejecución del script
                echo ""
                echo "    Descargando paquetes necesarios para la correcta ejecución del script..."
                echo ""
                sudo apt-get -y update
                sudo apt-get -y install curl
                sudo apt-get -y install gpg
                sudo apt-get -y install wget
                sudo apt-get -y install gsfonts
                sudo apt-get -y install fonts-freefont-ttf
                sudo apt-get -y install fonts-dejavu

              # Determinar la última versión disponible de Flectra
                echo ""
                echo "    Determinando la última versión disponible..."
                echo ""
                vUltVersFlectra=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2 | cut -d '/' -f1)
                echo "      La última versión disponible es la $vUltVersFlectra"
                echo ""

              # Descargar el .deb
                echo ""
                echo "    Descargando el archivo .deb..."
                echo ""
                vURLIntermediaArchivo=$(curl -ksL download.flectrahq.com | sed 's->->\n-g' | grep href | grep latest | grep deb | head -n1 | cut -d '"' -f2)
                curl -kL https://download.flectrahq.com/"$vURLIntermediaArchivo" -o /tmp/flectra.deb

              # Instalar el archivo .deb
                echo ""
                echo "    Instalando el archivo .deb..."
                echo ""
                sudo apt -y install /tmp/flectra.deb

              # Notificar fin de ejecución del script
                echo ""
                echo "    La ejecución del script ha finalizado."
                echo "    Flectra está instalada y configurada."

            ;;

        esac

    done

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Flectra para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
