-- s-18-procedimiento-simulacion.sql
CONNECT sys/"Hola1234*" as sysdba

-- Habilitamos el Block Change Tracking de forma segura (solo si esta apagado)
DECLARE
    v_status VARCHAR2(20);
BEGIN
    SELECT status INTO v_status FROM v$block_change_tracking;
    IF v_status = 'DISABLED' THEN
        EXECUTE IMMEDIATE 'ALTER DATABASE ENABLE BLOCK CHANGE TRACKING USING FILE ''/unam/bda/pf/core/d01/bct_trk.chg''';
    END IF;
END;
/

ALTER SESSION SET CONTAINER = media_pdb;

CREATE OR REPLACE PROCEDURE simula_carga_streaming (
    p_num_reproducciones IN NUMBER
) IS
BEGIN
    FOR i IN 1 .. p_num_reproducciones LOOP
        INSERT INTO erick_media.reproduccion (fecha, usuario_id, contenido_id, segundo_inicial)
        VALUES (
            SYSDATE, 
            TRUNC(DBMS_RANDOM.VALUE(1, 100)), 
            TRUNC(DBMS_RANDOM.VALUE(1, 100)),
            0
        );
    END LOOP;
    COMMIT;
END;
/
SHOW ERRORS;
EXIT;