rm(list=ls())

# Cargar las librerías necesarias
#install.packages("magick")
library(magick)
library(filesstrings)

# Ruta inicial de trabajo
root_path <- "/home/yoviajo/Descargas/f/_2003"

# Mensaje para confirmar el inicio del script
message("Iniciando el script.")

# Obtener la lista de carpetas en la ruta inicial
folders <- list.dirs(root_path, recursive = FALSE)

# Filtrar carpetas que sigan el formato "año-día-mes id"
pattern <- "\\d{4}-\\d{2}-\\d{2} \\w"
relevant_folders <- grep(pattern, folders, value = TRUE)

# Iterar a través de las carpetas relevantes
for (folder in relevant_folders) {
  message(paste("Procesando carpeta:", folder))
  
  # Ruta a la subcarpeta altaRes
  altaRes_path <- file.path(folder, "altaRes")
  
  # Verificar si la subcarpeta altaRes existe
  if (dir.exists(altaRes_path)) {
    # Obtener la lista de archivos en altaRes
    altaRes_files <- list.files(altaRes_path, pattern = "\\.(jpg|jpeg)$", ignore.case = TRUE)
    
    # Obtener la lista de archivos en la carpeta de primer nivel
    lowRes_files <- list.files(folder, pattern = "\\.(jpg|jpeg)$", ignore.case = TRUE)
    
    # Iterar a través de cada archivo en altaRes
    for (file in altaRes_files) {
      img_path <- file.path(altaRes_path, file)
      
      # Intentar leer la imagen
      img <- tryCatch({
        image_read(img_path)
      }, warning = function(w) {
        message(paste("Warning al leer la imagen:", w$message))
        return(NULL)
      }, error = function(e) {
        message(paste("Error al leer la imagen:", e$message))
        return(NULL)
      })
      
      # Verificar si la imagen se cargó correctamente
      if (is.null(img)) {
        message(paste("No se pudo cargar la imagen:", img_path))
        next
      }
      
      # Obtener dimensiones de la imagen
      dims <- dim(img)
      if (is.null(dims) || length(dims) < 2) {
        message(paste("Dimensiones inválidas para la imagen:", img_path))
        next
      }
      
      # Verificar si las dimensiones son válidas y continuar con el procesamiento
      max_dim <- max(dims[1:2])
      message(paste("Dimensiones de alta resolución para", file, ": ", max_dim))
      
      # ... (el resto del script para el procesamiento)
    }
  }
}

