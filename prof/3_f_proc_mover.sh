#!/bin/bash

# Rutas de las carpetas
ORIGEN="/home/yoviajo/Descargas/f/proc2/procesado/"
DESTINO="/home/yoviajo/GD_p/PROF/gamsc-sms/gamsc-sms_f/"

# Verificar si la carpeta de origen existe
if [ -d "$ORIGEN" ]; then
    # Mover y fusionar el contenido de la carpeta de origen a la carpeta de destino
    echo "Moviendo y fusionando el contenido de $ORIGEN a $DESTINO..."
    rsync -av --remove-source-files "$ORIGEN" "$DESTINO"

    # Verificar si el comando rsync se ejecutó correctamente
    if [ $? -eq 0 ]; then
        echo "El contenido se movió y fusionó correctamente."

        # Eliminar las carpetas vacías en el origen
        find "$ORIGEN" -type d -empty -delete

        echo "Carpetas vacías en el origen eliminadas."
    else
        echo "Error al mover y fusionar el contenido."
    fi
else
    echo "La carpeta de origen $ORIGEN no existe."
fi

