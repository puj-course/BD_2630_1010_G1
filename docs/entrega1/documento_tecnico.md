# **Documento Técnico — Entrega 1**

## **Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA**

* **Asignatura:** Bases de Datos  

* **Universidad:** Pontificia Universidad Javeriana  

* **Integrantes:** Sara Daiana Barreto, Jerónimo Lievano, Camilo Aguilar 

## **1\. Descripción del problema y alcance del sistema**

La Copa Mundial de la FIFA genera una gran cantidad de información relacionada con la organización del torneo, los estadios, las selecciones participantes, los partidos disputados y sus resultados. Esta información debe almacenarse de forma estructurada y relacionada para permitir su consulta y garantizar la consistencia de los datos durante el desarrollo de una edición del torneo.

El proyecto propone el diseño e implementación de una base de datos relacional orientada a la gestión de la información de una Copa Mundial de la FIFA. En el proyecto completo se contempla la administración de diferentes componentes del torneo, como organización, competencia deportiva, jugadores, arbitraje, estadísticas, logística, medios e incidencias.

Sin embargo, el alcance de la Entrega 1 se limita exclusivamente al modelo genérico inicial definido en el enunciado. Este modelo está compuesto por cinco entidades: EDICION\_MUNDIAL, ESTADIO, SELECCION, PARTIDO y PARTICIPACION\_PARTIDO. Estas entidades permiten representar una edición del Mundial, los estadios asociados a ella, las selecciones participantes, los partidos programados y la participación de cada selección en dichos partidos.

Dentro de este alcance, el sistema debe permitir relacionar cada estadio y selección con una edición del torneo, registrar los partidos disputados en los diferentes estadios y asociar a cada partido exactamente dos selecciones mediante la entidad PARTICIPACION\_PARTIDO. Esta última funciona como entidad asociativa entre PARTIDO y SELECCION, permitiendo además registrar la condición de participación de cada selección y los goles marcados.

En esta primera entrega no se incorporan todavía elementos adicionales como jugadores, árbitros, estadísticas detalladas, grupos, fases eliminatorias completas, boletería, medios o incidencias. La ampliación del modelo hacia estos componentes será desarrollada posteriormente, por lo que el trabajo actual se concentra en aplicar conceptos de modelo relacional, integridad, SQL, consultas, agrupaciones y relaciones sobre las cinco entidades iniciales.

## **2\. Supuestos de modelado adoptados por el equipo**

Para el desarrollo de la Entrega 1 se adopta como punto de partida el modelo genérico inicial propuesto en el enunciado, compuesto por las entidades EDICION\_MUNDIAL, ESTADIO, SELECCION, PARTIDO y PARTICIPACION\_PARTIDO.

A partir de este modelo, el equipo adopta los siguientes supuestos de modelado:

* Cada registro de ESTADIO corresponde a un estadio asociado a una única edición del Mundial mediante el atributo id\_edicion.  
* Cada registro de SELECCION representa la participación de una selección dentro de una edición específica del torneo. Por esta razón, la relación con EDICION\_MUNDIAL se mantiene mediante id\_edicion.  
* Cada PARTIDO pertenece a una única edición del Mundial y se disputa en un único estadio registrado para dicha edición.  
* La relación entre PARTIDO y SELECCION se representa exclusivamente mediante la entidad asociativa PARTICIPACION\_PARTIDO. Esta entidad permite que una selección pueda participar en varios partidos y que un partido esté relacionado con las selecciones que lo disputan.  
* Para cada partido deben existir exactamente dos registros en PARTICIPACION\_PARTIDO, correspondientes a las dos selecciones participantes.  
* El atributo condicion de PARTICIPACION\_PARTIDO se utiliza para diferenciar la condición de participación de cada selección en el partido, considerando los valores local y visitante, tal como se define en el modelo inicial.  
* El atributo goles\_marcados representa la cantidad de goles obtenidos por una selección en un partido determinado y se considera un valor entero no negativo.  
* Los atributos pais\_sede, ciudad, confederacion y fase se mantienen como atributos de texto dentro del modelo inicial, aunque posteriormente puedan analizarse como posibles entidades independientes durante la evolución del modelo.

Estos supuestos se adoptan únicamente para el alcance de la Entrega 1 y podrán ser revisados o modificados en entregas posteriores a medida que el modelo sea ampliado y se incorporen nuevas entidades y reglas de negocio.

## **3\. Modelo Entidad–Relación**

![][image1]

El modelo Entidad–Relación utilizado para la Entrega 1 parte del modelo genérico inicial propuesto en el enunciado y está compuesto por cinco entidades principales: EDICION\_MUNDIAL, ESTADIO, SELECCION, PARTIDO y PARTICIPACION\_PARTIDO.

La entidad EDICION\_MUNDIAL representa cada edición del torneo y constituye el punto principal de organización del modelo. A una edición se encuentran asociados los estadios utilizados, las selecciones participantes y los partidos programados.

La entidad ESTADIO almacena la información correspondiente a los estadios utilizados durante una edición del Mundial. Cada estadio pertenece a una edición específica mediante id\_edicion, mientras que una edición puede tener asociados múltiples estadios.

La entidad SELECCION representa a las selecciones participantes de una edición. Cada selección se encuentra asociada a una edición mediante id\_edicion. Adicionalmente, se incluye el atributo grupo, utilizado para identificar el grupo al que pertenece la selección dentro de la edición modelada.

La entidad PARTIDO representa los encuentros disputados durante el torneo. Cada partido pertenece a una edición y se juega en un estadio determinado, por lo que contiene las claves foráneas id\_edicion e id\_estadio. Además de la fecha, hora y fase del encuentro, se incorpora el atributo asistencia\_registrada, que permite almacenar la cantidad de asistentes al partido y posteriormente calcular indicadores como el porcentaje de ocupación del estadio.

Finalmente, PARTICIPACION\_PARTIDO funciona como entidad asociativa entre PARTIDO y SELECCION. Esta entidad permite resolver la relación muchos-a-muchos existente entre ambas: una selección puede disputar múltiples partidos y un partido involucra diferentes selecciones. Para cada participación se registra la condición de la selección, local o visitante, y la cantidad de goles marcados.

Las principales cardinalidades del modelo son:

* Una EDICION\_MUNDIAL puede tener múltiples ESTADIO, mientras que cada estadio pertenece a una única edición.  
* Una EDICION\_MUNDIAL puede tener múltiples SELECCION, mientras que cada selección pertenece a una única edición.  
* Una EDICION\_MUNDIAL puede contener múltiples PARTIDO, mientras que cada partido pertenece a una única edición.  
* Un ESTADIO puede albergar múltiples PARTIDO, mientras que cada partido se disputa en un único estadio.  
* Un PARTIDO posee múltiples registros en PARTICIPACION\_PARTIDO.  
* Una SELECCION puede aparecer en múltiples registros de PARTICIPACION\_PARTIDO.  
* La relación muchos-a-muchos entre PARTIDO y SELECCION se resuelve mediante PARTICIPACION\_PARTIDO.

Los atributos grupo y asistencia\_registrada corresponden a ajustes menores realizados sobre el modelo inicial. El primero facilita la identificación del grupo al que pertenece una selección y el segundo permite resolver los requerimientos relacionados con asistencia y ocupación de estadios.

## **4\. Transformación a Modelo Lógico Relacional: Justificación de Llaves y Cardinalidades

---

### 1. Tabla: `EDICION_MUNDIAL`

* **Llave Primaria (`id_edicion`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Se elige un identificador unívoco e inmutable para evitar la identidad del torneo de datos descriptivos susceptibles a cambios o formatos complejos. Con esto aseguramos claves foráneas compactas y estables en todas las demás entidades.

* **Cardinalidad de sus relaciones salientes:**
  * **1:N con `SELECCION`:** Una edición alberga muchas selecciones participantes ($1 \dots N$), pero cada registro de selección pertenece a una única edición ($1:1$).
  * **1:N con `ESTADIO`:** Una edición asigna múltiples estadios como sedes oficiales ($1 \dots N$), y en este diseño el estadio queda vinculado a la edición para la cual fue catalogado ($1:1$).
  * **1:N con `PARTIDO`:** Un torneo organiza múltiples partidos de calendario ($1 \dots N$), y un partido pertenece exclusivamente a una edición ($1:1$).

---

### 2. Tabla: `SELECCION`

* **Llave Primaria (`id_seleccion`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Representa la participación de un país en una edición específica. Aunque la combinación `(id_edicion, pais)` es única (respaldada por la restricción `edicion_pais`), se utiliza un identificador artificial simple para simplificar las referencias como clave foránea en `CONVOCADOS_POR_EDICION` y `PARTICIPACION_PARTIDO`.

* **Llave Foránea (`id_edicion`):**
  * **Referencia:** `EDICION_MUNDIAL(id_edicion)`.
  * **Acción Referencial (`ON DELETE CASCADE`):** Si una edición se elimina del sistema, las selecciones inscritas en ella pierden su contexto de competencia, carece de sentido mantener plantillas o cupos huérfanos sin torneo asociado.
  * **Acción de Actualización (`RESTRICT`):** Al ser `id_edicion` una clave inmutable, se previene cualquier alteración en cascada involuntaria.

* **Cardinalidad:**
  * **N:1 con `EDICION_MUNDIAL`:** Muchas selecciones corresponden a una sola edición.
  * **1:N con `CONVOCADOS_POR_EDICION`:** Una selección convoca entre 23 y 26 futbolistas ($1 \dots N$), mientras que cada registro de convocatoria individual pertenece a una sola selección ($1:1$).
  * **1:N con `PARTICIPACION_PARTIDO`:** Una selección juega múltiples encuentros a lo largo del torneo ($1 \dots N$).

---

### 3. Tabla: `JUGADOR`

* **Llave Primaria (`id_jugador`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Garantiza la unicidad del deportista a lo largo del tiempo. Evitamos usamos claves naturales para evitar el uso de información sensible de los jugadores.


* **Cardinalidad:**
  * **1:N con `CONVOCADOS_POR_EDICION`:** Un jugador puede ser convocado a cero, una o varias ediciones de mundiales a lo largo de su carrera deportiva ($0 \dots N$).

---

### 4. Tabla: `CONVOCADOS_POR_EDICION`

* **Llave Primaria (`id_edicion`, `id_jugador`):**
  * **Tipo:** Clave primaria compuesta.
  * **Justificación:** Esta tabla es la "conexión" de la relación **Muchos a Muchos ($M:N$)** entre `EDICION_MUNDIAL` y `JUGADOR`. La combinación de ambos atributos asegura a nivel físico que un mismo jugador no pueda ser convocado más de una vez dentro de la misma edición del torneo.

* **Llave Foránea (`id_edicion`):**
  * **Referencia:** `EDICION_MUNDIAL(id_edicion)`.
  * **Acción Referencial (`ON DELETE CASCADE`):** Al suprimirse un torneo, desaparecen todas las convocatorias oficiales ligadas a él.

* **Llave Foránea (`id_jugador`):**
  * **Referencia:** `JUGADOR(id_jugador)`.
  * **Acción Referencial (`ON DELETE RESTRICT`):** Protege la integridad histórica deportiva. No se permite eliminar un futbolista de la base de datos si ya tiene un registro de convocatoria.

* **Llave Foránea (`id_seleccion`):**
  * **Referencia:** `SELECCION(id_seleccion)`.
  * **Acción Referencial (`ON DELETE RESTRICT`):** Impide borrar una selección que ya cuenta con futbolistas inscritos y dorsales asignados en una edición.

---

### 5. Tabla: `ESTADIO`

* **Llave Primaria (`id_estadio`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Identifica de forma unívoca el estadio, independientemente de que los estadios cambien de nombre.

* **Llave Foránea (`id_edicion`):**
  * **Referencia:** `EDICION_MUNDIAL(id_edicion)`.
  * **Acción Referencial (`ON DELETE CASCADE`):** Si se borra la edición del torneo, las sedes asociadas se remueven por completo.

* **Cardinalidad:**
  * **N:1 con `EDICION_MUNDIAL`:** Múltiples estadios forman parte del catálogo de una edición ($N:1$).
  * **1:N con `PARTIDO`:** Un estadio puede albergar múltiples partidos a lo largo de la edicion ($0 \dots N$).

---

### 6. Tabla: `PARTIDO`

* **Llave Primaria (`id_partido`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Es un identificador compacto y estable.

* **Llave Foránea (`id_edicion`):**
  * **Referencia:** `EDICION_MUNDIAL(id_edicion)`.
  * **Acción Referencial (`ON DELETE CASCADE`):** Un partido de fútbol no tiene sentido sin la competencia a la que pertenece. Si se anula la edición, se eliminan todos sus partidos.

* **Llave Foránea (`id_estadio`):**
  * **Referencia:** `ESTADIO(id_estadio)`.
  * **Acción Referencial (`ON DELETE SET NULL`):** En caso de demolición, remodelación o baja del registro de un estadio, se prefiere conservar el registro histórico del encuentro, su fase y su asistencia, dejando la referencia física en valor nulo (`NULL`).

* **Cardinalidad:**
  * **N:1 con `EDICION_MUNDIAL`:** Varios partidos integran la edición.
  * **N:1 con `ESTADIO`:** Varios partidos se disputan en una misma sede física.
  * **1:N con `PARTICIPACION_PARTIDO`:** Cada partido genera exactamente dos registros de participación.

---

### 7. Tabla: `PARTICIPACION_PARTIDO`

* **Llave Primaria (`id_participacion`):**
  * **Tipo:** Clave subrogada artificial (`VARCHAR(20)`).
  * **Justificación:** Permite referenciar cada actuación particular de manera inequívoca.

* **Llave Foránea (`id_partido`):**
  * **Referencia:** `PARTIDO(id_partido)`.
  * **Acción Referencial (`ON DELETE CASCADE`):** Si se borra un partido, las estadísticas y actuaciones de los contendientes en ese compromiso deben eliminarse de inmediato.

* **Llave Foránea (`id_seleccion`):**
  * **Referencia:** `SELECCION(id_seleccion)`.
  * **Acción Referencial (`ON DELETE RESTRICT`):** Una selección con historial de partidos jugados no puede ser removida del sistema, evitando corromper los resultados y marcadores registrados.

* **Cardinalidad:**
  * Resuelve la relación de enfrentamiento entre dos selecciones en un partido mediante una cardinalidad estricta $1:2$ por encuentro.

---
