library(readxl)
library(dplyr)
library(lubridate)

# 1. Importar la base de datos
datos <- read_excel("data/data_sinfuente.xlsx")

# 2. Revisar la estructura
names(datos)
str(datos)
head(datos)
summary(datos)

#Convertir date a fecha mensual
datos <- datos %>%
  mutate(date = ym(date))

# Comprobar la conversión
str(datos)
head(datos)
tail(datos)

#Comprobar que los datos estén completos
# Ordenar cronológicamente
datos <- datos %>%
  arrange(date)
# Revisar valores faltantes
colSums(is.na(datos))
# Revisar fechas duplicadas
sum(duplicated(datos$date))
# Revisar la distancia entre observaciones
meses <- year(datos$date) * 12 + month(datos$date)
all(diff(meses) == 1)

#Crear el objeto de serie de tiempo
serie <- ts(
  datos[["Total Entidad"]],
  start = c(1997, 1),
  frequency = 12
)

# Revisar la serie
start(serie)
end(serie)
frequency(serie)

# Graficar
plot(
  serie,
  main = "Total Entidad",
  xlab = "Año",
  ylab = "Valor"
)

# Guardar base procesada
write.csv(
  datos,
  "data/datos_procesados.csv",
  row.names = FALSE
)

# Guardar base en formato nativo de R
saveRDS(
  datos,
  "data/datos_procesados.rds"
)

# Guardar objeto de serie de tiempo
saveRDS(
  serie,
  "data/serie_tiempo.rds"
)
