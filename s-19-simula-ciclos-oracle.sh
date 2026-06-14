#!/bin/bash
# s-19-simula-ciclos.sh
# Descripción: Simulación de ciclos de backups para la plataforma de Streaming

echo "Compilando el procedimiento de carga y habilitando BCT"
sqlplus -s sys/\"Hola1234\*\" as sysdba @s-18-procedimiento-simulacion.sql

echo " Configurando parametros de RMAN"
rman target / cmdfile=s-17-configuracion-respaldos.rman

echo "==>Domingo: Backup Incremental Nivel 0 (Base)"
rman target / << EOF
backup incremental level 0 database tag backup_streaming_n0;
exit;
EOF

echo "==>Lunes: Carga de usuarios normales viendo peliculas"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(50);
EXIT;
EOF

echo "==> Martes: Backup Incremental N1 Diferencial"
rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_mar;
exit;
EOF

echo "==> Miercoles: Simulando trafico medio"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(100);
EXIT;
EOF

echo "==> Jueves: Generando Backup Incremental N1 Cumulativo"
rman target / << EOF
backup incremental level 1 cumulative database tag backup_streaming_n1c_jue;
exit;
EOF

echo "==> Simulación de la estrategia completada con exito."