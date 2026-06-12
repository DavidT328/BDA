--- tamanio y ubicacion
alter system set db_recovery_file_dest_size = 2g scope=both;
alter system set db_recovery_file_dest = '/unam/bda/pf/fra' scope=both;

-- copia a redologs
alter system set log_archive_dest_1 = 'location=use_db_recovery_file_dest' scope=both;

-- retencion flashback logs de 24 horas
alter system set db_flashback_retention_target = 1440 scope=both;

-- multiplexeo
alter database add logfile member '/unam/bda/pf/fra/redo01c.log' to group 1;
alter database add logfile member '/unam/bda/pf/fra/redo02c.log' to group 2;
alter database add logfile member '/unam/bda/pf/fra/redo03c.log' to group 3;

-- consulta ubicacion actual (Solo de carácter informativo)
select name from v$controlfile;

-- nueva ruta 
alter system set control_files = 
  '/opt/oracle/oradata/FREE/control01.ctl', 
  '/unam/bda/pf/fra/control02.ctl' 
scope=spfile;

-- reincio para realizar la copia física
shutdown immediate;

-- copia física desde el host de
!sudo cp /opt/oracle/oradata/FREE/control01.ctl /unam/bda/pf/fra/control02.ctl

-- Levantar la base para encender características
startup mount;

-- habilitar el modo archivelog
alter database archivelog;

-- habilitar la característica flashback
alter database flashback on;

-- abrir la base de datos
alter database open;
exit;