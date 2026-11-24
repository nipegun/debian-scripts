#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear bases de datos MySQL
#
# Ejecución remota:
#  curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/ParaSoftware/MySQL-BaseDeDatos-Crear.sh | bash -s NombreBD UsuarioBD PasswordBD
# ----------

cCantArgsEsperados=3


cColorRojo='\033[1;31m'
cColorVerde='\033[1;32m'
cFinColor='\033[0m'

if [ $# -ne $cCantArgsEsperados ]
  then
    echo ""
    echo -e "${cColorRojo}Mal uso del script.${cFinColor}"
    echo ""
    echo "El uso correcto sería:"
    echo -e "$0 ${cColorVerde}[NombreBD] [UsuarioBD] [PasswordBD]${cFinColor}"
    echo ""
    echo "Ejemplo:"
    echo "$0 wordpress usuariowp 12345678"
    echo ""
    exit
  else
    echo ""
    echo "" Ingresa el password del root de MySQL
    echo ""
    MYSQL=`which mysql`
    Q1="CREATE DATABASE IF NOT EXISTS $1;"
    Q2="CREATE USER '$2'@'localhost' IDENTIFIED BY '$3';"
    Q3="GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost';"
    Q4="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}${Q4}"
    $MYSQL -u root -p -e "$SQL"
    ok() { echo -e '\e[32m'$1'\e[m'; } # Green
    ok "\n----------\n\nLa base de datos MySQL con nombre '$1' fue creada correctamente.\nEl usuario MySQL con nombre '$2' fue creado correctamente.\nLa contraseña '$3' fue asignada correctamente al usuario MySQL con nombre '$2'.\nLos permisos para el manejo de la base de datos '$1' fueron asignados al usuario '$2' correctamente.\n\nYa deberías poder usar la base de datos normalmente con las siguientes credenciales:\n\nUsuario: $1\nContraseña: $3\n\n----------\n"
fi

