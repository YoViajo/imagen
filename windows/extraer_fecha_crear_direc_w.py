from PIL import Image
import piexif
import os

def get_original_date(image_path):
    try:
        image = Image.open(image_path)
        exif_data = piexif.load(image.info['exif'])
        original_date = exif_data['Exif'][piexif.ExifIFD.DateTimeOriginal].decode('utf-8')
        return original_date
    except (KeyError, FileNotFoundError):
        print(f"La fecha original no se pudo obtener para la imagen {image_path}.")
        return None

def create_subdir_name(date_str):
    if date_str:
        date_parts = date_str.split(':')
        subdir_name = f"{date_parts[0]}-{date_parts[1]}-{date_parts[2]}"
        return subdir_name
    return None

image_path = "path/to/your/image.jpg"  # Reemplaza esto con la ruta a tu imagen JPEG
original_date = get_original_date(image_path)
subdir_name = create_subdir_name(original_date)

if subdir_name:
    print(f"Nombre del subdirectorio: {subdir_name}")
else:
    print("No se pudo crear el nombre del subdirectorio.")
 
