--@Autor: Erick Nava Santiago y David Tavera Castillo
--@Descripción: Scriptde consultas

SET LINESIZE 200
SET PAGESIZE 100

prompt === a. datos generales de la instancia ===
col host_name format a25
col instance_name format a15
col version format a15
select host_name, instance_name, version, status, database_status, active_state, con_id 
from v$instance;

prompt === b. datos generales de la cdb ===
col name format a10
col platform_name format a20
select name, created, log_mode, open_mode, platform_name, current_scn, flashback_on, cdb 
from v$database;

prompt === c. datos generales de las pdbs ===
col name format a20
select con_id, name, open_mode, round(total_size / 1024 / 1024 / 1024, 2) as total_size_gb 
from v$pdbs;

prompt === d. datos de los tablespaces de la cdb ===
col tablespace_name format a25
select tablespace_name, status, contents, extent_management, segment_space_management, retention, bigfile, encrypted, con_id 
from cdb_tablespaces;

prompt === e. datos de los datafiles ===
col file_name format a60
select con_id, tablespace_name, file_id, file_name, round(bytes / 1024 / 1024, 2) as size_mb, autoextensible, online_status 
from cdb_data_files
order by con_id, tablespace_name;

prompt === f. características de grupos de redo logs ===
select group#, sequence#, members, archived, status, con_id 
from v$log;

prompt === g. detalle de miembros de redo logs ===
col member format a60
select group#, status, is_recovery_dest_file, type, member, con_id 
from v$logfile;

prompt === h. copias de archivos de control ===
col name format a70
select con_id, status, name, is_recovery_dest_file 
from v$controlfile;

prompt === i. archived redo logs generados ===
col name format a70
select recid, name, dest_id, sequence#, to_char(completion_time, 'dd/mm/yyyy hh24:mi:ss') as completion_time, is_recovery_dest_file, backup_count, con_id 
from v$archived_log 
order by sequence# desc 
fetch first 20 rows only;

prompt === j. uso de la fast recovery area (fra) ===
col file_type format a25
select file_type, percent_space_used, percent_space_reclaimable, number_of_files, con_id 
from v$recovery_area_usage;

prompt === k. backup pieces generadas ===
col handle format a60
col tag format a30
select p.recid, s.backup_type, p.tag, s.controlfile_included, s.pieces as total_pieces, p.piece#, p.copy#, p.device_type, to_char(p.completion_time, 'dd/mm/yyyy hh24:mi:ss') as completion_time, p.handle 
from v$backup_piece p 
join v$backup_set s on p.set_stamp = s.set_stamp and p.set_count = s.set_count
order by p.completion_time desc;

prompt === l. total de backups y espacio ocupado ===
select backup_type, incremental_level, count(*) as num_backups, round(sum(bytes) / 1024 / 1024 / 1024, 2) as total_gb 
from v$backup_set 
group by backup_type, incremental_level;

prompt === m. backups tipo image copy ===
select tag, count(*) as cantidad, round(sum(blocks * block_size) / 1024 / 1024, 2) as total_mb 
from v$datafile_copy 
where tag is not null 
group by tag;

prompt === l. total de backups y espacio ocupado ===
select s.backup_type, s.incremental_level, count(distinct s.set_stamp) as num_backups, round(sum(p.bytes) / 1024 / 1024 / 1024, 2) as total_gb 
from v$backup_set s
join v$backup_piece p on s.set_stamp = p.set_stamp and s.set_count = p.set_count
group by s.backup_type, s.incremental_level;

PROMPT === N. Usuarios del proyecto creados en la CDB ===
col username format a20
col default_tablespace format a20
col temporary_tablespace format a20
select username, account_status, default_tablespace, temporary_tablespace, local_temp_tablespace, to_char(created, 'dd/mm/yyyy hh24:mi:ss') as created, last_login, con_id 
from cdb_users 
where username not in ('SYS','SYSTEM','SYSAUX','OUTLN','DBSNMP', 'APPQOSSYS', 'XDB', 'AUDSYS')
order by created desc;

prompt === o. cuotas de almacenamiento de los usuarios ===
select u.username, q.tablespace_name, round(q.bytes / 1024 / 1024, 2) as charged_mb, q.max_bytes, q.con_id 
from cdb_users u 
join cdb_ts_quotas q on u.username = q.username and u.con_id = q.con_id
where u.username not in ('SYS','SYSTEM');

prompt === p. segmentos, extensiones y mb por tablespace y owner ===
col owner format a20
select tablespace_name, owner, count(*) as total_segmentos, sum(extents) as total_extensiones, round(sum(bytes) / 1024 / 1024, 2) as total_mb, con_id 
from cdb_segments 
where owner not in ('SYS','SYSTEM','XDB','AUDSYS', 'DBSNMP', 'OJVMSYS') 
group by tablespace_name, owner, con_id
order by owner, tablespace_name;

prompt === q. espacio total reservado para el proyecto ===
select round(sum(bytes) / 1024 / 1024, 2) as total_mb_reservado 
from cdb_segments 
where owner not in ('SYS','SYSTEM','XDB','AUDSYS', 'DBSNMP', 'OJVMSYS');