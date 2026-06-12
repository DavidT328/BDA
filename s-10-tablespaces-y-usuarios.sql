PROMPT 1. USUARIO GLOBAL EN CDB
CONNECT sys/"Hola1234*" as sysdba

PROMPT Creando usuario global c##david_admin...
CREATE USER c##david_admin IDENTIFIED BY "Hola1234*" CONTAINER=ALL;
GRANT DBA TO c##david_admin CONTAINER=ALL;


PROMPT 2. TABLESPACES Y USUARIO EN PDB USUARIOS
ALTER SESSION SET CONTAINER = usuarios_pdb;

PROMPT Creando tablespaces locales para el modulo de Usuarios...
CREATE TABLESPACE usuarios_c1_data_ts 
DATAFILE 
    '/unam/bda/pf/c1/d01/usuarios_c1_data_ts_01.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 1G,
    '/unam/bda/pf/c1/d02/usuarios_c1_data_ts_02.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

CREATE SMALLFILE TABLESPACE usuarios_c1_idx_ts 
DATAFILE '/unam/bda/pf/c1/d01/usuarios_c1_idx_ts_01.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

PROMPT Creando dueño de esquema david_usuarios...
CREATE USER david_usuarios IDENTIFIED BY "Hola1234*"
    DEFAULT TABLESPACE usuarios_c1_data_ts
    QUOTA UNLIMITED ON usuarios_c1_data_ts
    QUOTA UNLIMITED ON usuarios_c1_idx_ts;

GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM TO david_usuarios;


PROMPT 3. TABLESPACES Y USUARIO EN PDB MEDIA
ALTER SESSION SET CONTAINER = media_pdb;

PROMPT Creando tablespaces locales para el modulo de Media...
CREATE BIGFILE TABLESPACE media_c1_data_ts 
DATAFILE '/unam/bda/pf/c1/d01/media_c1_data_ts_01.dbf' SIZE 500M AUTOEXTEND ON NEXT 50M MAXSIZE 2G;

CREATE SMALLFILE TABLESPACE media_c1_idx_ts 
DATAFILE '/unam/bda/pf/c1/d01/media_c1_idx_ts_01.dbf' SIZE 200M AUTOEXTEND ON NEXT 20M MAXSIZE 1G;

CREATE BIGFILE TABLESPACE media_c2_lob_ts 
DATAFILE '/unam/bda/pf/c2/d01/media_c2_lob_ts_01.dbf' SIZE 1G AUTOEXTEND ON NEXT 100M MAXSIZE 3G;

PROMPT Creando dueno de esquema david_media...
CREATE USER david_media IDENTIFIED BY "Hola1234*"
    DEFAULT TABLESPACE media_c1_data_ts
    QUOTA UNLIMITED ON media_c1_data_ts
    QUOTA UNLIMITED ON media_c1_idx_ts
    QUOTA UNLIMITED ON media_c2_lob_ts;

GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM TO david_media;

