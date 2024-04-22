rm(list = ls()) # Elimina todas las variables del entorno global

# Definir el directorio de trabajo
setwd("/home/yoviajo/Descargas/f/lab/prof/3_analisis")

# Librerías
library(tidyverse)
library(purrr)

# Función para obtener información de fotos
obtener_info_fotos <- function(carpeta) {
  # Filtrar carpetas con formato YYYY-MM-DD C
  carpetas_fecha <- list.files(carpeta, pattern = "^\\d{4}-\\d{2}-\\d{2} [a-z]$")
  
  # Lista para almacenar resultados
  resultados <- list()
  
  for (carpeta_fecha in carpetas_fecha) {
    # Extraer fecha
    fecha <- str_replace(carpeta_fecha, " [a-z]$", "")
    
    # Contar fotos en altaRes y pano
    n_fotos_altares <- length(list.files(file.path(carpeta, carpeta_fecha, "altaRes")))
    n_fotos_pano <- length(list.files(file.path(carpeta, carpeta_fecha, "pano")))
    
    # Total de archivos
    total_archivos <- n_fotos_altares + n_fotos_pano
    
    # Agregar información a la lista
    resultados[[length(resultados) + 1]] <- list(fecha = fecha,
                                                 n_fotos_altares = n_fotos_altares,
                                                 n_fotos_pano = n_fotos_pano,
                                                 total_archivos = total_archivos)
  }
  
  return(resultados)
}

# Directorios con las carpetas de fotos
directorios <- c("/home/yoviajo/OneDrive/resp/gamsc-sms_f/",
                 "/home/yoviajo/OneDrive/resp/gamsc-sms_f/z2023/")

# Obtener información de las fotos
resultados_totales <- purrr::map_dfr(directorios, obtener_info_fotos)

# Ordenar por fecha ascendente
resultados_totales <- resultados_totales %>%
  arrange(fecha)

# Seleccionar columnas
df_final <- select(resultados_totales, fecha, total_archivos)

# Guardar como CSV
write.csv(df_final, "info_fotos.csv", row.names = FALSE)

# Imprimir resultados
print(df_final)
