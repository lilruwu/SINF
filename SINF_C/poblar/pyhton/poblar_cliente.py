import csv
import mysql.connector
from faker import Faker

numero_tuplas = 1000000

# Instanciar el generador de datos falsos
fake = Faker()

# Generar los datos y guardarlos en una lista de tuplas
datos = []
for _ in range(numero_tuplas):
    dni_cliente = fake.random_number(digits=8)
    while dni_cliente in [d[0] for d in datos]:
        dni_cliente = fake.random_number(digits=8)
    datos_bancarios_cliente = fake.bban()
    datos.append((dni_cliente, datos_bancarios_cliente))

# Guardar los datos en un archivo CSV
archivo_csv = 'clientes.csv'
with open(archivo_csv, 'w', newline='') as file:
    writer = csv.writer(file, delimiter=';')
    writer.writerow(['dni_cliente', 'datos_bancarios_cliente'])
    writer.writerows(datos)

# Importar los datos del archivo CSV en la base de datos
connection = mysql.connector.connect(
    host="localhost",
    user="juan",
    password="1234",
    database="Taquilla"
)

cursor = connection.cursor()

query = "LOAD DATA INFILE '{}' INTO TABLE Cliente FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 ROWS (dni_cliente, datos_bancarios_cliente)".format(archivo_csv)
cursor.execute(query)
connection.commit()

cursor.close()
connection.close()
