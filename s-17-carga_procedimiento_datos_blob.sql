create or replace procedure cargar_imagen_album(
    p_nombre in varchar2,
    p_fecha in date,
    p_nombre_archivo in varchar2
) as
    v_bfile bfile;
    v_blob blob;
begin
    -- 1. insertamos un registro con un blob vacío y recuperamos su puntero (localizador)
    -- nota: no enviamos album_id porque es generated always as identity
    insert into album (nombre, fecha_lanzamiento, imagen)
    values (p_nombre, p_fecha, empty_blob())
    returning imagen into v_blob;

    -- 2. apuntamos al archivo físico en el sistema operativo usando el directory
    v_bfile := bfilename('dir_carga_blobs', p_nombre_archivo);

    -- 3. verificamos si el archivo existe, lo abrimos y volcamos el contenido al blob
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