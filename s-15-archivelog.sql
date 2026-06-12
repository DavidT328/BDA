-- A. Autenticar como sysdba (se asume ejecución previa de connect)
connect sys/"Hola1234*" as sysdba

-- B. Respaldo del SPFILE
CREATE PFILE='/tmp/initFREE_backup.ora' FROM SPFILE;

-- C. Configuración procesos ARCn
ALTER SYSTEM SET log_archive_max_processes=2 SCOPE=BOTH;

-- D. Configurar 2 destinos (disk_a es obligatorio/MANDATORY)
-- E. Configurar formato de nombre
ALTER SYSTEM SET log_archive_format='arch_free_%t_%s_%r.arc' SCOPE=SPFILE;


alter system set log_archive_dest_2 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST OPTIONAL' scope=spfile;
alter system set log_archive_dest_1 = 'location=/unam/bda/pf/archivelogs_secundarios/ MANDATORY' scope=spfile;


-- F. Asegurar éxito con al menos una copia (mínimo 1 requerido)
ALTER SYSTEM SET log_archive_min_succeed_dest=1 SCOPE=BOTH;

-- G. Detener e iniciar en modo archivelog
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

-- H. Comprobación
ARCHIVE LOG LIST;

-- I. Respaldo final
CREATE PFILE='/tmp/initFREE_final.ora' FROM SPFILE;

-- J. Evento de archivado manual (P4: ALTER SYSTEM ARCHIVE LOG CURRENT)
ALTER SYSTEM ARCHIVE LOG CURRENT;

-- L. Consulta de estado de archivos
COL name FORMAT A60
SELECT name, dest_id, sequence#, status 
FROM v$archived_log;
