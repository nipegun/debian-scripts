#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para instalar y configurar Fail2Ban en Debian
#
# Ejecución remota (puede requerir permisos sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Fail2Ban-InstalarYConfigurar.sh | bash
#
# Ejecución remota como root (para sistemas sin sudo):
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/InstDeSoftware/ParaCLI/Fail2Ban-InstalarYConfigurar.sh | sed 's-sudo--g' | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
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
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 13 (Trixie)...${cFinColor}"
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
      #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      #menu=(dialog --radiolist "Marca las opciones que quieras instalar:" 22 80 16)      # Selección única
      menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 80 16)
        opciones=(
          1 "Instalar fail2ban"                   on
          2 "  Aplicar configuración nipeguniana" on
          3 "  Activar notificaciones por email"  off
        )
      choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Instalando paquetes de fail2ban..."
              echo ""
              sudo apt-get -y update
              sudo apt-get -y install fail2ban

              # Crear el archivo de log de autenticaciones (Necesario para que inicie el servicio)
                sudo touch /var/log/auth.log

              # Reiniciar el servicio
                sudo systemctl restart fail2ban

            ;;

            2)

              echo ""
              echo "  Aplicando configuración nipeguniana..."
              echo ""
              # Crear el archivo de configuración
              echo "[INCLUDES]"                                            | sudo tee    /etc/fail2ban/filter.d/JaulaInCrescendo.conf
              echo "before = common.conf"                                  | sudo tee -a /etc/fail2ban/filter.d/JaulaInCrescendo.conf
              echo "[Definition]"                                          | sudo tee -a /etc/fail2ban/filter.d/JaulaInCrescendo.conf
              echo "failregex = \]\s+Unban\s+<HOST>"                       | sudo tee -a /etc/fail2ban/filter.d/JaulaInCrescendo.conf
              echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" | sudo tee -a /etc/fail2ban/filter.d/JaulaInCrescendo.conf
              # Crear la jaula
              echo "[DEFAULT]"                                                                         | sudo tee    /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 1 minuto"                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 3"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 1m"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 1m"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo ""                                                                                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "[JaulaInCrescendo2]"                                                               | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# Si ocurren 2 baneos de 1 minuto en 5 minutos, crear un nuevo baneo de 5 minutos" | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "enabled = true"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "filter = JaulaInCrescendo"                                                         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 2"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 5m"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 5m"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "logpath = /var/log/fail2ban.log"                                                   | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo ""                                                                                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "[JaulaInCrescendo3]"                                                               | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# Si ocurren 2 baneos de 5 minutos en 30 minutos, crear un nuevo baneo 30 minutos" | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "enabled = true"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "filter = JaulaInCrescendo"                                                         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 2"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 30m"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 30m"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "logpath = /var/log/fail2ban.log"                                                   | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo ""                                                                                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "[JaulaInCrescendo4]"                                                               | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# Si ocurren 2 baneos de 30 minutos en 1 día, crear un nuevo baneo de 1 día"       | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "enabled = true"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "filter = JaulaInCrescendo"                                                         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 2"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 1d"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 1d"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "logpath = /var/log/fail2ban.log"                                                   | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo ""                                                                                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "[JaulaInCrescendo5]"                                                               | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "enabled = true"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "filter = JaulaInCrescendo"                                                         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 2"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 1w"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 1w"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "logpath = /var/log/fail2ban.log"                                                   | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo ""                                                                                  | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "[JaulaInCrescendo6]"                                                               | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "enabled = true"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "filter = JaulaInCrescendo"                                                         | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "maxretry = 2"                                                                      | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "findtime = 1mo"                                                                    | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "bantime = 1mo"                                                                     | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local
              echo "logpath = /var/log/fail2ban.log"                                                   | sudo tee -a /etc/fail2ban/jail.d/JaulaInCrescendo.local

              # Crear el archivo de log de jaulas (Necesario para que inicie el servicio)
                sudo touch /var/log/fail2ban.log

              # Reiniciar el servicio
                sudo systemctl restart fail2ban

            ;;

            3)

              echo ""
              echo "  Activando notificaciones por email..."
              echo ""
              sudo apt-get -y install sendmail

              # Modificar debian defaults
                echo "[DEFAULT]"                                             | sudo tee    /etc/fail2ban/jail.d/defaults-debian.conf
                echo "banaction = nftables"                                  | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "banaction_allports = nftables[type=allports]"          | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo ""                                                      | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "ignoreip = 127.0.0.1"                                  | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "maxretry = 3"                                          | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "bantime = 10m"                                         | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "findtime = 5m"                                         | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo ""                                                      | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "destemail = tu_correo@gmail.com"                       | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "sender = tu_correo@gmail.com"                          | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "sendername = Fail2Ban"                                 | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "mta = sendmail"                                        | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "action = %(action_mwl)s"                               | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo ""                                                      | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "[sshd]"                                                | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "backend = systemd"                                     | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "journalmatch = _SYSTEMD_UNIT=ssh.service + _COMM=sshd" | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf
                echo "enabled = true"                                        | sudo tee -a /etc/fail2ban/jail.d/defaults-debian.conf

              # Reiniciar el servicio
                sudo systemctl restart fail2ban

            ;;

        esac

    done

elif [ $cVerSO == "12" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 12 (Bookworm)...${cFinColor}"
  echo ""

  echo ""
  echo "  Instalando paquetes..." 
  echo ""
  apt-get -y update
  apt-get -y install fail2ban
  #apt-get -y install sendmail

  # Crear el archivo de configuración
    echo "[INCLUDES]"                                             > /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "before = common.conf"                                  >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "[Definition]"                                          >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "failregex = \]\s+Unban\s+<HOST>"                       >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
  # Crear la jaula
    echo "[DEFAULT]"                                                                          > /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 1 minuto"                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 3"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo2]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 minuto en 5 minutos, crear un nuevo baneo de 5 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 5m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 5m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo3]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 5 minutos en 30 minutos, crear un nuevo baneo 30 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 30m"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 30m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo4]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 30 minutos en 1 día, crear un nuevo baneo de 1 día"       >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1d"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1d"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo5]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1w"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1w"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo6]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1mo"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1mo"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local

  # Modificar debian defaults
    #echo "ignoreip = 127.0.0.1"        >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "maxretry = 3"                >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "bantime = 10m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "findtime = 5m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo ""                            >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "# Mail"                      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#destemail = mail@gmail.com" >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sender = mail@gmail.com"    >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sendername = Fail2Ban"      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#mta = sendmail"             >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#action = %(action_mwl)s"    >> /etc/fail2ban/jail.d/defaults-debian.conf

  # Crear los archivos de logs
    touch /var/log/auth.log      # Necesario para que inicie el servicio
    touch /var/log/fail2ban.log

  # Reiniciar el servicio
    systemctl restart fail2ban
    systemctl --no-pager status fail2ban
    # tail -f /var/log/fail2ban.log

elif [ $cVerSO == "11" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 11 (Bullseye)...${cFinColor}"
  echo ""

  echo ""
  echo "  Instalando paquetes..." 
  echo ""
  apt-get -y update
  apt-get -y install fail2ban
  #apt-get -y install sendmail

  # Crear el archivo de configuración
    echo "[INCLUDES]"                                             > /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "before = common.conf"                                  >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "[Definition]"                                          >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "failregex = \]\s+Unban\s+<HOST>"                       >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
    echo "ignoreregex = \[JaulaInCrescendo.*\]\s+Unban\s+<HOST>" >> /etc/fail2ban/filter.d/JaulaInCrescendo.conf
  # Crear la jaula
    echo "[DEFAULT]"                                                                          > /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# 3 contraseñas erróneas en 1 minuto, crear un baneo de 1 minuto"                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 3"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo2]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 minuto en 5 minutos, crear un nuevo baneo de 5 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 5m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 5m"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo3]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 5 minutos en 30 minutos, crear un nuevo baneo 30 minutos" >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 30m"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 30m"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo4]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 30 minutos en 1 día, crear un nuevo baneo de 1 día"       >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1d"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1d"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo ""                                                                                  >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo5]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 día en 1 semana, crear un nuevo baneo de 1 semana"      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1w"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1w"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "[JaulaInCrescendo6]"                                                               >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "# Si ocurren 2 baneos de 1 semana en 1 mes, crear un nuevo baneo de 1 mes"         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "enabled = true"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "filter = JaulaInCrescendo"                                                         >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "maxretry = 2"                                                                      >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "findtime = 1mo"                                                                    >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "bantime = 1mo"                                                                     >> /etc/fail2ban/jail.d/JaulaInCrescendo.local
    echo "logpath = /var/log/fail2ban.log"                                                   >> /etc/fail2ban/jail.d/JaulaInCrescendo.local

  # Modificar debian defaults
    #echo "ignoreip = 127.0.0.1"        >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "maxretry = 3"                >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "bantime = 10m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "findtime = 5m"               >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo ""                            >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "# Mail"                      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#destemail = mail@gmail.com" >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sender = mail@gmail.com"    >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#sendername = Fail2Ban"      >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#mta = sendmail"             >> /etc/fail2ban/jail.d/defaults-debian.conf
    #echo "#action = %(action_mwl)s"    >> /etc/fail2ban/jail.d/defaults-debian.conf

  # Reiniciar el servicio
    service fail2ban reload
    service fail2ban restart
    # tail -f /var/log/fail2ban.log

elif [ $cVerSO == "10" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 10 (Buster)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 10 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "9" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 9 (Stretch)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 9 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "8" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 8 (Jessie)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 8 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

elif [ $cVerSO == "7" ]; then

  echo ""
  echo -e "${cColorAzulClaro}  Iniciando el script de instalación de Fail2Ban para Debian 7 (Wheezy)...${cFinColor}"
  echo ""

  echo ""
  echo -e "${cColorRojo}    Comandos para Debian 7 todavía no preparados. Prueba ejecutarlo en otra versión de Debian.${cFinColor}"
  echo ""

fi

