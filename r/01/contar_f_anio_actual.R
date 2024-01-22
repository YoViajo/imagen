rm(list=ls())  # Elimina todas las variables en el entorno global

# Cargar la librería necesaria
#install.packages("fs")
library(fs)

# Función para contar fotos en 'altaRes' en un directorio específico
count_photos <- function(dir_path) {
  high_res_path <- file.path(dir_path, 'altaRes')
  if (dir_exists(high_res_path)) {
    return(length(dir_ls(high_res_path)))
  } else {
    return(0)
  }
}

# Función para validar el nombre del subdirectorio
is_valid_subdir <- function(subdir_name) {
  return(grepl("^\\d{4}-\\d{2}-\\d{2} \\w+$", subdir_name))
}

# Función para procesar un conjunto de directorios y contar fotos por año
process_directories <- function(root_path) {
  # Inicializar un vector para almacenar los conteos por año
  year_counts <- integer(0)
  names(year_counts) <- character(0)
  
  # Obtener la lista de subdirectorios
  sub_dirs <- dir_ls(root_path, type = "directory")
  
  # Loop para procesar cada subdirectorio
  for (sub_dir in sub_dirs) {
    # Validar el nombre del subdirectorio
    if (is_valid_subdir(basename(sub_dir))) {
      # Obtener el año del nombre del subdirectorio (asumiendo el formato "YYYY-MM-DD Código")
      year <- substr(basename(sub_dir), 1, 4)
      
      # Contar las fotos en el subdirectorio 'altaRes'
      photo_count <- count_photos(sub_dir)
      
      # Actualizar el conteo para el año correspondiente
      if (year %in% names(year_counts)) {
        year_counts[year] <- year_counts[year] + photo_count
      } else {
        year_counts[year] <- photo_count
      }
    }
  }
  
  return(year_counts)
}

# Procesar el directorio para el año actual y obtener los conteos
count_current_year <- process_directories("D:/f")

# Mostrar el resultado en un formato simplificado
if (length(count_current_year) > 0) {
  cat(paste("Total de fotos para el año actual:", sum(count_current_year), "\n"))
} else {
  cat("No se encontraron fotos para el año actual que cumplan con los criterios.\n")
}
