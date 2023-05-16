import mysql.connector

# Conexión a la base de datos
connection = mysql.connector.connect(
    host="localhost",
    user="juan",
    password="1234",
    database="Taquilla"
)

# Crear un cursor para ejecutar consultas
cursor = connection.cursor()
print("Generando ofertas...")
# Obtener los eventos abiertos
cursor.execute("SELECT nombre_espectaculo_evento, nombre_recinto_evento, fecha_evento FROM Evento WHERE estado_evento = 'abierto'")
eventos = cursor.fetchall()
print(eventos)
# Obtener los registros de UsLoc que tienen localidades disponibles
cursor.execute("SELECT tipo_usuario_usloc, localizacion_localidad_usloc, nombre_grada_usloc, nombre_recinto_usloc FROM UsLoc WHERE (tipo_usuario_usloc, localizacion_localidad_usloc, nombre_grada_usloc, nombre_recinto_usloc) IN (SELECT tipo_usuario_usloc, localizacion_localidad_usloc, nombre_grada_usloc, nombre_recinto_usloc FROM Localidad WHERE estado_localidad = 'disponible')")
uslocs = cursor.fetchall()

# Crear una oferta para cada UsLoc en eventos abiertos y localidades disponibles
for evento in eventos:
    print("Creando oferta para evento", evento[0], "en", evento[1], "el", evento[2])
    for usloc in uslocs:
        nombre_espectaculo = evento[0]
        nombre_recinto = evento[1]
        fecha_evento = evento[2]
        tipo_usuario = usloc[0]
        localizacion_localidad = usloc[1]
        nombre_grada = usloc[2]
        try:
            # Verificar la existencia de la oferta
            cursor.execute("""
                SELECT COUNT(*) FROM Oferta
                WHERE nombre_espectaculo_oferta = %s
                AND nombre_recinto_oferta = %s
                AND fecha_evento_oferta = %s
                AND tipo_usuario_oferta = %s
                AND localizacion_localidad_oferta = %s
                AND nombre_grada_oferta = %s
            """, (nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario, localizacion_localidad, nombre_grada))

            row_count = cursor.fetchone()[0]

            # Insertar la oferta solo si no existe
            if row_count == 0:
                cursor.callproc("crearOferta", (nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario , localizacion_localidad, nombre_grada))
                connection.commit()
            else:
                print("La oferta ya existe:", nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario, localizacion_localidad, nombre_grada)
            
        except mysql.connector.IntegrityError:
            # Capturar la excepción cuando la tupla ya existe en UsLoc
            print("Error en", nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario, localizacion_localidad, nombre_grada)
            pass

# Cerrar el cursor y la conexión
cursor.close()
connection.close()
