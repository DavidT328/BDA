-- s-18-procedimiento-simulacion.sql
CONNECT sys/"Hola1234*" as sysdba

-- Habilitamos el Block Change Tracking primero
-- Cambia esta línea:
ALTER DATABASE ENABLE BLOCK CHANGE TRACKING USING FILE '/opt/oracle/oradata/FREE/files/unam/bda/pf/bct_trk.chg';

ALTER SESSION SET CONTAINER = media_pdb;

CREATE OR REPLACE PROCEDURE simula_carga_streaming (
    p_num_reproducciones IN NUMBER
) IS
BEGIN
    FOR i IN 1 .. p_num_reproducciones LOOP
        INSERT INTO erick_media.reproduccion (fecha, calificacion, usuario_id, contenido_id)
        VALUES (
            SYSDATE, 
            TRUNC(DBMS_RANDOM.VALUE(1, 5)), 
            TRUNC(DBMS_RANDOM.VALUE(1, 100)), 
            TRUNC(DBMS_RANDOM.VALUE(1, 100))
        );
    END LOOP;
    COMMIT;
END;
/
SHOW ERRORS;
EXIT;