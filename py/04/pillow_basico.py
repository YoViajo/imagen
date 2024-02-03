import os
from PIL import Image
from PIL.ExifTags import TAGS

# Establecer la carpeta de trabajo
ruta = "C:/temp/OneDrive/LAB/prog/python/geom/img"
os.chdir(ruta)


# Abrir la imagen
im = Image.open("IMG_20200101_004714.jpg")

# Mostrar atributos básicos de la imagen
print(im.format, im.size, im.mode)

# Mostrar la imagen
im.show()


def get_field (exif,field) :
    for (k,v) in exif.iteritems():
        if TAGS.get(k) == field:
            return v
        

exif = im._getexif()
print get_field(exif, 'ExposureTime')
