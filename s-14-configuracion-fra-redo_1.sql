connect sys/"Hola1234*" as sysdba

-- Tamanio y ubicacion del area de recuperacion rapida
alter system set db_recovery_file_dest_size = 10g scope=both;
alter system set db_recovery_file_dest = '/unam/bda/pf/fra' scope=both;

-- Copia a redologs
alter system set log_archive_dest_1 = 'location=use_db_recovery_file_dest' scope=both;

-- Retencion flashback logs de 24 horas (expresado en minutos)
alter system set db_flashback_retention_target = 1440 scope=both;


alter database add logfile group 4 size 80M blocksize 512;
alter database add logfile group 5 size 80M blocksize 512;
alter database add logfile group 6 size 80M blocksize 512;


--miembros para el grupo 4
alter database add logfile member '/unam/bda/pf/core/d01/redo04a.log' to group 4;
alter database add logfile member '/unam/bda/pf/core/d02/redo04b.log' to group 4;
--miembros para el grupo 5
alter database add logfile member '/unam/bda/pf/core/d01/redo05a.log' to group 5;
alter database add logfile member '/unam/bda/pf/core/d02/redo05b.log' to group 5;
--miembros para el grupo 6
alter database add logfile member '/unam/bda/pf/core/d01/redo06a.log' to group 6;
alter database add logfile member '/unam/bda/pf/core/d02/redo06b.log' to group 6;


alter system switch logfile;
alter system switch logfile;
alter system switch logfile;
alter system switch logfile;


alter system checkpoint;


alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;
