REM ** ImageMagick **
REM Convierte grupo de imágenes PNG a una animación GIF
REM con una demora de 100 centésimas de segundo (1 segundo), 
REM 5 repeticiones y se borra cada cuadro previo
convert -delay 100 -loop 5 -dispose previous *.png animacion.gif