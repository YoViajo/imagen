#!/bin/bash

# Ruta a los scripts de R
SCRIPT1="/home/yoviajo/Descargas/f/lab/prof/1_prepar/img_ajustar_fechahora_exif_x.R"
SCRIPT2="/home/yoviajo/Descargas/f/lab/prof/1_prepar/cappan_ajustar_exif_x.R"

# Ejecutar el primer script de R
echo "Ejecutando $SCRIPT1..."
Rscript $SCRIPT1

# Verificar si el primer script se ejecutó correctamente
if [ $? -eq 0 ]; then
    # Ejecutar el segundo script de R
    echo "Ejecutando $SCRIPT2..."
    Rscript $SCRIPT2

    # Verificar si el segundo script se ejecutó correctamente
    if [ $? -eq 0 ]; then
        echo "Ambos scripts se ejecutaron correctamente."
    else
        echo "Error al ejecutar $SCRIPT2."
    fi
else
    echo "Error al ejecutar $SCRIPT1."
fi

