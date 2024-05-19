######################
#
#   Procesa imágenes y videos en un directorio
#   siguiendo una estructura predefinida de archivado
#   de archivos multimedia. Reconoce el patrón de nombres
#   DCIM de celulares Xiaomi Redmi Note (8 o superior)
#
#   Eric Armijo (rcrmj@hotmail.com), enero 2024
#
######################

# Cargar el paquete magick
library(magick)

# Establecer el directorio de trabajo (ajusta la ruta según sea necesario)
setwd("D:/Users/earmijo/Downloads/f/proc/")

# Leer los nombres de los archivos y directorios que siguen el patrón específico
#elementos <- list.files(pattern = "^(IMG|VID|PANO)_[0-9]{8}_[0-9]{6}\\.(jpg|mp4)$")
elementos <- list.files(pattern = "^(IMG|VID|PANO)_[0-9]{8}_[0-9]{6}.*\\.(jpg|mp4)$")

# Filtrar solo archivos, excluyendo directorios
archivos <- Filter(function(x) !file.info(x)$isdir, elementos)

# Extraer fechas únicas y crear directorios para cada fecha
fechas_unicas <- unique(sapply(archivos, function(archivo) {
  partes <- unlist(strsplit(archivo, "_"))
  fecha <- partes[2]
  formatted_fecha <- paste(substr(fecha, 1, 4), substr(fecha, 5, 6), substr(fecha, 7, 8), sep = "-")
  return(formatted_fecha)
}))

for (fecha in fechas_unicas) {
  nombre_directorio <- paste(fecha, "u")
  if (!dir.exists(nombre_directorio)) {
    dir.create(nombre_directorio)
  }
}

# Mover archivos a sus respectivos directorios y procesar imágenes
for (archivo in archivos) {
  partes <- unlist(strsplit(archivo, "_|\\."))
  fecha <- partes[2]
  formatted_fecha <- paste(substr(fecha, 1, 4), substr(fecha, 5, 6), substr(fecha, 7, 8), sep = "-")
  nombre_directorio <- paste(formatted_fecha, "u")
  
  if (grepl("\\.jpg$", archivo) && !grepl("^PANO_", archivo)) {
    # Procesar imágenes normales
    subdirectorio <- file.path(nombre_directorio, "altaRes")
    if (!dir.exists(subdirectorio)) {
      dir.create(subdirectorio)
    }
    archivo_destino <- file.path(subdirectorio, archivo)
    
    if (!file.exists(archivo_destino)) {
      file.rename(archivo, archivo_destino)
      
      img <- image_read(archivo_destino)
      img_resized <- image_resize(img, "1000x1000")
      ruta_guardado <- file.path(nombre_directorio, basename(archivo))
      image_write(img_resized, ruta_guardado)
      
      rm(img, img_resized)
      gc()
    }
  } else if (grepl("^PANO_", archivo) && grepl("\\.jpg$", archivo)) {
    # Procesar imágenes panorámicas
    subdirectorio_pano <- file.path(nombre_directorio, "pano")
    if (!dir.exists(subdirectorio_pano)) {
      dir.create(subdirectorio_pano)
    }
    archivo_destino_pano <- file.path(subdirectorio_pano, archivo)
    
    if (!file.exists(archivo_destino_pano)) {
      file.rename(archivo, archivo_destino_pano)
      
      # Aquí puedes agregar código adicional si deseas procesar las imágenes panorámicas de manera diferente
    }
  } else if (grepl("\\.mp4$", archivo)) {
    # Procesar videos
    ruta_video_destino <- file.path(nombre_directorio, archivo)
    if (!file.exists(ruta_video_destino)) {
      file.rename(archivo, ruta_video_destino)
    }
  }
}

