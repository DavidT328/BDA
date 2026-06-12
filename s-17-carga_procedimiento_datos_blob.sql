create or replace procedure cargar_imagen_album(
    p_nombre in varchar2,
    p_fecha in date,
    p_nombre_archivo in varchar2
) as
    v_bfile bfile;
    v_blob blob;
begin
    -- 1. insertamos un registro con un blob vacío y recuperamos su puntero (localizador)
    insert into album (nombre, fecha_lanzamiento, imagen)
    values (p_nombre, p_fecha, empty_blob())
    returning imagen into v_blob;

    -- apuntamos al archivo físico en el sistema operativo usando el directory
    v_bfile := bfilename('dir_carga_blobs', p_nombre_archivo);

    -- verificamos si el archivo existe, lo abrimos y volcamos el contenido al blob
    if dbms_lob.fileexists(v_bfile) = 1 then
        dbms_lob.fileopen(v_bfile, dbms_lob.file_readonly);
        dbms_lob.loadfromfile(v_blob, v_bfile, dbms_lob.getlength(v_bfile));
        dbms_lob.fileclose(v_bfile);
        
        dbms_output.put_line('imagen cargada exitosamente: ' || p_nombre_archivo);
    else
        raise_application_error(-20001, 'el archivo ' || p_nombre_archivo || ' no existe.');
    end if;

    commit;
exception
    when others then
        rollback;
        dbms_output.put_line('error en la carga: ' || sqlerrm);
end;
/

CREATE OR REPLACE PROCEDURE actualizar_imagen_album(
    p_album_id IN NUMERIC,
    p_nombre_archivo IN VARCHAR2
) AS
    v_bfile BFILE;
    v_blob BLOB;
BEGIN
    -- 1. Seleccionamos el BLOB vacío generado por Python y lo bloqueamos para escritura
    SELECT IMAGEN INTO v_blob
    FROM ALBUM
    WHERE ALBUM_ID = p_album_id
    FOR UPDATE;

    -- 2. Apuntamos al archivo físico (Recuerda: el directorio va en MAYÚSCULAS)
    v_bfile := BFILENAME('DIR_CARGA_BLOBS', p_nombre_archivo);

    -- 3. Verificamos y volcamos el contenido en la fila existente
    IF DBMS_LOB.FILEEXISTS(v_bfile) = 1 THEN
        DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
        DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
        DBMS_LOB.FILECLOSE(v_bfile);
        
        DBMS_OUTPUT.PUT_LINE('Álbum ID ' || p_album_id || ' actualizado con éxito.');
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'El archivo ' || p_nombre_archivo || ' no existe.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error en la actualización: ' || SQLERRM);
END;
/