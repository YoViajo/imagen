#!/bin/bash

# Definir las rutas de origen y destino
origen="/home/yoviajo/GD_p/PROF/gamsc-sms/gamsc-sms_f/"
destino="/media/windows/f/"

# Iterar sobre las carpetas en el directorio de origen
for carpeta in "$origen"*/; do
    # Obtener el nombre de la carpeta
    nombre_carpeta=$(basename "$carpeta")
    
    # Excluir la carpeta "z2023"
    if [ "$nombre_carpeta" != "z2023" ]; then
        # Verificar si la carpeta existe en el destino
        if [ ! -d "$destino$nombre_carpeta" ]; then
            echo "Copiando $nombre_carpeta al destino..."
            cp -r "$carpeta" "$destino"
        else
            echo "$nombre_carpeta ya existe en el destino."
        fi
    fi
done

echo "Proceso completado."
