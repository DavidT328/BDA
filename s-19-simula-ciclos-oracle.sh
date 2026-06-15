#!/bin/bash
# s-19-simula-ciclos.sh
# Descripción: Simulación de la semana completa de backups para la plataforma de Streaming

echo "==> 0. Compilando el procedimiento de carga y habilitando BCT"
sqlplus -s sys/\"Hola1234\*\" as sysdba @s-18-procedimiento-simulacion.sql

echo "==> 1. Configurando parametros de RMAN"
rman target / cmdfile=s-17-configuracion-respaldos.rman

echo "==> DOMINGO: Backup Incremental Nivel 0 "
rman target / << EOF
backup incremental level 0 database tag backup_streaming_n0_dom;
exit;
EOF

echo "==> LUNES: Carga de usuarios y Backup N1 Diferencial"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(50);
EXIT;
EOF

rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_lun;
exit;
EOF

echo "MARTES: Carga de usuarios y Backup N1 Diferencial"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(75);
EXIT;
EOF

rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_mar;
exit;
EOF

echo "MIÉRCOLES: Carga de usuarios y Backup N1 Diferencial"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(100);
EXIT;
EOF
rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_mie;
exit;
EOF

echo "JUEVES: Carga de usuarios y Backup N1 CUMULATIVO"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(150);
EXIT;
EOF
rman target / << EOF
backup incremental level 1 cumulative database tag backup_streaming_n1c_jue;
exit;
EOF

echo "VIERNES: Carga de usuarios y Backup N1 Diferencial"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(200);
EXIT;
EOF
rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_vie;
exit;
EOF

echo "SÁBADO: Carga de usuarios y Backup N1 Diferencial"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(300);
EXIT;
EOF
rman target / << EOF
backup incremental level 1 database tag backup_streaming_n1d_sab;
exit;
EOF

echo "==> Simulación de la estrategia semanal completada con exito."