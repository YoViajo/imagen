#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from pathlib import Path
import shutil

def seleccionar_tipo_camara(tipo):
    return {
        'n': 'Huawei Nexus 6P',
        'j': 'Sony Nex-6',
        's': 'Xiaomi Redmi 5 Plus'
    }.get(tipo, 'Xiaomi Redmi 5 Plus')

def obtener_fecha(ruta_arch):
    txt_fecha = ruta_arch.stem.rsplit('_')[1]
    return txt_fecha[0:4], txt_fecha[4:6], txt_fecha[6:8]

def main():
    tipo_camara = 't'
    #camara = seleccionar_tipo_camara(tipo_camara)

    directorio = Path('C:/Users/yoviajo/Downloads/f/proc')
    os.chdir(directorio)

    for ext in ['*.jpg', '*.jpeg', '*.mp4']:
        for ruta_arch in directorio.glob(ext):
            print(ruta_arch)
            anio, mes, dia = obtener_fecha(ruta_arch)
            nvo_dir = directorio / f'{anio}-{mes}-{dia} {tipo_camara}'

            # Use a different subdirectory name depending on the file extension and name
            if ext in ['*.jpg', '*.jpeg']:
                if ruta_arch.stem.startswith('pano'):
                    subdirectorio = 'pano'
                else:
                    subdirectorio = 'altaRes'
            else:
                subdirectorio = 'video'

            nvo_dir_alta_res = nvo_dir / subdirectorio
            nvo_dir_alta_res.mkdir(parents=True, exist_ok=True)
            shutil.move(ruta_arch, nvo_dir_alta_res / ruta_arch.name)

if __name__ == "__main__":
    main()
