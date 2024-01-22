##########################################################
#   Para una lista de archivos JPG/MP4 que poseen nombre
#   con referencia a la fecha de creación, extraer la
#   fecha, crear un subdirectorio derivado de la fecha
#   y un código del tipo de cámara, y mover el archivo
#   a una subcarpeta a crearse, según el tipo de archivo
#   encontrado
##########################################################


import glob
import os
import shutil

abreviatura_camara = 't'  # Seleccione la abreviatura del tipo de cámara (e.g., Xiaomi Redmi 8 Note Pro)

directorio = 'D:/Usuarios/earmijo/Downloads/f/proc/'  # Cambie por el directorio con las imágenes en Windows
os.chdir(directorio)


def main():
    for ruta_arch in glob.glob(os.path.join(directorio, '*.*')):
        print(ruta_arch)
        txt_encab = ruta_arch.rsplit('_')[0]
        txt_fecha = ruta_arch.rsplit('_')[1]
        txt_anio = txt_fecha[0:4]
        txt_mes = txt_fecha[4:6]
        txt_dia = txt_fecha[6:8]
        nvo_dir = f"{txt_anio}-{txt_mes}-{txt_dia} {abreviatura_camara}"

        if 'IMG' in txt_encab:
            nom_carp = "altaRes"
        elif 'PANO' in txt_encab:
            nom_carp = "pano"
        elif 'VID' in txt_encab:
            nom_carp = "vid"
        else:
            nom_carp = "varios"

        os.makedirs(os.path.join(directorio, nvo_dir, nom_carp), exist_ok=True)
        shutil.move(ruta_arch, os.path.join(nvo_dir, nom_carp, os.path.basename(ruta_arch)))


if __name__ == '__main__':
    main()
