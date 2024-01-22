REM utiliza programa de Hugin para alinear las imágenes
"C:\Program Files\Hugin\bin\align_image_stack.exe" -m -a alin *.jpg

REM aplica el cálculo de la mediana del valor a cada píxel
convert alin* -evaluate-sequence median salida.jpg