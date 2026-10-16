#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para preparás el menú de ciberseguridad en Mate
#
# Ejecución remota:
#   curl -sL https://raw.githubusercontent.com/nipegun/debian-scripts/refs/heads/main/PostInstDebian/GUI/Escritorio-Mate-Menu-Ciberseguridad-Crear.sh | bash
# ----------

# Definir constantes de color
  cColorAzul="\033[0;34m"
  cColorAzulClaro="\033[1;34m"
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

  # Definir fecha de ejecución del script
    cFechaDeEjec=$(date +a%Ym%md%d@%T)

  # Comprobar si el paquete dialog está instalado. Si no lo está, instalarlo.
    if [[ $(dpkg-query -s dialog 2>/dev/null | grep installed) == "" ]]; then
      echo ""
      echo -e "${cColorRojo}  El paquete dialog no está instalado. Iniciando su instalación...${cFinColor}"
      echo ""
      apt-get -y update && apt-get -y install dialog
      echo ""
    fi

  # Crear el menú
    #menu=(dialog --timeout 5 --checklist "Marca las opciones que quieras instalar:" 22 96 16)
    menu=(dialog --checklist "Marca las opciones que quieras instalar:" 22 96 16)
      opciones=(
        1 "Crear los iconos para lanzar las aplicaciones"        on
        2 "Crear las subcarpetas del menú"                       on
        3 "Crear el menú con lanzadores, subcarpetas y carpetas" on
        4 "Opción 4" off
        5 "Opción 5" off
      )
    choices=$("${menu[@]}" "${opciones[@]}" 2>&1 >/dev/tty)
    #clear

    for choice in $choices
      do
        case $choice in

          1)

            echo ""
            echo "  Creando los iconos para lanzar las aplicaciones..."
            echo ""
            # ~/.local/share/applications/, para menú de usuario o /usr/share/applications, para menú del sistema.

            # testdisk
              echo '[Desktop Entry]'                          > ~/.local/share/applications/testdisk.desktop
              echo 'Type=Application'                        >> ~/.local/share/applications/testdisk.desktop
              echo 'Name=testdisk'                           >> ~/.local/share/applications/testdisk.desktop
              echo 'Exec=/bin/testdisk'                      >> ~/.local/share/applications/testdisk.desktop
              echo 'Icon=utilities-terminal'                 >> ~/.local/share/applications/testdisk.desktop
              echo 'Categories=Cybersecurity;Data recovery;' >> ~/.local/share/applications/testdisk.desktop

          ;;

          2)

            echo ""
            echo "  Creando las subcarpetas del menú..."
            echo ""

            # Crear carpeta del meú
              echo '#!/usr/bin/env xdg-open'     > ~/.local/share/desktop-directories/cybersecurity.directory
              echo '[Desktop Entry]'            >> ~/.local/share/desktop-directories/cybersecurity.directory
              echo 'Version=1.0'                >> ~/.local/share/desktop-directories/cybersecurity.directory
              echo 'Type=Directory'             >> ~/.local/share/desktop-directories/cybersecurity.directory
              echo 'Name[es_ES]=Ciberseguridad' >> ~/.local/share/desktop-directories/cybersecurity.directory
              echo 'Name=Cybersecurity'         >> ~/.local/share/desktop-directories/cybersecurity.directory
              echo 'Icon=security'              >> ~/.local/share/desktop-directories/cybersecurity.directory

              # Subcarpeta Forensicsú
                echo '#!/usr/bin/env xdg-open'  > ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo '[Desktop Entry]'         >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Version=1.0'             >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Type=Directory'          >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Name[es_ES]=Forénsica'   >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Name=Forensics'          >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory

              # Subcarpeta Data Recovey
                echo '#!/usr/bin/env xdg-open'            > ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo '[Desktop Entry]'                   >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Version=1.0'                       >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Type=Directory'                    >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Name[es_ES]=Recuperación de datos' >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory
                echo 'Name=Data recovery'                >> ~/.local/share/desktop-directories/cybersecurity-forensics.directory

          ;;

          3)

            echo ""
            echo "  Crear el menú con lanzadores, subcarpetas y carpetas..."
            echo ""

            # Agregar la sección a categorías
              rm -f ~/.config/menus/mate-settings.menu
              echo '<Menu>'                                                                    > ~/.config/menus/mate-settings.menu
              echo '  <Name>Desktop</Name>'                                                   >> ~/.config/menus/mate-settings.menu
              echo '  <MergeFile type="parent">/etc/xdg/menus/mate-settings.menu</MergeFile>' >> ~/.config/menus/mate-settings.menu
              echo '</Menu>'                                                                  >> ~/.config/menus/mate-settings.menu

              rm -f /.config/menus/mate-applications.menu
              echo '<Menu>'                                                                        > ~/.config/menus/mate-applications.menu
              echo '  <Name>Applications</Name>'                                                  >> ~/.config/menus/mate-applications.menu
              echo '  <MergeFile type="parent">/etc/xdg/menus/mate-applications.menu</MergeFile>' >> ~/.config/menus/mate-applications.menu
              echo '  <DefaultLayout inline="false"/>'                                            >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '  <Menu>'                                                                     >> ~/.config/menus/mate-applications.menu
              echo '    <Name>Cybersecurity</Name>'                                               >> ~/.config/menus/mate-applications.menu
              echo '    <Directory>cybersecurity.directory</Directory>'                           >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '    <Menu>'                                                                   >> ~/.config/menus/mate-applications.menu
              echo '      <Name>cybersecurity-forensics</Name>'                                   >> ~/.config/menus/mate-applications.menu
              echo '      <Directory>cybersecurity-forensics.directory</Directory>'               >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '      <Include>'                                                              >> ~/.config/menus/mate-applications.menu
              echo '        <Filename>dd.desktop</Filename>'                                      >> ~/.config/menus/mate-applications.menu
              echo '      </Include>'                                                             >> ~/.config/menus/mate-applications.menu
              echo '      <Layout>'                                                               >> ~/.config/menus/mate-applications.menu
              echo '        <Merge type="menus"/>'                                                >> ~/.config/menus/mate-applications.menu
              echo '        <Filename>dd.desktop</Filename>'                                      >> ~/.config/menus/mate-applications.menu
              echo '        <Merge type="files"/>'                                                >> ~/.config/menus/mate-applications.menu
              echo '      </Layout>'                                                              >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '    </Menu>'                                                                  >> ~/.config/menus/mate-applications.menu
              echo '    <DefaultLayout inline="false"/>'                                          >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '    <Menu>'                                                                   >> ~/.config/menus/mate-applications.menu
              echo '      <Name>cybersecurity-datarecovery</Name>'                                >> ~/.config/menus/mate-applications.menu
              echo '      <Directory>cybersecurity-datarecovery.directory</Directory>'            >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '      <Include>'                                                              >> ~/.config/menus/mate-applications.menu
              echo '        <Filename>testdisk.desktop</Filename>'                                >> ~/.config/menus/mate-applications.menu
              echo '      </Include>'                                                             >> ~/.config/menus/mate-applications.menu
              echo '      <Layout>'                                                               >> ~/.config/menus/mate-applications.menu
              echo '        <Merge type="menus"/>'                                                >> ~/.config/menus/mate-applications.menu
              echo '        <Filename>testdisk.desktop</Filename>'                                >> ~/.config/menus/mate-applications.menu
              echo '        <Merge type="files"/>'                                                >> ~/.config/menus/mate-applications.menu
              echo '      </Layout>'                                                              >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '    </Menu>'                                                                  >> ~/.config/menus/mate-applications.menu
              echo '    <Include>'                                                                >> ~/.config/menus/mate-applications.menu
              echo '      <Filename>gparted.desktop</Filename>'                                   >> ~/.config/menus/mate-applications.menu
              echo '    </Include>'                                                               >> ~/.config/menus/mate-applications.menu
              echo '    <Layout>'                                                                 >> ~/.config/menus/mate-applications.menu
              echo '      <Merge type="menus"/>'                                                  >> ~/.config/menus/mate-applications.menu
              echo '      <Menuname>cybersecurity-forensics</Menuname>'                           >> ~/.config/menus/mate-applications.menu
              echo '      <Menuname>cybersecurity-datarecovery</Menuname>'                        >> ~/.config/menus/mate-applications.menu
              echo '      <Filename>gparted.desktop</Filename>'                                   >> ~/.config/menus/mate-applications.menu
              echo '      <Merge type="files"/>'                                                  >> ~/.config/menus/mate-applications.menu
              echo '    </Layout>'                                                                >> ~/.config/menus/mate-applications.menu
              echo ''                                                                             >> ~/.config/menus/mate-applications.menu
              echo '  </Menu>'                                                                    >> ~/.config/menus/mate-applications.menu
              echo '  <Layout>'                                                                   >> ~/.config/menus/mate-applications.menu
              echo '    <Merge type="menus"/>'                                                    >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Universal Access</Menuname>'                                    >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Accessories</Menuname>'                                         >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Collection</Menuname>'                                          >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Education</Menuname>'                                           >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Graphics</Menuname>'                                            >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>System</Menuname>'                                              >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Internet</Menuname>'                                            >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Games</Menuname>'                                               >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Office</Menuname>'                                              >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Other</Menuname>'                                               >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Development</Menuname>'                                         >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Multimedia</Menuname>'                                          >> ~/.config/menus/mate-applications.menu
              echo '    <Menuname>Cybersecurity</Menuname>'                                       >> ~/.config/menus/mate-applications.menu
              echo '    <Merge type="files"/>'                                                    >> ~/.config/menus/mate-applications.menu
              echo '  </Layout>'                                                                  >> ~/.config/menus/mate-applications.menu
              echo '</Menu>'                                                                      >> ~/.config/menus/mate-applications.menu

              # Copiar la primera app para que se muestre el menú
                cp '/usr/share/applications/gparted.desktop' ~/.local/share/applications/

              # Re-lanzar el panel
                mate-panel --replace &

          ;;

          4)

            echo ""
            echo "  Opción 4..."
            echo ""

          ;;

          5)

            echo ""
            echo "  Opción 5..."
            echo ""

          ;;

      esac

  done



