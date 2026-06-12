# Este archivo no se ejecuta se guarda en 
# nano /etc/profile.d/99-custom-env.sh
# Variables de entorno para Oracle.
docker start c-dtc-proy-final

docker exec -u 0 -it c-dtc-proy-final bash

cat << 'EOF' > /etc/profile.d/99-custom-env.sh
alias rman='rlwrap rman'
export NLS_DATE_FORMAT='yyyy/mm/dd hh24:mi:ss'
export UNAM_HOME=/unam
export ORACLE_HOSTNAME=h-dtc-proy-final.fi.unam
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/23ai/dbhomeFree
export ORA_INVENTORY=$ORACLE_BASE/oraInventory
export ORACLE_SID=free
export NLS_LANG=American_America.AL32UTF8
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
alias sqlplus='rlwrap sqlplus'
EOF

chmod 644 /etc/profile.d/99-custom-env.sh

su - oracle

source /etc/profile.d/99-custom-env.sh
