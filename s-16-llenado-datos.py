from faker import Faker
import random
from datetime import datetime, timedelta

fake = Faker('es_MX')

def generar_datos_usuarios(num_registros=2000):
    print("Generando carga para PDB Usuarios...")
    with open('01_carga_usuarios.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = usuarios_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        planes = [
            ("BASICO", "Plan Básico (1 Pantalla)", 99.00),
            ("ESTANDAR", "Plan Estándar (2 Pantallas HD)", 149.00),
            ("PREMIUM", "Plan Premium (4 Pantallas 4K)", 199.00),
            ("FAMILIAR", "Plan Familiar VIP", 249.00)
        ]
        for clave, desc, costo in planes:
            fecha_inicio = fake.date_between(start_date='-2y', end_date='-1y').strftime('%d-%m-%Y')
            f.write(f"INSERT INTO PLAN (CLAVE, FECHA_INICIO, COSTO, DESCRIPCION) VALUES ('{clave}', TO_DATE('{fecha_inicio}', 'DD-MM-YYYY'), {costo}, '{desc}');\n")
        
        tipos_tarjeta = ['Credito', 'Debito']
        for _ in range(num_registros):
            nombre = fake.first_name().replace("'", "")
            ap_paterno = fake.last_name().replace("'", "")
            ap_materno = fake.last_name().replace("'", "")
            username = f"{nombre.lower()[:3]}{ap_paterno.lower()}{random.randint(100,999)}"
            email = fake.free_email()
            rfc = f"{ap_paterno[:2]}{ap_materno[:1]}{nombre[:1]}{fake.date_of_birth(minimum_age=18, maximum_age=60).strftime('%y%m%d')}{fake.lexify('???')}".upper()
            
            f.write(f"INSERT INTO USUARIO (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, USERNAME, PASSWORD, EMAIL, RFC) "
                    f"VALUES ('{nombre}', '{ap_paterno}', '{ap_materno}', '{username}', 'System2026*', '{email}', '{rfc}');\n")
            
            mes = str(random.randint(1, 12)).zfill(2)
            anio = str(random.randint(2026, 2030))
            cvv = fake.numerify('###')
            numero = fake.credit_card_number()[:16]
            tipo = random.choice(tipos_tarjeta)
            f.write(f"INSERT INTO TARJETA_CLIENTE (MES, ANIO, CVV, NUMERO, TIPO, USUARIO_ID) "
                    f"VALUES ('{mes}', '{anio}', '{cvv}', '{numero}', '{tipo}', {_+1});\n")

        f.write("\nCOMMIT;\nEXIT;\n")

def generar_datos_media_completo(num_contenidos=2000, num_reproducciones=2500, num_comentarios=3500):
    print("Generando carga para PDB Media (Incluyendo Reproducciones y Comentarios)...")
    with open('02_carga_media.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = media_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        generos = ['Rock', 'Pop', 'Jazz', 'Sci-Fi', 'Terror', 'Comedia', 'Drama', 'Documental', 'Anime', 'Clásica']
        for g in generos:
            f.write(f"INSERT INTO CONTENIDO_GENERO (NOMBRE, DESCRIPCION) VALUES ('{g}', 'Género {g}');\n")
            
        status_list = ['por estrenarse', 'en línea', 'suspendido', 'retirado']
        for s in status_list:
            f.write(f"INSERT INTO CONTENIDO_STATUS (STATUS, DESCRIPCION) VALUES ('{s}', 'Estado: {s}');\n")

        for _ in range(50):
            fecha = fake.date_between(start_date='-5y', end_date='today').strftime('%d-%m-%Y')
            f.write(f"INSERT INTO SERIE (NOMBRE, FECHA_LANZAMIENTO) VALUES ('{fake.catch_phrase().replace(chr(39), chr(39)+chr(39))}', TO_DATE('{fecha}', 'DD-MM-YYYY'));\n")
            # Nota: ALBUM requiere un BLOB, se matendra vacio
            f.write(f"INSERT INTO ALBUM (NOMBRE, FECHA_LANZAMIENTO, IMAGEN) VALUES ('{fake.catch_phrase().replace(chr(39), chr(39)+chr(39))}', TO_DATE('{fecha}', 'DD-MM-YYYY'), EMPTY_BLOB());\n")

        f.write("\n-- Carga de Contenido Multimedia\n")
        tipos = ['AUDIO', 'VIDEO']
        for cont_id in range(1, num_contenidos + 1):
            tipo = random.choice(tipos)
            clave = fake.lexify('????????????????').upper()
            nombre = fake.catch_phrase().replace("'", "''")[:200]
            duracion = random.randint(180, 7200)
            genero_id = random.randint(1, len(generos))
            
            f.write(f"INSERT INTO CONTENIDO_MULTIMEDIA (TIPO, CLAVE, NOMBRE, TOTAL_REPRODUCCIONES, DURACION, GENERO_ID) "
                    f"VALUES ('{tipo}', '{clave}', '{nombre}', 0, {duracion}, {genero_id});\n")
            
            if tipo == 'AUDIO':
                album_id = random.randint(1, 50)
                f.write(f"INSERT INTO AUDIO (CONTENIDO_ID, FORMATO, KBPS, ALBUM_ID) VALUES ({cont_id}, 'MP3', 320, {album_id});\n")
            else:
                serie_id = random.randint(1, 50)
                f.write(f"INSERT INTO VIDEO (CONTENIDO_ID, TIPO_VIDEO, CLASIFICACION, TIPO_CODIFICACION, TIPO_TRANSPORTE, PROTOCOLO_TRANSMISION, SERIE_ID) "
                        f"VALUES ({cont_id}, 'HD', 'B', 'H.264', 'MPEG-TS', 'HLS', {serie_id});\n")

        f.write("\n-- Carga de Reproducciones\n")
        fecha_inicio_2026 = datetime(2026, 1, 1)
        for _ in range(num_reproducciones):
            dias_random = random.randint(0, 364)
            fecha_rep = fecha_inicio_2026 + timedelta(days=dias_random)
            fecha_str = fecha_rep.strftime('%d-%m-%Y')
            f.write(f"INSERT INTO REPRODUCCION (FECHA, SEGUNDO_INICIAL, SEGUNDO_FINAL, CONTENIDO_ID, USUARIO_ID) "
                    f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), 0, {random.randint(10, 180)}, {random.randint(1, num_contenidos)}, {random.randint(1, 2000)});\n")

        f.write("\n-- Carga de Comentarios y Respuestas\n")
        comentarios_por_contenido = {}
        comentario_id_actual = 1
        
        for _ in range(num_comentarios):
            cont_id = random.randint(1, num_contenidos)
            usr_id = random.randint(1, 2000) 
            fecha_str = fake.date_between(start_date='-1y', end_date='today').strftime('%d-%m-%Y')
            texto = fake.text(max_nb_chars=150).replace("'", "''").replace("\n", " ")
            
            es_respuesta = random.random() < 0.40 and cont_id in comentarios_por_contenido
            
            if es_respuesta:
                padre_id = random.choice(comentarios_por_contenido[cont_id])
                f.write(f"INSERT INTO COMENTARIO (FECHA, TEXTO_COMENTARIO, CONTENIDO_ID, USUARIO_ID, COMENTARIO_PADRE_ID) "
                        f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), '{texto}', {cont_id}, {usr_id}, {padre_id});\n")
            else:
                f.write(f"INSERT INTO COMENTARIO (FECHA, TEXTO_COMENTARIO, CONTENIDO_ID, USUARIO_ID, COMENTARIO_PADRE_ID) "
                        f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), '{texto}', {cont_id}, {usr_id}, NULL);\n")
                
                if cont_id not in comentarios_por_contenido:
                    comentarios_por_contenido[cont_id] = []
                comentarios_por_contenido[cont_id].append(comentario_id_actual)
            
            comentario_id_actual += 1

        f.write("\nCOMMIT;\nEXIT;\n")

generar_datos_usuarios()
generar_datos_media_completo()
print("¡Archivos SQL generados con éxito y listos para ejecutar!")