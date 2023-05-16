import csv
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

# Cargar el archivo CSV de ofertas en la base de datos
with open('ofertas.csv', 'r') as file:
    reader = csv.reader(file)
    next(reader)  # Omitir la primera línea (encabezados)

    # Iterar sobre las filas del archivo CSV y ejecutar una inserción por cada fila
    for row in reader:
        nombre_espectaculo = row[0]
        nombre_recinto = row[1]
        fecha_evento = row[2]
        tipo_usuario = row[3]
        localizacion_localidad = row[4]
        nombre_grada = row[5]

        # Ejecutar la inserción de la oferta en la tabla correspondiente
        cursor.execute("INSERT INTO Oferta (nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario, localizacion_localidad, nombre_grada) VALUES (%s, %s, %s, %s, %s, %s)", (nombre_espectaculo, nombre_recinto, fecha_evento, tipo_usuario, localizacion_localidad, nombre_grada))

    # Confirmar los cambios en la base de datos
    connection.commit()

# Cerrar el cursor y la conexión
cursor.close()
connection.close()
