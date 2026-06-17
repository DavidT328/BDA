connect sys/"Hola1234*" as sysdba

-- respaldo
SHUTDOWN abort;
CREATE PFILE='/tmp/initFREE_backup.ora' FROM SPFILE;

-- limpieza y preparacion
STARTUP NOMOUNT;
ALTER SYSTEM RESET control_files SCOPE=SPFILE;
SHUTDOWN ABORT;
STARTUP NOMOUNT;

--archive contrl file que apunta a la fra //hacer manual desde oracle
!echo "restore controlfile from '/unam/bda/pf/c0/d02/control01.ctl';" | rman target /

-- Mostrar la ruta dinámica que Oracle acaba de generar
SHOW PARAMETER control_files;


PROMPT =========================================================
PROMPT continuar manual
PROMPT =========================================================


--linead de codigo para el multiplexio, uno en la fra y los otros duera
ALTER SYSTEM SET control_files='/unam/bda/pf/c0/fra/FREE/controlfile/o1_mf_o32xv0gf_.ctl','/unam/bda/pf/c0/d03/control02.ctl','/unam/bda/pf/c0/d02/control01.ctl' SCOPE=SPFILE;


-- 1. Ampliar el lienzo de la terminal
SET LINESIZE 200;
SET PAGESIZE 100;

-- 2. Formatear la columna del nombre del archivo y el estado
COL name FORMAT a80;
COL status FORMAT a10;

-- 3. Ejecutar la consulta
SELECT * FROM v$controlfile;