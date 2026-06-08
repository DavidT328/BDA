#!/bin/bash
export ORACLE_SID=free

echo "Creación del diccionario de datos"
echo "Ejecución del script con perl, esperar alrededor de 1 hr"

# Se crea el directorio para los logs si no existe
mkdir -p /tmp/dd-logs
cd ${ORACLE_HOME}/rdbms/admin

# Ejecución del catálogo para arquitectura CDB
perl -I ${ORACLE_HOME}/rdbms/admin \
${ORACLE_HOME}/rdbms/admin/catcdb.pl \
--logDirectory /tmp/dd-logs \
--logFilename dd.log \
--logErrorsFilename dderror.log

echo "Listo!! Verificar la correcta creación del DD"

# Verificación conectándose con autenticación de sistema operativo (/ as sysdba)
sqlplus -s / as sysdba << EOF
set serveroutput on
exec dbms_dictionary_check.full;
EOF

echo "Listo, diccionario de datos compilado y verificado."
