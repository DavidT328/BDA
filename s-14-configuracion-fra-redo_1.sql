connect sys/"Hola1234*" as sysdba

-- Tamanio y ubicacion del area de recuperacion rapida
alter system set db_recovery_file_dest_size = 4g scope=both;
alter system set db_recovery_file_dest = '/unam/bda/pf/c0/fra' scope=both;

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;


-- Retencion flashback logs de 24 horas (expresado en minutos)
alter database flashback on;
alter system set db_flashback_retention_target = 1440 scope=both;


alter database add logfile group 4 size 80M blocksize 512;
alter database add logfile group 5 size 80M blocksize 512;
alter database add logfile group 6 size 80M blocksize 512;


--miembros para el grupo 4
alter database add logfile member '/unam/bda/pf/c0/d02/redo04a.log' to group 4;
alter database add logfile member '/unam/bda/pf/c0/d03/redo04b.log' to group 4;
--miembros para el grupo 5
alter database add logfile member '/unam/bda/pf/c0/d02/redo05a.log' to group 5;
alter database add logfile member '/unam/bda/pf/c0/d03/redo05b.log' to group 5;
--miembros para el grupo 6
alter database add logfile member '/unam/bda/pf/c0/d02/redo06a.log' to group 6;
alter database add logfile member '/unam/bda/pf/c0/d03/redo06b.log' to group 6;


alter system switch logfile;
alter system switch logfile;
alter system switch logfile;
alter system switch logfile;


alter system checkpoint;

SELECT l.group#, l.status AS estado_grupo, lf.member AS ruta_archivo FROM v$log l JOIN v$logfile lf ON l.group# = lf.group# ORDER BY l.group#, lf.member;





alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;