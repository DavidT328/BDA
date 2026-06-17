#!/bin/bash

echo "Proceso de creación de una BD"

echo "1. Configurando ORACLE_SID"
export ORACLE_SID=free

echo "ORACLE_SID: ${ORACLE_SID}"

echo "2. Creando un archivo de passwords usar como password Hola1234*"

if [ -f "${ORACLE_HOME}/dbs/orapw${ORACLE_SID}" ]; then
  read -p "El archivo de parametros ya existe, [enter] para sobrescribir"
fi

# Generando el archivo de passwords
#el password debe ser al menos de 8 caracteres con letras y caracteres
# especiales.  Por ejemplo:  Hola1234*  (no debe contener el nombre de usuario)
orapwd FORCE=Y \
  FILE='${ORACLE_HOME}/dbs/orapw${ORACLE_SID}' \
  FORMAT=12.2 \
  SYS=password password=Hola1234*

echo "Comprobando la creación del archivo"
ls -l $ORACLE_HOME/dbs/orapw${ORACLE_SID}