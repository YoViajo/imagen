#
# Compila las imágenes en los directorios de alta resolución (altaRes)
# Esto puede ayudar a respaldar luego las imágenes en Google Fotos
#

# Cargar librerías necesarias
library(stringr)

# Definir el directorio principal y el directorio destino
directorio_principal <- "/media/windows/f/"
directorio_destino <- "/home/yoviajo/Descargas/f/proc/tmp"

# Obtener una lista de subdirectorios en el directorio principal
subdirectorios <- list.files(directorio_principal, full.names = TRUE)

# Filtrar subdirectorios que sigan el patrón '<fecha> espacio <código>'
patron_fecha_codigo <- "^\\d{4}-\\d{2}-\\d{2} [a-zA-Z0-9]+$"
subdirectorios_filtrados <- subdirectorios[str_detect(basename(subdirectorios), patron_fecha_codigo)]

# Iterar sobre los subdirectorios filtrados
for (subdir in subdirectorios_filtrados) {
  # Construir la ruta al subdirectorio 'altaRes'
  ruta_altaRes <- file.path(subdir, "altaRes")
  
  # Verificar si el subdirectorio 'altaRes' existe
  if (file.exists(ruta_altaRes) && file.info(ruta_altaRes)$isdir) {
    # Obtener la lista de imágenes en 'altaRes'
    imagenes <- list.files(ruta_altaRes, pattern = "\\.(jpg|jpeg|png)$", full.names = TRUE)
    
    # Copiar cada imagen al directorio destino
    for (imagen in imagenes) {
      file.copy(imagen, directorio_destino)
    }
  }
}
