from faker import Faker
import random
from datetime import datetime, timedelta

# Configurar Faker en español
fake = Faker('es_MX')
def generar_datos_media_con_comentarios(num_contenidos=2000, num_reproducciones=2500, num_comentarios=3500):
    print("Generando carga para PDB Media (Incluyendo hilos de comentarios)...")
    with open('02_carga_media.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = media_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        # --- (Aquí va la generación de géneros, status y contenido multimedia que ya teníamos) ---
        
        # 1. Catálogos base (Simplificado para el ejemplo)
        generos = ['Rock', 'Pop', 'Jazz', 'Sci-Fi', 'Terror']
        for g in generos:
            f.write(f"INSERT INTO CONTENIDO_GENERO (NOMBRE, DESCRIPCION) VALUES ('{g}', 'Género {g}');\n")
            
        status_list = ['por estrenarse', 'en línea', 'suspendido', 'retirado']
        for s in status_list:
            f.write(f"INSERT INTO CONTENIDO_STATUS (STATUS, DESCRIPCION) VALUES ('{s}', 'Estado: {s}');\n")
            
        # 2. Contenido Multimedia Masivo
        for _ in range(num_contenidos):
            clave = fake.lexify('????????????????').upper()
            nombre = fake.catch_phrase().replace("'", "''") # Escapar comillas para SQL
            f.write(f"INSERT INTO CONTENIDO_MULTIMEDIA (TIPO, CLAVE, NOMBRE, TOTAL_REPRODUCCIONES, DURACION, GENERO_ID) "
                    f"VALUES ('VIDEO', '{clave}', '{nombre}', 0, {random.randint(180, 7200)}, {random.randint(1, 5)});\n")

        # 3. Lógica avanzada de Hilos de Comentarios
        # Diccionario para rastrear qué IDs de comentario pertenecen a qué contenido
        # Estructura: { contenido_id: [lista_de_ids_de_comentarios_padre] }
        comentarios_por_contenido = {}
        comentario_id_actual = 1 # Oracle empezará la secuencia IDENTITY en 1
        
        f.write("\n-- Carga de comentarios y respuestas\n")
        for _ in range(num_comentarios):
            cont_id = random.randint(1, num_contenidos)
            usr_id = random.randint(1, 2000) 
            fecha_str = fake.date_between(start_date='-1y', end_date='today').strftime('%d-%m-%Y')
            
            # Generar un texto simulado y escapar las comillas simples para evitar errores ORA-00917
            texto = fake.text(max_nb_chars=150).replace("'", "''").replace("\n", " ")
            
            # Probabilidad del 40% de que sea una respuesta (si ya existen comentarios en ese contenido)
            es_respuesta = random.random() < 0.40 and cont_id in comentarios_por_contenido
            
            if es_respuesta:
                # Elegir un comentario anterior del mismo contenido para responderle
                padre_id = random.choice(comentarios_por_contenido[cont_id])
                f.write(f"INSERT INTO COMENTARIO (FECHA, TEXTO_COMENTARIO, CONTENIDO_ID, USUARIO_ID, COMENTARIO_PADRE_ID) "
                        f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), '{texto}', {cont_id}, {usr_id}, {padre_id});\n")
            else:
                # Es un comentario raíz (nuevo hilo)
                f.write(f"INSERT INTO COMENTARIO (FECHA, TEXTO_COMENTARIO, CONTENIDO_ID, USUARIO_ID, COMENTARIO_PADRE_ID) "
                        f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), '{texto}', {cont_id}, {usr_id}, NULL);\n")
                
                # Registrar este ID como un posible padre para futuras respuestas
                if cont_id not in comentarios_por_contenido:
                    comentarios_por_contenido[cont_id] = []
                comentarios_por_contenido[cont_id].append(comentario_id_actual)
            
            # Incrementar nuestro contador local para mantener sincronía con el IDENTITY de Oracle
            comentario_id_actual += 1

        f.write("\nCOMMIT;\nEXIT;\n")

# Solo necesitas llamar a la función

def generar_datos_usuarios(num_registros=2000):
    print("Generando carga para PDB Usuarios...")
    with open('01_carga_usuarios.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = usuarios_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        # 1. Catálogo de Planes
        planes = [
            ("BASICO", "Plan Básico (1 Pantalla)", 99.00),
            ("ESTANDAR", "Plan Estándar (2 Pantallas HD)", 149.00),
            ("PREMIUM", "Plan Premium (4 Pantallas 4K)", 199.00),
            ("FAMILIAR", "Plan Familiar VIP", 249.00)
        ]
        for clave, desc, costo in planes:
            fecha_inicio = fake.date_between(start_date='-2y', end_date='-1y').strftime('%d-%m-%Y')
            f.write(f"INSERT INTO PLAN (CLAVE, FECHA_INICIO, COSTO, DESCRIPCION) VALUES ('{clave}', TO_DATE('{fecha_inicio}', 'DD-MM-YYYY'), {costo}, '{desc}');\n")
        
        # 2. Generación de Usuarios y Tarjetas
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
            
            # Generar 1 tarjeta por usuario
            # Nota: Al insertar usamos sentencias genéricas asumiendo IDs secuenciales de 1 a N
            mes = str(random.randint(1, 12)).zfill(2)
            anio = str(random.randint(2026, 2030))
            cvv = fake.numerify('###')
            numero = fake.credit_card_number()[:16] # Limitar a 16 chars
            tipo = random.choice(tipos_tarjeta)
            f.write(f"INSERT INTO TARJETA_CLIENTE (MES, ANIO, CVV, NUMERO, TIPO, USUARIO_ID) "
                    f"VALUES ('{mes}', '{anio}', '{cvv}', '{numero}', '{tipo}', {_+1});\n")

        f.write("\nCOMMIT;\nEXIT;\n")

def generar_datos_media(num_contenidos=2000, num_reproducciones=2500):
    print("Generando carga para PDB Media...")
    with open('02_carga_media.sql', 'w', encoding='utf-8') as f:
        f.write("ALTER SESSION SET CONTAINER = media_pdb;\n")
        f.write("SET DEFINE OFF;\n\n")
        
        # 1. Catálogos base
        generos = ['Rock', 'Pop', 'Jazz', 'Sci-Fi', 'Terror', 'Comedia', 'Drama', 'Documental', 'Anime', 'Clásica']
        for g in generos:
            f.write(f"INSERT INTO CONTENIDO_GENERO (NOMBRE, DESCRIPCION) VALUES ('{g}', 'Contenido del género {g}');\n")
            
        status_list = ['por estrenarse', 'en línea', 'suspendido', 'retirado']
        for s in status_list:
            f.write(f"INSERT INTO CONTENIDO_STATUS (STATUS, DESCRIPCION) VALUES ('{s}', 'Estado: {s}');\n")
            
        # 2. Contenido Multimedia Masivo
        tipos = ['AUDIO', 'VIDEO']
        for _ in range(num_contenidos):
            tipo = random.choice(tipos)
            clave = fake.lexify('????????????????').upper() # 16 caracteres exactos
            nombre = fake.catch_phrase().replace("'", "")[:200]
            duracion = random.randint(180, 7200) # De 3 min a 2 horas en segundos
            genero_id = random.randint(1, 10)
            
            f.write(f"INSERT INTO CONTENIDO_MULTIMEDIA (TIPO, CLAVE, NOMBRE, TOTAL_REPRODUCCIONES, DURACION, GENERO_ID) "
                    f"VALUES ('{tipo}', '{clave}', '{nombre}', 0, {duracion}, {genero_id});\n")

        # 3. Reproducciones (Obligatorio en 2026 por el particionamiento)
        # La tabla REPRODUCCION está particionada por RANGE (FECHA) en los 4 trimestres de 2026
        fecha_inicio_2026 = datetime(2026, 1, 1)
        fecha_fin_2026 = datetime(2026, 12, 31)
        
        for _ in range(num_reproducciones):
            dias_random = random.randint(0, 364)
            fecha_rep = fecha_inicio_2026 + timedelta(days=dias_random)
            fecha_str = fecha_rep.strftime('%d-%m-%Y')
            
            seg_inicial = 0
            seg_final = random.randint(10, 180)
            cont_id = random.randint(1, num_contenidos)
            usr_id = random.randint(1, 2000) # Asumiendo que ejecutaste primero el de usuarios
            
            f.write(f"INSERT INTO REPRODUCCION (FECHA, SEGUNDO_INICIAL, SEGUNDO_FINAL, CONTENIDO_ID, USUARIO_ID) "
                    f"VALUES (TO_DATE('{fecha_str}', 'DD-MM-YYYY'), {seg_inicial}, {seg_final}, {cont_id}, {usr_id});\n")

        f.write("\nCOMMIT;\nEXIT;\n")

# Ejecutar funciones
generar_datos_usuarios()

generar_datos_media_con_comentarios()
generar_datos_media()
print("¡Archivos SQL generados con éxito!")