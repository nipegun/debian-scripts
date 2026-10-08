#!/bin/bash

# Pongo a disposición pública este script bajo el término de "software de dominio público".
# Puedes hacer lo que quieras con él porque es libre de verdad; no libre con condiciones como las licencias GNU y otras patrañas similares.
# Si se te llena la boca hablando de libertad entonces hazlo realmente libre.
# No tienes que aceptar ningún tipo de términos de uso o licencia para utilizarlo o modificarlo porque va sin CopyLeft.

# ----------
# Script de NiPeGun para crear los alias de los debian-scripts 
# ----------

# Definir constantes de color
  cColorAzul='\033[0;34m'
  cColorAzulClaro='\033[1;34m'
  cColorVerde='\033[1;32m'
  cColorRojo='\033[1;31m'
  # Para el color rojo también:
    #echo "$(tput setaf 1)Mensaje en color rojo. $(tput sgr 0)"
  cFinColor='\033[0m'

echo ""
echo -e "${cColorAzulClaro}  Creando alias para los debian-scripts...${cFinColor}"
echo ""

ln -s ~/scripts/debian-scripts/Externos/VelocidadDeInternet.sh                      ~/scripts/debian-scripts/Alias/vdi

ln -s ~/scripts/debian-scripts/Sistema/RepararPartición.sh                                  ~/scripts/debian-scripts/Alias/rp
ln -s ~/scripts/debian-scripts/Sistema/Archivo-Borrar.sh                                    ~/scripts/debian-scripts/Alias/del
ln -s ~/scripts/debian-scripts/Sistema/EditarInterfacesDeRed.sh                             ~/scripts/debian-scripts/Alias/eidr
ln -s ~/scripts/debian-scripts/ZeroTier.sh                                          ~/scripts/debian-scripts/Alias/zt
ln -s ~/scripts/debian-scripts/MumbleServer-Editar.sh                               ~/scripts/debian-scripts/Alias/emumble
ln -s ~/scripts/debian-scripts/EditarUHUB.sh                                        ~/scripts/debian-scripts/Alias/euhub
ln -s ~/scripts/debian-scripts/MidnightCommander-Abrir.sh                           ~/scripts/debian-scripts/Alias/amc
ln -s ~/scripts/debian-scripts/ADministrarUsuariosDElSERvidorCALibre.sh             ~/scripts/debian-scripts/Alias/adudelsercal
ln -s ~/scripts/debian-scripts/AgregarAlMailElUsuario.sh                            ~/scripts/debian-scripts/Alias/aameu
ln -s ~/scripts/debian-scripts/BloquearTráficoDeTORConIPTables.sh                   ~/scripts/debian-scripts/Alias/btdtorcipt
ln -s ~/scripts/debian-scripts/Sistema/BorrarArchivosDSStore.sh                             ~/scripts/debian-scripts/Alias/badss
ln -s ~/scripts/debian-scripts/Sistema/BorrarArchivosPuntoGuiónBajo.sh                      ~/scripts/debian-scripts/Alias/bapgb
ln -s ~/scripts/debian-scripts/Sistema/BorrarArchivosZoneIdentifier.sh                      ~/scripts/debian-scripts/Alias/bazi
ln -s ~/scripts/debian-scripts/Sistema/BorrarKernelsViejos.sh                               ~/scripts/debian-scripts/Alias/bkv
ln -s ~/scripts/debian-scripts/Sistema/BorrarTAGsMP3.sh                                     ~/scripts/debian-scripts/Alias/btagmp3
ln -s ~/scripts/debian-scripts/Sistema/BorrarUsuarioYHome.sh                                ~/scripts/debian-scripts/Alias/buyh
ln -s ~/scripts/debian-scripts/Sistema/BuscarArchivoEnElSistema.sh                          ~/scripts/debian-scripts/Alias/baees
ln -s ~/scripts/debian-scripts/Sistema/BuscarCarpetaEnElSistema.sh                          ~/scripts/debian-scripts/Alias/bcees
ln -s ~/scripts/debian-scripts/Sistema/BuscarTextoEnArchivos.sh                             ~/scripts/debian-scripts/Alias/btea
ln -s ~/scripts/debian-scripts/Sistema/BuscarTextoEnArchivosDeSistema.sh                    ~/scripts/debian-scripts/Alias/bteads
ln -s ~/scripts/debian-scripts/Sistema/BuscarTextoEnNombreDeArchivos.sh                     ~/scripts/debian-scripts/Alias/btenda
ln -s ~/scripts/debian-scripts/Sistema/BuscarTextoEnScripts.sh                              ~/scripts/debian-scripts/Alias/btes
ln -s ~/scripts/debian-scripts/Sistema/BuscarYReemplazarTextoEnArchivosDeSistema.sh         ~/scripts/debian-scripts/Alias/byrteads
ln -s ~/scripts/debian-scripts/Sistema/CambiarNombreDeUsuario.sh                            ~/scripts/debian-scripts/Alias/cndu
ln -s ~/scripts/debian-scripts/Sistema/CompilarEInstalarElÚltimoKernelEstable.sh            ~/scripts/debian-scripts/Alias/ceieuke
ln -s ~/scripts/debian-scripts/Sistema/ComprobarSSD.sh                                      ~/scripts/debian-scripts/Alias/cssd
ln -s ~/scripts/debian-scripts/Sistema/DejarSóloElKernelMásReciente.sh                      ~/scripts/debian-scripts/Alias/dsekmr
ln -s ~/scripts/debian-scripts/DScripts-Sincronizar.sh                              ~/scripts/debian-scripts/Alias/sinds
ln -s ~/scripts/debian-scripts/Sistema/EjecutarComo.sh                                      ~/scripts/debian-scripts/Alias/ec
ln -s ~/scripts/debian-scripts/ExtraerSubtítuloDeMKV.sh                             ~/scripts/debian-scripts/Alias/esdmkv
ln -s ~/scripts/debian-scripts/Sistema/MostrarFrecuenciaCPU.sh                              ~/scripts/debian-scripts/Alias/mfcpu
ln -s ~/scripts/debian-scripts/Sistema/Grub-Editar.sh                                       ~/scripts/debian-scripts/Alias/egrub
ln -s ~/scripts/debian-scripts/Sistema/Grupos-Mostrar.sh                                    ~/scripts/debian-scripts/Alias/grupos
ln -s ~/scripts/debian-scripts/HAProxy-Editar.sh                                    ~/scripts/debian-scripts/Alias/ehaproxy
ln -s ~/scripts/debian-scripts/Sistema/Hardware-Info.sh                                     ~/scripts/debian-scripts/Alias/hi
ln -s ~/scripts/debian-scripts/Sistema/Hardware-InfoDisco.sh                                ~/scripts/debian-scripts/Alias/hidis
ln -s ~/scripts/debian-scripts/Sistema/Hardware-InfoGráfica.sh                              ~/scripts/debian-scripts/Alias/higra
ln -s ~/scripts/debian-scripts/Sistema/Hardware-InfoProcesador.sh                           ~/scripts/debian-scripts/Alias/hipro
ln -s ~/scripts/debian-scripts/Sistema/Hardware-InfoRAM.sh                                  ~/scripts/debian-scripts/Alias/hiram
ln -s ~/scripts/debian-scripts/Sistema/Hardware-InfoRed.sh                                  ~/scripts/debian-scripts/Alias/hired
ln -s ~/scripts/debian-scripts/Sistema/IMPrimir.sh                                          ~/scripts/debian-scripts/Alias/imp
ln -s ~/scripts/debian-scripts/Sistema/IMPrimirArchivo.sh                                   ~/scripts/debian-scripts/Alias/impa
ln -s ~/scripts/debian-scripts/InfoNodoLitecoin.sh                                  ~/scripts/debian-scripts/Alias/inl
ln -s ~/scripts/debian-scripts/Sistema/InfoShell.sh                                         ~/scripts/debian-scripts/Alias/is
ln -s ~/scripts/debian-scripts/Sistema/LanzarEscritorio.sh                                  ~/scripts/debian-scripts/Alias/le
ln -s ~/scripts/debian-scripts/ListarNodosTORQueEntran.sh                           ~/scripts/debian-scripts/Alias/lntorqe
ln -s ~/scripts/debian-scripts/Sistema/LogsDelSistema-Mostrar.sh                            ~/scripts/debian-scripts/Alias/slog
ln -s ~/scripts/debian-scripts/Sistema/Mail-Enviar-Texto-UsandoMail.sh                      ~/scripts/debian-scripts/Alias/metum
ln -s ~/scripts/debian-scripts/Sistema/MonitorizarLog.sh                                    ~/scripts/debian-scripts/Alias/ml
ln -s ~/scripts/debian-scripts/Sistema/MostrarAparatosConectadosAlRouterDebian.sh           ~/scripts/debian-scripts/Alias/macard
ln -s ~/scripts/debian-scripts/Sistema/MostrarAparatosConectadosEnLaInterfaz.sh             ~/scripts/debian-scripts/Alias/maceli
ln -s ~/scripts/debian-scripts/Sistema/MostrarContenidoDelPaquete.sh                        ~/scripts/debian-scripts/Alias/mcdp
ln -s ~/scripts/debian-scripts/Sistema/MostrarIPLAN.sh                                      ~/scripts/debian-scripts/Alias/miplan
ln -s ~/scripts/debian-scripts/Sistema/MostrarIPWAN.sh                                      ~/scripts/debian-scripts/Alias/mipwan
ln -s ~/scripts/debian-scripts/Sistema/MostrarKernelsInstalados.sh                          ~/scripts/debian-scripts/Alias/mki
ln -s ~/scripts/debian-scripts/Sistema/MostrarMódulosCargados.sh                            ~/scripts/debian-scripts/Alias/mmc
ln -s ~/scripts/debian-scripts/Sistema/MostrarReglasIPTablesActivas.sh                      ~/scripts/debian-scripts/Alias/mripta
ln -s ~/scripts/debian-scripts/Sistema/MostrarSetsIPSet.sh                                  ~/scripts/debian-scripts/Alias/msips
ln -s ~/scripts/debian-scripts/Sistema/MostrarUsuariosDelGrupo.sh                           ~/scripts/debian-scripts/Alias/mudg
ln -s ~/scripts/debian-scripts/MostrarVelocidadDeCargaDeLaWeb.sh                    ~/scripts/debian-scripts/Alias/mvdcdlw
ln -s ~/scripts/debian-scripts/MostrarVersiónDeDebian.sh                            ~/scripts/debian-scripts/Alias/mvdd
ln -s ~/scripts/debian-scripts/MySQL-BaseDeDatos-Crear.sh                           ~/scripts/debian-scripts/Alias/cbddyu
ln -s ~/scripts/debian-scripts/MySQL-BaseDeDatos-Exportar.sh                        ~/scripts/debian-scripts/Alias/ebdd
ln -s ~/scripts/debian-scripts/MySQL-BaseDeDatos-Importar.sh                        ~/scripts/debian-scripts/Alias/ibdd
ln -s ~/scripts/debian-scripts/NotificarFalloDeDisco.sh                             ~/scripts/debian-scripts/Alias/nfdd
ln -s ~/scripts/debian-scripts/NuevaWebVarWWW.sh                                    ~/scripts/debian-scripts/Alias/nwvwww
ln -s ~/scripts/debian-scripts/Sistema/PCIPassThrough-Editar.sh                             ~/scripts/debian-scripts/Alias/epcip
ln -s ~/scripts/debian-scripts/Sistema/Proceso-Matar.sh                                     ~/scripts/debian-scripts/Alias/mp
ln -s ~/scripts/debian-scripts/Plex-Editar.sh                                       ~/scripts/debian-scripts/Alias/eplex
ln -s ~/scripts/debian-scripts/Sistema/ProcesosCorriendo.sh                                 ~/scripts/debian-scripts/Alias/pc
ln -s ~/scripts/debian-scripts/Sistema/ProcesosCorriendoEnÁrbol.sh                          ~/scripts/debian-scripts/Alias/pcea
ln -s ~/scripts/debian-scripts/Sistema/PuertosAbiertos.sh                                   ~/scripts/debian-scripts/Alias/pa
ln -s ~/scripts/debian-scripts/Sistema/QuéInstalóElPaquete.sh                               ~/scripts/debian-scripts/Alias/qiep
ln -s ~/scripts/debian-scripts/RepararPermisosVarWWW.sh                             ~/scripts/debian-scripts/Alias/rpvwww
ln -s ~/scripts/debian-scripts/Sistema/RetenerKernels.sh                                    ~/scripts/debian-scripts/Alias/rk
ln -s ~/scripts/debian-scripts/Sistema/RPMDeDisco.sh                                        ~/scripts/debian-scripts/Alias/rpmdd
ln -s ~/scripts/debian-scripts/Samba-Editar.sh                                      ~/scripts/debian-scripts/Alias/esamba
ln -s ~/scripts/debian-scripts/Sistema/ServiciosEnEJecución.sh                              ~/scripts/debian-scripts/Alias/seej
ln -s ~/scripts/debian-scripts/Sistema/SistemaOperativo-Actualizar.sh                       ~/scripts/debian-scripts/Alias/aso
ln -s ~/scripts/debian-scripts/Sistema/SistemaOperativo-ActualizarYApagar.sh                ~/scripts/debian-scripts/Alias/asoya
ln -s ~/scripts/debian-scripts/Sistema/SistemaOperativo-ActualizarYReiniciar.sh             ~/scripts/debian-scripts/Alias/asoyr
ln -s ~/scripts/debian-scripts/Sistema/SistemaOperativo-Apagar.sh                           ~/scripts/debian-scripts/Alias/apso
ln -s ~/scripts/debian-scripts/Sistema/SistemaOperativo-Reiniciar.sh                        ~/scripts/debian-scripts/Alias/rso
ln -s ~/scripts/debian-scripts/TelegramIT.sh                                        ~/scripts/debian-scripts/Alias/tit
ln -s ~/scripts/debian-scripts/TelegramITFile.sh                                    ~/scripts/debian-scripts/Alias/titf
ln -s ~/scripts/debian-scripts/Sistema/Terminal-Limpiar.sh                                  ~/scripts/debian-scripts/Alias/cls
ln -s ~/scripts/debian-scripts/Sistema/Texto-BuscarYReemplazarEnArchivosDeTodoElSistema.sh  ~/scripts/debian-scripts/Alias/tbyreadtes
ln -s ~/scripts/debian-scripts/Sistema/Texto-BuscarEnContenidosDeArchivosDeLaCarpeta.sh     ~/scripts/debian-scripts/Alias/tbecdadlc
ln -s ~/scripts/debian-scripts/Sistema/Texto-BuscarEnContenidosDeArchivosDeTodoElSistema.sh ~/scripts/debian-scripts/Alias/tbecdadtes
ln -s ~/scripts/debian-scripts/Sistema/Texto-BuscarEnNombresDeArchivosDeLaCarpeta.sh        ~/scripts/debian-scripts/Alias/tbendadlc
ln -s ~/scripts/debian-scripts/Sistema/Texto-BuscarEnNombresDeArchivosDeTodoElSistema.sh    ~/scripts/debian-scripts/Alias/tbendadtes
ln -s ~/scripts/debian-scripts/Sistema/TransmissionDaemon-Editar.sh                         ~/scripts/debian-scripts/Alias/etransmission
ln -s ~/scripts/debian-scripts/Sistema/TRIM.sh                                              ~/scripts/debian-scripts/Alias/trim
ln -s ~/scripts/debian-scripts/Sistema/UsuarioNuevoConShell.sh                              ~/scripts/debian-scripts/Alias/uncs
ln -s ~/scripts/debian-scripts/Sistema/UsuarioNuevoSinShell.sh                              ~/scripts/debian-scripts/Alias/unss
ln -s ~/scripts/debian-scripts/Sistema/Usuarios.sh                                          ~/scripts/debian-scripts/Alias/u
ln -s ~/scripts/debian-scripts/Sistema/VelocidadDeDiscoDeSistema.sh                         ~/scripts/debian-scripts/Alias/vddds
ln -s ~/scripts/debian-scripts/Sistema/VerEstadoDeServicio.sh                               ~/scripts/debian-scripts/Alias/veds
ln -s ~/scripts/debian-scripts/Sistema/VersiónDeDebian.sh                                   ~/scripts/debian-scripts/Alias/vdd
ln -s ~/scripts/debian-scripts/Sistema/VerLogEnTiempoReal.sh                                ~/scripts/debian-scripts/Alias/vletr
ln -s ~/scripts/debian-scripts/Sistema/WinDir.sh                                            ~/scripts/debian-scripts/Alias/wd
ln -s ~/scripts/debian-scripts/WireGuard-Editar.sh                                  ~/scripts/debian-scripts/Alias/ewireguard

ln -s ~/scripts/debian-scripts/router/EditarDHCP.sh                                 ~/scripts/debian-scripts/Alias/edhcp
ln -s ~/scripts/debian-scripts/router/EditarHOSTAPD.sh                              ~/scripts/debian-scripts/Alias/ehostapd
ln -s ~/scripts/debian-scripts/router/MostrarAparatosConectados.sh                  ~/scripts/debian-scripts/Alias/mac
ln -s ~/scripts/debian-scripts/router/EditarOpenVPN.sh                              ~/scripts/debian-scripts/Alias/eovpn

echo ""
echo -e "${cColorVerde}    Alias creados. Deberías poder ejecutar los debian-scripts escribiendo el nombre de su alias.${cFinColor}"
echo ""

