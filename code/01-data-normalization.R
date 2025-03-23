# -----------------------------------------------------------
# pre_processing.R
#
# Este script realiza la limpieza inicial del entorno, 
# carga los paquetes necesarios y procesa los archivos 
# extraídos desde REDCap en formato CSV utilizando scripts 
# de transformación específicos. Finalmente, guarda los 
# datos procesados en formato `.RData` y `.rds`.
# -----------------------------------------------------------

# -----------------------------------------------------------
# 1. Configuración del entorno y paquetes necesarios
# - Limpia todos los objetos existentes del entorno
# - Verifica si pacman está instalado; si no, lo instala
# - Descarga y carga todos los paquetes necesarios
# -----------------------------------------------------------

clear_all()  # Elimina todos los objetos del entorno

# Carga paquetes necesarios y verifica versiones
load_and_check_versions(
  tidyverse,     # Colección de paquetes para ciencia de datos
  rio,           # Importar/exportar datos fácilmente
  here,          # Manejo de rutas de archivo
  labelled,      # Manejo de etiquetas
  Hmisc,         # Herramientas estadísticas
  tidyr,         # Transformación de datos
  lubridate,     # Manejo de fechas
  tidyREDCap,    # Procesamiento de datos de REDCap
  janitor,       # Limpieza de datos
  glue           # Interpolación de cadenas
)

# -----------------------------------------------------------
# 2. Carga de funciones personalizadas
# - Carga función externa para transformar datos REDCap
# -----------------------------------------------------------

source(here::here("code/source/redcap_to_r_data_set.R"))

# -----------------------------------------------------------
# 3. Lectura y transformación de archivos CSV de REDCap
# - Lista los archivos CSV y scripts asociados
# - Aplica transformación a cada par (CSV + script)
# - Asigna resultado a un objeto dinámico
# - Limpia variables auxiliares
# -----------------------------------------------------------

# Lista archivos CSV crudos en la carpeta Data/Raw
temp_csv <- list.files(here::here("data/raw"), 
                       pattern = ".csv",
                       full.names = TRUE) ; temp_csv

# Lista archivos R con scripts de transformación REDCap
temp_r <- list.files(here::here("code"),
                     pattern = "import-raw",
                     full.names = TRUE) ; temp_r

# Lista de nombres base para los datasets resultantes
db <- c("raw")

# Bucle para leer y transformar cada archivo CSV
for (i in 1:length(temp_csv)) {
  data <- redcap_to_r_data_set(
    redcap_data_file = temp_csv[i],
    redcap_script_file = temp_r[i], 
    encoding = "UTF-8")
  name <- paste0("data_", db[i])  # Construye nombre del objeto
  assign(name, data)              # Asigna dataset con nombre dinámico
  rm(data)                        # Elimina objeto temporal
}

# Limpieza de objetos temporales
rm(db, i, name, temp_csv, temp_r, redcap_to_r_data_set)

# -----------------------------------------------------------
# 4. Guardado de datos procesados
# - Guarda todo el entorno en archivo .RData
# - Guarda objeto específico en formato .rds
# -----------------------------------------------------------

# save.image(file = "Data/Tidy/database.RData")
export(data_raw, file = here::here("data/tidy/data_raw.rds"))

# https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7366179
# https://www.bmj.com/content/370/bmj.m33


