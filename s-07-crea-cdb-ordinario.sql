prompt Conectando como SYS
connect sys/"Hola1234*" as sysdba

prompt Iniciando en modo nomount
startup nomount

prompt 1. Ejecutar la instruccion create database
whenever sqlerror exit rollback

create database free
    user sys identified by "Hola1234*"
    user system identified by "Hola1234*"
    logfile group 1 (
        '/unam/bda/pf/c0/d02/redo01a.log',
        '/unam/bda/pf/c0/d03/redo01b.log') size 50m blocksize 512,
    group 2 (
        '/unam/bda/pf/c0/d02/redo02a.log',
        '/unam/bda/pf/c0/d03/redo02b.log') size 50m blocksize 512,
    group 3 (
        '/unam/bda/pf/c0/d02/redo03a.log',
        '/unam/bda/pf/c0/d03/redo03b.log') size 50m blocksize 512
    maxloghistory 1
    maxlogfiles 16
    maxlogmembers 3
    maxdatafiles 1024
    character set AL32UTF8
    national character set AL16UTF16
    extent management local
      datafile '/unam/bda/pf/c0/d02/system01.dbf'
        size 500m autoextend on next 10m maxsize 11G
      sysaux datafile '/unam/bda/pf/c0/d02/sysaux01.dbf'
        size 300m autoextend on next 10m maxsize 11G
      default tablespace users
        datafile '/unam/bda/pf/c0/d02/users01.dbf'
        size 50m autoextend on next 10m maxsize 11G
      default temporary tablespace temp_core_ts
        tempfile '/unam/bda/pf/c0/d01/temp_core_01.dbf'
        size 20m autoextend on next 1m maxsize 2G
      undo tablespace undo_core_ts
        datafile '/unam/bda/pf/c0/d01/undo_core_01.dbf'
        size 100m autoextend on next 5m maxsize 2G
      enable pluggable database
        seed
          file_name_convert = ('/unam/bda/pf/c0/d02/', '/unam/bda/pf/c0/d02/pdbseed/',
          		       '/unam/bda/pf/c0/d01/', '/unam/bda/pf/c0/d02/pdbseed/')
        system datafiles size 250m autoextend on next 10m maxsize 11G
        sysaux datafiles size 200m autoextend on next 10m maxsize 11G
      local undo on
;

prompt 2. Homologando passwords
alter user sys identified by "Hola1234*";
alter user system identified by "Hola1234*";

prompt Listo!
exit