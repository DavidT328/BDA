# Este archivo no se ejecuta se guarda en 
# nano /etc/profile.d/99-custom-env.sh
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
