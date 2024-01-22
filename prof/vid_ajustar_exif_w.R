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

# Función para procesar cada archivo de video
procesar_video <- function(archivo) {
  nombre_archivo <- basename(archivo)
  
  # Determinar el formato del nombre del archivo y extraer la fecha y hora
  if (grepl("^VID_", nombre_archivo)) {
    partes <- unlist(strsplit(nombre_archivo, "_"))
    fecha_hora_str <- paste(partes[2], partes[3], sep = "T")
  } else if (grepl("^VID-", nombre_archivo)) {
    partes <- unlist(strsplit(nombre_archivo, "-"))
    fecha_str <- partes[2]
    fecha_hora_str <- paste(fecha_str, "000000", sep = "T")
  } else {
    return()  # Ignorar archivos que no coinciden con los patrones
  }
  
  fecha_hora_nombre <- ymd_hms(str_replace_all(fecha_hora_str, "([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})", "\\1-\\2-\\3 \\4:\\5:\\6"), tz = "UTC")
  
  # Verificar si la conversión fue exitosa
  if (is.na(fecha_hora_nombre)) {
    warning("No se pudo convertir la fecha/hora para el archivo: ", archivo)
    return()
  }
  
  # Formatear la fecha y hora para exiftool
  fecha_hora_formato_exif <- format(fecha_hora_nombre, "%Y:%m:%d %H:%M:%S")
  
  # Comando para actualizar la fecha y hora en los metadatos del video usando exiftool
  comando <- sprintf("exiftool -DateTimeOriginal=\"%s\" -overwrite_original \"%s\"", fecha_hora_formato_exif, archivo)
  system(comando)
  
  # Mover el archivo a la subcarpeta "procesado"
  file_move(archivo, file.path(subcarpeta, nombre_archivo))
}

# Procesar todos los archivos de video que cumplan con los patrones
patron1 <- "^VID_\\d{8}_.*\\.mp4$"
patron2 <- "^VID-\\d{8}-.*\\.mp4$"
archivos_videos <- c(dir(directorio, pattern = patron1, full.names = TRUE),
                     dir(directorio, pattern = patron2, full.names = TRUE))
sapply(archivos_videos, procesar_video)
