connect sys/"Hola1234*" as sysdba
alter system set log_archive_dest_2='LOCATION=USE_DB_RECOVERY_FILE_DEST'
scope=both;

-- B. Auditoria de destinos de archivado
SET LINESIZE 180
SET PAGESIZE 50
COL dest_name FORMAT A20
COL status FORMAT A10
COL binding FORMAT A10
COL destination FORMAT A40

SELECT dest_id, dest_name, status, binding, destination
FROM v$archive_dest 
WHERE dest_id IN (1, 2);

-- C. Forzar la generacion de un archivo (Log Switch)
ALTER SYSTEM SWITCH LOGFILE;

-- D. Auditoria de logs archivados (verificacion de ubicacion y bandera FRA)
SET LINESIZE 200
COL name FORMAT A80
COL completion_time FORMAT A20
COL is_recovery_dest_file FORMAT A20

SELECT * FROM (
    SELECT recid, name, dest_id, sequence#,
           TO_CHAR(completion_time, 'yyyy-mm-dd hh24:mi:ss') AS completion_time,
           is_recovery_dest_file
    FROM v$archived_log 
    ORDER BY sequence# DESC
) WHERE ROWNUM <= 4;
