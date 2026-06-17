#!/bin/bash
# s-19-simula-ciclos.sh
# Descripción: Simulación representativa de estrategia trimestral (Semana Normal vs Semana de Estreno)

echo "==> 0. Compilando el procedimiento de carga y habilitando BCT"
sqlplus -s sys/\"Hola1234\*\" as sysdba @s-18-procedimiento-simulacion.sql


# =========================================================
# SEMANA 1: CICLO SEMANAL NORMAL (3 meses)
# =========================================================
echo " "

echo "=== INICIANDO SEMANA 1: CICLO REGULAR ==="

echo "==> DOMINGO: Backup Incremental Nivel 0 "
rman target / << EOF
backup incremental level 0 database tag backup_streaming_n0_dom;
exit;
EOF

# Lunes a Sábado con tráfico regular  y Diferenciales diarios
for dia in LUNES MARTES MIERCOLES JUEVES VIERNES SABADO; do
    echo "-> $dia S1: Tráfico regular y Backup N1-Diferencial"
    sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
    ALTER SESSION SET CONTAINER = media_pdb;
    EXEC simula_carga_streaming(20);
    EXIT;
EOF
    rman target / << EOF
    backup incremental level 1 database tag backup_S1_n1d_${dia};
    exit;
EOF
done

echo "==> DOMINGO: Backup Incremental Nivel 0 "
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
    ALTER SESSION SET CONTAINER = media_pdb;
    EXEC simula_carga_streaming(20);
    EXIT;
EOF
rman target / << EOF
backup incremental level 0 database tag backup_streaming_n0_dom;
exit;
EOF

# =========================================================
# Semana 2 se e./strena una pelicala
# =========================================================
echo " "
echo "=== INICIANDO SEMANA 2: CICLO DE ESTRENO ==="

echo "-> DOMINGO S2: Backup Incremental N0 (Base)"
rman target / << EOF
backup incremental level 0 database tag backup_S2_n0_dom;
exit;
EOF

echo "-> LUNES a MIERCOLES S2: Tráfico regular y Backups N1-Diferenciales"
for dia in LUNES MARTES MIERCOLES; do
    sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
    ALTER SESSION SET CONTAINER = media_pdb;
    EXEC simula_carga_streaming(20);
    EXIT;
EOF
    rman target / << EOF
    backup incremental level 1 database tag backup_S2_n1d_${dia};
    exit;
EOF
done

echo "-> JUEVES S2 (ESTRENO): Tráfico MASIVO y Backup N1-ACUMULATIVO"
sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
ALTER SESSION SET CONTAINER = media_pdb;
EXEC simula_carga_streaming(50);  -- ¡10 veces más tráfico por el estreno!
EXIT;
EOF
rman target / << EOF
backup incremental level 1 cumulative database tag backup_S2_n1c_jue_estreno;
exit;
EOF

echo "-> VIERNES y SABADO S2: Tráfico post-estreno y Backups N1-Diferenciales"
for dia in VIERNES SABADO; do
    sqlplus -s sys/\"Hola1234\*\" as sysdba << EOF
    ALTER SESSION SET CONTAINER = media_pdb;
    EXEC simula_carga_streaming(80);
    EXIT;
EOF
    rman target / << EOF
    backup incremental level 1 database tag backup_S2_n1d_${dia};
    exit;
EOF
done

echo "==> Simulación estratégica completada con éxito."