# -----------------------------------------------------------
# CONFIGURACIÓN INICIAL PARA PROYECTO CON QUARTO
# -----------------------------------------------------------

# Mostrar más decimales
options(digits = 10)

# Mostrar strings como strings
options(stringsAsFactors = FALSE)

# Mostrar advertencias inmediatamente
options(warn = 1)

# Imprimir estructuras compactas en consola
options(
  tibble.print_min = 10,
  tibble.print_max = 100,
  width = 120
)

# Activar historial persistente
Sys.setenv(R_HISTFILE = ".Rhistory")

# -----------------------------------------------------------
# REGISTRO DE OBJETOS CREADOS POR .RPROFILE
# Esto permite protegerlos en funciones como limpiar entorno
# -----------------------------------------------------------
OBJETOS_RPROFILE <- ls()

# -----------------------------------------------------------
# FUNCIÓN PARA CREAR Y USAR SEMILLA ALEATORIA PERSISTENTE
# -----------------------------------------------------------
set_random_seed <- function(seed_file = ".seed.R", force = FALSE) {
  if (file.exists(seed_file) && !force) {
    source(seed_file, local = TRUE)
    assign("SEED_PROYECTO", .Random.seed_value, envir = .GlobalEnv)
    set.seed(.Random.seed_value)
    return(.Random.seed_value)
  } else {
    new_seed <- sample.int(1e6, 1)
    assign("SEED_PROYECTO", new_seed, envir = .GlobalEnv)
    set.seed(new_seed)
    writeLines(sprintf(".Random.seed_value <- %d", new_seed), seed_file)
    return(new_seed)
  }
}

# Ejecutar y guardar semilla actual
.seed_val <- set_random_seed()

# -----------------------------------------------------------
# FUNCIÓN PARA CARGAR PAQUETES Y VERIFICAR VERSIONES
# Simula pacman::p_load pero sin instalar
# -----------------------------------------------------------
load_and_check_versions <- function(..., repos = "https://cloud.r-project.org") {
  pkgs <- as.character(substitute(list(...)))[-1L]
  available_pkgs <- tryCatch({
    available.packages(repos = repos)
  }, error = function(e) {
    warning("⚠️ No se pudo consultar versiones en CRAN.")
    NULL
  })
  
  for (pkg in pkgs) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message(sprintf("❌ El paquete '%s' no está instalado. Usa setup-packages.R.", pkg))
      next
    }
    suppressPackageStartupMessages(library(pkg, character.only = TRUE))
    if (!is.null(available_pkgs) && pkg %in% rownames(available_pkgs)) {
      local_ver <- as.character(packageVersion(pkg))
      remote_ver <- available_pkgs[pkg, "Version"]
      if (utils::compareVersion(remote_ver, local_ver) > 0) {
        message(sprintf("🔄 '%s' tiene una versión más reciente: instalada %s → disponible %s",
                        pkg, local_ver, remote_ver))
      }
    }
  }
}

# -----------------------------------------------------------
# FUNCIÓN PARA LIMPIAR ENTORNO SIN BORRAR OBJETOS DEL .RPROFILE
# -----------------------------------------------------------
clear_all <- function(verbose = TRUE) {
  if (!exists("OBJETOS_RPROFILE")) {
    stop("No se ha definido OBJETOS_RPROFILE. ¿Lo olvidaste en tu .Rprofile?")
  }
  objetos_todos <- ls(envir = .GlobalEnv)
  objetos_a_borrar <- setdiff(objetos_todos, OBJETOS_RPROFILE)
  if (length(objetos_a_borrar) > 0) {
    rm(list = objetos_a_borrar, envir = .GlobalEnv)
    if (verbose) {
      message("🧹 Entorno limpio. Objetos eliminados: ", paste(objetos_a_borrar, collapse = ", "))
    }
  } else if (verbose) {
    message("👌 Nada que eliminar. Solo están los objetos protegidos definidos en .Rprofile.")
  }
}

# -----------------------------------------------------------
# ACTIVAR RENV SI ESTÁ PRESENTE
# -----------------------------------------------------------
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

# -----------------------------------------------------------
# MENSAJE AL CERRAR LA SESIÓN
# -----------------------------------------------------------
.Last <- function() {
  message("📦 Sesión finalizada. Historial guardado en '.Rhistory'.")
}

# -----------------------------------------------------------
# REGISTRO FINAL DE LOS OBJETOS DEFINIDOS POR EL .RPROFILE
# -----------------------------------------------------------
OBJETOS_RPROFILE <- ls()

# -----------------------------------------------------------
# MENSAJE DE INICIO PERSONALIZADO
# -----------------------------------------------------------
message(paste0(
  "\n📘 Proyecto de tesis iniciado — ", Sys.Date(), "\n",
  "🔢 Semilla aleatoria reproducible: ", .seed_val, "\n",
  "⚙️  Configuración: digits = ", getOption("digits"), 
  ", ancho de impresión = ", getOption("width"), "\n",
  "🛡 Se han protegido ", length(OBJETOS_RPROFILE), " objetos creados por el .Rprofile.\n"
))
