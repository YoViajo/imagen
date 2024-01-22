rm(list=ls())  # Elimina todas las variables en el entorno global

# Cargar las librerías necesarias
#install.packages(c("fs", "lubridate"))
library(fs)
library(lubridate)

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
# Función para validar el nombre del subdirectorio
is_valid_subdir <- function(subdir_name) {
  return(grepl("^\\d{4}-\\d{2}-\\d{2} \\w+$", subdir_name))
}

# Función para procesar un conjunto de directorios y guardar las fechas específicas para todas las cámaras
process_directories_for_all_cameras <- function(root_path) {
  camera_dates_all <- list()
  year_dirs <- dir_ls(root_path, type = "directory")
  for (year_dir in year_dirs) {
    sub_dirs <- dir_ls(year_dir, type = "directory")
    for (sub_dir in sub_dirs) {
      if (is_valid_subdir(basename(sub_dir))) {
        camera_code <- regmatches(basename(sub_dir), regexpr("\\w+$", basename(sub_dir)))[[1]]
        date_part <- regmatches(basename(sub_dir), regexpr("^\\d{4}-\\d{2}-\\d{2}", basename(sub_dir)))[[1]]
        if (is.null(camera_dates_all[[camera_code]])) {
          camera_dates_all[[camera_code]] <- c()
        }
        camera_dates_all[[camera_code]] <- c(camera_dates_all[[camera_code]], date_part)
      }
    }
  }
  return(camera_dates_all)
}

# Procesar los directorios y obtener las fechas para todas las cámaras
dates_for_all_cameras <- process_directories_for_all_cameras("D:/f/zArch")

# Verificar si el subdirectorio 'salida' ya existe; si no, crearlo
if (!dir_exists("salida")) {
  dir_create("salida")
}

# Abrir el archivo de texto en el subdirectorio 'salida' para guardar la salida
sink("salida/rango_duracion_cámaras.txt")

# Mostrar la duración para cada cámara
for (camera_code in names(dates_for_all_cameras)) {
  dates <- dates_for_all_cameras[[camera_code]]
  if (length(dates) > 0) {
    min_date <- min(as.Date(dates))
    max_date <- max(as.Date(dates))
    duration <- as.period(interval(min_date, max_date))
    cat(paste(camera_codes[[camera_code]], " - Duración: ", duration@year, "años ", duration@month, "meses ", duration@day, "días\n"))
  }
}

# Cerrar el archivo de texto
sink()
