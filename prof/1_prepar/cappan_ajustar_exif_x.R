library(stringr)
library(fs)
library(lubridate)

# Directorio de los archivos
#directorio <- "D:/Users/earmijo/Downloads/f/proc2/"
directorio <- "/home/yoviajo/Descargas/f/proc2/"

# Crear la subcarpeta "procesado" si no existe
subcarpeta <- file.path(directorio, "procesado")
if (!dir.exists(subcarpeta)) {
  dir.create(subcarpeta)
}

# Función para procesar cada captura de pantalla
procesar_screenshot <- function(archivo) {
  # Extraer la fecha y hora del nombre del archivo
  nombre_archivo <- basename(archivo)
  partes <- strsplit(nombre_archivo, "_")[[1]]
  fecha_hora_str <- partes[2]
  
  # Ajustar el formato de fecha y hora para coincidir con ymd_hms
  fecha_hora_str <- sub("([0-9]{4})-([0-9]{2})-([0-9]{2})-([0-9]{2})-([0-9]{2})-([0-9]{2}).*", "\\1-\\2-\\3 \\4:\\5:\\6", fecha_hora_str)
  fecha_hora_nombre <- ymd_hms(fecha_hora_str)
  
  # Verificar si la conversión fue exitosa
  if (is.na(fecha_hora_nombre)) {
    warning("No se pudo convertir la fecha/hora para el archivo: ", archivo)
    return()
  }
  
  # Formatear la fecha y hora para exiftool
  fecha_hora_formato_exif <- format(fecha_hora_nombre, "%Y:%m:%d %H:%M:%S")
  
  # Comando para actualizar la fecha y hora en los metadatos de la imagen usando exiftool
  comando <- sprintf("exiftool -DateTimeOriginal=\"%s\" -overwrite_original \"%s\"", fecha_hora_formato_exif, archivo)
  system(comando)
  
  # Mover el archivo a la subcarpeta "procesado"
  file_move(archivo, file.path(subcarpeta, basename(archivo)))
}

# Procesar todas las capturas de pantalla que cumplan con el patrón
archivos_screenshots <- dir(directorio, pattern = "^Screenshot_\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}-\\d{2}-\\d+.*\\.jpg$", full.names = TRUE)
sapply(archivos_screenshots, procesar_screenshot)

