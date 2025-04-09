# -----------------------------------------------------------
# procesamiento_datos.R
#
# Este script realiza:
# - Configuración inicial del entorno de trabajo
# - Importación de datos crudos procesados desde REDCap
# - Exploración y resumen de las variables
# - Preparación de variables para cálculo del puntaje ISARIC-4C
# -----------------------------------------------------------

# -----------------------------------------------------------
# 1. Configuración del entorno y paquetes                   
# -----------------------------------------------------------

clear_all()  # Elimina todos los objetos del entorno

# Carga paquetes necesarios y verifica versiones
load_and_check_versions(
  rio,             # Importación/exportación de datos
  tidyverse,       # Manipulación y visualización de datos
  here,            # Manejo de rutas relativas
  labelled,        # Etiquetas de variables
  lubridate,       # Manejo de fechas
  tidyREDCap,      # Herramientas para datos de REDCap
  janitor,         # Limpieza de nombres de variables
  glue,            # Interpolación de texto
  summarytools,    # Exploración descriptiva avanzada
  kableExtra       # Mejor presentación de tablas
) 

# -----------------------------------------------------------
# 2. Importación de datos                                    
# -----------------------------------------------------------

# Lee los datos crudos transformados de REDCap y limpia nombres
data_raw <- import(here::here("data/tidy/data_raw.rds"), trust = TRUE) |> 
  clean_names()

# -----------------------------------------------------------
# 3. Exploración preliminar de los datos                     
# -----------------------------------------------------------

glimpse(data_raw)         # Estructura general del dataset
head(data_raw)            # Primeras filas para vista rápida

# # Diccionario de variables con summarytools
# dfSummary(data_raw,
#           varnumbers   = FALSE, 
#           valid.col    = FALSE, 
#           graph.magnif = 0.75) |> 
#   print(method = 'render')

# -----------------------------------------------------------
# 4. Preparación de variables         
# -----------------------------------------------------------

## Cleaning of variables for predictive scores
data_tidy <- 
  data_raw |> 
  ### ISARIC-4C----
mutate(
  #### Fecha de ingreso----
  fecha_admin = date(ymd_hm(emerg_admin_fecha)), 
  
  #### Age----
  edadcat = case_when(
    edad < 50 ~ "<50", 
    edad >= 50 & edad < 60 ~ "50-59", 
    edad >= 60 & edad < 70 ~ "60-69", 
    edad >= 70 & edad < 80 ~ "70-79", 
    edad >= 80 ~ ">=80", 
    TRUE ~ as.character(NA)
  ), 
  edadcat = factor(edadcat, levels = c("<50", "50-59", "60-69", "70-79", ">=80")), 
  
  #### Number of comorbidities----
  across(c(com_fcc, com_im, com_epoc, com_er, com_erc_modsev, com_hepa_leve, 
           com_hepa_modsev, com_demen, com_ecv, com_tia, com_hemip, com_etc, 
           com_dmnc, com_dmc, com_sida, inm_vih, inm_inmsup_prim, com_tsol_loc, com_tsol_met, 
           com_leuc, com_linf), ~ recode_factor(., 
                                                "No (historia lo indica)" = "No", 
                                                "Información no disponible en la historia" = "No", 
                                                "Sí (historia lo indica)" = "Sí")), 
  across(c(com_fcc, com_im, com_epoc, com_er, com_erc_modsev, com_hepa_leve, 
           com_hepa_modsev, com_demen, com_ecv, com_tia, com_hemip, com_etc, 
           com_dmnc, com_dmc, com_sida, inm_vih, inm_inmsup_prim, com_tsol_loc, com_tsol_met, 
           com_leuc, com_linf), ~ as.integer(as.character(.) == "Sí")),
  
  ncomorb1 = com_fcc + com_im + com_epoc + com_er + com_erc_modsev + 
    com_hepa_leve + com_hepa_modsev + com_demen + com_ecv + com_tia + 
    com_hemip + com_etc + com_dmnc + com_dmc + com_sida + inm_vih + inm_inmsup_prim +
    com_tsol_loc + com_tsol_met + com_leuc + com_linf ,
  
  ncomorb2 = com_fcc + com_im + com_epoc + com_erc_modsev + 
    com_hepa_leve + com_hepa_modsev + com_demen + com_ecv + com_tia + 
    com_hemip + com_etc + com_dmnc + com_dmc + com_sida + inm_vih + inm_inmsup_prim +
    com_tsol_loc + com_tsol_met + com_leuc + com_linf ,
  
  ncomorb1cat = case_when(
    ncomorb1 == 0 ~ "0", 
    ncomorb1 == 1 ~ "1", 
    ncomorb1 >= 2 ~ ">=2", 
    TRUE ~ as.character(NA)
  ), 
  ncomorb2cat = case_when(
    ncomorb2 == 0 ~ "0", 
    ncomorb2 == 1 ~ "1", 
    ncomorb2 >= 2 ~ ">=2", 
    TRUE ~ as.character(NA)
  ), 
  across(c(ncomorb1cat, ncomorb2cat), ~ factor(., levels = c("0", "1", ">=2"))), 
  
  #### Peripheral oxygen saturation----
  across(c(sv_satodisp_res, sv_satoamb_res), ~ na_if(., "NI")), 
  across(c(sv_satodisp_res, sv_satoamb_res), ~ na_if(., "")), 
  across(c(sv_satodisp_res, sv_satoamb_res), ~ as.numeric(.)), 
  sv_satoamb_res = replace(sv_satoamb_res, sv_satoamb_res == 0.8, 80), 
  sato = case_when(
    sv_satoamb_res >= 92 ~ ">=92", 
    sv_satoamb_res < 92 | (sv_satodisp_res < 92 & is.na(sv_satoamb_res)) | 
      (oxigen_tipo %in% c("Cánula simple", "Mascarilla simple", 
                          "Mascarilla venturi", "Mascarilla de reservorio", 
                          "Cánula nasal simple + mascarilla de reservorio", 
                          "Cánula de Alto Flujo", "Ventilador mecánico") & is.na(sv_satoamb_res)) ~ "<92", 
    TRUE ~ as.character(NA)
  ), 
  sato = factor(sato, levels = c(">=92", "<92")), 
  
  #### Glasgow coma scale - proxy by confusion an altered mental status----
  coma = case_when(
    (sint_confusion %in% c("No (historia lo indica)", "Información no disponible en la historia") & 
       alter_mental %in% c("No (historia lo indica)", "Información no disponible en la historia")) | 
      (sint_confusion %in% c("No (historia lo indica)") & is.na(alter_mental)) | 
      (is.na(sint_confusion) & alter_mental %in% c("No (historia lo indica)")) ~ "15", 
    sint_confusion == "Sí (historia lo indica)" | alter_mental == "Sí (historia lo indica)" ~ "<15", 
    TRUE ~ as.character(NA)
  ), 
  coma = factor(coma, levels = c("15", "<15")),
  
  #### Lab variables categorizadas ----
  ureacat = factor(case_when(
    lab_res_urea < 7 ~ "<7", 
    lab_res_urea <= 14 ~ "7-14", 
    lab_res_urea > 14 ~ ">14", 
    TRUE ~ NA_character_
  ), levels = c("<7", "7-14", ">14")),
  
  pcrcat = factor(case_when(
    lab_res_pcr < 5 ~ "<5", 
    lab_res_pcr < 10 ~ "5-9.9", 
    lab_res_pcr >= 10 ~ ">= 10", 
    TRUE ~ NA_character_
  ), levels = c("<5", "5-9.9", ">= 10")),
  
  neutcat = factor(case_when(
    lab_res_neut < 1.5 ~ "Bajo", 
    lab_res_neut <= 7.5 ~ "Normal",
    lab_res_neut > 7.5 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Bajo", "Normal", "Alto")),
  
  linfcat = factor(case_when(
    lab_res_linf < 1.0 ~ "Bajo", 
    lab_res_linf <= 3.0 ~ "Normal",
    lab_res_linf > 3.0 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Bajo", "Normal", "Alto")),
  
  plaqcat = factor(case_when(
    lab_res_plaq < 150 ~ "Bajo", 
    lab_res_plaq <= 400 ~ "Normal",
    lab_res_plaq > 400 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Bajo", "Normal", "Alto")),
  
  phcat = factor(case_when(
    lab_res_ph < 7.35 ~ "Acidosis", 
    lab_res_ph <= 7.45 ~ "Normal",
    lab_res_ph > 7.45 ~ "Alcalosis",
    TRUE ~ NA_character_
  ), levels = c("Acidosis", "Normal", "Alcalosis")),
  
  lactcat = factor(case_when(
    lab_res_lact < 2 ~ "Normal",
    lab_res_lact >= 2 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Normal", "Alto")),
  
  dimdcat = factor(case_when(
    lab_res_dimd < 500 ~ "Normal", 
    lab_res_dimd >= 500 ~ "Elevado",
    TRUE ~ NA_character_
  ), levels = c("Normal", "Elevado")),
  
  fibricat = factor(case_when(
    lab_res_fibri < 200 ~ "Bajo",
    lab_res_fibri <= 400 ~ "Normal",
    lab_res_fibri > 400 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Bajo", "Normal", "Alto")),
  
  creatcat = factor(case_when(
    lab_res_creat < 0.7 ~ "Bajo", 
    lab_res_creat <= 1.2 ~ "Normal",
    lab_res_creat > 1.2 ~ "Alto",
    TRUE ~ NA_character_
  ), levels = c("Bajo", "Normal", "Alto")),
  
  gluccat = factor(case_when(
    lab_res_gluc < 70 ~ "Hipoglucemia",
    lab_res_gluc < 100 ~ "Normal",
    lab_res_gluc >= 100 ~ "Elevada",
    TRUE ~ NA_character_
  ), levels = c("Hipoglucemia", "Normal", "Elevada")),
  
  #### Outcome----
  death = case_when(
    fallec == "Sí (historia lo indica)" ~ "Muerto",
    fallec == "No (historia lo indica)" ~ "Vivo",
    TRUE ~ NA_character_
  ), 
  death_d = case_when(
    fallec == "Sí (historia lo indica)" ~ 1, 
    fallec == "No (historia lo indica)" ~ 0,
    TRUE ~ NA_real_
  )
) |>  
  dplyr::select(
    sexo, edad, edadcat, ncomorb2, ncomorb2cat, com_fcc, com_im, com_epoc, com_er, com_erc_modsev,
    com_hepa_leve, com_hepa_modsev, com_demen, com_ecv, com_tia, com_hemip, com_etc, com_dmnc, 
    com_dmc, com_sida, inm_vih, inm_inmsup_prim, com_tsol_loc, com_tsol_met, com_leuc, com_linf, obesidad_sino, 
    sv_fr_res, sato, sint_disnea, coma, 
    lab_res_urea, ureacat, lab_res_pcr, pcrcat, 
    lab_res_neut, neutcat, lab_res_linf, linfcat, lab_res_plaq, plaqcat, 
    lab_res_ph, phcat, lab_res_pafi, lab_res_lact, lactcat, lab_res_dimd, dimdcat, 
    lab_res_fibri, fibricat, lab_res_creat, creatcat, lab_res_gluc, gluccat, 
    lab_res_granul, tag_efuspleu, tag_infilt, tag_compro, death, death_d
  ) |> 
  set_variable_labels(
    sexo = "Sexo",
    edad = "Edad (años)",
    edadcat = "Grupo etario",
    
    ncomorb2 = "Número de comorbilidades",
    ncomorb2cat = "Número de comorbilidades",
    
    com_fcc = "Falla cardíaca congestiva",
    com_im = "Infarto agudo de miocardio",
    com_epoc = "Enfermedad pulmonar obstructiva crónica (EPOC)",
    com_er = "Enfermedad renal crónica (leve)",
    com_erc_modsev = "Enfermedad renal crónica moderada/severa",
    com_hepa_leve = "Enfermedad hepática leve",
    com_hepa_modsev = "Enfermedad hepática moderada/severa",
    com_demen = "Demencia",
    com_ecv = "Enfermedad cerebrovascular",
    com_tia = "Accidente isquémico transitorio (AIT)",
    com_hemip = "Hemiplejía",
    com_etc = "Enfermedad del tejido conectivo",
    com_dmnc = "Diabetes mellitus no complicada",
    com_dmc = "Diabetes mellitus complicada",
    com_sida = "SIDA",
    inm_vih = "Infección por VIH",
    inm_inmsup_prim = "Inmunosupresión primaria",
    com_tsol_loc = "Tumor sólido localizado",
    com_tsol_met = "Tumor sólido metastásico",
    com_leuc = "Leucemia",
    com_linf = "Linfoma",
    obesidad_sino = "Obesidad (presente/ausente)",
    
    sv_fr_res = "Frecuencia respiratoria (rpm)",
    sato = "Saturación de oxígeno (aire ambiente o soporte)",
    sint_disnea = "Disnea (según historia clínica)",
    coma = "Escala de Glasgow (proxy por estado mental)",
    
    lab_res_urea = "Urea (mg/dL)",
    ureacat = "Niveles de urea (mg/dL)",
    
    lab_res_pcr = "Proteína C Reactiva (mg/dL)",
    pcrcat = "Niveles de PCR (mg/dL)",
    
    lab_res_neut = "Neutrófilos absolutos (10^3/µL)",
    neutcat = "Niveles de neutrófilos (10^3/µL)",
    
    lab_res_linf = "Linfocitos absolutos (10^3/µL)",
    linfcat = "Niveles de linfocitos (10^3/µL)",
    
    lab_res_plaq = "Plaquetas (10^3/µL)",
    plaqcat = "Niveles de plaquetas (10^3/µL)",
    
    lab_res_ph = "pH sanguíneo (sin unidad)",
    phcat = "Estado ácido-base",
    
    lab_res_lact = "Lactato (mmol/L)",
    lactcat = "Niveles de lactato (mmol/L)",
    
    lab_res_dimd = "Dímero D (µg/mL FEU)",
    dimdcat = "Niveles de Dímero D (µg/mL FEU)",
    
    lab_res_fibri = "Fibrinógeno (mg/dL)",
    fibricat = "Niveles de fibrinógeno (mg/dL)",
    
    lab_res_creat = "Creatinina (mg/dL)",
    creatcat = "Niveles de creatinina (mg/dL)",
    
    lab_res_gluc = "Glucosa (mg/dL)",
    gluccat = "Niveles de glucosa (mg/dL)",
    
    lab_res_pafi = "Relación PaO₂/FiO₂ (PaFi)",
    lab_res_granul = "Granulocitos (10^3/µL)",
    
    tag_efuspleu = "Presencia de derrame pleural (TAC)",
    tag_infilt = "Presencia de infiltrado pulmonar (TAC)",
    tag_compro = "Porcentaje de compromiso pulmonar (TAC)",
    
    death = "Condición al alta (vivo/muerto)",
    death_d = "Condición al alta (binario: 0=vivo, 1=muerto)"
  )

data_tidy <- data_tidy |> 
  mutate(across(
    where(~ inherits(., "labelled") && is.numeric(.)),
    ~ as.double(as_factor(.) %>% as.character()), 
    .names = "{.col}"
  ))

glimpse(data_tidy)

export(data_tidy, here::here("data", "tidy", "data_tidy.rds"))
