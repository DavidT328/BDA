Prompt conectando como SYS
connect sys/"Hola1234*" as sysdba

Prompt iniciando en modo nomount
startup nomount

prompt 1. Ejecutar la instrucción create database
whenever sqlerror exit rollback

create database free
  user sys identified by "Hola1234*"
  user system identified by "Hola1234*"
  logfile group 1 (
    '/unam/bda/pf/core/d01/redo01a.log',
    '/unam/bda/pf/core/d02/redo01b.log') size 50m blocksize 512,
  group 2 (
    '/unam/bda/pf/core/d01/redo02a.log',
    '/unam/bda/pf/core/d02/redo02b.log') size 50m blocksize 512,
  group 3 (
    '/unam/bda/pf/core/d01/redo03a.log',
    '/unam/bda/pf/core/d02/redo03b.log') size 50m blocksize 512
  maxloghistory 1
  maxlogfiles 16
  maxlogmembers 3
  maxdatafiles 1024
  character set AL32UTF8
  national character set AL16UTF16
  extent management local
  datafile '/opt/oracle/oradata/FREE/system01.dbf'
    size 500m autoextend on next 10m maxsize 11G
  sysaux datafile '/opt/oracle/oradata/FREE/sysaux01.dbf'
    size 300m autoextend on next 10m maxsize 11G
  default tablespace users
    datafile '/opt/oracle/oradata/FREE/users01.dbf'
    size 50m autoextend on next 10m maxsize 11G
  default temporary tablespace temp_c0_ts
    tempfile '/unam/bda/pf/c0/d01/temp_c0_01.dbf'
    size 20m autoextend on next 1m maxsize 2G
  undo tablespace undo_c1_ts
    datafile '/unam/bda/pf/c1/d01/undo_c1_01.dbf'
    size 100m autoextend on next 5m maxsize 2G
  -- ARQUITECTURA MULTITENANT
  enable pluggable database
    seed
      file_name_convert = ('/opt/oracle/oradata/FREE', '/opt/oracle/oradata/FREE/pdbseed',
                           '/unam/bda/pf/c0/d01', '/opt/oracle/oradata/FREE/pdbseed',
                           '/unam/bda/pf/c1/d01', '/opt/oracle/oradata/FREE/pdbseed')
    system datafiles size 250m autoextend on next 10m maxsize 11G
    sysaux datafiles size 200m autoextend on next 10m maxsize 11G
  local undo on
;

prompt 2. Homologando passwords
alter user sys identified by "Hola1234*";
alter user system identified by "Hola1234*";

prompt Listo!
exit
