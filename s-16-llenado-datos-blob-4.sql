-- s-16-llenado-datos-blob-4.sql
CONNECT erick_media/Hola1234*@MEDIA

SET SERVEROUTPUT ON;

PROMPT =========================================================
PROMPT 1. Cargando Imagenes de Albumes 
PROMPT =========================================================
DECLARE
    v_bfile BFILE;
    v_blob BLOB;
    v_filename VARCHAR2(50);
BEGIN
    -- Quitamos el FOR UPDATE de aqui para no bloquear toda la tabla
    FOR r IN (SELECT ALBUM_ID FROM ALBUM) LOOP
        v_filename := 'album_' || r.ALBUM_ID || '.jpg';
        v_bfile := BFILENAME('PF_ALBUMES_DIR', v_filename);
        
        IF DBMS_LOB.FILEEXISTS(v_bfile) = 1 THEN
            -- Bloqueamos SOLO la fila que vamos a trabajar en este instante
            SELECT IMAGEN INTO v_blob FROM ALBUM WHERE ALBUM_ID = r.ALBUM_ID FOR UPDATE;
            DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
            DBMS_LOB.FILECLOSE(v_bfile);
            -- Hacemos COMMIT por cada fila para vaciar la memoria RAM
            COMMIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Albumes cargados exitosamente.');
END;
/

PROMPT =========================================================
PROMPT 2. Cargando Fragmentos de Video 
PROMPT =========================================================
DECLARE
    v_bfile BFILE;
    v_blob BLOB;
    v_filename VARCHAR2(50);
BEGIN
    FOR r IN (SELECT FRAGMENTO_ID, CONTENIDO_ID FROM VIDEO_FRAGMENTO) LOOP
        v_filename := 'video_' || r.CONTENIDO_ID || '.mp4';
        v_bfile := BFILENAME('PF_VIDEOS_DIR', v_filename);
        
        IF DBMS_LOB.FILEEXISTS(v_bfile) = 1 THEN
            SELECT CONTENIDO INTO v_blob FROM VIDEO_FRAGMENTO WHERE FRAGMENTO_ID = r.FRAGMENTO_ID FOR UPDATE;
            DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
            DBMS_LOB.FILECLOSE(v_bfile);
            COMMIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Videos cargados exitosamente.');
END;
/

PROMPT =========================================================
PROMPT 3. Cargando Archivos de Audio 
PROMPT =========================================================
DECLARE
    v_bfile BFILE;
    v_blob BLOB;
    v_filename VARCHAR2(50);
BEGIN
    FOR r IN (SELECT CONTENIDO_ID FROM AUDIO) LOOP
        v_filename := 'audio_' || r.CONTENIDO_ID || '.mp3';
        v_bfile := BFILENAME('PF_AUDIOS_DIR', v_filename);
        
        IF DBMS_LOB.FILEEXISTS(v_bfile) = 1 THEN
            SELECT CONTENIDO INTO v_blob FROM AUDIO WHERE CONTENIDO_ID = r.CONTENIDO_ID FOR UPDATE;
            DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADFROMFILE(v_blob, v_bfile, DBMS_LOB.GETLENGTH(v_bfile));
            DBMS_LOB.FILECLOSE(v_bfile);
            COMMIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Audios cargados exitosamente.');
END;
/

PROMPT =========================================================
PROMPT 4. Cargando Letras de Canciones
PROMPT =========================================================
DECLARE
    v_bfile BFILE;
    v_clob CLOB;
    v_filename VARCHAR2(50);
    v_dest_offset INTEGER;
    v_src_offset INTEGER;
    v_lang_context INTEGER := DBMS_LOB.DEFAULT_LANG_CTX;
    v_warning INTEGER;
BEGIN
    FOR r IN (SELECT CONTENIDO_ID FROM AUDIO) LOOP
        v_filename := 'letra_' || r.CONTENIDO_ID || '.txt';
        v_bfile := BFILENAME('PF_LETRAS_DIR', v_filename);
        
        IF DBMS_LOB.FILEEXISTS(v_bfile) = 1 THEN
            SELECT LETRA INTO v_clob FROM AUDIO WHERE CONTENIDO_ID = r.CONTENIDO_ID FOR UPDATE;
            
            -- Reseteamos los offsets justo antes de cargar
            v_dest_offset := 1;
            v_src_offset := 1;
            
            DBMS_LOB.FILEOPEN(v_bfile, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADCLOBFROMFILE(
                dest_lob     => v_clob,
                src_bfile    => v_bfile,
                amount       => DBMS_LOB.GETLENGTH(v_bfile),
                dest_offset  => v_dest_offset,
                src_offset   => v_src_offset,
                bfile_csid   => DBMS_LOB.DEFAULT_CSID,
                lang_context => v_lang_context,
                warning      => v_warning
            );
            DBMS_LOB.FILECLOSE(v_bfile);
            COMMIT;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Letras (CLOBs) cargadas exitosamente.');
END;
/

EXIT;