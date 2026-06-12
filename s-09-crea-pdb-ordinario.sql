Prompt Conectando como sys
connect sys/"Hola1234*" as sysdba

create pluggable database usuarios_pdb
  admin user usuarios_admin identified by "Hola1234*"
  file_name_convert = (
    '/opt/oracle/oradata/FREE/pdbseed/',
    '/opt/oracle/oradata/FREE/usuarios_pdb/'
  );

prompt abrir la PDB de usuarios
alter pluggable database usuarios_pdb open;

Prompt guardar el estado de la PDB de usuarios
alter pluggable database usuarios_pdb save state;


create pluggable database media_pdb
  admin user media_admin identified by "Hola1234*"
  file_name_convert = (
    '/opt/oracle/oradata/FREE/pdbseed/',
    '/opt/oracle/oradata/FREE/media_pdb/'
  );

prompt abrir la PDB de media
alter pluggable database media_pdb open;

Prompt guardar el estado de la PDB de media
alter pluggable database media_pdb save state;

prompt Listo! PDBs creadas y abiertas correctamente.
exit
