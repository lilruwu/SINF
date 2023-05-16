import csv
import random
import string
import mysql.connector

# Conexión a la base de datos
connection = mysql.connector.connect(
    host="localhost",
    user="juan",
    password="1234",
    database="Taquilla"
)

# Consulta de los recintos existentes
cursor = connection.cursor()
cursor.execute("SELECT nombre_recinto FROM Recinto")
recintos = cursor.fetchall()

# Lista de adjetivos y nombres de dirección para los nombres de las gradas
adjetivos = ["Norte", "Sur", "Este", "Oeste", "Roja", "Verde", "Azul", "Blanca", "Negra", "Amarilla"]
direcciones = ["Grada", "Tribuna", "Sector", "Zona", "Sector"]

gradas_data = []

# Generación y ejecución de la inserción de gradas por recinto
for recinto in recintos:
    # Conjunto para almacenar los nombres de las gradas generadas
    gradas_generadas = set()
    nombre_recinto = recinto[0]
    num_gradas = random.randint(1, 3)

    while len(gradas_generadas) < num_gradas:
        nombre_grada = "Grada " + random.choice(adjetivos) + " " + random.choice(direcciones)

        # Verificar si el nombre de grada ya ha sido generado
        if nombre_grada not in gradas_generadas:
            gradas_generadas.add(nombre_grada)

            num_localidades = random.randint(1, 50)
            precio_grada = random.randint(10, 100)

            gradas_data.append([nombre_grada, nombre_recinto, num_localidades, precio_grada])

# Cierre de la conexión
cursor.close()
connection.close()

# Escribir los datos de gradas en un archivo CSV
with open('gradas.csv', mode='w', newline='') as gradas_file:
    writer = csv.writer(gradas_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    writer.writerow(['nombre_grada', 'nombre_recinto', 'num_localidades', 'precio_grada'])
    writer.writerows(gradas_data)

print("Datos de las gradas generados y guardados en el archivo gradas.csv.")

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
cursor.execute("LOAD DATA INFILE 'gradas.csv' INTO TABLE Grada FIELDS TERMINATED BY ',' ENCLOSED BY '\"' IGNORE 1 ROWS")

# Confirmar los cambios en la base de datos
connection.commit()

# Cerrar el cursor y la conexión
cursor.close()
connection.close()

print("Datos de las gradas cargados en la base de datos desde el archivo gradas.csv.")
