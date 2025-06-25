# ===============================================================================
# EJEMPLO DE EJECUCIÓN Y VALIDACIÓN DEL PROYECTO
# ===============================================================================

# Cargar librerías
library(dplyr)
library(tidyr)
library(readr)

# ===============================================================================
# 1. EJECUTAR EL ANÁLISIS PRINCIPAL
# ===============================================================================

# Cargar y ejecutar el script principal
source("run_analysis.R")

# Ejecutar análisis (esto descargará datos si es necesario)
datos_resultado <- run_analysis()

# ===============================================================================
# 2. VALIDACIONES DEL CONJUNTO DE DATOS FINAL
# ===============================================================================

cat("\n=== VALIDACIONES DEL CONJUNTO DE DATOS ===\n")

# Cargar datos finales para validación
datos_finales <- read.table("datos_limpios_finales.txt", header = TRUE)

# Validación 1: Dimensiones correctas
cat("1. Validando dimensiones...\n")
cat(sprintf("   Filas: %d (esperado: 180)\n", nrow(datos_finales)))
cat(sprintf("   Columnas: %d (esperado: 68)\n", ncol(datos_finales)))

validacion_dim <- nrow(datos_finales) == 180 & ncol(datos_finales) == 68
cat(sprintf("   ✓ Dimensiones correctas: %s\n", validacion_dim))

# Validación 2: Sujetos completos
cat("\n2. Validando sujetos...\n")
sujetos_unicos <- unique(datos_finales$subject)
cat(sprintf("   Sujetos únicos: %d (esperado: 30)\n", length(sujetos_unicos)))
cat(sprintf("   Rango de sujetos: %d-%d\n", min(sujetos_unicos), max(sujetos_unicos)))

validacion_sujetos <- length(sujetos_unicos) == 30 & all(sujetos_unicos == 1:30)
cat(sprintf("   ✓ Sujetos completos: %s\n", validacion_sujetos))

# Validación 3: Actividades completas
cat("\n3. Validando actividades...\n")
actividades_unicas <- unique(datos_finales$activity)
actividades_esperadas <- c("LAYING", "SITTING", "STANDING", "WALKING", 
                          "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS")
cat(sprintf("   Actividades únicas: %d (esperado: 6)\n", length(actividades_unicas)))
cat("   Actividades encontradas:\n")
for(act in sort(actividades_unicas)) {
  cat(sprintf("     - %s\n", act))
}

validacion_actividades <- length(actividades_unicas) == 6 & 
                         all(sort(actividades_unicas) == sort(actividades_esperadas))
cat(sprintf("   ✓ Actividades completas: %s\n", validacion_actividades))

# Validación 4: Sin valores faltantes
cat("\n4. Validando valores faltantes...\n")
valores_na <- sum(is.na(datos_finales))
cat(sprintf("   Valores NA encontrados: %d\n", valores_na))

validacion_na <- valores_na == 0
cat(sprintf("   ✓ Sin valores faltantes: %s\n", validacion_na))

# Validación 5: Rango de valores de mediciones
cat("\n5. Validando rangos de mediciones...\n")
# Excluir columnas de identificación
columnas_medicion <- datos_finales[, -c(1,2)]
valor_min <- min(columnas_medicion)
valor_max <- max(columnas_medicion)
cat(sprintf("   Valor mínimo: %.6f\n", valor_min))
cat(sprintf("   Valor máximo: %.6f\n", valor_max))

validacion_rango <- valor_min >= -1 & valor_max <= 1
cat(sprintf("   ✓ Valores en rango [-1,1]: %s\n", validacion_rango))

# Validación 6: Estructura de datos ordenados (tidy)
cat("\n6. Validando estructura tidy...\n")
# Verificar que cada combinación sujeto-actividad aparece exactamente una vez
combinaciones <- datos_finales %>% 
  count(subject, activity) %>% 
  pull(n)

validacion_tidy <- all(combinaciones == 1) & length(combinaciones) == 180
cat(sprintf("   Combinaciones únicas sujeto-actividad: %d\n", length(combinaciones)))
cat(sprintf("   ✓ Estructura tidy correcta: %s\n", validacion_tidy))

# ===============================================================================
# 3. RESUMEN DE VALIDACIONES
# ===============================================================================

cat("\n=== RESUMEN DE VALIDACIONES ===\n")
validaciones <- c(
  "Dimensiones" = validacion_dim,
  "Sujetos" = validacion_sujetos, 
  "Actividades" = validacion_actividades,
  "Sin valores NA" = validacion_na,
  "Rango de valores" = validacion_rango,
  "Estructura tidy" = validacion_tidy
)

for(i in 1:length(validaciones)) {
  estado <- ifelse(validaciones[i], "✓ PASÓ", "✗ FALLÓ")
  cat(sprintf("%s: %s\n", names(validaciones)[i], estado))
}

todas_validaciones <- all(validaciones)
cat(sprintf("\n🎯 RESULTADO GENERAL: %s\n", 
            ifelse(todas_validaciones, "TODAS LAS VALIDACIONES PASARON", 
                   "ALGUNAS VALIDACIONES FALLARON")))

# ===============================================================================
# 4. ESTADÍSTICAS DESCRIPTIVAS
# ===============================================================================

cat("\n=== ESTADÍSTICAS DESCRIPTIVAS ===\n")

# Resumen por actividad
cat("\n4.1 Distribución por actividad:\n")
tabla_actividades <- datos_finales %>% 
  count(activity) %>% 
  arrange(activity)
print(tabla_actividades)

# Resumen de algunas variables clave
cat("\n4.2 Estadísticas de variables seleccionadas:\n")
variables_ejemplo <- c("TimeBodyAccelerometerMeanX", 
                      "TimeBodyAccelerometerMeanY",
                      "TimeBodyAccelerometerMeanZ")

for(var in variables_ejemplo) {
  if(var %in% names(datos_finales)) {
    cat(sprintf("\n%s:\n", var))
    stats <- summary(datos_finales[[var]])
    print(stats)
  }
}

# ===============================================================================
# 5. EJEMPLOS DE USO DE LOS DATOS
# ===============================================================================

cat("\n=== EJEMPLOS DE USO ===\n")

# Ejemplo 1: Promedio de aceleración por actividad
cat("\n5.1 Promedio de aceleración en X por actividad:\n")
ejemplo1 <- datos_finales %>% 
  group_by(activity) %>% 
  summarise(
    promedio_acc_x = mean(TimeBodyAccelerometerMeanX, na.rm = TRUE),
    .groups = 'drop'
  ) %>% 
  arrange(desc(promedio_acc_x))
print(ejemplo1)

# Ejemplo 2: Datos de un sujeto específico
cat("\n5.2 Datos del sujeto 1:\n")
ejemplo2 <- datos_finales %>% 
  filter(subject == 1) %>% 
  select(subject, activity, TimeBodyAccelerometerMeanX, TimeBodyAccelerometerMeanY, TimeBodyAccelerometerMeanZ)
print(ejemplo2)

# Ejemplo 3: Comparación entre actividades dinámicas vs estáticas
cat("\n5.3 Comparación actividades dinámicas vs estáticas:\n")
ejemplo3 <- datos_finales %>% 
  mutate(
    tipo_actividad = case_when(
      activity %in% c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS") ~ "Dinámica",
      activity %in% c("SITTING", "STANDING", "LAYING") ~ "Estática"
    )
  ) %>% 
  group_by(tipo_actividad) %>% 
  summarise(
    n_observaciones = n(),
    promedio_acc_magnitude = mean(TimeBodyAccelerometerMagnitudeMean, na.rm = TRUE),
    promedio_gyro_magnitude = mean(TimeBodyGyroscopeMagnitudeMean, na.rm = TRUE),
    .groups = 'drop'
  )
print(ejemplo3)

# ===============================================================================
# 6. VERIFICACIÓN DE ARCHIVOS GENERADOS
# ===============================================================================

cat("\n=== VERIFICACIÓN DE ARCHIVOS ===\n")

archivos_esperados <- c("datos_limpios_finales.txt", "datos_limpios_finales.csv")

for(archivo in archivos_esperados) {
  existe <- file.exists(archivo)
  if(existe) {
    tamaño <- file.size(archivo)
    cat(sprintf("✓ %s - Tamaño: %d bytes\n", archivo, tamaño))
  } else {
    cat(sprintf("✗ %s - NO ENCONTRADO\n", archivo))
  }
}

# ===============================================================================
# 7. CÓDIGO DE VERIFICACIÓN PARA GITHUB
# ===============================================================================

cat("\n=== CÓDIGO PARA VERIFICACIÓN EN GITHUB ===\n")

# Este código puede ser usado por otros para verificar el conjunto de datos
codigo_verificacion <- '
# Código de verificación rápida
datos <- read.table("datos_limpios_finales.txt", header = TRUE)
cat("Dimensiones:", dim(datos), "\n")
cat("Sujetos únicos:", length(unique(datos$subject)), "\n") 
cat("Actividades únicas:", length(unique(datos$activity)), "\n")
cat("Valores NA:", sum(is.na(datos)), "\n")
cat("Rango de valores:", range(datos[,-c(1,2)]), "\n")
'

cat("Copiar y pegar en R para verificación rápida:\n")
cat(codigo_verificacion)

cat("\n=== ANÁLISIS Y VALIDACIÓN COMPLETADOS ===\n")