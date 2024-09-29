import os
from PIL import Image

# Ruta base de las carpetas
base_path = r'x:\tmp\f\_salida'

# Recorrer todas las carpetas dentro de la ruta base
for root, dirs, files in os.walk(base_path):
    if 'altaRes' in dirs:
        alta_res_path = os.path.join(root, 'altaRes')
        for filename in os.listdir(alta_res_path):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.tiff', '.bmp', '.gif')):
                alta_res_file = os.path.join(alta_res_path, filename)
                
                # Crear el camino para la versión de menor resolución
                lower_res_file = os.path.join(root, filename)
                
                # Abrir la imagen de alta resolución
                with Image.open(alta_res_file) as img:
                    # Calcular la nueva resolución
                    width, height = img.size
                    if width > height:
                        new_width = 1000
                        new_height = int((height / width) * 1000)
                    else:
                        new_height = 1000
                        new_width = int((width / height) * 1000)
                    
                    # Redimensionar la imagen usando LANCZOS
                    img_resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
                    
                    # Guardar la imagen redimensionada fuera de la subcarpeta "altaRes"
                    img_resized.save(lower_res_file)

print("Proceso completado.")
