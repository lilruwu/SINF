import csv
import random
import string

# Función para generar un nombre de localidad único en una grada y recinto específicos
def generar_nombre_localidad(grada, recinto, contador):
    formatos_localidad = ["Asiento", "Butaca", "Suelo", "Balcón"]
    nombre_localidad = "{} {}".format(random.choice(formatos_localidad), contador)
    
    return nombre_localidad

# Consulta de los recintos existentes
recintos = ["Recinto A", "Recinto B", "Recinto C"]

# Generación y escritura de las localidades por recinto
with open('localidades.csv', mode='w', newline='') as localidades_file:
    localidades_writer = csv.writer(localidades_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    localidades_writer.writerow(["Nombre Localidad", "Nombre Recinto", "Nombre Grada", "Precio Base Localidad", "Estado Localidad"])
    
    for recinto in recintos:
        nombre_recinto = recinto
    
        # Consulta de las gradas del recinto
        gradas = [
            {"nombre_grada": "Grada Norte", "num_localidades_reservar_grada": random.randint(1, 50)},
            {"nombre_grada": "Grada Sur", "num_localidades_reservar_grada": random.randint(1, 50)},
            {"nombre_grada": "Grada Este", "num_localidades_reservar_grada": random.randint(1, 50)},
            {"nombre_grada": "Grada Oeste", "num_localidades_reservar_grada": random.randint(1, 50)},
        ]
    
        for grada in gradas:
            num_localidades = grada['num_localidades_reservar_grada']
            contador = 1
            #print(f"Generando {num_localidades} localidades para la grada {grada['nombre_grada']} del recinto {nombre_recinto}")
            
            for _ in range(num_localidades):
                nombre_localidad = generar_nombre_localidad(grada, nombre_recinto, contador)
                precio_base_localidad = random.randint(5, 50)
                estado_localidad = 'disponible'
                
                localidades_writer.writerow([nombre_localidad, nombre_recinto, grada['nombre_grada'], precio_base_localidad, estado_localidad])
                
                contador += 1
