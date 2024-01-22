rm(list=ls())  # Elimina todas las variables en el entorno global

# Cargar la librería necesaria
#install.packages("fs")
library(fs)

# Diccionario de códigos de cámaras
camera_codes <- list(
  a = "Canon Powershot S1 IS",
  b = "Canon Powershot SD700 IS",
  c = "Fuji FinePix S8100",
  d = "Nikon P90",
  e = "celular Nokia 2630",
  f = "Nikon CoolPix S610",
  g = "Canon Powershot SD1300 IS",
  h = "Olympus FE-240",
  i = "Nikon CoolPix S3300",
  j = "Sony Nex-6",
  k = "LG Nexus 4",
  l = "Samsung Galaxy Tab S",
  m = "Samsung GT-I8190N",
  n = "Huawei 6P",
  o = "Blü Advance 4.0",
  p = "Xiaomi Yi",
  q = "Samsung Galaxy J5",
  r = "Nikon P900",
  s = "Xiaomi Redmi 5 Plus",
  t = "Xiaomi Redmi Note 8 Pro",
  w = "desconocido",
  x = "Canon Powershot G3",
  y = "Olympus D-340R",
  z = "Canon Powershot A75"
)

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

# Función para procesar un conjunto de directorios y contar fotos por año y cámara
process_directories <- function(root_path) {
  # Inicializar una lista para almacenar los conteos por año y cámara
  year_camera_counts <- list()
  
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
        # Obtener el año y el código de la cámara del subdirectorio
        year <- basename(year_dir)
        camera_code <- regmatches(basename(sub_dir), regexpr("\\w+$", basename(sub_dir)))[[1]]
        
        # Contar las fotos en el subdirectorio 'altaRes'
        photo_count <- count_photos(sub_dir)
        
        # Actualizar el conteo para el año y la cámara correspondientes
        if (!is.null(year_camera_counts[[year]])) {
          if (!is.null(year_camera_counts[[year]][[camera_code]])) {
            year_camera_counts[[year]][[camera_code]] <- year_camera_counts[[year]][[camera_code]] + photo_count
          } else {
            year_camera_counts[[year]][[camera_code]] <- photo_count
          }
        } else {
          year_camera_counts[[year]] <- list()
          year_camera_counts[[year]][[camera_code]] <- photo_count
        }
      }
    }
  }
  
  return(year_camera_counts)
}

# Procesar el directorio de archivo y obtener los conteos por año y cámara
count_zArch <- process_directories("D:/f/zArch")

# Calcular el conteo global de fotos por cámara a partir de count_zArch
global_camera_counts <- integer(0)
names(global_camera_counts) <- character(0)

for (year in names(count_zArch)) {
  for (camera_code in names(count_zArch[[year]])) {
    photo_count <- count_zArch[[year]][[camera_code]]
    if (camera_code %in% names(global_camera_counts)) {
      global_camera_counts[camera_code] <- global_camera_counts[camera_code] + photo_count
    } else {
      global_camera_counts[camera_code] <- photo_count
    }
  }
}

# Mostrar el resultado en el formato "<año> -> <cámara>: <cantidad de fotos>"
cat("Resumen de fotos por año y cámara:\n")
for (year in names(count_zArch)) {
  cat(paste("\nAño:", year, "\n"))
  for (camera_code in names(count_zArch[[year]])) {
    if (count_zArch[[year]][[camera_code]] > 0) {
      cat(paste("  ", camera_codes[[camera_code]], ": ", count_zArch[[year]][[camera_code]], "\n"))
    }
  }
}

# Ordenar el conteo global por cámara y seleccionar las 5 cámaras principales
top_cameras <- sort(global_camera_counts, decreasing = TRUE)[1:5]

# Calcular los años mínimos y máximos
min_year <- min(na.omit(as.integer(names(count_zArch))))
max_year <- max(na.omit(as.integer(names(count_zArch))))

# Abrir el archivo de texto para guardar la salida
sink("5 cámaras con más fotos.txt")

# Mostrar las 5 cámaras con más fotos
cat(paste("\nEntre los años ", min_year, " y ", max_year, ", las 5 cámaras con más fotos son:\n"))
for (camera_code in names(top_cameras)) {
  cat(paste("  ", camera_codes[[camera_code]], ": ", top_cameras[camera_code], "\n"))
}

# Cerrar el archivo de texto
sink()
