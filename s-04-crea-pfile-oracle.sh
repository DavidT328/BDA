#!/bin/bash
echo "1. Creando un archivo de parámetros básico"
export ORACLE_SID=free
pfile=$ORACLE_HOME/dbs/init${ORACLE_SID}.ora

if [ -f "${pfile}" ]; then
  read -p "El archivo ${pfile} ya existe, [enter] para sobrescribir"
fi;

echo \
"db_name=${ORACLE_SID}
memory_target=2G
control_files=(
  /unam/bda/pf/core/d01/control01.ctl,
  /unam/bda/pf/core/d02/control02.ctl
)
db_domain=fi.unam
enable_pluggable_database=true
" > $pfile

echo "Listo"
echo "Comprobando la existencia y contenido del PFILE"
echo ""
cat ${pfile}
