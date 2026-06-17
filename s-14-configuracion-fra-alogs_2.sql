connect sys/"Hola1234*" as sysdba
--configuracion de ruta

ALTER SYSTEM SET log_archive_dest_1='LOCATION=/unam/bda/pf/c0/d03/archivelogs_secundarios/' SCOPE=BOTH;
Alter system set log_archive_dest_2='LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=both;
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