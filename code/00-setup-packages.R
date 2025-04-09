# -----------------------------------------------------------
# setup-packages.R
#
# Este script instala automáticamente los paquetes requeridos
# si no se encuentran instalados en el entorno local.
# También puede verificar si hay versiones más recientes en CRAN
# y actualizarlas si se activa el parámetro force_update.
# -----------------------------------------------------------

# -----------------------------------------------------------
# Función: install_if_missing
# - Verifica si el paquete está instalado
# - Si no lo está, lo instala desde CRAN
# - Si está instalado, verifica si hay una versión más reciente
# - Si force_update = TRUE y hay una versión más nueva, actualiza
# -----------------------------------------------------------
install_if_missing <- function(pkg, repos = "https://cloud.r-project.org", force_update = FALSE) {
  installed <- pkg %in% rownames(installed.packages())
  
  if (!installed) {
    message(sprintf("📦 Instalando '%s'...", pkg))
    install.packages(pkg, repos = repos)
  } else {
    local_version <- as.character(packageVersion(pkg))
    available <- tryCatch({
      available_packages <- available.packages(repos = repos)
      available_version <- available_packages[pkg, "Version"]
      available_version
    }, error = function(e) NA)
    
    if (!is.na(available) && utils::compareVersion(available, local_version) > 0) {
      message(sprintf("🔄 Hay una versión más reciente de '%s': instalada %s → disponible %s", pkg, local_version, available))
      if (force_update) {
        message(sprintf("⚙️  Actualizando '%s' a la última versión...", pkg))
        install.packages(pkg, repos = repos)
      } else {
        message(sprintf("ℹ️  Puedes usar force_update = TRUE para actualizar '%s'.", pkg))
      }
    } else {
      message(sprintf("✅ El paquete '%s' está instalado y actualizado (%s).", pkg, local_version))
    }
  }
}

# -----------------------------------------------------------
# Vector de paquetes requeridos por el proyecto
# - Agrega o quita según tus necesidades
# -----------------------------------------------------------
required_packages <- c(
  "remotes",     # Instalación desde GitHub y otras fuentes
  "data.table",  # Manipulación de datos eficiente
  "tidyverse",   # Colección de paquetes para ciencia de datos
  "patchwork",   # Combina graficos ggplot2
  "labelled",    # Etiquetas de variables
  "lubridate",   # Manejo de fechas
  "summarytools",# Exploración descriptiva avanzada
  "skimr",       # Resúmenes de datos
  "tidyREDCap",  # Procesamiento de datos de REDCap
  "quarto",      # Renderizado de QMD desde R
  "rio",         # Importar/exportar datos fácilmente
  "here",        # Manejo de rutas de archivo
  "janitor",     # Limpieza de nombres y datos
  "Hmisc",       # Herramientas estadísticas
  "gtsummary",   # Tablas de resumen
  "gt",          # Tablas con estilo
  "flextable",   # Tablas flexibles para Word/PDF
  "kableExtra",  # Mejor presentación de tablas
  "naniar",      # Exploración de datos faltantes
  "visdat",      # Visualización de datos faltantes
  "knitr",       # Motor de reportes dinámicos
  "scales",        # Escalas de gráficos
  "randomForestSRC"
)

# -----------------------------------------------------------
# Ejecutar instalación (puedes cambiar force_update a TRUE si deseas actualizar)
# -----------------------------------------------------------
invisible(lapply(required_packages, install_if_missing, force_update = FALSE))
# invisible(lapply(required_packages, install_if_missing, force_update = TRUE))
