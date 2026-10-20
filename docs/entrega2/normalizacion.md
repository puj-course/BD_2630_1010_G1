# Justificación de la Normalización del Modelo

## Introducción
Justificar las tres formas normales de nuestro modelo de Gestión de la FIFA. Se evaluará el modelo completo. 

![Modelo físico](https://raw.githubusercontent.com/Daiana-07/puj-course/BD_2630_1010_G1/blob/main/docs/entrega2/modelo_fisico.pdf)

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


## Justificación 3FN

1. El modelo cumple previamente con la Primera y Segunda Forma Normal.

2. **No existen dependencias transitivas:** los atributos no clave de cada tabla dependen directamente de su clave primaria y no de otros atributos no clave.

3. **Se evita almacenar información redundante que puede obtenerse mediante relaciones entre tablas.** Por ejemplo, en `SELECCION` no se almacena `id_edicion`, ya que la edición puede obtenerse mediante `id_etapa_grupo` y la relación con `ETAPA_COMPETENCIA`.

4. De manera similar, `ESTADIO` no almacena directamente la sede o la edición, ya que esta información puede obtenerse mediante la relación:

   `ESTADIO → CIUDAD → SEDE → EDICION_MUNDIAL`

5. Los datos descriptivos de entidades relacionadas se mantienen en sus respectivas tablas. Por ejemplo, `PARTIDO` almacena las claves foráneas de la etapa y el estadio, pero no repite atributos como el nombre del estadio, la ciudad o la edición.

Por estas razones, el modelo evita dependencias transitivas y redundancias innecesarias, cumpliendo con los criterios de la Tercera Forma Normal.