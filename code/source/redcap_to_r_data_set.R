# -----------------------------------------------------------
# redcap_to_r_data_set.R
#
# Esta función permite importar archivos CSV exportados desde 
# REDCap junto con el script de etiquetas generado por REDCap
# en formato R. Suprime el sufijo `.factor` innecesario y 
# preserva las etiquetas de variables, niveles y factores.
# Fuente original: https://www.waderstats.com/redcap-to-r-data-set/
# -----------------------------------------------------------

redcap_to_r_data_set <- function(redcap_data_file, redcap_script_file, ...) {
  
  # -----------------------------------------------------------
  # 1. Lectura de archivos
  # - Carga archivo CSV de datos exportado por REDCap
  # - Carga líneas del script generado por REDCap
  # -----------------------------------------------------------
  redcap_data <- read.csv(file = redcap_data_file, stringsAsFactors = FALSE)
  redcap_script <- readLines(redcap_script_file, ...)
  
  # -----------------------------------------------------------
  # 2. Extracción de líneas clave del script
  # - Extrae líneas con funciones factor(), levels() y label()
  # - Se usará para reordenar y procesar correctamente el script
  # -----------------------------------------------------------
  redcap_factor <- redcap_script[grep("factor\\(", redcap_script)]       # Factores
  redcap_levels <- redcap_script[grep("levels\\(", redcap_script)]       # Niveles
  redcap_label  <- redcap_script[grep("^label\\(", redcap_script)]       # Etiquetas
  
  # -----------------------------------------------------------
  # 3. Reordenamiento y limpieza del script
  # - Se ordenan primero factores, luego niveles, luego etiquetas
  # - Se eliminan sufijos innecesarios ".factor"
  # - Se reemplaza el nombre 'data$' por 'redcap_data$'
  #   para que se aplique sobre el objeto cargado
  # -----------------------------------------------------------
  redcap_reorder     <- c(redcap_factor, "", redcap_levels, "", redcap_label)
  redcap_no_append   <- gsub("\\.factor", "", redcap_reorder)
  redcap_rename      <- gsub("data\\$", "redcap_data\\$", redcap_no_append)
  
  # -----------------------------------------------------------
  # 4. Evaluación del script corregido sobre el dataset
  # - Se aplican las transformaciones directamente sobre redcap_data
  # -----------------------------------------------------------
  eval(parse(text = redcap_rename))
  
  # -----------------------------------------------------------
  # 5. Retorno del dataset transformado
  # -----------------------------------------------------------
  return(redcap_data)
}
