import os
import pandas as pd
from concurrent.futures import ThreadPoolExecutor
import time

# Definir las rutas de origen y destino
origen = "x:/tmp/f/"
destino = "D:/f/"

# Obtener información de los archivos
def get_file_info(file):
    return {"nombre": os.path.basename(file), "tamano": os.path.getsize(file), "ruta": file}

# Cargar archivos de la carpeta de origen
archivos_origen = [os.path.join(origen, f) for f in os.listdir(origen) if f.endswith('.jpg')]
info_origen = pd.DataFrame([get_file_info(file) for file in archivos_origen])

# Cargar archivos de la carpeta de destino, incluyendo subdirectorios
archivos_destino = [os.path.join(root, file) for root, _, files in os.walk(destino) for file in files if file.endswith('.jpg')]
info_destino = pd.DataFrame([get_file_info(file) for file in archivos_destino])

# Función para verificar si el archivo existe en destino
def check_file(row):
    existe = any((info_destino['nombre'] == row['nombre']) & (info_destino['tamano'] == row['tamano']))
    return "Existe en destino" if existe else "No existe en destino"

# Iniciar la medición del tiempo
inicio = time.time()

# Usar ThreadPoolExecutor para realizar la comparación en paralelo
with ThreadPoolExecutor() as executor:
    info_origen['existe'] = list(executor.map(check_file, [row for _, row in info_origen.iterrows()]))

# Mostrar resultados
print(info_origen[['nombre', 'tamano', 'existe']])

# Finalizar la medición del tiempo
fin = time.time()
print("Tiempo total de procesamiento:", fin - inicio, "segundos")
