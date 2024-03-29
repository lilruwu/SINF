import csv
import random
import mysql.connector

numero_estadios = 250000
# Archivo CSV con los nombres y capacidades de los recintos
archivo_csv = 'nombres_capacidad.csv'

# Lista para almacenar los nombres de recintos
nombres_recintos = []

# Leer el archivo CSV y obtener los nombres de los recintos
with open(archivo_csv, 'r') as file:
    reader = csv.DictReader(file)
    for row in reader:
        nombres_recintos.append(row['Nombre'])

# Eliminar nombres duplicados
nombres_recintos = set(nombres_recintos)

# Crear 100 estadios con nombres aleatorios basados en la lista original
nuevos_estadios = []
for _ in range(numero_estadios):
    nombre_recinto = random.choice(list(nombres_recintos))
    palabra_aleatoria = ''.join(random.choice('abcdefghijklmnopqrstuvwxyz') for _ in range(10))
    nuevo_nombre = f"{nombre_recinto} {palabra_aleatoria}"
    capacidad_estadio = random.randint(10000, 1000000)
    nuevos_estadios.append({'Nombre': nuevo_nombre, 'Capacidad': capacidad_estadio})

# Guardar los nuevos estadios en un archivo CSV
output_file = '/var/lib/mysql/Taquilla/nuevos_estadios.csv'
with open(output_file, 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=['Nombre', 'Capacidad'])
    writer.writeheader()
    writer.writerows(nuevos_estadios)

print(f"Se han creado y guardado los {numero_estadios} estadios en el archivo {output_file}.")

# Cargar el archivo CSV en la base de datos
config = {
    'user': 'juan',
    'password': '1234',
    'host': 'localhost',
    'database': 'Taquilla'
}

# Crear la conexión a la base de datos
connection = mysql.connector.connect(**config)

# Crear un cursor para ejecutar consultas
cursor = connection.cursor()

# Cargar el archivo CSV en la tabla correspondiente
load_query = """
    LOAD DATA INFILE '{}'
    INTO TABLE Recinto
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS
    (nombre_recinto , localidades_recinto)
""".format(output_file)

cursor.execute(load_query)

# Confirmar los cambios en la base de datos
connection.commit()

# Cerrar el cursor y la conexión
cursor.close()
connection.close()

print("Los datos se han cargado correctamente en la base de datos.")
