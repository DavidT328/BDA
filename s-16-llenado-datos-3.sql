connect sys/"Hola1234*" as sysdba
ALTER SESSION SET CONTAINER = media_pdb;

PROMPT ==> Reconfigurando directorios apuntando a la Capa 2 (LOBs)

CREATE OR REPLACE DIRECTORY pf_videos_dir AS  '/unam/bda/pf/c2/media/videos';
CREATE OR REPLACE DIRECTORY pf_audios_dir AS  '/unam/bda/pf/c2/media/audios';
CREATE OR REPLACE DIRECTORY pf_letras_dir AS  '/unam/bda/pf/c2/media/letras';
CREATE OR REPLACE DIRECTORY pf_albumes_dir AS '/unam/bda/pf/c2/media/albumes';

PROMPT ==> Otorgando permisos al dueño del esquema

GRANT READ ON DIRECTORY pf_videos_dir TO erick_media;
GRANT READ ON DIRECTORY pf_audios_dir TO erick_media;
GRANT READ ON DIRECTORY pf_letras_dir TO erick_media;
GRANT READ ON DIRECTORY pf_albumes_dir TO erick_media;

PROMPT Listo! Directorios creados en la Capa 2.