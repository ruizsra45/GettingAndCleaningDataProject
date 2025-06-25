# ===============================================================================
# Proyecto: Limpieza de Datos - Human Activity Recognition Using Smartphones
# Autor: Sergio Ruiz Arévalo 
# Fecha: 25/6/2025
# Descripción: Script para limpiar y preparar datos de acelerómetros de smartphones
# ===============================================================================

# Cargar librerías necesarias
library(dplyr)
library(tidyr)
library(readr)

# Función para descargar y descomprimir datos si no existen
descargar_datos <- function() {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  archivo_zip <- "UCI_HAR_Dataset.zip"
  
  if (!file.exists(archivo_zip)) {
    cat("Descargando datos...\n")
    download.file(url, archivo_zip, method = "curl")
  }
  
  if (!dir.exists("UCI HAR Dataset")) {
    cat("Descomprimiendo datos...\n")
    unzip(archivo_zip)
  }
}

# Función principal de análisis
run_analysis <- function() {
  
  # Descargar datos si es necesario
  descargar_datos()
  
  cat("Iniciando análisis de datos...\n")
  
  # ============================================================================
  # PASO 0: Cargar archivos de referencia
  # ============================================================================
  
  cat("Cargando archivos de referencia...\n")
  
  # Cargar nombres de características (features)
  features <- read.table("UCI HAR Dataset/features.txt", 
                        col.names = c("id", "feature"))
  
  # Cargar etiquetas de actividades
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                                col.names = c("id", "activity"))
  
  # ============================================================================
  # PASO 1: Fusionar conjuntos de entrenamiento y prueba
  # ============================================================================
  
  cat("Paso 1: Fusionando datos de entrenamiento y prueba...\n")
  
  # Cargar datos de entrenamiento
  X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  
  # Cargar datos de prueba
  X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  
  # Fusionar datos
  X_combined <- rbind(X_train, X_test)
  y_combined <- rbind(y_train, y_test)
  subject_combined <- rbind(subject_train, subject_test)
  
  # Combinar todo en un solo data frame
  datos_completos <- cbind(subject_combined, y_combined, X_combined)
  
  cat(sprintf("Datos fusionados: %d filas, %d columnas\n", 
              nrow(datos_completos), ncol(datos_completos)))
  
  # ============================================================================
  # PASO 2: Extraer solo mediciones de media y desviación estándar
  # ============================================================================
  
  cat("Paso 2: Extrayendo mediciones de media y desviación estándar...\n")
  
  # Identificar columnas con mean() y std()
  indices_mean_std <- grep("mean\\(\\)|std\\(\\)", features$feature)
  
  # Seleccionar columnas (subject + activity_id + mediciones mean/std)
  columnas_seleccionadas <- c(1, 2, indices_mean_std + 2)
  datos_filtrados <- datos_completos[, columnas_seleccionadas]
  
  cat(sprintf("Columnas seleccionadas: %d (incluyendo subject y activity)\n", 
              ncol(datos_filtrados)))
  
  # ============================================================================
  # PASO 3: Usar nombres descriptivos para actividades
  # ============================================================================
  
  cat("Paso 3: Aplicando nombres descriptivos a actividades...\n")
  
  # Fusionar con etiquetas de actividades
  datos_con_actividades <- merge(datos_filtrados, activity_labels, 
                                by.x = "activity_id", by.y = "id", all.x = TRUE)
  
  # Remover columna activity_id y reorganizar
  datos_con_actividades <- datos_con_actividades %>%
    select(-activity_id) %>%
    select(subject, activity, everything())
  
  # ============================================================================
  # PASO 4: Etiquetar con nombres descriptivos de variables
  # ============================================================================
  
  cat("Paso 4: Aplicando nombres descriptivos a variables...\n")
  
  # Obtener nombres de características para las columnas seleccionadas
  nombres_features <- features$feature[indices_mean_std]
  
  # Limpiar y hacer más descriptivos los nombres
  nombres_descriptivos <- nombres_features %>%
    gsub("^t", "Time", .) %>%
    gsub("^f", "Frequency", .) %>%
    gsub("Acc", "Accelerometer", .) %>%
    gsub("Gyro", "Gyroscope", .) %>%
    gsub("Mag", "Magnitude", .) %>%
    gsub("BodyBody", "Body", .) %>%
    gsub("-mean\\(\\)", "Mean", .) %>%
    gsub("-std\\(\\)", "StandardDeviation", .) %>%
    gsub("-X", "X", .) %>%
    gsub("-Y", "Y", .) %>%
    gsub("-Z", "Z", .)
  
  # Aplicar nombres descriptivos
  colnames(datos_con_actividades) <- c("subject", "activity", nombres_descriptivos)
  
  # ============================================================================
  # PASO 5: Crear conjunto de datos final con promedios
  # ============================================================================
  
  cat("Paso 5: Creando conjunto de datos final con promedios...\n")
  
  # Calcular promedio de cada variable por sujeto y actividad
  datos_finales <- datos_con_actividades %>%
    group_by(subject, activity) %>%
    summarise_all(mean, na.rm = TRUE) %>%
    ungroup()
  
  # Ordenar por sujeto y actividad
  datos_finales <- datos_finales %>%
    arrange(subject, activity)
  
  cat(sprintf("Datos finales: %d filas, %d columnas\n", 
              nrow(datos_finales), ncol(datos_finales)))
  
  # ============================================================================
  # GUARDAR RESULTADOS
  # ============================================================================
  
  cat("Guardando resultados...\n")
  
  # Guardar conjunto de datos final
  write.table(datos_finales, "datos_limpios_finales.txt", 
              row.names = FALSE, quote = FALSE, sep = "\t")
  
  # Guardar también en formato CSV para mayor compatibilidad
  write_csv(datos_finales, "datos_limpios_finales.csv")
  
  # Crear resumen de las transformaciones
  resumen <- list(
    filas_originales = nrow(datos_completos),
    columnas_originales = ncol(datos_completos),
    columnas_mean_std = length(indices_mean_std),
    filas_finales = nrow(datos_finales),
    columnas_finales = ncol(datos_finales),
    sujetos = length(unique(datos_finales$subject)),
    actividades = length(unique(datos_finales$activity))
  )
  
  # Mostrar resumen
  cat("\n=== RESUMEN DEL ANÁLISIS ===\n")
  cat(sprintf("Filas originales: %d\n", resumen$filas_originales))
  cat(sprintf("Columnas originales: %d\n", resumen$columnas_originales))
  cat(sprintf("Columnas con mean/std: %d\n", resumen$columnas_mean_std))
  cat(sprintf("Filas finales: %d\n", resumen$filas_finales))
  cat(sprintf("Columnas finales: %d\n", resumen$columnas_finales))
  cat(sprintf("Número de sujetos: %d\n", resumen$sujetos))
  cat(sprintf("Número de actividades: %d\n", resumen$actividades))
  
  cat("\nActividades incluidas:\n")
  print(unique(datos_finales$activity))
  
  cat("\nPrimeras filas del conjunto final:\n")
  print(head(datos_finales, 3))
  
  cat("\nAnálisis completado exitosamente!\n")
  cat("Archivos generados:\n")
  cat("- datos_limpios_finales.txt\n")
  cat("- datos_limpios_finales.csv\n")
  
  return(datos_finales)
}

# Ejecutar análisis principal
if (!interactive()) {
  datos_resultado <- run_analysis()
}