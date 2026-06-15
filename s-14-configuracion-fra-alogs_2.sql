connect sys/"Hola1234*" as sysdba

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

--configuracion de ruta
ALTER SYSTEM SET log_archive_dest_2='LOCATION=/unam/bda/pf/archivelogs_secundarios' SCOPE=BOTH;

--forzado de archivos fisicos
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM SWITCH LOGFILE;

-- check de que los dos esten funcionando
SET LINESIZE 180
COL dest_name FORMAT A20
COL destination FORMAT A40
SELECT dest_id, dest_name, status, destination 
FROM v$archive_dest WHERE dest_id IN (1, 2);

-- --chech
SET LINESIZE 200
COL name FORMAT A80
SELECT name, dest_id, sequence# 
FROM v$archived_log WHERE ROWNUM <= 4 ORDER BY sequence# DESC;

EXIT;