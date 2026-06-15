--@Autor: Erick Nava Santiago y David Tavera Castillo
--@Descripción: creacion del spfile
Prompt Conectando como sys empleando archivo de passwords
connect sys/Hola1234* as sysdba

Prompt  creando el SPFILE a partir del PFILE
create spfile from pfile;

Prompt verificando su existencia.
!ls ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora

Prompt Listo!
exit
