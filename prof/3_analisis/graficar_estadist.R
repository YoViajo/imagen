rm(list = ls()) # Elimina todas las variables del entorno global

library(lubridate)
library(ggplot2)


# Directorio de trabajo
setwd("/home/yoviajo/Descargas/f/lab/prof/3_analisis/")

# Cargar datos
datos <- read.csv("info_fotos.csv")

# Convertir fecha a formato Date
datos$fecha <- as.Date(datos$fecha, "%Y-%m-%d")

# Crear gráfico de barras vertical
ggplot(datos, aes(x = fecha, y = total_archivos)) +
  geom_bar(stat = "identity") +
  labs(title = "Total de imágenes por fecha",
       x = "Fecha",
       y = "Total de imágenes") +
  scale_x_date(breaks = "3 months", labels = scales::date_format("%Y-%b"))

# Mostrar el gráfico
ggsave("grafico_barras_total_imagenes.pdf")

