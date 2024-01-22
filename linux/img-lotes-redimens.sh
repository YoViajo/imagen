#!/usr/bin/env bash
# Purpose: batch image resizer
# Source: https://guides.wp-bullet.com
# Author: Mike

# absolute path to image folder
CARPETA="/home/eric/Imágenes/2019-12-19_r"

# max height
#ANCHO=540

# max width
#ALTO=300

# proporción (% de la imagen original)
PROPORC=22%

# calidad de imagen de salida (%)
CALIDAD=60

#resize png or jpg to either height or width, keeps proportions using imagemagick
#find ${CARPETA} -iname '*.jpg' -o -iname '*.png' -exec convert \{} -verbose -resize $ANCHOx$ALTO\> \{} \;

#resize png to either height or width, keeps proportions using imagemagick
#find ${CARPETA} -iname '*.png' -exec convert \{} -verbose -resize $ANCHOx$ALTO\> \{} \;

#resize jpg only to either height or width, keeps proportions using imagemagick
#find ${CARPETA} -iname '*.jpg' -exec convert \{} -verbose -resize $ANCHOx$ALTO\> \{} \;

# redimensionar sólo jpg a una proporción, manteniendo las proporciones con imagemagick
find ${CARPETA} -iname '*.jpg' -exec convert \{} -verbose -quality $CALIDAD -resize $PROPORC\> \{} \;

# alternative
#mogrify -path ${CARPETA} -resize ${ANCHO}x${ALTO}% *.png -verbose