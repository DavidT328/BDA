#!/bin/bash
export ORACLE_SID=free

echo "Creación del diccionario de datos"
echo "Ejecución del script con perl, esperar alrededor de 1 hr"

# Se cambia /tmp por tu ruta persistente del proyecto
LOG_DIR="/unam/bda/pf/c0/d03/admin_logs"
mkdir -p ${LOG_DIR}

cd ${ORACLE_HOME}/rdbms/admin

# Ejecución del catálogo para arquitectura CDB
perl -I ${ORACLE_HOME}/rdbms/admin \
${ORACLE_HOME}/rdbms/admin/catcdb.pl \
--logDirectory ${LOG_DIR} \
--logFilename dd.log \
--logErrorsFilename dderror.log

echo "Listo!! Verificar la correcta creación del DD"

# Verificación conectándose con autenticación de sistema operativo (/ as sysdba)
sqlplus -s / as sysdba << EOF
set serveroutput on
exec dbms_dictionary_check.full;
EOF

echo "Listo, diccionario de datos compilado y verificado. Logs guardados en ${LOG_DIR}"