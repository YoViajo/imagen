rm(list=ls())  # Elimina todas las variables en el entorno global

# Cargar las librerías necesarias
#install.packages(c("fs", "ggplot2"))
library(fs)
library(ggplot2)

# Función para validar el nombre del subdirectorio
is_valid_subdir <- function(subdir_name) {
  return(grepl("^\\d{4}-\\d{2}-\\d{2} \\w+$", subdir_name))
}

# Función para procesar un conjunto de directorios y contar las fotos por año
count_photos_by_year <- function(root_path) {
  count_by_year <- list()
  year_dirs <- dir_ls(root_path, type = "directory")
  for (year_dir in year_dirs) {
    year <- basename(year_dir)
    # Añadir una condición para verificar que el directorio comienza con un guión bajo y luego un año
    if (startsWith(year, "_") && grepl("^_[0-9]{4}$", year)) {
      sub_dirs <- dir_ls(year_dir, type = "directory")
      count = 0
      for (sub_dir in sub_dirs) {
        if (is_valid_subdir(basename(sub_dir))) {
          alta_res_path <- file.path(sub_dir, "altaRes")
          if (dir_exists(alta_res_path)) {
            count <- count + length(dir_ls(alta_res_path))
          }
        }
      }
      count_by_year[[substr(year, 2, 5)]] <- count  # Quitamos el guión bajo para el año
    }
  }
  return(count_by_year)
}

# Contar las fotos por año
photo_count_by_year <- count_photos_by_year("D:/f/zArch")

# Convertir la lista en un data.frame para ggplot2
photo_count_df <- data.frame(Year = names(photo_count_by_year), Count = unlist(photo_count_by_year))

# Crear el objeto ggplot
p <- ggplot(photo_count_df, aes(x = Year, y = Count)) +
  geom_bar(stat = "identity") +
  ggtitle("Cantidad de fotos por año") +
  xlab("Año") +
  ylab("Cantidad de fotos") +
  coord_flip()

# Verificar si el subdirectorio 'salida' ya existe; si no, crearlo
if (!dir_exists("salida")) {
  dir_create("salida")
}

# Guardar el gráfico como PNG en el subdirectorio 'salida'
ggsave("salida/cantidad_f_x_anio.png", plot = p, width = 10, height = 6)
