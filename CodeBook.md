# CodeBook: Human Activity Recognition Dataset

## Descripción General

Este codebook describe las variables, datos y transformaciones realizadas para limpiar el conjunto de datos "Human Activity Recognition Using Smartphones". El resultado final es un conjunto de datos ordenado con promedios de mediciones por sujeto y actividad.

## Datos Originales

### Fuente
- **Dataset:** Human Activity Recognition Using Smartphones Dataset
- **Versión:** 1.0
- **Autores:** Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto
- **Institución:** Smartlab - Non Linear Complex Systems Laboratory, DITEN - Università degli Studi di Genova
- **URL:** http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Descripción del Experimento Original
Los experimentos se llevaron a cabo con un grupo de 30 voluntarios de edades entre 19-48 años. Cada persona realizó seis actividades (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) usando un smartphone Samsung Galaxy S II en la cintura.

### Mediciones Originales
- **Acelerómetro triaxial:** Aceleración lineal total y aceleración del cuerpo
- **Giroscopio triaxial:** Velocidad angular
- **Frecuencia de muestreo:** 50Hz
- **Ventana deslizante:** 2.56 sec con 50% de solapamiento (128 lecturas/ventana)

## Transformaciones Realizadas

### 1. Fusión de Conjuntos de Datos
- **Archivos combinados:**
  - `train/X_train.txt` + `test/X_test.txt` → Mediciones
  - `train/y_train.txt` + `test/y_test.txt` → Etiquetas de actividad
  - `train/subject_train.txt` + `test/subject_test.txt` → Identificadores de sujeto

### 2. Filtrado de Variables
- **Criterio:** Solo variables que contienen `mean()` o `std()` en el nombre
- **Variables originales:** 561
- **Variables seleccionadas:** 66
- **Variables excluidas:** meanFreq(), angle() con Mean, y otras mediciones

### 3. Nombres de Actividades
Conversión de códigos numéricos a nombres descriptivos:

| Código | Actividad Original    | Actividad Final       |
|--------|-----------------------|-----------------------|
| 1      | WALKING               | WALKING               |
| 2      | WALKING_UPSTAIRS      | WALKING_UPSTAIRS      |
| 3      | WALKING_DOWNSTAIRS    | WALKING_DOWNSTAIRS    |
| 4      | SITTING               | SITTING               |
| 5      | STANDING              | STANDING              |
| 6      | LAYING                | LAYING                |

### 4. Nombres Descriptivos de Variables
Transformación de nombres técnicos a nombres legibles:

| Prefijo/Sufijo Original | Reemplazo           | Significado                    |
|-------------------------|---------------------|--------------------------------|
| `t`                     | `Time`              | Dominio temporal               |
| `f`                     | `Frequency`         | Dominio frecuencial            |
| `Acc`                   | `Accelerometer`     | Acelerómetro                   |
| `Gyro`                  | `Gyroscope`         | Giroscopio                     |
| `Mag`                   | `Magnitude`         | Magnitud                       |
| `BodyBody`              | `Body`              | Corrección de duplicación      |
| `-mean()`               | `Mean`              | Media                          |
| `-std()`                | `StandardDeviation` | Desviación estándar            |
| `-X`                    | `X`                 | Eje X                          |
| `-Y`                    | `Y`                 | Eje Y                          |
| `-Z`                    | `Z`                 | Eje Z                          |

### 5. Agregación Final
- **Función aplicada:** Media aritmética
- **Agrupación:** Por sujeto y actividad
- **Resultado:** 180 filas (30 sujetos × 6 actividades)

## Variables del Conjunto de Datos Final

### Variables de Identificación

| Variable   | Tipo      | Rango     | Descripción                              |
|------------|-----------|-----------|------------------------------------------|
| `subject`  | Entero    | 1-30      | Identificador único del sujeto           |
| `activity` | Carácter  | 6 valores | Nombre de la actividad realizada         |

### Variables de Medición

Todas las variables de medición son numéricas (tipo double) y representan **promedios** de las mediciones originales normalizadas entre [-1, 1].

#### Mediciones de Acelerómetro en Dominio Temporal
1. `TimeBodyAccelerometerMeanX`
2. `TimeBodyAccelerometerMeanY`
3. `TimeBodyAccelerometerMeanZ`
4. `TimeBodyAccelerometerStandardDeviationX`
5. `TimeBodyAccelerometerStandardDeviationY`
6. `TimeBodyAccelerometerStandardDeviationZ`

#### Mediciones de Gravedad en Dominio Temporal
7. `TimeGravityAccelerometerMeanX`
8. `TimeGravityAccelerometerMeanY`
9. `TimeGravityAccelerometerMeanZ`
10. `TimeGravityAccelerometerStandardDeviationX`
11. `TimeGravityAccelerometerStandardDeviationY`
12. `TimeGravityAccelerometerStandardDeviationZ`

#### Mediciones de Jerk del Acelerómetro en Dominio Temporal
13. `TimeBodyAccelerometerJerkMeanX`
14. `TimeBodyAccelerometerJerkMeanY`
15. `TimeBodyAccelerometerJerkMeanZ`
16. `TimeBodyAccelerometerJerkStandardDeviationX`
17. `TimeBodyAccelerometerJerkStandardDeviationY`
18. `TimeBodyAccelerometerJerkStandardDeviationZ`

#### Mediciones de Giroscopio en Dominio Temporal
19. `TimeBodyGyroscopeMeanX`
20. `TimeBodyGyroscopeMeanY`
21. `TimeBodyGyroscopeMeanZ`
22. `TimeBodyGyroscopeStandardDeviationX`
23. `TimeBodyGyroscopeStandardDeviationY`
24. `TimeBodyGyroscopeStandardDeviationZ`

#### Mediciones de Jerk del Giroscopio en Dominio Temporal
25. `TimeBodyGyroscopeJerkMeanX`
26. `TimeBodyGyroscopeJerkMeanY`
27. `TimeBodyGyroscopeJerkMeanZ`
28. `TimeBodyGyroscopeJerkStandardDeviationX`
29. `TimeBodyGyroscopeJerkStandardDeviationY`
30. `TimeBodyGyroscopeJerkStandardDeviationZ`

#### Mediciones de Magnitud en Dominio Temporal
31. `TimeBodyAccelerometerMagnitudeMean`
32. `TimeBodyAccelerometerMagnitudeStandardDeviation`
33. `TimeGravityAccelerometerMagnitudeMean`
34. `TimeGravityAccelerometerMagnitudeStandardDeviation`
35. `TimeBodyAccelerometerJerkMagnitudeMean`
36. `TimeBodyAccelerometerJerkMagnitudeStandardDeviation`
37. `TimeBodyGyroscopeMagnitudeMean`
38. `TimeBodyGyroscopeMagnitudeStandardDeviation`
39. `TimeBodyGyroscopeJerkMagnitudeMean`
40. `TimeBodyGyroscopeJerkMagnitudeStandardDeviation`

#### Mediciones de Acelerómetro en Dominio Frecuencial
41. `FrequencyBodyAccelerometerMeanX`
42. `FrequencyBodyAccelerometerMeanY`
43. `FrequencyBodyAccelerometerMeanZ`
44. `FrequencyBodyAccelerometerStandardDeviationX`
45. `FrequencyBodyAccelerometerStandardDeviationY`
46. `FrequencyBodyAccelerometerStandardDeviationZ`

#### Mediciones de Jerk del Acelerómetro en Dominio Frecuencial
47. `FrequencyBodyAccelerometerJerkMeanX`
48. `FrequencyBodyAccelerometerJerkMeanY`
49. `FrequencyBodyAccelerometerJerkMeanZ`
50. `FrequencyBodyAccelerometerJerkStandardDeviationX`
51. `FrequencyBodyAccelerometerJerkStandardDeviationY`
52. `FrequencyBodyAccelerometerJerkStandardDeviationZ`

#### Mediciones de Giroscopio en Dominio Frecuencial
53. `FrequencyBodyGyroscopeMeanX`
54. `FrequencyBodyGyroscopeMeanY`
55. `FrequencyBodyGyroscopeMeanZ`
56. `FrequencyBodyGyroscopeStandardDeviationX`
57. `FrequencyBodyGyroscopeStandardDeviationY`
58. `FrequencyBodyGyroscopeStandardDeviationZ`

#### Mediciones de Magnitud en Dominio Frecuencial
59. `FrequencyBodyAccelerometerMagnitudeMean`
60. `FrequencyBodyAccelerometerMagnitudeStandardDeviation`
61. `FrequencyBodyAccelerometerJerkMagnitudeMean`
62. `FrequencyBodyAccelerometerJerkMagnitudeStandardDeviation`
63. `FrequencyBodyGyroscopeMagnitudeMean`
64. `FrequencyBodyGyroscopeMagnitudeStandardDeviation`
65. `FrequencyBodyGyroscopeJerkMagnitudeMean`
66. `FrequencyBodyGyroscopeJerkMagnitudeStandardDeviation`

## Unidades y Rangos

### Unidades
- **Acelerómetro:** g (gravedad estándar, 9.80665 m/s²)
- **Giroscopio:** rad/seg (radianes por segundo)
- **Todas las variables:** Normalizadas entre [-1, 1]

### Rangos de Valores
- **Variables de medición:** [-1, 1] (valores normalizados)
- **subject:** [1, 30] (enteros)
- **activity:** 6 categorías distintas

## Estructura del Conjunto de Datos Final

### Dimensiones
- **Filas:** 180 (30 sujetos × 6 actividades)
- **Columnas:** 68 (2 identificadores + 66 mediciones)

### Formato
- **Tipo:** Datos ordenados (tidy data)
- **Criterios tidy:**
  - Cada variable forma una columna
  - Cada observación forma una fila
  - Cada tipo de unidad observacional forma una tabla

### Orden
- Ordenado primero por `subject` (1 a 30)
- Dentro de cada sujeto, ordenado por `activity` (alfabéticamente)

## Notas Adicionales

### Preprocesamiento Original
- Filtro Butterworth paso bajo (20Hz) para separar ruido
- Filtro Butterworth paso alto (0.3Hz) para separar gravedad
- Ventana deslizante de 2.56 seg con 50% solapamiento
- Normalización de características entre [-1, 1]

### Consideraciones Técnicas
- Los valores son promedios de múltiples mediciones
- Datos normalizados sin unidades físicas específicas
- Variables de frecuencia obtenidas mediante FFT
- Variables de magnitud calculadas usando norma euclidiana

### Calidad de Datos
- Sin valores faltantes (NA)
- Sin duplicados
- Todas las mediciones están dentro del rango esperado [-1, 1]
- Distribución equilibrada entre sujetos y actividades

---

**Última actualización:** 25/6/2025
**Versión del CodeBook:** 1.0  
**Conjunto de datos:** datos_limpios_finales.txt