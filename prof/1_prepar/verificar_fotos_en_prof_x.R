#
# Revisa si las imágenes recibidas ya están en repositorio PROF
# además reemplazando si las imágenes recibidas tienen mayor tamaño
# que las existentes en PROF. Si ya están y son de menor tamaño, ignorar
#

# Definir las rutas de los directorios origen y destino
origen <- "/home/yoviajo/Descargas/f/proc2/"
destino <- "/home/yoviajo/GD_p/PROF/gamsc-sms/gamsc-sms_f/"

# Obtener la lista de archivos .jpg en el directorio origen
archivos_origen <- list.files(origen, pattern = "\\.jpg$", full.names = TRUE)

# Función para obtener el tamaño de un archivo
get_size <- function(path) file.info(path)$size

# Archivos que no se movieron
no_movidos <- character()

# Recorrer los archivos de origen
for (archivo_origen in archivos_origen) {
  # Obtener el nombre del archivo
  nombre_archivo <- basename(archivo_origen)
  
  # Buscar el archivo en el directorio destino y sus subdirectorios
  archivo_destino <- list.files(destino, recursive = TRUE, pattern = nombre_archivo, full.names = TRUE)
  
  if (length(archivo_destino) == 1) {
    # El archivo está presente en el destino
    if (grepl("altaRes", archivo_destino, ignore.case = TRUE)) {
      # El archivo está en el subdirectorio "altaRes"
      if (get_size(archivo_origen) > get_size(archivo_destino)) {
        # El archivo de origen tiene mayor tamaño, moverlo y reemplazar
        file.rename(archivo_origen, archivo_destino)
        cat("Archivo", nombre_archivo, "movido y reemplazado en", archivo_destino, "\n")
      }
    }
  } else if (length(archivo_destino) == 0) {
    no_movidos <- c(no_movidos, archivo_origen)
    cat("Archivo", nombre_archivo, "no encontrado en el destino\n")
  } else {
    cat("Archivo", nombre_archivo, "encontrado en múltiples ubicaciones en el destino\n")
  }
}

# Eliminar los archivos que no se movieron
invisible(file.remove(no_movidos))

# Eliminar solo los archivos .jpg del directorio origen
archivos_restantes <- list.files(origen, pattern = "\\.jpg$", full.names = TRUE)
file.remove(archivos_restantes)
