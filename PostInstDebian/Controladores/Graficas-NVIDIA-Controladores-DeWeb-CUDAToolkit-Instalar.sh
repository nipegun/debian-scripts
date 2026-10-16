#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar la versión web de CUDA toolkit de forma que se pueda dar uso a los núcleos CUDA de la tarjeta gráfica
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Instalar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Instalar.sh | sed 's-sudo--g' | bash
#
# Ejecución remota sin caché:
#   curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Instalar.sh | bash
#
# Ejecución remota con parámetros:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/Controladores/Graficas-NVIDIA-Controladores-DeWeb-CUDAToolkit-Instalar.sh | bash -s Parámetro1 Parámetro2
#
#
# Enlaces relacionados: https://developer.nvidia.com/cuda-toolkit-archive
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
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

if [ $cVerSO == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 13 (x)...${cFinColor}"
  echo ""

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
    menu=(dialog --checklist "Marca la versión de CUDA Toolkit que quieres instalar:" 22 96 16)
      opciones=(
        1 "13.3.1" on
        2 "12.9.2" off
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando CUDA Toolkit..."
              echo ""

              # Descargar
                cVers='13.3.1'
                echo ""
                echo "    Descargando versión $cVers..."
                echo ""
                curl -L https://developer.download.nvidia.com/compute/cuda/"$cVers"/local_installers/cuda-repo-debian13-13-3-local_"$cVers"-610.43.02-1_amd64.deb -o /tmp/CudaRepo.deb
                sudo apt -y install /tmp/CudaRepo.deb
                sudo cp -v /var/cuda-repo-debian13-13-3-local/cuda-*-keyring.gpg /usr/share/keyrings/
                sudo apt-get -y update
                sudo apt-get -y install cuda-toolkit-13-3

              # Notificar fin de ejecución del script
                echo ""
                echo "    Script de instalación de CUDA Toolkit, finalizado."
                echo ""

            ;;

            2)

              echo ""
              echo "  Instalando CUDA Toolkit..."
              echo ""

                cVers='12.9.2'
                echo ""
                echo "    Descargando versión $cVers..."
                echo ""
                curl -L https://developer.download.nvidia.com/compute/cuda/12.9.2/local_installers/cuda-repo-debian12-12-9-local_12.9.2-575.57.08-1_amd64.deb -o /tmp/CudaRepo.deb
                sudo apt -y install /tmp/CudaRepo.deb
                sudo cp -v /var/cuda-repo-debian12-12-9-local/cuda-*-keyring.gpg /usr/share/keyrings/
                sudo apt-get update
                sudo apt-get -y install cuda-toolkit-12-9

              # Notificar fin de ejecución del script
                echo ""
                echo "    Script de instalación de CUDA Toolkit, finalizado."
                echo ""

            ;;

        esac

    done

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

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
    menu=(dialog --checklist "Marca la versión de CUDA Toolkit que quieres instalar:" 22 96 16)
      opciones=(
        1 "13.1" on
        2 "12.8" off
      )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando CUDA Toolkit 13.0..."
              echo ""

              # Instalar CUDA Toolkit
                echo ""
                echo "    Instalando CUDA Toolkit..."
                echo ""
                curl -L https://developer.download.nvidia.com/compute/cuda/13.1.1/local_installers/cuda-repo-debian12-13-1-local_13.1.1-590.48.01-1_amd64.deb -o /tmp/CudaRepo.deb
                sudo apt -y install /tmp/CudaRepo.deb
                sudo cp /var/cuda-repo-debian12-13-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
                sudo apt-get update
                sudo apt-get -y install cuda-toolkit-13-1

              # Notificar fin de ejecución del script
                echo ""
                echo "    Script de instalación de CUDA Toolkit, finalizado."
                echo ""

            ;;

            2)

              echo ""
              echo "  Instalando CUDA Toolkit 12.8..."
              echo ""

              # Instalar CUDA Toolkit
                echo ""
                echo "    Instalando CUDA Toolkit..."
                echo ""
                curl -L https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda-repo-debian12-12-8-local_12.8.0-570.86.10-1_amd64.deb -o /tmp/CudaRepo.deb
                sudo apt -y install /tmp/CudaRepo.deb
                sudo cp -v /var/cuda-repo-debian12-12-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
                sudo apt-get update
                sudo apt-get -y install cuda-toolkit-12-8

              # Notificar fin de ejecución del script
                echo ""
                echo "    Script de instalación de CUDA Toolkit, finalizado."
                echo ""

            ;;

        esac

    done

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 11 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de los controladores NVIDIA para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi
