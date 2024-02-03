## Requiere la instalación previa de ImageMagick

# Exportar las páginas del PDF como imágenes PNG
convert -density 300 refcon.pdf -quality 100 pag-%02d.png


# Vuelve a ensamblar el PDF a partir de las imágenes PNG
convert pag-*.png documento_final.pdf
