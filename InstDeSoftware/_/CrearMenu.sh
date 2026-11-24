#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

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
          1 "Opción 1" on
          2 "Opción 2" off
          3 "Opción 3" off
          4 "Opción 4" off
          5 "Opción 5" off
        )
      choices=$("${menu[@]}" "${opciones[@]}" </dev/tty 2>&1 >/dev/tty)
      #clear

      for choice in $choices
        do
          case $choice in

            1)

              echo ""
              echo "  Opción 1..."
              echo ""

            ;;

            2)

              echo ""
              echo "  Opción 2..."
              echo ""

            ;;

            3)

              echo ""
              echo "  Opción 3..."
              echo ""

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

