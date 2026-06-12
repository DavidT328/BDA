connect sys/"Hola1234*" as sysdba
-- A. Detener instancia
SHUTDOWN IMMEDIATE;

-- B. Respaldar configuración actual (por seguridad)
CREATE PFILE='/tmp/initFREE_backup.ora' FROM SPFILE;

-- C. Iniciar en modo nomount
STARTUP NOMOUNT;

ALTER SYSTEM RESET control_files SCOPE=SPFILE;

SHUTDOWN ABORT;
STARTUP NOMOUNT;

-- G. RMAN: Restaurar control file (este bloque se ejecuta en terminal, no en SQL)
-- Sal de SQL*Plus y ejecuta esto en la terminal bash:
-- rman target /
-- RMAN> restore controlfile from '/unam/bda/pf/core/d01/control01.ctl';
-- RMAN> exit;

-- H. Validar que la ruta ahora apunte a la FRA
-- (Reconecta a SQL*Plus)
STARTUP NOMOUNT;
SHOW PARAMETER control_files;

-- I. Eliminación física de la copia 3 (ejecutar en terminal bash)
-- host rm /unam/bda/d03/app/oracle/oradata/FREE/control03.ctl

-- J. Modificar parámetro para incluir las 3 rutas (la de FRA + las 2 originales)
-- Sustituye el nombre del archivo generado por RMAN por el que aparezca en tu 'SHOW PARAMETER'
ALTER SYSTEM SET control_files='/unam/bda/pf/fra/FREE/controlfile/o1_mf_o2q4tr1c_.ctl', '/unam/bda/pf/core/d02/control02.ctl', '/unam/bda/pf/core/d01/control01.ctl'  SCOPE=SPFILE;

-- K. Reiniciar instancia en modo open y verificar
SHUTDOWN IMMEDIATE;
STARTUP;

SELECT name, is_recovery_dest_file 
FROM v$controlfile;
