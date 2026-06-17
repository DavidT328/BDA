from faker import Faker
import random
from datetime import datetime, timedelta
import unicodedata

# Configurar Faker en español
fake = Faker('es_MX')

def quitar_acentos(texto):
    if not texto: return ""
    return unicodedata.normalize('NFKD', texto).encode('ASCII', 'ignore').decode('utf-8')

def generar_datos_usuarios(num_registros=20):
    print("Generando carga para PDB Usuarios (Alineado a tu diseño físico)...")
    usuarios_generados = []

    with open('01_carga_usuarios.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = usuarios_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        # 1. Catálogo de Planes y su Histórico (Corregido)
        planes = [
            ("BASICO", "Plan Básico (1 Pantalla)", 99.00),
            ("ESTANDAR", "Plan Estándar (2 Pantallas HD)", 149.00),
            ("PREMIUM", "Plan Premium (4 Pantallas 4K)", 199.00),
            ("FAMILIAR", "Plan Familiar VIP", 249.00)
        ]
        for plan_id, (clave, desc, costo) in enumerate(planes, start=1):
            fecha_inicio = fake.date_between(start_date='-5y', end_date='-3y').strftime('%d-%m-%Y')
            f.write(f"INSERT INTO PLAN (CLAVE, FECHA_INICIO, COSTO, DESCRIPCION) VALUES ('{clave}', TO_DATE('{fecha_inicio}', 'DD-MM-YYYY'), {costo}, '{desc}');\n")
            
            fecha_fin_hist = fake.date_between(start_date='-3y', end_date='-2y').strftime('%d-%m-%Y')
            # PLAN_HISTORICO usa PLAN_ID directo al catálogo
            f.write(f"INSERT INTO PLAN_HISTORICO (COSTO, FECHA_INICIO, FECHA_FIN, PLAN_ID) "
                    f"VALUES ({costo - 20}, TO_DATE('{fecha_inicio}', 'DD-MM-YYYY'), TO_DATE('{fecha_fin_hist}', 'DD-MM-YYYY'), {plan_id});\n")

        # 2. Usuarios y dependencias
        tipos_tarjeta = ['Credito', 'Debito']
        tipos_disp = ['Smartphone', 'Smart TV', 'Tablet', 'Laptop']
        sistemas_operativos = ['Android', 'iOS', 'WebOS', 'Windows']

        for i in range(1, num_registros + 1):
            nombre_real = fake.first_name().replace("'", "")
            ap_paterno_real = fake.last_name().replace("'", "")
            ap_materno_real = fake.last_name().replace("'", "")
            
            nombre_limpio = quitar_acentos(nombre_real)
            ap_paterno_limpio = quitar_acentos(ap_paterno_real)
            ap_materno_limpio = quitar_acentos(ap_materno_real)

            username = f"{nombre_limpio.lower()[:3]}{ap_paterno_limpio.lower()}{random.randint(100,999)}"
            email = fake.free_email()
            rfc = f"{ap_paterno_limpio[:2]}{ap_materno_limpio[:1]}{nombre_limpio[:1]}{fake.date_of_birth(minimum_age=18, maximum_age=60).strftime('%y%m%d')}{fake.lexify('???')}".upper()
            password = 'System2026*'

            usuarios_generados.append({
                'id': i,
                'username': username,
                'password': password,
                'email': email
            })
            
            f.write(f"INSERT INTO USUARIO (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, USERNAME, PASSWORD, EMAIL, RFC) "
                    f"VALUES ('{nombre_real}', '{ap_paterno_real}', '{ap_materno_real}', '{username}', '{password}', '{email}', '{rfc}');\n")
            
            f.write(f"INSERT INTO TARJETA_CUENTA (MES, ANIO, CVV, NUMERO, TIPO, USUARIO_ID) "
                    f"VALUES ('{str(random.randint(1, 12)).zfill(2)}', '{random.randint(2026, 2030)}', '{fake.numerify('###')}', '{fake.credit_card_number()[:16]}', '{random.choice(tipos_tarjeta)}', {i});\n")

            # DISPOSITIVO ahora usa IP, SO y NOMBRE 
            ip_falsa = fake.ipv4()
            nom_disp = f"Disp de {nombre_limpio}"[:40]
            f.write(f"INSERT INTO DISPOSITIVO (TIPO, IP, SO, NOMBRE, MARCA, USUARIO_ID) "
                    f"VALUES ('{random.choice(tipos_disp)}', '{ip_falsa}', '{random.choice(sistemas_operativos)}', '{nom_disp}', '{fake.company().replace(chr(39),'')[:30]}', {i});\n")

            plan_id = random.randint(1, 4)
            fecha_sus = fake.date_between(start_date='-1y', end_date='today').strftime('%d-%m-%Y')
            
            # USUARIO_SUSCRIPCION ahora usa STATUS 
            f.write(f"INSERT INTO USUARIO_SUSCRIPCION (FECHA_INICIO, STATUS, PLAN_ID, USUARIO_ID) "
                    f"VALUES (TO_DATE('{fecha_sus}', 'DD-MM-YYYY'), 'ACTIVO', {plan_id}, {i});\n")

            # CARGO ahora se enlaza directo a la TARJETA_ID
            f.write(f"INSERT INTO CARGO (FECHA_CARGO, IMPORTE, TARJETA_ID) "
                    f"VALUES (TO_DATE('{fecha_sus}', 'DD-MM-YYYY'), 199.00, {i});\n")

            if random.random() < 0.05:
                # Genera un folio de exactamente 8 caracteres y usa el CARGO_ID recién creado (que aquí mapeaste como 'i' temporalmente)
                folio = fake.lexify('????????').upper()
                f.write(f"INSERT INTO VIP_OPERACION (FOLIO, TIPO_OPERACION, FECHA_COMPRA, PERIODO_RENTA, CARGO_ID, USUARIO_ID) "
                        f"VALUES ('{folio}', 'RENTA', TO_DATE('{fecha_sus}', 'DD-MM-YYYY'), 30, {i}, {i});\n")

        f.write("\nCOMMIT;\nEXIT;\n")
    
    return usuarios_generados

def generar_datos_media_completo(lista_usuarios, num_contenidos=20, num_reproducciones=30, num_comentarios=40):
    print("Generando carga para PDB Media (Sincronizando la tabla espejo)...")
    num_registros_usuarios = len(lista_usuarios)

    with open('02_carga_media.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = media_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")

        f.write("\n-- Carga de Tabla Espejo de Usuarios\n")
        for usr in lista_usuarios:
            f.write(f"INSERT INTO USUARIO (USERNAME, PASSWORD, EMAIL) VALUES ('{usr['username']}', '{usr['password']}', '{usr['email']}');\n")
        
        generos = ['Rock', 'Pop', 'Jazz', 'Sci-Fi', 'Terror', 'Comedia', 'Drama', 'Documental', 'Anime', 'Clásica']
        for g in generos:
            f.write(f"INSERT INTO CONTENIDO_GENERO (NOMBRE, DESCRIPCION) VALUES ('{g}', 'Género {g}');\n")
            
        status_list = ['por estrenarse', 'en línea', 'suspendido', 'retirado']
        for s in status_list:
            f.write(f"INSERT INTO CONTENIDO_STATUS (STATUS, DESCRIPCION) VALUES ('{s}', 'Estado: {s}');\n")

        f.write("\n-- Carga de Autores\n")
        f.write("\n-- Carga de Autores\n")
        for _ in range(1, 101):
            nom_art = fake.user_name().replace(chr(39),'')[:100]
            email_art = fake.free_email()
            f.write(f"INSERT INTO AUTOR (NOMBRE, APELLIDO_PATERNO, EMAIL, NOMBRE_ARTISTICO) "
                    f"VALUES ('{fake.first_name().replace(chr(39),'')}', '{fake.last_name().replace(chr(39),'')}', '{email_art}', '{nom_art}');\n")
    

        for _ in range(50):
            fecha = fake.date_between(start_date='-5y', end_date='today').strftime('%d-%m-%Y')
            f.write(f"INSERT INTO SERIE (NOMBRE, FECHA_LANZAMIENTO) VALUES ('{fake.catch_phrase().replace(chr(39), '')}', TO_DATE('{fecha}', 'DD-MM-YYYY'));\n")
            f.write(f"INSERT INTO ALBUM (NOMBRE, FECHA_LANZAMIENTO, IMAGEN) VALUES ('{fake.catch_phrase().replace(chr(39), '')}', TO_DATE('{fecha}', 'DD-MM-YYYY'), EMPTY_BLOB());\n")

        f.write("\n-- Carga de Contenido Multimedia\n")
        tipos = ['AUDIO', 'VIDEO']
        for cont_id in range(1, num_contenidos + 1):
            tipo = random.choice(tipos)
            clave = quitar_acentos(fake.lexify('????????????????')).upper()
            nombre = fake.catch_phrase().replace("'", "")[:200]
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
                f.write(f"INSERT INTO VIDEO_FRAGMENTO (SECUENCIA, CONTENIDO, CONTENIDO_ID) VALUES (1, EMPTY_BLOB(), {cont_id});\n")

            # Corrección: Agregar PARTICIPACION (ej. 100%)
            f.write(f"INSERT INTO AUTOR_CONTENIDO (PARTICIPACION, CONTENIDO_ID, AUTOR_ID) VALUES (100.00, {cont_id}, {random.randint(1, 100)});\n")
            
            # Corrección: Cambiar FECHA_STATUS_FIN por FECHA
            f.write(f"INSERT INTO CONTENIDO_STATUS_HISTORICO (FECHA, CONTENIDO_STATUS_ID, CONTENIDO_ID) VALUES (SYSDATE, {random.randint(1, 4)}, {cont_id});\n")

            if random.random() < 0.05:
                # Corrección: Usar COSTO_RENTA, COSTO_VENTA, VIGENCIA_INICIO, VIGENCIA_FIN
                f.write(f"INSERT INTO VIP_CONTENIDO (CONTENIDO_ID, COSTO_RENTA, COSTO_VENTA, VIGENCIA_INICIO, VIGENCIA_FIN) "
                        f"VALUES ({cont_id}, 49.90, 149.90, SYSDATE, SYSDATE + 30);\n")

        f.write("\n-- Carga de Playlists\n")
        f.write("\n-- Carga de Playlists\n")
        for i in range(1, 101):
            usr_id = random.randint(1, num_registros_usuarios)
            estrellas = random.randint(1, 5)
            # Corrección: Quitar TIPO_ACCESO y usar ESTRELLAS
            f.write(f"INSERT INTO PLAYLIST (NOMBRE, ESTRELLAS, USUARIO_ID) VALUES ('Mi Playlist {i}', {estrellas}, {usr_id});\n")
            f.write(f"INSERT INTO PLAYLIST_CONTENIDO (PLAYLIST_ID, CONTENIDO_ID) VALUES ({i}, {random.randint(1, num_contenidos)});\n")
            f.write(f"INSERT INTO PLAYLIST_CONTENIDO (PLAYLIST_ID, CONTENIDO_ID) VALUES ({i}, {random.randint(1, num_contenidos)});\n")
            f.write(f"INSERT INTO PLAYLIST_COMPARTIDA (PLAYLIST_ID, USUARIO_ID) VALUES ({i}, {random.randint(1, num_registros_usuarios)});\n")

        f.write("\n-- Carga de Reproducciones\n")
        fecha_inicio_2026 = datetime(2026, 1, 1)
        for _ in range(num_reproducciones):
            dias_random = random.randint(0, 364)
            fecha_rep = fecha_inicio_2026 + timedelta(days=dias_random)
            fecha_str = fecha_rep.strftime('%d-%m-%Y')
            f.write(f"INSERT INTO REPRODUCCION (FECHA, SEGUNDO_INICIAL, SEGUNDO_FINAL, CONTENIDO_ID, USUARIO_ID) "
                    f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), 0, {random.randint(10, 180)}, {random.randint(1, num_contenidos)}, {random.randint(1, num_registros_usuarios)});\n")

        f.write("\n-- Carga de Comentarios y Respuestas\n")
        comentarios_por_contenido = {}
        comentario_id_actual = 1
        
        for _ in range(num_comentarios):
            cont_id = random.randint(1, num_contenidos)
            usr_id = random.randint(1, num_registros_usuarios) 
            fecha_str = fake.date_between(start_date='-1y', end_date='today').strftime('%d-%m-%Y')
            texto = fake.text(max_nb_chars=150).replace("'", "").replace("\n", " ")
            
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

# Ejecutar el pipeline completo
usuarios_memoria = generar_datos_usuarios()
generar_datos_media_completo(usuarios_memoria)
print("¡Archivos SQL generados con éxito y ajustados al diseño de Erick!")