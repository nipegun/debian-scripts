#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Odoo en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Odoo-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Odoo-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Odoo-InstalarYConfigurar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Odoo-InstalarYConfigurar.sh | bash -s Parámetro1 Parámetro2
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/d-scripts/refs/heads/master/InstDeSoftware/ServWeb/Odoo-InstalarYConfigurar.sh | nano -
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  #if [ $(id -u) -ne 0 ]; then     # Sólo comprueba si es root
  if [[ $EUID -ne 0 ]]; then       # Comprueba si es root o sudo
    echo ""
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse con privilegios de administrador (como root o con sudo).${cFinColor}"
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 13 (x)...${cFinColor}"
    echo ""

    # Instalar postgres
      sudo apt-get -y update
      sudo apt-get -y install postgresql

    # Agregar repositorio
      # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete wget no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install wget
          echo ""
        fi
      # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
        if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
          echo ""
          echo -e "${cColorRojo}    El paquete gnupg2 no está instalado. Iniciando su instalación...${cFinColor}"
          echo ""
          sudo apt-get -y update
          sudo apt-get -y install gnupg2
          echo ""
        fi
      wget -q -O - https://nightly.odoo.com/odoo.key | sudo gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg
      echo 'deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] https://nightly.odoo.com/20.0/nightly/deb/ ./' | sudo tee /etc/apt/sources.list.d/odoo.list
      sudo apt-get -y update

    # Corregir error de dependencia del paquete python3-pypdf2
      #curl -L http://snapshot.debian.org/archive/debian/20221107T202155Z/pool/main/p/pypdf2/python3-pypdf2_1.26.0-4_all.deb          -o /tmp/python3-pypdf2-v1.deb
      curl -L http://snapshot.debian.org/archive/debian/20251004T022838Z/pool/main/p/pypdf2/python3-pypdf2_2.12.1-3%2Bdeb12u1_all.deb -o /tmp/python3-pypdf2-v2.deb
      sudo apt -y install /tmp/python3-pypdf2-v2.deb
      sudo apt-get -y install python3-phonenumbers

    # Instalar Odoo
      sudo apt-get install odoo

    # Notificar fin de ejecución del script
      echo ""
      echo "  La ejecución del script ha finalizado."
      echo ""
      echo "    Conéctate a la web en:"
      echo ""
      echo "      http://localhost:8069"
      echo ""
      echo "        o en:"
      echo ""
      vIPLocal=$(hostname -I | sed 's- --g')
      echo "      http://$vIPLocal:8069"
      echo ""

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    # Definir fecha de ejecución del script
      cFechaDeEjec=$(date +a%Ym%md%d@%T)

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
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
        opciones=(
          1 "Versión Community (desde la web oficial)"    on
          2 "Versión Community (desde repos de Debian) 2" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando versión Community desde la web..."
              echo ""

              echo ""
              echo "  Instalando la base de datos PostgreSQL..." 
              echo ""
              # Comprobar si el paquete wget está instalado. Si no lo está, instalarlo.
                if [[ $(dpkg-query -s wget 2>/dev/null | grep installed) == "" ]]; then
                  echo ""
                  echo "  wget no está instalado. Iniciando su instalación..."
                  echo ""
                  apt-get -y update > /dev/null
                  apt-get -y install wget
                  echo ""
                fi
              # Descargar la llave para firmar el repositorio
                mkdir -p /root/aptkeys/ 2> /dev/null
                wget -q -O- https://www.postgresql.org/media/keys/ACCC4CF8.asc -O /root/aptkeys/postgresql.key
                # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo "  gnupg2 no está instalado. Iniciando su instalación..."
                    echo ""
                    apt-get -y update > /dev/null
                    apt-get -y install gnupg2
                    echo ""
                  fi
                gpg --dearmor /root/aptkeys/postgresql.key
                cp /root/aptkeys/postgresql.key.gpg /usr/share/keyrings/postgresql.gpg
              # Crear el archivo de repositorio
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt bullseye-pgdg main" > /etc/apt/sources.list.d/postgresql.list
              # Actualizar el cache de paquetes
                apt-get -y update
              # Instalar la última versión de PostreSQL
                apt-get -y install postgresql
              # Crear usuario
                #su - postgres -c "createuser $UsuarioPSQL"
              # Crear base de datos
                #su - postgres -c "createdb $BaseDeDatosPSQL"

              echo ""
              echo "  Instalando wkhtmltopdf..." 
              echo ""
              # Instalar paquetes necesarios
                apt-get -y install fontconfig
                apt-get -y install libjpeg62-turbo
                apt-get -y install xfonts-75dpi
                apt-get -y install xfonts-base
              # Determinar la URL del archivo a bajar
                # Comprobar si el paquete curl está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s curl 2>/dev/null | grep installed) == "" ]]; then
                   echo ""
                    echo "  El paquete curl no está instalado. Iniciando su instalación..."
                    echo ""
                    sudo apt-get -y update > /dev/null
                    sudo apt-get -y install curl
                    echo ""
                  fi
                vSubURL=$(curl -sL https://github.com/wkhtmltopdf/packaging/releases | grep href | grep .deb | grep amd64 | grep buster | head -n1 | cut -d '"' -f2)
                rm -rf /root/SoftInst/wkhtmltopdf/
                mkdir -p /root/SoftInst/wkhtmltopdf/ 2> /dev/null
                cd /root/SoftInst/wkhtmltopdf/
                wget https://github.com/$vSubURL -O wkhtmltopdf.deb
                dpkg -i /root/SoftInst/wkhtmltopdf/wkhtmltopdf.deb

              echo ""
              echo "  Iniciando la instalación de Odoo..." 
              echo ""
              # Agregar llave para firmar repositorio
                mkdir -p /root/aptkeys/ 2> /dev/null
                wget -q -O- https://nightly.odoo.com/odoo.key -O /root/aptkeys/odoo.key
                gpg --dearmor /root/aptkeys/odoo.key
                cp /root/aptkeys/odoo.key.gpg /usr/share/keyrings/odoo.gpg
              # Agregar repositorio
                # Comprobar si el paquete gnupg2 está instalado. Si no lo está, instalarlo.
                  if [[ $(dpkg-query -s gnupg2 2>/dev/null | grep installed) == "" ]]; then
                    echo ""
                    echo "  gnupg2 no está instalado. Iniciando su instalación..."
                    echo ""
                    apt-get -y update > /dev/null
                    apt-get -y install gnupg2
                    echo ""
                  fi
                vUltVersOdoo=$(curl -sL http://nightly.odoo.com/ | grep blob | grep -v master | head -n1 | cut -d '"' -f2 | sed 's-blob/-\n-g' | grep -v http | cut -d '/' -f1)
                echo "deb [arch=amd64 signed-by=/usr/share/keyrings/odoo.gpg] http://nightly.odoo.com/$vUltVersOdoo/nightly/deb/ ./" > /etc/apt/sources.list.d/odoo.list
              # Actualizar el cache de paquetes
                apt-get -y update
              # Instalar la última versión de Odoo
                apt-get -y install odoo
                systemctl enable --now odoo
                echo ""
                ss -tunelp | grep 8069
                echo ""

            ;;

            2)

              echo ""
              echo "  Instalando versión Community desde repos de Debian..."
              echo ""
              apt-get -y update 2> /dev/null
              vVersPostgre=$(apt-cache depends postgresql | grep pen | cut -d '-' -f2)
              vVersWkHTMLtoPDF=$(apt-cache policy wkhtmltopdf | grep and | cut -d':' -f2 | sed 's- --g')
              vVersOdoo=$(apt-cache search odoo | grep -v Voo | grep -v python | grep odoo | cut -d '-' -f2)
              echo "Este script instalará el siguiente software:"
              echo "  PostgreSQL v$vVersPostgre"
              echo "  wkhtmltopdf v$vVersWkHTMLtoPDF"
              echo "  Odoo v$vVersOdoo"
              echo ""
              sleep 5

              echo ""
              echo "  Instalando la base de datos PostgreSQL..." 
              echo ""
              apt-get -y install postgresql

              echo ""
              echo "  Instalando wkhtmltopdf..." 
              echo ""
              apt-get -y install wkhtmltopdf

              echo ""
              echo "  Instalando odoo..." 
              echo ""
              apt-get -y install odoo

              echo ""
              echo "  Activando el servicio"
              echo ""
              systemctl enable --now odoo

              echo ""
              echo "  Información de puerto:"
              echo ""
              ss -tunelp | grep 8069

            ;;

        esac

    done

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Odoo para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
