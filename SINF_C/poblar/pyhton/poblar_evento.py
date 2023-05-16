import mysql.connector
import random
import datetime
import csv

# Conexión a la base de datos
connection = mysql.connector.connect(
    host="localhost",
    user="juan",
    password="1234",
    database="Taquilla"
)

# Crear un cursor para ejecutar consultas SQL
cursor = connection.cursor()

# Obtener los nombres de los espectáculos existentes
cursor.execute("SELECT nombre_espectaculo FROM Espectaculo")
espectaculos = cursor.fetchall()

# Obtener los nombres de los recintos existentes
cursor.execute("SELECT nombre_recinto FROM Recinto")
recintos = cursor.fetchall()

# Lista para almacenar los eventos generados
eventos = []

# Generar eventos aleatorios para cada espectáculo
for espectaculo in espectaculos:
    for _ in range(5):
        # Generar fecha aleatoria posterior a julio de 2023
        fecha_evento = datetime.datetime(random.randint(2024, 2027), random.randint(1, 12), random.randint(1, 28))
        estado_evento = 'abierto'

        # Seleccionar un recinto aleatorio
        recinto = random.choice(recintos)[0]

        # Agregar el evento a la lista de eventos generados
        eventos.append([espectaculo[0], recinto, fecha_evento, estado_evento])

# Cerrar el cursor y la conexión
cursor.close()
connection.close()

# Escribir los eventos generados en un archivo CSV
with open('eventos.csv', mode='w', newline='') as eventos_file:
    eventos_writer = csv.writer(eventos_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    eventos_writer.writerow(['Espectaculo', 'Recinto', 'Fecha', 'Estado'])
    for evento in eventos:
        eventos_writer.writerow([evento[0], evento[1], evento[2], evento[3]])

print("Eventos generados y guardados en el archivo eventos.csv.")

# Conexión a la base de datos nuevamente
connection = mysql.connector.connect(
    host="localhost",
    user="juan",
    password="1234",
    database="Taquilla"
)

# Crear un cursor para ejecutar consultas SQL
cursor = connection.cursor()

# Cargar el archivo CSV en la base de datos
cursor.execute("LOAD DATA INFILE 'eventos.csv' INTO TABLE Evento FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 ROWS")

# Confirmar los cambios en la base de datos
connection.commit()

# Cerrar el cursor y la conexión
cursor.close()
connection.close()

print("Eventos cargados en la base de datos desde el archivo eventos.csv.")
