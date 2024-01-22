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
  
  # Obtener la lista de directorios por año
  year_dirs <- dir_ls(root_path, type = "directory")
  
  # Loop para procesar cada directorio por año
  for (year_dir in year_dirs) {
    # Obtener la lista de subdirectorios dentro del directorio del año
    sub_dirs <- dir_ls(year_dir, type = "directory")
    
    # Loop para procesar cada subdirectorio
    for (sub_dir in sub_dirs) {
      # Validar el nombre del subdirectorio
      if (is_valid_subdir(basename(sub_dir))) {
        # Obtener el año del directorio (asumiendo que el directorio del año es el nombre)
        year <- basename(year_dir)
        
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
  }
  
  return(year_counts)
}

# Procesar el directorio de archivo y obtener los conteos por año
count_zArch <- process_directories("D:/f/zArch")

# Mostrar el resultado en el formato "<año>: <cantidad de fotos>"
cat("Resumen de fotos por año:\n")
for (year in names(count_zArch)) {
  cat(paste(year, ": ", count_zArch[year], "\n"))
}
