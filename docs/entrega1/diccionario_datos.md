# Diccionario de Datos del Sistema

## 1. Información General
* **Nombre de la base de datos:** Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA
* **Motor:** Oracle
* **Grupo 1:**  Sara Daiana Barreto Diaz 
                Jerónimo Lievano Bernal 
                Jaison Camilo Aguilar 

---

## 2. Catálogo de Tablas

### 2.1. Tabla: `EDICION_MUNDIAL`
* **Descripción:** Esta tabla recopila toda la información resoectiva a la caracterización de las ediciones de los mundiales.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_edicion` | `VARCHAR(20)` | No | PK | - | Ninguna | Identificacor de cada torneo. |
| `anio` | `NUMERIC(4)` | No |  - | - | CHECK (anio >= 1930 AND anio != 1942 AND anio != 1946) | Año en el que se dio la edicion |
| `pais_sede` | `VARCHAR(50)` | No | - | - | Ninguna | Pais anfitrion de la edicion. |
|`lema` | `VARCHAR(1000)` | Sí | - | - | Ninguna | Lema característico de la edicion, |
| `fecha_inicio` | `DATE ` | No | - | - | Ninguna | Fecha de inicio del torneo. |
| `fecha_fin` |`DATE ` | No | - | - | Ninguna | Fecha de fin del torneo. | 

#### Restricciones de Tabla (Compuestas o Checks globales)
* **fecha_edicion:** `CHECK (fecha_fin > fecha_inicio)`

---

### 2.2. Tabla: `SELECCION`
* **Descripción:** Almacena info. específica de cada seleccion.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :--- | :--- | :--- |
| `id_seleccion` | `VARCHAR(20)` |No | PK | - | Ninguna | Identificador de cada selección. |
| `id_edicion` | `VARCHAR(20)` |No | FK | - | Ninguna | Identificador de cada torneo. |
| `pais` | `VARCHAR(50)` | No |  - | -  | Ninguna | Nombre del país al que pertenece la selección.  |
| `confederaciones` | `VACRCHAR(15)` | No | - | - |CHECK (confederacion IN ('UEFA','CONMEBOL','CONCACAF','CAF','AFC','OFC')) | Confederacion asociada a la seleccion. |
|`grupo` | `CHAR(1)` | No | - | - | Ninguna | Grupo en el que está la selección en la edicion. |
|`convocados`|`NUMERIC(2)` | No | - | - |CHECK (convocados <= 26 AND convocados >=23) | Numero de jugadores convocados por la seleccion en la edicion. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **edicion_pais:** `UNIQUE (id_edicion, pais)`

---

### 2.3. Tabla: `JUGADOR`
* **Descripción:** Almacena info. de cada jugador.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :--- | :--- | :--- |
| `id_jugador` | `VARCHAR(20)` |No | PK | - | Ninguna | Identificador de cada jugador. |
| `nombre` | `VARCHAR(40)` | No | - | - | Ninguna | Nombre del jugador. |
| `fecha_nacimiento` | `DATE` | No |  - | -  | Ninguna | Fecha nacimiento del jugador.  |
| `confederaciones` | `VACRCHAR(15)` | No | - | - |CHECK (confederacion IN ('UEFA','CONMEBOL','CONCACAF','CAF','AFC','OFC')) | Confederacion asociada a la seleccion. |
|`grupo` | `CHAR(1)` | No | - | - | Ninguna | Grupo en el que está la selección en la edicion. |
|`convocados`|`NUMERIC(2)` | No | - | - |CHECK (convocados <= 26 AND convocados >=23) | Numero de jugadores convocados por la seleccion en la edicion. |

---

### 2.4. Tabla: `CONVOCADOS_POR_EDICION`
* **Descripción:** Recopila la información acerca de los jugadores convocados por una seleccion en alguna edicion.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_edicion` | `VARCHAR(20)` | No | FK | - | Ninguna | Identificacor de cada torneo. |
| `id_seleccion` | `VARCHAR(20)` |No | FK | - | Ninguna | Identificador de cada selección. |
| `id_jugador` | `VARCHAR(20)` |No | FK | - | Ninguna | Identificador de cada jugador. |
| `dorsal` | `NUMERIC(2)` | No |  - | - | CHECK (dorsal <= 99 AND dorsal >= 1) | Numero id de cada jugador en su seleccion. |
| `posicion` | `VARCHAR(15)` | Sí | - | - | CHECK (posicion IN ('delantero','portero', 'defensa', 'mediocampista')) | Posicion en la que juega el jugador. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_seleccion` $\rightarrow$ Referencia a `SELECCION(id_seleccion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`.
* `id_jugador` $\rightarrow$ Referencia a `JUGADOR(id_jugador)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **seleccion_dorsal:** `UNIQUE (id_edicion, id_seleccion, dorsal)`

---

### 2.5. Tabla: `ESTADIO`
* **Descripción:** Esta tabla contiene informacion acerca de los estadios.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_estadio` | `VARCHAR(20)` | No |  PK | - | Ninguna | Identificador del estadio. |
| `id_edicion` | `VARCHAR(20)` | No | FK | - | Ninguna | Identificacor de cada torneo. |
| `nombre` | `VARCHAR(50)` | No | - | - | Ninguna | Nombre del estadio. |
|`ciudad` | `VARCHAR(10)` | Sí | - | - | Ninguna | Ciudad en la que se encuentra el estadio. |
| `capacidad` | `NUMERIC(10) ` | No | - | - | CHECK (capacidad >= 75000) | Capacidad del estadio. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

---


### 2.6. Tabla: `PARTIDO`
* **Descripción:** Esta tabla contiene informacion sobre los partidos (en general).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_partido` | `VARCHAR(20)` | No | PK | - | Ninguna | Identificador del partido. |
| `id_estadio` | `VARCHAR(20)` | No |  FK | - | Ninguna | Identificador del estadio. |
| `id_edicion` | `VARCHAR(20)` | No | FK | - | Ninguna | Identificacor de cada torneo. |
| `fecha_hora` | `TIMESTAMP` | No | - | - | Ninguna | Fecha y hora del partido. |
|`fase` | `VARCHAR(15)` | Sí | - | - | Ninguna | Fase del partido. |
| `asistencia_registrada` | `NUMERIC(10) ` | Si | - | - | CHECK (asistencia_registrada >= 0) | Asistencia de aficionados en el partido. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_estadio` $\rightarrow$ Referencia a `ESTADIO(id_estadio)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **unico_partido:** `UNIQUE (id_estadio, fecha_hora)`

---
### 2.1. Tabla: `PARTICIPACION_PARTIDO`
* **Descripción:** Contiene información acerca de la participacion de las selecciones en sus respectivos partidos.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_participacion` | `VARCHAR(20)` |No | PK | - | Ninguna | Identificador de cada participacion. |
| `id_partido` | `VARCHAR(20)` | No | FK | - | Ninguna | Identificador del partido. |
| `id_seleccion` | `VARCHAR(20)` |No | FK | - | Ninguna | Identificador de cada selección. |
| `condicion` | `VARCHAR(10)` | No |  - | - | CHECK (condicion in ('local','visitante')) | Indica si la seleccion es local o visitante. |
| `goles_marcados` | `NUMERIC(2)` | No | - | 0 | CHECK (goles_marcados >= 0) | Goles marcados por una seleccion en un partido. |
|`resultado` | `VARCHAR(10)` | No | - | - | CHECK (resultado IN ('GANO','PERDIO','EMPATO')) | Estado de la selección al final del partido. |

#### Restricciones de Tabla (Compuestas o Checks globales)
* **partido_condicion:** `UNIQUE (id_partido, condicion)`
* **unica_selección_condicion:** `UNIQUE (id_partido, id_seleccion, condicion)`

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `PARTIDO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_seleccion` $\rightarrow$ Referencia a `SELECCION(id_seleccion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`.

---


