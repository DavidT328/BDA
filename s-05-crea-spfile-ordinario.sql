Prompt Conectando como sys empleando archivo de passwords
connect sys/Hola1234* as sysdba

Prompt  creando el SPFILE a partir del PFILE
create spfile from pfile;

Prompt verificando su existencia.
!ls ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora

Prompt Listo!
exit