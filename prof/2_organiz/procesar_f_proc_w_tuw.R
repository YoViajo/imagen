# Instalar el paquete magick si aún no está instalado
if (!requireNamespace("magick", quietly = TRUE)) {
  install.packages("magick")
}

# Cargar el paquete magick
library(magick)

# Establecer el directorio de trabajo
setwd("C:/Users/yoviajo/Downloads/f/proc2/procesado/")

# Leer los nombres de los archivos que siguen el patrón específico
archivos <- list.files(pattern = "^(IMG|VID|PANO)(_|-)[0-9]{8}.*\\.(jpg|mp4)$")

# Extraer fechas únicas y crear directorios para cada fecha
fechas_unicas <- unique(sapply(archivos, function(archivo) {
  partes <- unlist(strsplit(archivo, "_|-"))
  fecha <- if (length(partes) >= 3 && (partes[1] == "IMG" || partes[1] == "VID" || partes[1] == "PANO")) {
    substr(partes[2], 1, 8)
  } else {
    NA
  }
  if (!is.na(fecha)) {
    formatted_fecha <- paste(substr(fecha, 1, 4), substr(fecha, 5, 6), substr(fecha, 7, 8), sep = "-")
    return(formatted_fecha)
  }
}))
fechas_unicas <- na.omit(fechas_unicas)

for (fecha in fechas_unicas) {
  # Determinar el carácter final del nombre del directorio según la fecha y presencia de "w"
  caracter_final <- ifelse(as.Date(fecha) <= as.Date("2023-11-30"), "t", "u")
  
  # Verificar si hay archivos con subcadena "w" en lugar de la hora
  if (any(grepl("\\d{8}w", archivos) & grepl(fecha, archivos))) {
    caracter_final <- "w"
  }
  
  nombre_directorio <- paste(fecha, caracter_final)
  if (!dir.exists(nombre_directorio)) {
    dir.create(nombre_directorio)
  }
}

# Mover archivos a sus respectivos directorios y procesar imágenes
for (archivo in archivos) {
  # Verificar si es un archivo y no un directorio
  if (!file.info(archivo)$isdir) {
    partes <- unlist(strsplit(archivo, "_|-|\\."))
    fecha <- if (length(partes) >= 3 && (partes[1] == "IMG" || partes[1] == "VID" || partes[1] == "PANO")) {
      substr(partes[2], 1, 8)
    } else {
      NA
    }
    if (!is.na(fecha)) {
      formatted_fecha <- paste(substr(fecha, 1, 4), substr(fecha, 5, 6), substr(fecha, 7, 8), sep = "-")
      caracter_final <- ifelse(as.Date(formatted_fecha) <= as.Date("2023-11-30"), "t", "u")
      if (any(grepl("\\d{8}w", archivos) & grepl(formatted_fecha, archivos))) {
        caracter_final <- "w"
      }
      nombre_directorio <- paste(formatted_fecha, caracter_final)
      
      if (grepl("\\.jpg$", archivo) && !grepl("^PANO_", archivo)) {
        subdirectorio <- file.path(nombre_directorio, "altaRes")
        if (!dir.exists(subdirectorio)) {
          dir.create(subdirectorio)
        }
        archivo_destino <- file.path(subdirectorio, archivo)
        
        if (!file.exists(archivo_destino)) {
          file.rename(archivo, archivo_destino)
          
          # Leer, redimensionar y guardar la imagen redimensionada
          img <- image_read(archivo_destino)
          img_resized <- image_resize(img, "1000x1000")
          ruta_guardado <- file.path(nombre_directorio, basename(archivo))
          image_write(img_resized, ruta_guardado)
          
          # Limpiar y liberar memoria
          rm(img, img_resized)
          gc()
        }
      } else if (grepl("\\.mp4$", archivo) || grepl("^PANO_", archivo)) {
        # Asignar a subdirectorio "pano" si es un archivo PANO
        subdirectorio <- ifelse(grepl("^PANO_", archivo), file.path(nombre_directorio, "pano"), nombre_directorio)
        if (!dir.exists(subdirectorio)) {
          dir.create(subdirectorio)
        }
        archivo_destino <- file.path(subdirectorio, archivo)
        
        if (!file.exists(archivo_destino)) {
          file.rename(archivo, archivo_destino)
        }
      }
    }
  }
}

