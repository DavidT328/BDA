connect sys/Hola1234* as sysdba
ALTER SESSION SET CONTAINER = media_pdb;

PROMPT ==> Reconfigurando directorios con rutas absolutas

CREATE OR REPLACE DIRECTORY pf_videos_dir AS  '/opt/oracle/oradata/FREE/files/unam/bda/pf/media/videos';
CREATE OR REPLACE DIRECTORY pf_audios_dir AS  '/opt/oracle/oradata/FREE/files/unam/bda/pf/media/audios';
CREATE OR REPLACE DIRECTORY pf_letras_dir AS  '/opt/oracle/oradata/FREE/files/unam/bda/pf/media/letras';
CREATE OR REPLACE DIRECTORY pf_albumes_dir AS '/opt/oracle/oradata/FREE/files/unam/bda/pf/media/albumes';

PROMPT ==> Otorgando permisos de lectura al esquema erick_media

GRANT READ ON DIRECTORY pf_videos_dir TO erick_media;
GRANT READ ON DIRECTORY pf_audios_dir TO erick_media;
GRANT READ ON DIRECTORY pf_letras_dir TO erick_media;
GRANT READ ON DIRECTORY pf_albumes_dir TO erick_media;

PROMPT Directorios corregidos.