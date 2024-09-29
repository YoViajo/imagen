#!/bin/bash

# Ruta al tercer script de R
SCRIPT3="/home/yoviajo/Descargas/f/lab/prof/2_organiz/procesar_f_proc_x_tuw.R"

# Ejecutar el tercer script de R
echo "Ejecutando $SCRIPT3..."
Rscript $SCRIPT3

# Verificar si el tercer script se ejecutó correctamente
if [ $? -eq 0 ]; then
    echo "El script $SCRIPT3 se ejecutó correctamente."
else
    echo "Error al ejecutar $SCRIPT3."
fi

