# -----------------------------------------------------------
# import_redcap_data.R
#
# Este script:
# - Carga los datos exportados desde REDCap en formato CSV
# - Asigna etiquetas (labels) a cada variable
# - Crea variables de tipo factor (duplicadas con sufijo `.factor`)
# - Asigna etiquetas a los niveles de las variables categóricas
#
# *Nota: REDCap crea redundancia entre columnas character y factor.
#        Esto puede requerir limpieza posterior del objeto `data`.
# -----------------------------------------------------------

# -----------------------------------------------------------
# Limpieza del entorno y gráficos
# -----------------------------------------------------------
clear_all()
graphics.off()

# -----------------------------------------------------------
# Carga de librerías
# -----------------------------------------------------------
load_and_check_versions(Hmisc)

# -----------------------------------------------------------
# Lectura de datos desde carpeta 'data/raw'
# -----------------------------------------------------------
data=read.csv(here::here("data", "raw", 'ValidacinDePuntajesD_DATA_2022-06-28_1816.csv'))

# -----------------------------------------------------------
# Asignación de etiquetas descriptivas (labels) a variables
# -----------------------------------------------------------
# Cada línea utiliza `label()` del paquete Hmisc para asignar
# una etiqueta de texto a cada variable del dataset.
# Esto permite conservar metadatos útiles durante el análisis.
# -----------------------------------------------------------
label(data$record_id)="ID de participante"
label(data$redcap_data_access_group)="Data Access Group"
label(data$recolect_id)="ID médico investigador"
label(data$fecha_llenado)="Fecha y hora de llenado del formulario"
label(data$doc_tipo_otros)="Otro tipo de documentos especificar"
label(data$sexo)="Sexo"
label(data$edad)="Edad al ingreso a Emergencias"
label(data$sint_resp)="Al momento del ingreso a Emergencias, ¿El paciente o acompañante de este reportó que el paciente era sintomático respiratorio?"
label(data$dx_covid_pcr)="Prueba Molecular de RT-PCR"
label(data$dx_covid_pantig)="Prueba de Antígeno"
label(data$dx_covid_prapid)="Prueba Rápida"
label(data$dx_covid_clintac)="Criterios clínicos tomográficos"
label(data$emerg_admin)="¿Fue admitido por el Servicio de Emergencias de CELIM COVID-19?"
label(data$emerg_admin_fecha)="Indicar fecha y hora de admisión al Servicio de Emergencias"
label(data$resid_ancian)="¿El paciente vive en una residencia para ancianos, asilo, casa de reposo u otro similar?"
label(data$elegibilidad)="Elegibilidad"
label(data$sint_dia)="Tiempo desde inicio de síntomas (en días)"
label(data$previo_covid)="Indicar si historia refiere que paciente tuvo COVID-19 o infección por SARS-CoV-2 previamente al cuadro actual"
label(data$vacuna)="Indicar si historia clínica refiere que paciente fue vacunado contra el COVID-19"
label(data$sint_confusion)="Confusión"
label(data$sint_disnea)="Disnea"
label(data$sint_fiebre)="Fiebre"
label(data$sint_fatiga)="Fatiga"
label(data$sint_mialgia)="Mialgia"
label(data$sint_artralgia)="Artralgia"
label(data$sint_rash)="Rash"
label(data$sint_tosseca)="Tos seca"
label(data$sint_tosprod)="Tos productiva"
label(data$sint_tosnodef)="Tos (no definido tipo)"
label(data$sint_dolortox)="Dolor de tórax"
label(data$sint_hemopt)="Hemoptisis"
label(data$sint_sibil)="Sibilancia"
label(data$sint_dolorgarg)="Dolor de garganta"
label(data$sint_rinorr)="Rinorrea"
label(data$sint_hipogeu)="Hipogeusia"
label(data$sint_otalg)="Otalgia"
label(data$sint_diarr)="Diarrea"
label(data$sint_nausea)="Náuseas"
label(data$sint_vomit)="Vómitos"
label(data$sint_dolorabdom)="Dolor abdominal"
label(data$sint_cefalea)="Cefalea"
label(data$oxigen)="Dispositivo para la adminsitración de oxígeno al momento del ingreso"
label(data$oxigen_tipo)="Tipo de apoyo oxigenatorio al ingreso"
label(data$oxigen_tipo_espec)="Especificar tipo de dispositivo de oxigeno - otros"
label(data$oxigen_aporte)="Aporte de oxígeno en litros"
label(data$alter_mental)="¿Presentó ESTADO MENTAL, DE CONCIENCIA O SENSORIO ALTERADO en la evaluación de INGRESO A EMERGENCIA?"
label(data$sv_temp_sino)="Temperatura - tiene"
label(data$sv_fr_sino)="Frecuencia respiratoria - tiene"
label(data$sv_fc_sino)="Pulso/Frecuencia Cardíaca - tiene"
label(data$sv_pas_sino)="Presión Arterial Sistólica - tiene"
label(data$sv_pad_sino)="Presión Arterial Diastólica - tiene"
label(data$sv_satoamb_sino)="Saturación de Oxígeno con aire ambiental - tiene"
label(data$sv_satodisp_sino)="Saturación de Oxígeno con dispositivo - tiene"
label(data$sv_glasgow_sino)="Puntaje Glasgow - tiene"
label(data$sv_temp_res)="Temperatura (Celsius) - Resultado"
label(data$sv_fr_res)="Frecuencia respiratoria - Resultado"
label(data$sv_fc_res)="Pulso/Frecuencia Cardíaca - Resultado"
label(data$sv_pas_res)="Presión Arterial Sistólica - Resultado"
label(data$sv_pad_res)="Presión Arterial Diastólica - Resultado"
label(data$sv_satoamb_res)="Saturación de Oxígeno aire ambiental - Resultado"
label(data$sv_satodisp_res)="Saturación de Oxígeno con dispositivo - Resultado"
label(data$sv_satodisp_fio2)="FiO2 (%)"
label(data$sv_glasgow_res)="Puntaje Glasgow - Resultado"
label(data$hepatomeg)="¿Tiene hepatomegalia? La evaluación puede ser semiológica o por imágenes."
label(data$esplenomeg)="¿Tiene esplenomegalia? La evaluación puede ser semiológica o por imágenes."
label(data$com_neop)="Enfermedad neoplásica"
label(data$com_hepa_leve)="Hepatopatía leve"
label(data$com_hepa_modsev)="Hepatopatía moderada a severa"
label(data$com_fcc)="Falla cardíaca congestiva"
label(data$com_ecv)="Enfermedad cerebrovascular"
label(data$com_er)="Historia de enfermedad renal"
label(data$com_im)="Infarto a miocardio"
label(data$com_evp)="Enfermedad vascular periférica"
label(data$com_tia)="Accidente isquémico transitorio"
label(data$com_demen)="Demencia"
label(data$com_epoc)="Enfermedad Pulmonar Obstructiva Crónica"
label(data$com_etc)="Enfermedad del tejido conjuntivo"
label(data$com_dmnc)="Diabetes mellitus NO complicada"
label(data$com_dmc)="Diabetes mellitus COMPLICADA (con daño de órgano blanco)"
label(data$com_hemip)="Hemiplejía"
label(data$com_erc_modsev)="Enfermedad renal crónica moderada a severa"
label(data$com_tsol_loc)="Tumor sólido localizado"
label(data$com_tsol_met)="Tumor sólido metastásico"
label(data$com_leuc)="Leucemia"
label(data$com_linf)="Linfoma"
label(data$com_sida)="SIDA"
label(data$com_hta)="Hipertensión Arterial"
label(data$antec_vacuna)="¿El paciente ya ha sido vacunado?"
label(data$antec_vacuna_dosis)="¿Cuántas dosis?"
label(data$inm_vih)="VIH positivo"
label(data$inm_ttoinmsup)="Terapia de imunosupresión de larga data (p. ej., glucocorticoides, ciclosporina, azatiopina, etc.)"
label(data$inm_inmsup_prim)="Inmunodeficiencia primaria"
label(data$peso_sino)="Peso - tiene"
label(data$talla_sino)="Talla - tiene"
label(data$obesidad_sino)="Obesidad - tiene"
label(data$peso_res)="Peso - resultado"
label(data$talla_res)="Talla - resultado"
label(data$obesidad_res)="Obesidad - resultado"
label(data$fecha_labo)="Fecha de resultados de laboratorio"
label(data$lab_sino_sod)="Sodio - tiene resultados"
label(data$lab_sino_clor)="Cloro - tiene resultados"
label(data$lab_sino_potas)="Potasio - tiene resultados"
label(data$lab_sino_urea)="Urea - tiene resultados"
label(data$lab_sino_creat)="Creatinina - tiene resultados"
label(data$lab_sino_gluc)="Glucosa - tiene resultados"
label(data$lab_sino_album)="Albúmina - tiene resultados"
label(data$lab_sino_hcto)="Hematocrito - tiene resultados"
label(data$lab_sino_hb)="Hemoglobina - tiene resultados"
label(data$lab_sino_leuc)="Conteo de leucocitos - tiene resultados"
label(data$lab_sino_neut)="Conteo de neutrófilos - tiene resultados"
label(data$lab_sino_granul)="Recuento de granulocitos inmaduros - tiene resultados"
label(data$lab_sino_linf)="Conteo de linfocitos - tiene resultados"
label(data$lab_sino_plaq)="Conteo de plaquetas - tiene resultados"
label(data$lab_sino_ph)="pH - tiene resultados"
label(data$lab_sino_pao2)="Presión parcial de oxígeno - tiene resultados"
label(data$lab_sino_pco2)="Presión parcial de CO2 - tiene resultados"
label(data$lab_sino_fio2)="Fracción de oxígeno inspirado - tiene resultados"
label(data$lab_sino_gaa)="Gradiente Alveolo-Arterial - tiene resultados"
label(data$lab_sino_pafi)="PAFI - tiene resultados"
label(data$lab_sino_lact)="Lactato - tiene resultados"
label(data$lab_sino_dimd)="Dímero D - tiene resultados"
label(data$lab_sino_fibri)="Fibrinógeno - tiene resultados"
label(data$lab_sino_dhl)="Deshidrogenasa láctica - tiene resultados"
label(data$lab_sino_pcr)="Proteína C reactiva - tiene resultados"
label(data$lab_sino_ferrit)="Ferritina - tiene resultados"
label(data$lab_sino_falc)="Fosfatasa alcalina - tiene resultados"
label(data$lab_sino_tgo)="TGO - tiene resultados"
label(data$lab_sino_tgp)="TGP - tiene resultados"
label(data$lab_sino_trigli)="Triglicéridos - tiene resultados"
label(data$lab_res_sod)="Sodio - resultado"
label(data$lab_res_clor)="Cloro - resultado"
label(data$lab_res_potas)="Potasio - resultado"
label(data$lab_res_urea)="Urea - resultado"
label(data$lab_res_creat)="Creatinina - resultado"
label(data$lab_res_gluc)="Glucosa - resultado"
label(data$lab_res_album)="Albúmina - resultado"
label(data$lab_res_hcto)="Hematocrito - resultado"
label(data$lab_res_hb)="Hemoglobina - resultado"
label(data$lab_res_leuc)="Conteo de leucocitos - resultado"
label(data$lab_res_neut)="Conteo de neutrófilos - resultado"
label(data$lab_res_granul)="Recuento de granulocitos inmaduros - resultado"
label(data$lab_res_linf)="Conteo de linfocitos - resultado"
label(data$lab_res_plaq)="Conteo de plaquetas - resultado"
label(data$lab_res_ph)="pH - resultado"
label(data$lab_res_pao2)="Presión parcial de oxígeno - resultado"
label(data$lab_res_pco2)="Presión parcial de CO2 - resultado"
label(data$lab_res_fio2)="Fracción de oxígeno inspirado - resultado"
label(data$lab_res_gaa)="Gradiente Alveolo-Arterial - resultado"
label(data$lab_res_pafi)="PAFI - resultado"
label(data$lab_res_lact)="Lactato - resultado"
label(data$lab_res_dimd)="Dímero D - resultado"
label(data$lab_res_fibri)="Fibrinógeno - resultado"
label(data$lab_res_dhl)="Deshidrogenasa láctica - resultado"
label(data$lab_res_pcr)="Proteína C Reactiva - resultado"
label(data$lab_res_ferrit)="Ferritina - resultado"
label(data$lab_res_falc)="Fosfatasa alcalina - resultado"
label(data$lab_res_tgo)="TGO - resultado"
label(data$lab_res_tgp)="TGP - resultado"
label(data$lab_res_trigli)="Triglicéridos - resultado"
label(data$rx_fecha)="Fecha de toma de radiografía de tórax"
label(data$rx_tiene)="¿Cuenta con radiografía de tórax tomada al ingreso en Emergencia?"
label(data$rx_efuspleu)="Efusión pleural según radiografía de tórax"
label(data$rx_infilt)="Infiltrado pulmonar según radiografía de tórax"
label(data$rx_compro_na___1)="No evaluación de compromiso pulmonar por radiografía de tórax (choice=No cuenta con evaluación de compromiso)"
label(data$rx_compro_na___ni)="No evaluación de compromiso pulmonar por radiografía de tórax (choice=No information)"
label(data$rx_compro)="Compromiso pulmonar  por radiografía de tórax"
label(data$tag_tiene)="¿Cuenta con tomografía de tórax tomada al ingreso en Emergencia?"
label(data$tag_fecha)="Fecha de toma de tomgorafía de tórax"
label(data$tag_efuspleu)="Efusión pleural según tomografía de tórax "
label(data$tag_infilt)="Infiltrado pulmonar según tomografía de tórax"
label(data$tag_compro_na___1)="No evaluación de compromiso pulmonar por tomografía de tórax (choice=No cuenta con evaluación de compromiso)"
label(data$tag_compro_na___ni)="No evaluación de compromiso pulmonar por tomografía de tórax (choice=No information)"
label(data$tag_compro)="Compromiso pulmonar por tomografía de tórax"
label(data$tag_corads)="¿Cuál es la categoría CO-RADS asignada al paciente?"
label(data$medicin_basal_complete)="Complete?"
label(data$recolect_id_2)="ID médico investigador"
label(data$fecha_llenado_2)="Fecha y hora de llenado del formulario"
label(data$fallec)="Durante su hospitalización, ¿el paciente falleció?"
label(data$fallec_fecha)="Fecha de fallecimiento"
label(data$fallec_hora)="Hora de fallecimiento"
label(data$fallec_causa)="Causa muerte - enfermedad que produjo muerte directamente"
label(data$fallec_relaccovid)="¿Muerte relacionada a COVID-19?"
label(data$fallec_lugar)="Lugar donde el paciente falleció"
label(data$alta)="¿El paciente fue dado de alta?"
label(data$alta_fecha)="Fecha cuando el paciente fue dado de alta"
label(data$alta_hora)="Hora cuando el paciente fue dado de alta (Consignar hora consignada en el registro electrónico)"
label(data$alta_motivo)="Motivo de alta"
label(data$vmi_crit)="¿Participante cumplió criterio de VMI en algun momento de su hospitalización?"
label(data$vmi_crit_cualcrit)="Detallar criterios para necesidad de VMI"
label(data$vmi_crit_fecha)="¿Cuándo cumplió criterio para VMI por primera vez? - Fecha"
label(data$vmi_crit_hora)="¿Cuándo cumplió criterio para VMI por primera vez? - Hora"
label(data$vmi)="¿El paciente inició VMI?"
label(data$vmi_fecha)="¿Cuándo inició VMI? - Fecha"
label(data$vmi_hora)="¿Cuándo inició VMI? - Hora"
label(data$desenlaces_de_estudio_complete)="Complete?"
#Setting Units


# -----------------------------------------------------------
# Creación de factores a partir de variables categóricas
# -----------------------------------------------------------
# REDCap genera columnas adicionales con el sufijo `.factor`,
# replicando el contenido de la columna original pero como factor.
# Estas variables suelen usarse para análisis estadísticos,
# gráficos, tabulados o modelado, y pueden ser limpiadas luego.
# -----------------------------------------------------------
data$redcap_data_access_group.factor = factor(data$redcap_data_access_group,levels=c("acceso01","acceso02","acceso03","acceso04","acceso05","acceso06","acceso07","acceso08","acceso09","acceso10","acceso11","acceso12","acceso13","acceso14","acceso15","acceso16"))
data$sexo.factor = factor(data$sexo,levels=c("1","2"))
data$sint_resp.factor = factor(data$sint_resp,levels=c("1","0","9999"))
data$dx_covid_pcr.factor = factor(data$dx_covid_pcr,levels=c("-9999","1","0"))
data$dx_covid_pantig.factor = factor(data$dx_covid_pantig,levels=c("-9999","1","0"))
data$dx_covid_prapid.factor = factor(data$dx_covid_prapid,levels=c("-9999","1","0"))
data$dx_covid_clintac.factor = factor(data$dx_covid_clintac,levels=c("-9999","1","0"))
data$emerg_admin.factor = factor(data$emerg_admin,levels=c("1","0"))
data$resid_ancian.factor = factor(data$resid_ancian,levels=c("1","0","9999"))
data$previo_covid.factor = factor(data$previo_covid,levels=c("1","0","9999"))
data$vacuna.factor = factor(data$vacuna,levels=c("1","0","9999"))
data$sint_confusion.factor = factor(data$sint_confusion,levels=c("9999","1","0"))
data$sint_disnea.factor = factor(data$sint_disnea,levels=c("9999","1","0"))
data$sint_fiebre.factor = factor(data$sint_fiebre,levels=c("9999","1","0"))
data$sint_fatiga.factor = factor(data$sint_fatiga,levels=c("9999","1","0"))
data$sint_mialgia.factor = factor(data$sint_mialgia,levels=c("9999","1","0"))
data$sint_artralgia.factor = factor(data$sint_artralgia,levels=c("9999","1","0"))
data$sint_rash.factor = factor(data$sint_rash,levels=c("9999","1","0"))
data$sint_tosseca.factor = factor(data$sint_tosseca,levels=c("9999","1","0"))
data$sint_tosprod.factor = factor(data$sint_tosprod,levels=c("9999","1","0"))
data$sint_tosnodef.factor = factor(data$sint_tosnodef,levels=c("9999","1","0"))
data$sint_dolortox.factor = factor(data$sint_dolortox,levels=c("9999","1","0"))
data$sint_hemopt.factor = factor(data$sint_hemopt,levels=c("9999","1","0"))
data$sint_sibil.factor = factor(data$sint_sibil,levels=c("9999","1","0"))
data$sint_dolorgarg.factor = factor(data$sint_dolorgarg,levels=c("9999","1","0"))
data$sint_rinorr.factor = factor(data$sint_rinorr,levels=c("9999","1","0"))
data$sint_hipogeu.factor = factor(data$sint_hipogeu,levels=c("9999","1","0"))
data$sint_otalg.factor = factor(data$sint_otalg,levels=c("9999","1","0"))
data$sint_diarr.factor = factor(data$sint_diarr,levels=c("9999","1","0"))
data$sint_nausea.factor = factor(data$sint_nausea,levels=c("9999","1","0"))
data$sint_vomit.factor = factor(data$sint_vomit,levels=c("9999","1","0"))
data$sint_dolorabdom.factor = factor(data$sint_dolorabdom,levels=c("9999","1","0"))
data$sint_cefalea.factor = factor(data$sint_cefalea,levels=c("9999","1","0"))
data$oxigen.factor = factor(data$oxigen,levels=c("1","0","9999"))
data$oxigen_tipo.factor = factor(data$oxigen_tipo,levels=c("1","2","3","4","5","6","7","8"))
data$alter_mental.factor = factor(data$alter_mental,levels=c("1","0","9999"))
data$sv_temp_sino.factor = factor(data$sv_temp_sino,levels=c("1","0"))
data$sv_fr_sino.factor = factor(data$sv_fr_sino,levels=c("1","0"))
data$sv_fc_sino.factor = factor(data$sv_fc_sino,levels=c("1","0"))
data$sv_pas_sino.factor = factor(data$sv_pas_sino,levels=c("1","0"))
data$sv_pad_sino.factor = factor(data$sv_pad_sino,levels=c("1","0"))
data$sv_satoamb_sino.factor = factor(data$sv_satoamb_sino,levels=c("1","0"))
data$sv_satodisp_sino.factor = factor(data$sv_satodisp_sino,levels=c("1","0"))
data$sv_glasgow_sino.factor = factor(data$sv_glasgow_sino,levels=c("1","0"))
data$hepatomeg.factor = factor(data$hepatomeg,levels=c("1","0","9999"))
data$esplenomeg.factor = factor(data$esplenomeg,levels=c("1","0","9999"))
data$com_neop.factor = factor(data$com_neop,levels=c("1","0","9999"))
data$com_hepa_leve.factor = factor(data$com_hepa_leve,levels=c("1","0","9999"))
data$com_hepa_modsev.factor = factor(data$com_hepa_modsev,levels=c("1","0","9999"))
data$com_fcc.factor = factor(data$com_fcc,levels=c("1","0","9999"))
data$com_ecv.factor = factor(data$com_ecv,levels=c("1","0","9999"))
data$com_er.factor = factor(data$com_er,levels=c("1","0","9999"))
data$com_im.factor = factor(data$com_im,levels=c("1","0","9999"))
data$com_evp.factor = factor(data$com_evp,levels=c("1","0","9999"))
data$com_tia.factor = factor(data$com_tia,levels=c("1","0","9999"))
data$com_demen.factor = factor(data$com_demen,levels=c("1","0","9999"))
data$com_epoc.factor = factor(data$com_epoc,levels=c("1","0","9999"))
data$com_etc.factor = factor(data$com_etc,levels=c("1","0","9999"))
data$com_dmnc.factor = factor(data$com_dmnc,levels=c("1","0","9999"))
data$com_dmc.factor = factor(data$com_dmc,levels=c("1","0","9999"))
data$com_hemip.factor = factor(data$com_hemip,levels=c("1","0","9999"))
data$com_erc_modsev.factor = factor(data$com_erc_modsev,levels=c("1","0","9999"))
data$com_tsol_loc.factor = factor(data$com_tsol_loc,levels=c("1","0","9999"))
data$com_tsol_met.factor = factor(data$com_tsol_met,levels=c("1","0","9999"))
data$com_leuc.factor = factor(data$com_leuc,levels=c("1","0","9999"))
data$com_linf.factor = factor(data$com_linf,levels=c("1","0","9999"))
data$com_sida.factor = factor(data$com_sida,levels=c("1","0","9999"))
data$com_hta.factor = factor(data$com_hta,levels=c("1","0","9999"))
data$antec_vacuna.factor = factor(data$antec_vacuna,levels=c("1","0","9999"))
data$antec_vacuna_dosis.factor = factor(data$antec_vacuna_dosis,levels=c("1","2","3","9999"))
data$inm_vih.factor = factor(data$inm_vih,levels=c("1","0","9999"))
data$inm_ttoinmsup.factor = factor(data$inm_ttoinmsup,levels=c("1","0","9999"))
data$inm_inmsup_prim.factor = factor(data$inm_inmsup_prim,levels=c("1","0","9999"))
data$peso_sino.factor = factor(data$peso_sino,levels=c("1","0","9999"))
data$talla_sino.factor = factor(data$talla_sino,levels=c("1","0","9999"))
data$obesidad_sino.factor = factor(data$obesidad_sino,levels=c("1","0","9999"))
data$obesidad_res.factor = factor(data$obesidad_res,levels=c("1","2","3","4"))
data$lab_sino_sod.factor = factor(data$lab_sino_sod,levels=c("1","0"))
data$lab_sino_clor.factor = factor(data$lab_sino_clor,levels=c("1","0"))
data$lab_sino_potas.factor = factor(data$lab_sino_potas,levels=c("1","0"))
data$lab_sino_urea.factor = factor(data$lab_sino_urea,levels=c("1","0"))
data$lab_sino_creat.factor = factor(data$lab_sino_creat,levels=c("1","0"))
data$lab_sino_gluc.factor = factor(data$lab_sino_gluc,levels=c("1","0"))
data$lab_sino_album.factor = factor(data$lab_sino_album,levels=c("1","0"))
data$lab_sino_hcto.factor = factor(data$lab_sino_hcto,levels=c("1","0"))
data$lab_sino_hb.factor = factor(data$lab_sino_hb,levels=c("1","0"))
data$lab_sino_leuc.factor = factor(data$lab_sino_leuc,levels=c("1","0"))
data$lab_sino_neut.factor = factor(data$lab_sino_neut,levels=c("1","0"))
data$lab_sino_granul.factor = factor(data$lab_sino_granul,levels=c("1","0"))
data$lab_sino_linf.factor = factor(data$lab_sino_linf,levels=c("1","0"))
data$lab_sino_plaq.factor = factor(data$lab_sino_plaq,levels=c("1","0"))
data$lab_sino_ph.factor = factor(data$lab_sino_ph,levels=c("1","0"))
data$lab_sino_pao2.factor = factor(data$lab_sino_pao2,levels=c("1","0"))
data$lab_sino_pco2.factor = factor(data$lab_sino_pco2,levels=c("1","0"))
data$lab_sino_fio2.factor = factor(data$lab_sino_fio2,levels=c("1","0"))
data$lab_sino_gaa.factor = factor(data$lab_sino_gaa,levels=c("1","0"))
data$lab_sino_pafi.factor = factor(data$lab_sino_pafi,levels=c("1","0"))
data$lab_sino_lact.factor = factor(data$lab_sino_lact,levels=c("1","0"))
data$lab_sino_dimd.factor = factor(data$lab_sino_dimd,levels=c("1","0"))
data$lab_sino_fibri.factor = factor(data$lab_sino_fibri,levels=c("1","0"))
data$lab_sino_dhl.factor = factor(data$lab_sino_dhl,levels=c("1","0"))
data$lab_sino_pcr.factor = factor(data$lab_sino_pcr,levels=c("1","0"))
data$lab_sino_ferrit.factor = factor(data$lab_sino_ferrit,levels=c("1","0"))
data$lab_sino_falc.factor = factor(data$lab_sino_falc,levels=c("1","0"))
data$lab_sino_tgo.factor = factor(data$lab_sino_tgo,levels=c("1","0"))
data$lab_sino_tgp.factor = factor(data$lab_sino_tgp,levels=c("1","0"))
data$lab_sino_trigli.factor = factor(data$lab_sino_trigli,levels=c("1","0"))
data$rx_tiene.factor = factor(data$rx_tiene,levels=c("1","0"))
data$rx_efuspleu.factor = factor(data$rx_efuspleu,levels=c("1","0"))
data$rx_infilt.factor = factor(data$rx_infilt,levels=c("1","0"))
data$rx_compro_na___1.factor = factor(data$rx_compro_na___1,levels=c("0","1"))
data$rx_compro_na___ni.factor = factor(data$rx_compro_na___ni,levels=c("0","1"))
data$tag_tiene.factor = factor(data$tag_tiene,levels=c("1","0"))
data$tag_efuspleu.factor = factor(data$tag_efuspleu,levels=c("1","0"))
data$tag_infilt.factor = factor(data$tag_infilt,levels=c("1","0"))
data$tag_compro_na___1.factor = factor(data$tag_compro_na___1,levels=c("0","1"))
data$tag_compro_na___ni.factor = factor(data$tag_compro_na___ni,levels=c("0","1"))
data$tag_corads.factor = factor(data$tag_corads,levels=c("9999","0","1","2","3","4","5","6"))
data$medicin_basal_complete.factor = factor(data$medicin_basal_complete,levels=c("0","1","2"))
data$fallec.factor = factor(data$fallec,levels=c("1","0","9999"))
data$fallec_relaccovid.factor = factor(data$fallec_relaccovid,levels=c("1","0","9999"))
data$fallec_lugar.factor = factor(data$fallec_lugar,levels=c("1","2","3","4","9999"))
data$alta.factor = factor(data$alta,levels=c("1","0","9999"))
data$alta_motivo.factor = factor(data$alta_motivo,levels=c("1","2","3","9999"))
data$vmi_crit.factor = factor(data$vmi_crit,levels=c("1","0","9999"))
data$vmi.factor = factor(data$vmi,levels=c("1","0","9999"))
data$desenlaces_de_estudio_complete.factor = factor(data$desenlaces_de_estudio_complete,levels=c("0","1","2"))

# -----------------------------------------------------------
# Asignación de etiquetas a los niveles de los factores
# -----------------------------------------------------------
# Cada línea asigna etiquetas legibles a los niveles de las
# variables categóricas tipo factor, lo cual es útil para
# visualización y modelamiento interpretativo.
# -----------------------------------------------------------

levels(data$redcap_data_access_group.factor)=c("acceso01","acceso02","acceso03","acceso04","acceso05","acceso06","acceso07","acceso08","acceso09","acceso10","acceso11","acceso12","acceso13","acceso14","acceso15","acceso16")
levels(data$sexo.factor)=c("Femenino","Masculino")
levels(data$sint_resp.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$dx_covid_pcr.factor)=c("No cuenta  con prueba o evaluación","Positivo (cuenta con prueba o evaluación)","Negativo (cuenta con prueba o evaluación)")
levels(data$dx_covid_pantig.factor)=c("No cuenta  con prueba o evaluación","Positivo (cuenta con prueba o evaluación)","Negativo (cuenta con prueba o evaluación)")
levels(data$dx_covid_prapid.factor)=c("No cuenta  con prueba o evaluación","Positivo (cuenta con prueba o evaluación)","Negativo (cuenta con prueba o evaluación)")
levels(data$dx_covid_clintac.factor)=c("No cuenta  con prueba o evaluación","Positivo (cuenta con prueba o evaluación)","Negativo (cuenta con prueba o evaluación)")
levels(data$emerg_admin.factor)=c("Sí","No")
levels(data$resid_ancian.factor)=c("Sí (historia lo indica)","No (historia lo indica o se infiere de la historia)","Información no disponible en la historia")
levels(data$previo_covid.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$vacuna.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$sint_confusion.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_disnea.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_fiebre.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_fatiga.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_mialgia.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_artralgia.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_rash.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_tosseca.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_tosprod.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_tosnodef.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_dolortox.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_hemopt.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_sibil.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_dolorgarg.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_rinorr.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_hipogeu.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_otalg.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_diarr.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_nausea.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_vomit.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_dolorabdom.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$sint_cefalea.factor)=c("Información no disponible en la historia","Sí (historia lo indica)","No (historia lo indica)")
levels(data$oxigen.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$oxigen_tipo.factor)=c("Cánula simple","Mascarilla simple","Mascarilla venturi","Mascarilla de reservorio","Cánula nasal simple + mascarilla de reservorio","Cánula de Alto Flujo","Ventilador mecánico","Otras {oxigen_tipo_espec:icons}")
levels(data$alter_mental.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$sv_temp_sino.factor)=c("Si","No")
levels(data$sv_fr_sino.factor)=c("Si","No")
levels(data$sv_fc_sino.factor)=c("Si","No")
levels(data$sv_pas_sino.factor)=c("Si","No")
levels(data$sv_pad_sino.factor)=c("Si","No")
levels(data$sv_satoamb_sino.factor)=c("Si","No")
levels(data$sv_satodisp_sino.factor)=c("Si","No")
levels(data$sv_glasgow_sino.factor)=c("Si","No")
levels(data$hepatomeg.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$esplenomeg.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_neop.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_hepa_leve.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_hepa_modsev.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_fcc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_ecv.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_er.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_im.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_evp.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_tia.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_demen.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_epoc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_etc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_dmnc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_dmc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_hemip.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_erc_modsev.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_tsol_loc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_tsol_met.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_leuc.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_linf.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_sida.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$com_hta.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$antec_vacuna.factor)=c("Sí","No","Información no disponible en la historia")
levels(data$antec_vacuna_dosis.factor)=c("Una dosis","Dos dosis","Tres dosis","Información no disponible en la historia")
levels(data$inm_vih.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$inm_ttoinmsup.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$inm_inmsup_prim.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$peso_sino.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$talla_sino.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$obesidad_sino.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$obesidad_res.factor)=c("Sí (IMC > 30)","No (IMC < = 30)","Sí (sin medición de IMC, solo por evaluación clínica o autoreporte de peso/talla)","No (sin medición de IMC, solo por evaluación clínica o autoreporte de peso/talla)")
levels(data$lab_sino_sod.factor)=c("Sí","No")
levels(data$lab_sino_clor.factor)=c("Sí","No")
levels(data$lab_sino_potas.factor)=c("Sí","No")
levels(data$lab_sino_urea.factor)=c("Sí","No")
levels(data$lab_sino_creat.factor)=c("Sí","No")
levels(data$lab_sino_gluc.factor)=c("Sí","No")
levels(data$lab_sino_album.factor)=c("Sí","No")
levels(data$lab_sino_hcto.factor)=c("Sí","No")
levels(data$lab_sino_hb.factor)=c("Sí","No")
levels(data$lab_sino_leuc.factor)=c("Sí","No")
levels(data$lab_sino_neut.factor)=c("Sí","No")
levels(data$lab_sino_granul.factor)=c("Sí","No")
levels(data$lab_sino_linf.factor)=c("Sí","No")
levels(data$lab_sino_plaq.factor)=c("Sí","No")
levels(data$lab_sino_ph.factor)=c("Sí","No")
levels(data$lab_sino_pao2.factor)=c("Sí","No")
levels(data$lab_sino_pco2.factor)=c("Sí","No")
levels(data$lab_sino_fio2.factor)=c("Sí","No")
levels(data$lab_sino_gaa.factor)=c("Sí","No")
levels(data$lab_sino_pafi.factor)=c("Sí","No")
levels(data$lab_sino_lact.factor)=c("Sí","No")
levels(data$lab_sino_dimd.factor)=c("Sí","No")
levels(data$lab_sino_fibri.factor)=c("Sí","No")
levels(data$lab_sino_dhl.factor)=c("Sí","No")
levels(data$lab_sino_pcr.factor)=c("Sí","No")
levels(data$lab_sino_ferrit.factor)=c("Sí","No")
levels(data$lab_sino_falc.factor)=c("Sí","No")
levels(data$lab_sino_tgo.factor)=c("Sí","No")
levels(data$lab_sino_tgp.factor)=c("Sí","No")
levels(data$lab_sino_trigli.factor)=c("Sí","No")
levels(data$rx_tiene.factor)=c("Si","No")
levels(data$rx_efuspleu.factor)=c("Si","No")
levels(data$rx_infilt.factor)=c("Si","No")
levels(data$rx_compro_na___1.factor)=c("Unchecked","Checked")
levels(data$rx_compro_na___ni.factor)=c("Unchecked","Checked")
levels(data$tag_tiene.factor)=c("Si","No")
levels(data$tag_efuspleu.factor)=c("Si","No")
levels(data$tag_infilt.factor)=c("Si","No")
levels(data$tag_compro_na___1.factor)=c("Unchecked","Checked")
levels(data$tag_compro_na___ni.factor)=c("Unchecked","Checked")
levels(data$tag_corads.factor)=c("No cuenta con categoría CO-RADS","0 (No interpretable)","1 (Muy baja)","2 (Baja)","3 (Equívoca)","4 (Alta)","5 (Muy alta)","6 (Confirmado)")
levels(data$medicin_basal_complete.factor)=c("Incomplete","Unverified","Complete")
levels(data$fallec.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$fallec_relaccovid.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$fallec_lugar.factor)=c("Hospitalización/Emergencias HNERM","UCI HNERM","Otro hospital o centros de salud (Especificar): {fallec_lugar_otros}","Hogar","Información no disponible en la historia")
levels(data$alta.factor)=c("Sí","No","Información no disponible en la historia")
levels(data$alta_motivo.factor)=c("Curación o Mejoría","Transferencia a otro establecimiento","Alta voluntaria","Información no disponible en la historia")
levels(data$vmi_crit.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$vmi.factor)=c("Sí (historia lo indica)","No (historia lo indica)","Información no disponible en la historia")
levels(data$desenlaces_de_estudio_complete.factor)=c("Incomplete","Unverified","Complete")

# -----------------------------------------------------------
# NOTA FINAL:
# Para eliminar las variables con sufijo `.factor` (redundantes),
# puede usarse una función como:
#
#   data <- data[, !grepl("\\.factor$", names(data))]
#
# o usar la función personalizada `redcap_to_r_data_set()`
# que ya evita crear estas columnas innecesarias.
# -----------------------------------------------------------
