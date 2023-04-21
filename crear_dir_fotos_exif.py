#####################################################
#  A partir de una lista de archivos JPG, extrae
#  la fecha de cada archivo y crea un
#  subdirectorio derivado de la fecha y un código
#  corto que identifica el tipo de cámara. Luego
#  mueve el archivo JPG a ese nuevo subdirectorio         
#####################################################

import os
import shutil
from PIL import Image
from PIL.ExifTags import TAGS
from datetime import datetime

def get_exif_date(image_path):
    try:
        img = Image.open(image_path)
        exif_data = img._getexif()
        
        if exif_data is None:
            print(f"Advertencia: No se encontraron datos EXIF en {image_path}")
            return None
        
        for tag, value in exif_data.items():
            if TAGS.get(tag) == 'DateTimeOriginal':
                return value
        print(f"Advertencia: No se encontró la fecha en los datos EXIF de {image_path}")
        return None
    except IOError:
        print(f"Error: No se pudo abrir el archivo {image_path}")
        return None

def move_image_to_subdirectory(image_path, target_dir):
    try:
        shutil.move(image_path, target_dir)
        print(f"Archivo '{image_path}' movido a '{target_dir}'.")
    except shutil.Error as e:
        print(f"Error al mover el archivo: {e}")
    except OSError as e:
        print(f"Error al mover el archivo: {e}")

def create_subdirectory_and_move_image(image_path):
    exif_date = get_exif_date(image_path)
    
    if exif_date is not None:
        try:
            # Cambiar el formato de fecha a uno válido para el sistema de archivos
            date_obj = datetime.strptime(exif_date, "%Y:%m:%d %H:%M:%S")
            formatted_date = date_obj.strftime("%Y-%m-%d")
            nom_subdir = formatted_date + " r"   # 'r' es el código de un tipo de cámara (e.g., Nikon P900) 
            
            parent_dir = os.path.dirname(image_path)
            target_dir = os.path.join(parent_dir, nom_subdir)

            if not os.path.exists(target_dir):
                os.makedirs(target_dir)
                print(f"Subdirectorio '{nom_subdir}' creado en '{parent_dir}'.")
            else:
                print(f"El subdirectorio '{nom_subdir}' ya existe en '{parent_dir}'.")
            
            move_image_to_subdirectory(image_path, os.path.join(target_dir, os.path.basename(image_path)))

        except ValueError:
            print(f"Error: No se pudo analizar la fecha en {image_path}")
    else:
        print("No se pudo encontrar la fecha EXIF en la imagen.")

def process_jpg_files_in_folder(folder_path):
    if not os.path.exists(folder_path) or not os.path.isdir(folder_path):
        print(f"Error: La ruta proporcionada '{folder_path}' no es una carpeta válida.")
        return

    for root, dirs, files in os.walk(folder_path):
        for file in files:
            if file.lower().endswith(".jpg"):
                image_path = os.path.join(root, file)
                print(f"Procesando: {image_path}")
                create_subdirectory_and_move_image(image_path)

if __name__ == "__main__":
    folder_path = "D:/Usuarios/earmijo/Downloads/f/proc"    # Directorio que contiene los archivo JPG
    process_jpg_files_in_folder(folder_path)
