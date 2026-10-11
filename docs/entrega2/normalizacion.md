# Justificación de la Normalización del Modelo

## Introducción
Justificar las tres formas normales de nuestro modelo de Gestión de la FIFA. Se evaluará el modelo completo. 

![Modelo físico](./modelo_fisico.pdf)

---

## Justificación 1FN:
Como se puede evidenciar en el modelo físico, el modelo: 
1. Todas las entidades tiene una llave primaria, ya sea única o compuesta. 
2. Los datos son atómicos, de esto se habla mas directamente en [Diccionario de datos Ampliado](./diccionario_datos_ampliado.md), en donde se especifica qué significa cada dato, y donde se evidencia que no pude haber más de un dato en una colúmna. 

---

## Justificación 2FN
1. Cumple con la Primera Forma Normal.
2. **NO dependencias parciales en claves simples:** La gran mayoría de las tablas principales del sistema (`EDICION_MUNDIAL`, `SEDE`, `CIUDAD`, `ESTADIO`, `PERSONA`, etc.) tienen una clave primaria simple, por tanto no pueden existir dependencias parciales.
3. **Dependencia en tablas asociativas:** En las entidades de asociación que manejan claves compuestas (como `PARTICIPACION_PARTIDO` con llave compuesta por `id_partido` e `id_seleccion`, o `VINCULACION_SELECCION` con `id_persona` e `id_seleccion`), todos los atributos descriptivos, como por ejemplo, `goles`, `condicion`, `rol` o `dorsal`, dependen estrictamente de la llave primaria completay no de una parte aislada de ellos.
