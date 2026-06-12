SET SERVEROUTPUT ON;

EXEC cargar_imagen_album('Dark Side of the Moon', TO_DATE('01-03-1973', 'DD-MM-YYYY'), 'album1.jpg');
EXEC cargar_imagen_album('Abbey Road', TO_DATE('26-09-1969', 'DD-MM-YYYY'), 'album2.jpg');

-- 2. El Loop para actualizar 25 registros generados por Python
PROMPT Iniciando actualizacion masiva de 25 albumes...

BEGIN
    FOR r IN (SELECT ALBUM_ID FROM ALBUM WHERE ROWNUM <= 25) LOOP
        actualizar_imagen_album(r.ALBUM_ID, 'album1.jpg');
    END LOOP;
END;
/

-- 3. Pruebas de carga de Fragmentos de Video
EXEC cargar_fragmento_video(1, 1, 'frag_video_1.mp4');
EXEC cargar_fragmento_video(2, 1, 'frag_video_2.mp4');

EXIT;