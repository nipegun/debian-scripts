#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar los idiomas inglés de USA y español de España,
# dejando el sistema y el teclado en español de España
#
# Ejecución remota como root:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/CLI/Idioma-CambiarTodoA-en-us-es-es.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  cFinColor='\033[0m'

# Comprobar si el script está corriendo como root
  if [ $(id -u) -ne 0 ]; then
    echo -e "${cColorRojo}  Este script está preparado para ejecutarse como root y no lo has ejecutado como root...${cFinColor}"
    exit
  fi

# Determinar la versión de Debian
  if [ -f /etc/os-release ]; then             # Para systemd y freedesktop.org
    . /etc/os-release
    cNomSO=$NAME
    cVerSO=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
    cNomSO=$(lsb_release -si)
    cVerSO=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then          # Para algunas versiones de Debian sin el comando lsb_release
    . /etc/lsb-release
    cNomSO=$DISTRIB_ID
    cVerSO=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then       # Para versiones viejas de Debian.
    cNomSO=Debian
    cVerSO=$(cat /etc/debian_version)
  else                                        # Para el viejo uname (También funciona para BSD)
    cNomSO=$(uname -s)
    cVerSO=$(uname -r)
  fi

if [ "$cVerSO" == "13" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 13 (x)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 10 (Buster)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 9 (Stretch)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 8 (Jessie)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

elif [ "$cVerSO" == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de cambio de idioma a español de España con inglés de USA también disponible en Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  # Poner que se generen el español de España y el inglés de USA cuando se creen locales
    rm -f  /etc/locale.gen
    echo "es_ES.UTF-8 UTF-8" | tee    /etc/locale.gen
    echo "en_US.UTF-8 UTF-8" | tee -a /etc/locale.gen

  # Compilar los locales borrando primero los existentes y dejando el español de España y el inglés de USA
    apt-get -y update
    apt-get -y install locales
    locale-gen --purge es_ES.UTF-8 en_US.UTF-8

  # Modificar el archivo /etc/default/locale reflejando los cambios
    echo 'LANG="es_ES.UTF-8"'  | tee    /etc/default/locale
    echo 'LANGUAGE="es_ES:es"' | tee -a /etc/default/locale
    update-locale LANG=es_ES.UTF-8 LANGUAGE=es_ES:es

  # Poner el teclado en español de España
    echo 'XKBMODEL="pc105"'  | tee    /etc/default/keyboard
    echo 'XKBLAYOUT="es"'    | tee -a /etc/default/keyboard
    echo 'XKBVARIANT=""'     | tee -a /etc/default/keyboard
    echo 'XKBOPTIONS=""'     | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard
    echo 'BACKSPACE="guess"' | tee -a /etc/default/keyboard
    echo ''                  | tee -a /etc/default/keyboard

  # Indicar idioma español de España para todos los usuarios sin machacar /etc/profile
    rm -f /etc/profile.d/00-idioma-es-es.sh
    rm -f /etc/profile.d/00-idioma-en-us.sh
    rm -f /etc/profile.d/00-idioma-en-us-y-es-es.sh
    rm -f /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo '# Poner idioma español de España a todos los usuarios, manteniendo inglés de USA disponible' | tee    /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANG=es_ES.UTF-8'                                                                 | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    echo 'export LANGUAGE=es_ES:es'                                                                | tee -a /etc/profile.d/00-idioma-es-es-con-en-us.sh
    chmod 644 /etc/profile.d/00-idioma-es-es-con-en-us.sh

    grep -qxF '  export LANG=es_ES.UTF-8'      /etc/skel/.bashrc || echo '  export LANG=es_ES.UTF-8'      | tee -a /etc/skel/.bashrc
    grep -qxF '  export LANGUAGE=es_ES:es'     /etc/skel/.bashrc || echo '  export LANGUAGE=es_ES:es'     | tee -a /etc/skel/.bashrc

  # Restaurar /etc/profile original
    vDirTrabajo="/tmp/base-files-profile-restore"
    rm -rf "$vDirTrabajo"
    mkdir -p "$vDirTrabajo"
    cd "$vDirTrabajo" || exit 1
    apt-get download "base-files=$(dpkg-query -W -f='${Version}' base-files)"
    vArchivoDeb=$(find "$vDirTrabajo" -maxdepth 1 -type f -name 'base-files_*.deb' | head -n 1)
    mkdir -p "$vDirTrabajo/extraido"
    dpkg-deb -x "$vArchivoDeb" "$vDirTrabajo/extraido"
    cp -a /etc/profile "/etc/profile.machacado.$(date +%Y%m%d-%H%M%S)"
    install -o root -g root -m 0644 "$vDirTrabajo/extraido/etc/profile" /etc/profile

  # Notificar cambios
    echo ""
    echo -e "${cColorAzulClaro}    Cambios realizados.${cFinColor}"
    echo -e "${cColorAzulClaro}    Debes reiniciar el sistema para que los cambios tengan efecto.${cFinColor}"
    echo ""

else

  echo ""
  echo -e "${cColorRojo}  Esta versión de Debian no está contemplada por el script.${cFinColor}"
  echo -e "${cColorRojo}  Sistema detectado: $cNomSO $cVerSO${cFinColor}"
  echo ""
  exit 1

fi
