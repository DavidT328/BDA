-- s-16-modifica-audio-lob.sql
CONNECT sys/"Hola1234*" as sysdba

-- Nos posicionamos en la PDB de Media
ALTER SESSION SET CONTAINER = media_pdb;

PROMPT =========================================================
PROMPT 1. Agregando columna CONTENIDO a la tabla AUDIO con SECUREFILE
PROMPT =========================================================
-- Agregamos la columna de forma segura manteniendo los datos intactos
-- y aplicando tu clausula de almacenamiento especifica para el Tablespace de LOBs
ALTER TABLE erick_media.audio 
ADD ( contenido BLOB )
LOB (contenido) STORE AS SECUREFILE audio_contenido_lob (
    TABLESPACE media_c2_lob_ts
);
PROMPT =========================================================
PROMPT 2. Inicializando los LOBs (EMPTY_BLOB y EMPTY_CLOB)
PROMPT =========================================================
-- Llenamos la nueva columna con un localizador BLOB vacio
UPDATE erick_media.audio 
SET contenido = EMPTY_BLOB();

-- Inicializamos la columna de la letra (CLOB) que estaba en NULL
UPDATE erick_media.audio 
SET letra = EMPTY_CLOB()
WHERE letra IS NULL;

-- Confirmamos los cambios para asegurar la persistencia
COMMIT;

PROMPT =========================================================
PROMPT 3. Verificando la estructura final de la tabla AUDIO
PROMPT =========================================================
SET LINESIZE 180
DESCRIBE erick_media.audio;

PROMPT Modificaciones completadas exitosamente sin perdida de datos.
EXIT;