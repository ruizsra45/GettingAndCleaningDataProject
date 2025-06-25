# Proyecto de Limpieza de Datos: Human Activity Recognition

## Descripción del Proyecto

Este proyecto demuestra la capacidad de recopilar, trabajar y limpiar un conjunto de datos para su análisis posterior. Trabajamos con datos de acelerómetros de smartphones Samsung Galaxy S que capturan información sobre actividades humanas.

## Conjunto de Datos

Los datos provienen del estudio "Human Activity Recognition Using Smartphones" del UCI Machine Learning Repository. El dataset contiene mediciones de acelerómetros y giroscopios de 30 voluntarios realizando 6 actividades diferentes.

**Fuente original:** http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

**Datos del proyecto:** https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Archivos del Repositorio

### Archivos Principales
- `run_analysis.R`: Script principal que ejecuta todo el proceso de limpieza
- `README.md`: Este archivo con la documentación del proyecto
- `CodeBook.md`: Descripción detallada de variables, datos y transformaciones
- `datos_limpios_finales.txt`: Conjunto de datos final (formato texto)
- `datos_limpios_finales.csv`: Conjunto de datos final (formato CSV)

### Estructura del Análisis

El script `run_analysis.R` realiza las siguientes operaciones en orden:

1. **Descarga y preparación de datos**
   - Descarga automática del archivo ZIP si no existe
   - Descompresión de archivos

2. **Fusión de conjuntos de datos (Paso 1)**
   - Combina datos de entrenamiento (`train/`) y prueba (`test/`)
   - Fusiona archivos X (mediciones), y (actividades) y subject (sujetos)

3. **Extracción de mediciones específicas (Paso 2)**
   - Selecciona solo columnas con mediciones de media (`mean()`) y desviación estándar (`std()`)
   - Reduce de 561 características a 66 características relevantes

4. **Aplicación de nombres descriptivos para actividades (Paso 3)**
   - Reemplaza códigos numéricos con nombres descriptivos:
     - 1 → WALKING
     - 2 → WALKING_UPSTAIRS
     - 3 → WALKING_DOWNSTAIRS
     - 4 → SITTING
     - 5 → STANDING
     - 6 → LAYING

5. **Etiquetado con nombres descriptivos de variables (Paso 4)**
   - Transforma nombres técnicos en nombres más legibles:
     - `t` → `Time`
     - `f` → `Frequency`
     - `Acc` → `Accelerometer`
     - `Gyro` → `Gyroscope`
     - `Mag` → `Magnitude`
     - `-mean()` → `Mean`
     - `-std()` → `StandardDeviation`

6. **Creación del conjunto de datos final (Paso 5)**
   - Calcula el promedio de cada variable por sujeto y actividad
   - Genera un conjunto de datos ordenado con 180 filas (30 sujetos × 6 actividades)

## Cómo Ejecutar el Análisis

### Requisitos Previos
```r
# Instalar paquetes necesarios
install.packages(c("dplyr", "tidyr", "readr"))
```

### Ejecución
```r
# Opción 1: Ejecutar todo el script
source("run_analysis.R")

# Opción 2: Ejecutar función específica
library(dplyr)
library(tidyr)
library(readr)
source("run_analysis.R")
datos_resultado <- run_analysis()
```

### Salida Esperada
El script generará:
- Mensajes de progreso en la consola
- Archivo `datos_limpios_finales.txt` (formato requerido)
- Archivo `datos_limpios_finales.csv` (formato adicional)
- Resumen estadístico del proceso

## Características del Conjunto de Datos Final

- **Dimensiones:** 180 filas × 68 columnas
- **Filas:** 30 sujetos × 6 actividades = 180 observaciones
- **Columnas:** 
  - `subject`: Identificador del sujeto (1-30)
  - `activity`: Nombre de la actividad
  - 66 variables de mediciones (promedios de mean y std)

## Transformaciones Realizadas

### Limpieza de Datos
- Eliminación de características irrelevantes
- Normalización de nombres de variables
- Conversión de códigos a nombres descriptivos

### Agregación
- Cálculo de promedios por grupo (sujeto + actividad)
- Ordenamiento por sujeto y actividad

### Estructura de Datos
- Formato "tidy data" donde cada fila es una observación única
- Cada columna representa una variable específica
- Cada celda contiene un valor único

## Validación de Resultados

### Verificaciones Automáticas
- Número correcto de filas (180)
- Número correcto de columnas (68)
- Presencia de todos los sujetos (1-30)
- Presencia de todas las actividades (6)
- Ausencia de valores faltantes

### Estructura Final
```
subject  activity                    TimeBodyAccelerometerMeanX  ...
1        LAYING                      0.2215982                   ...
1        SITTING                     0.2612376                   ...
1        STANDING                    0.2789176                   ...
...
```

## Notas Técnicas

- El script maneja automáticamente la descarga de datos
- Compatible con diferentes sistemas operativos
- Incluye manejo de errores básico
- Optimizado para eficiencia de memoria

## Contacto y Soporte

Para preguntas sobre el código o metodología, consultar:
- CodeBook.md para detalles técnicos de variables
- Comentarios en el código fuente
- Documentación original del dataset

---

**Fecha de última actualización:** 25/6/2025  
**Versión:** 1.0  
**Autor:** Sergio Ruiz Arévalo 