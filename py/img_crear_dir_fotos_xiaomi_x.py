#
# Organizador de fotos de celular
#
#  --- versión Linux ---
# 

#!/usr/bin/env python
# -*- coding: utf-8 -*-

#tipo_camara = 'n'   # Huawei Nexus 6P
#tipo_camara = 'j'   # Sony Nex-6
#tipo_camara = 's'   # Xiaomi Redmi 5 Plus
tipo_camara = 't'   # Xiaomi Redmi 8 Note Pro

import glob, os, shutil

#directorio = 'C:\\Users\\Eric\\Downloads\\f\\huawei'
#directorio = '/home/yoviajo/Imágenes/xiaomi'
directorio = '/home/yoviajo/Descargas/f/xiaomi/'
os.chdir(directorio)

for ruta_arch in glob.glob(os.path.join(directorio, '*.jpg')):
  print(ruta_arch)
  txt_encab = ruta_arch.rsplit('_')[0]
  txt_fecha = ruta_arch.rsplit('_')[1]
  txt_anio = txt_fecha[0:4]
  txt_mes = txt_fecha[4:6]
  txt_dia = txt_fecha[6:8]
  # print "Año: " + txt_anio + " Mes: " + txt_mes + " Día: " + txt_dia
  nvo_dir = txt_anio + '-' + txt_mes + '-' + txt_dia + ' ' + tipo_camara

  if txt_encab.find('IMG') >= 0:
    nom_carp = "altaRes"
  elif txt_encab.find('PANO') >= 0:
    nom_carp = "pano"
  else:
    nom_carp = "varios"
  try:
    # print "Se creará el directorio " + nvo_dir
    os.mkdir(os.path.join(directorio, nvo_dir))
    os.mkdir(os.path.join(directorio, nvo_dir, nom_carp))
  except OSError:
    # Maneja el caso cuando el directorio destino ya existe.
    pass
  shutil.move(ruta_arch, os.path.join(nvo_dir, nom_carp, os.path.basename(ruta_arch)))
	
	    
