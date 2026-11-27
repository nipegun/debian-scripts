#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar ZenDNN en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/ZenDNN-BajarCompilarInstalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/ZenDNN-BajarCompilarInstalar.sh | sed 's-sudo--g' | bash
#
# Bajar y editar directamente el archivo en nano
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/ZenDNN-BajarCompilarInstalar.sh | nano -
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
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 13 (Trixie)...${cFinColor}"
    echo ""

    # Instalar dependencias
      echo ""
      echo "    Instalando dependencias..."
      echo ""
      sudo apt-get -y update
      sudo apt-get -y install build-essential
      sudo apt-get -y install cmake
      sudo apt-get -y install git
      sudo apt-get -y install python3
      sudo apt-get -y install ca-certificates

    # Descargar la última versión estable
      echo ""
      echo "    Descargando la última versión estable..."
      echo ""
      mkdir -p "$HOME/Code/"  
      cRamaEstable='v6.1.0'
      rm -rf "$HOME/Code/ZenDNN-$cRamaEstable"
      git clone --depth 1 --branch "$cRamaEstable" https://github.com/amd/ZenDNN.git "$HOME/Code/ZenDNN-$cRamaEstable"
      cd "$HOME/Code/ZenDNN-$cRamaEstable"

    # Preparar /opt/zendnn/
      echo ""
      echo "    Preparando la carpeta /opt/zendnn/..."
      echo ""
      sudo rm -rf /opt/zendnn/ 2> /dev/null
      sudo mkdir -m 0755 /opt/zendnn/ && sudo chown "$(id -u):$(id -g)" /opt/zendnn/

    # Compilar e instalar
      cd "$HOME/Code/ZenDNN-$cRamaEstable"
      # Determinar la cantidad de hilos
        vHilos=$(( $(nproc) - 1 ))
        # Comprobar que no quede en cero
          if [ "$vHilos" -lt 1 ]; then
            vHilos=1
          fi
      # Preparar la compilación
        echo ""
        echo "    Preparando la compilación..."
        echo ""
        cmake -S . -B build-system             \
          -DZENDNNL_INSTALL_PREFIX=/opt/zendnn \
          -DZENDNNL_BUILD_TYPE=Release         \
          -DZENDNNL_LIB_BUILD_SHARED=ON        \
          -DZENDNNL_LIB_BUILD_ARCHIVE=ON       \
          -DZENDNNL_BUILD_EXAMPLES=ON          \
          -DZENDNNL_BUILD_GTEST=OFF            \
          -DZENDNNL_BUILD_DOXYGEN=OFF          \
          -DZENDNNL_BUILD_SYS_NPROC="$vHilos"
      # Compilar
        echo ""
        echo "    Compilando..."
        echo ""
        cmake --build build-system --target all --parallel "$vHilos"

    # Registrar la biblioteca en Debian
      echo ""
      echo "    Registrando la biblioteca en Debian..."
      echo ""
      printf '%s\n' '/opt/zendnn/zendnnl/lib' | sudo tee /etc/ld.so.conf.d/zendnn.conf >/dev/null
      sudo ldconfig

    # Facilitar que CMake encuentre ZenDNN
      echo ""
      echo "    Facilitando que CMake encuentre ZenDNN..."
      echo ""
      printf '%s\n' 'export CMAKE_PREFIX_PATH="/opt/zendnn/zendnnl${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"' | sudo tee /etc/profile.d/zendnn.sh >/dev/null
      sudo chmod 0644 /etc/profile.d/zendnn.sh

    # Comprobar la instalación
      echo ""
      echo "    Comprobando la instalación..."
      echo ""
      /sbin/ldconfig -p | grep -F libzendnnl

    # Listar las dependencias
      echo ""
      echo "    Listando las dependencias..."
      echo ""
      ldd /opt/zendnn/zendnnl/lib/libzendnnl.so

    # Activar el perfil en la termina actual
      echo ""
      echo "    Activando el perfil en la terminal actual..."
      echo ""
      . /etc/profile.d/zendnn.sh && echo -e "OK\n"

    # Notificar fin de ejecución del script
      echo ""
      echo "    Ejecución del script, finalizada."
      echo ""
      # Para indicar la ubicación explícitamente al configurar una aplicación que use ZenDNN:
      #   cmake -S . -B build -Dzendnnl_DIR=/opt/zendnn/zendnnl/lib/cmake

  elif [ $cVerSO == "12" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 12 (Bookworm)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 12 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "11" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 11 (Bullseye)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "10" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 10 (Buster)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "9" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 9 (Stretch)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "8" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 8 (Jessie)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  elif [ $cVerSO == "7" ]; then

    echo ""
    echo -e "${cColorAzulClaro}  Iniciando el script de instalación de ZenDNN para Debian 7 (Wheezy)...${cFinColor}"
    echo ""

    echo ""
    echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
    echo ""

  fi
