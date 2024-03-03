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

# Función para procesar cada archivo
procesar_archivo <- function(archivo) {
  # Extraer la fecha del nombre del archivo
  nombre_archivo <- basename(archivo)
  if (grepl("^IMG_", nombre_archivo)) {
    partes <- unlist(strsplit(nombre_archivo, "[_.]"))
    fecha_hora_str <- paste(partes[2], partes[3], sep = "T")
    fecha_hora_nombre <- ymd_hms(str_replace_all(fecha_hora_str, "([0-9]{4})([0-9]{2})([0-9]{2})T([0-9]{2})([0-9]{2})([0-9]{2})", "\\1-\\2-\\3 \\4:\\5:\\6"))
  } else if (grepl("^IMG-", nombre_archivo)) {
    partes <- unlist(strsplit(nombre_archivo, "-"))
    fecha_str <- partes[2]
    fecha_hora_nombre <- ymd(fecha_str)
  } else {
    return()  # Ignorar archivos que no coinciden con los patrones
  }
  
  # Formatear la fecha y hora para exiftool
  fecha_hora_formato_exif <- format(fecha_hora_nombre, "%Y:%m:%d %H:%M:%S")
  
  # Comando para actualizar la fecha EXIF usando exiftool
  comando <- sprintf("exiftool -DateTimeOriginal=\"%s\" -overwrite_original \"%s\"", fecha_hora_formato_exif, archivo)
  system(comando)
  
  # Mover el archivo a la subcarpeta "procesado"
  file_move(archivo, file.path(subcarpeta, nombre_archivo))
}

# Procesar todos los archivos que cumplan con los patrones
patron1 <- "^(IMG|PANO)_\\d{8}_.*\\.jpg$"
patron2 <- "^IMG-\\d{8}-.*\\.jpg$"
archivos <- c(dir(directorio, pattern = patron1, full.names = TRUE),
              dir(directorio, pattern = patron2, full.names = TRUE))
sapply(archivos, procesar_archivo)
