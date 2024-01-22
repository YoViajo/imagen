#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Process images in a directory and create multiple directories based on date extracted from file name

camera_type = 't'   # Xiaomi Redmi 8 Note Pro

import glob, os, shutil

directory = '/home/yoviajo/Descargas/f/xiaomi/'
os.chdir(directory)

for file_path in glob.glob(os.path.join(directory, '*.jpg')):
    print(file_path)
    txt_head = file_path.rsplit('_')[0]
    txt_date = file_path.rsplit('_')[1]
    txt_year = txt_date[0:4]
    txt_month = txt_date[4:6]
    txt_day = txt_date[6:8]
    # print "Año: " + txt_year + " Mes: " + txt_month + " Día: " + txt_day
    new_dir = txt_year + '-' + txt_month + '-' + txt_day + ' ' + camera_type

    if txt_head.find('IMG') >= 0:
        dir_name = "altaRes"
    elif txt_head.find('PANO') >= 0:
        dir_name = "pano"
    else:
        dir_name = "varios"
    try:
        os.mkdir(os.path.join(directory, new_dir))
        os.mkdir(os.path.join(directory, new_dir, dir_name))
    except OSError:
        pass
    shutil.move(file_path, os.path.join(new_dir, dir_name, os.path.basename(file_path)))
