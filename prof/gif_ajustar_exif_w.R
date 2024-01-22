library(stringr)
library(fs)
library(lubridate)

# Directorio de los archivos
directorio <- "D:/Users/earmijo/Downloads/f/proc2/"

# Crear la subcarpeta "procesado" si no existe
subcarpeta <- file.path(directorio, "procesado")
if (!dir.exists(subcarpeta)) {
  dir.create(subcarpeta)
}

# Función para procesar cada archivo GIF
procesar_gif <- function(archivo) {
  # Extraer la fecha del nombre del archivo
  partes <- unlist(strsplit(basename(archivo), "-"))
  fecha_str <- partes[2]
  fecha_hora_nombre <- ymd(fecha_str)
  
  # Verificar si la conversión fue exitosa
  if (is.na(fecha_hora_nombre)) {
    warning("No se pudo convertir la fecha para el archivo: ", archivo)
    return()
  }
  
  # Formatear la fecha para exiftool
  fecha_formato_exif <- format(fecha_hora_nombre, "%Y:%m:%d")
  
  # Comando para actualizar la fecha en los metadatos del GIF usando exiftool
  comando <- sprintf("exiftool -DateTimeOriginal=\"%s 00:00:00\" -overwrite_original \"%s\"", fecha_formato_exif, archivo)
  system(comando)
  
  # Mover el archivo a la subcarpeta "procesado"
  file_move(archivo, file.path(subcarpeta, basename(archivo)))
}

# Procesar todos los archivos GIF que cumplan con el patrón
archivos_gif <- dir(directorio, pattern = "^VID-\\d{8}-.*\\.gif$", full.names = TRUE)
sapply(archivos_gif, procesar_gif)
