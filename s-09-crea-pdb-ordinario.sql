prompt conectando como sys
connect sys/"Hola1234*" as sysdba

prompt 1. Crear PDB de usuarios
create pluggable database usuarios_pdb
    admin user admin_usuarios identified by "Hola1234*"
    file_name_convert = ('/unam/bda/pf/c0/d02/pdbseed/', '/unam/bda/pf/c1/d01/usuarios_pdb/');

prompt abrir la PDB de usuarios
alter pluggable database usuarios_pdb open;

prompt guardar el estado de la PDB de usuarios
alter pluggable database usuarios_pdb save state;


prompt 2. Crear PDB de media
create pluggable database media_pdb
    admin user admin_media identified by "Hola1234*"
    file_name_convert = ('/unam/bda/pf/c0/d02/pdbseed/', '/unam/bda/pf/c1/d02/media_pdb/');

prompt abrir la PDB de media
alter pluggable database media_pdb open;

prompt guardar el estado de la PDB de media
alter pluggable database media_pdb save state;

prompt Listo! PDBs creadas y abiertas correctamente.
exit