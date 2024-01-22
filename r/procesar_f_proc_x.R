#
# Procesa los archivos de imágenes y video que se descargan de la cámara al directorio temporal en la PC
# Crear estructura de directorios y subdirectorios, basada en la fecha y tipo de archivo
# Reubica la versión de alta y genera un versión de baja resolución de imágenes
#

# Instalar el paquete magick si aún no está instalado
if (!requireNamespace("magick", quietly = TRUE)) {
  install.packages("magick")
}

# Cargar el paquete magick
library(magick)

# Establecer el directorio de trabajo
setwd("/home/yoviajo/Descargas/f/proc/")

# Leer los nombres de los archivos que siguen el patrón específico
archivos <- list.files(pattern = "^(IMG|VID)_[0-9]{8}_[0-9]{6}\\.(jpg|mp4)$")

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
  # Verificar si es un archivo y no un directorio
  if (!file.info(archivo)$isdir) {
    partes <- unlist(strsplit(archivo, "_|\\."))
    fecha <- partes[2]
    formatted_fecha <- paste(substr(fecha, 1, 4), substr(fecha, 5, 6), substr(fecha, 7, 8), sep = "-")
    nombre_directorio <- paste(formatted_fecha, "u")
    
    if (grepl("\\.jpg$", archivo)) {
      subdirectorio <- file.path(nombre_directorio, "altaRes")
      if (!dir.exists(subdirectorio)) {
        dir.create(subdirectorio)
      }
      archivo_destino <- file.path(subdirectorio, archivo)
      
      if (!file.exists(archivo_destino)) {
        file.rename(archivo, archivo_destino)
        
        # Leer, redimensionar y guardar la imagen redimensionada
        img <- image_read(archivo_destino)
        img_resized <- image_resize(img, "1000x1000")
        ruta_guardado <- file.path(nombre_directorio, basename(archivo))
        image_write(img_resized, ruta_guardado)
        
        # Limpiar y liberar memoria
        rm(img, img_resized)
        gc()
      }
    } else if (grepl("\\.mp4$", archivo)) {
      # Corregir la asignación aquí
      ruta_video_destino <- file.path(nombre_directorio, archivo)
      if (!file.exists(ruta_video_destino)) {
        file.rename(archivo, ruta_video_destino)
      }
    }
  }
}
