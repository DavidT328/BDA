alter session set container = media_pdb;

create or replace directory dir_carga_blobs as '/tmp/carga_imagenes';
grant read, write on directory dir_carga_blobs to david_media;

