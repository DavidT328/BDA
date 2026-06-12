#!/bin/bash

# Verificar si el script se está ejecutando como root (sudo)
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script usando sudo:"
  echo "sudo $0"
  exit 1
fi

# Ruta donde se guardará el archivo
OUTPUT_FILE="/etc/profile.d/99-custom-env.sh"

echo "Creando el archivo de variables de entorno en $OUTPUT_FILE..."

# Escribiendo el contenido
cat << 'EOF' >> "$OUTPUT_FILE"
# Variables de entorno para Oracle.
export ORACLE_HOSTNAME=h-dtc-proy-final.fi.unam  # Cambia tus iniciales aqui.
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/23ai/dbhomeFree
export ORA_INVENTORY=$ORACLE_BASE/oraInventory
export ORACLE_SID=free
export NLS_LANG=American_America.AL32UTF8
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
#alias globales
alias sqlplus='rlwrap sqlplus'
EOF


echo "¡Listo! El archivo se ha creado correctamente."
echo "Para aplicar los cambios en tu sesión actual sin reiniciar, ejecuta:"
echo "source $OUTPUT_FILE"