connect sys/"Hola1234*" as sysdba

-- respaldo
SHUTDOWN IMMEDIATE;
CREATE PFILE='/tmp/initFREE_backup.ora' FROM SPFILE;

-- limpieza y preparacion
STARTUP NOMOUNT;
ALTER SYSTEM RESET control_files SCOPE=SPFILE;
SHUTDOWN ABORT;
STARTUP NOMOUNT;

--archive contrl file que apunta a la fra //hacer manual desde oracle
!echo "restore controlfile from '/unam/bda/pf/core/d01/control01.ctl';" | rman target /

-- Mostrar la ruta dinámica que Oracle acaba de generar
SHOW PARAMETER control_files;

-- limpiando
!rm -f /unam/bda/d03/app/oracle/oradata/FREE/control03.ctl

PROMPT =========================================================
PROMPT continuar manual
PROMPT =========================================================


--linead de codigo para el multiplexio, uno en la fra y los otros duera
---ALTER SYSTEM SET control_files=
---  '/unam/bda/pf/fra/FREE/controlfile/o1_mf_o2s0kybs_.ctl', 
---  '/unam/bda/pf/core/d02/control02.ctl', 
---  '/unam/bda/pf/core/d01/control01.ctl' 
---SCOPE=SPFILE;