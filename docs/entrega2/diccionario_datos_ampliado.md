# Diccionario de Datos del Sistema

## 1. Información General
* **Nombre de la base de datos:** Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA (Version 2.0)
* **Motor:** Oracle
* **Grupo 1:**  Sara Daiana Barreto Diaz 
                Jerónimo Lievano Bernal 
                Jaison Camilo Aguilar 

---

## 2. Catálogo de Tablas

### 2.1. Tabla: `EDICION_MUNDIAL`
* **Descripción:** Representa cada edición de la Copa Mundial registrada en el sistema.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_edicion` | `VARCHAR(20)` | No | PK | - | Ninguna | Identificador de cada torneo. |
| `anio` | `NUMBER(4)` | No |  - | - | CHECK (anio >= 1930 AND anio != 1942 AND anio != 1946), UNIQUE (anio) | Año en el que se dio la edicion |
| `nombre` | `VARCHAR2(100)` | No | - | - | Ninguna | Nombre respectivo a la edicion |
| `fecha_inicio` | `DATE` | No | - | - | Ninguna | Fecha de inicio del torneo. |
| `fecha_fin` | `DATE` | No | - | - | Ninguna | Fecha de fin del torneo. | 

#### Restricciones de Tabla (Compuestas o Checks globales)
* **fecha_edicion:** `CHECK (fecha_fin > fecha_inicio)`

---

### 2.2. Tabla: `SEDE`
* **Descripción:** Representa cada país anfitrión de una edición del Mundial.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_sede` | `VARCHAR(20)` | No | PK | - | Ninguna | Identificador de la sede. |
| `id_edicion` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de cada torneo. |
| `pais` | `VARCHAR2(80)` | No | - | - | Ninguna | Nombre del país sede |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **edicion_pais:** `UNIQUE (id_edicion, pais)`

---

### 2.3. Tabla: `CIUDAD`
* **Descripción:** Representa cada ciudad anfitriona perteneciente a una sede.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_ciudad` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador de cada ciudad. |
| `id_sede` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de la sede. |
| `nombre` | `VARCHAR2(80)` | No | - | - | Ninguna | Nombre de la ciudad. |

#### Relaciones (Foreign Keys)
* `id_sede` $\rightarrow$ Referencia a `SEDE(id_sede)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **ciudad_sede:** `UNIQUE (id_sede, nombre)`

---

### 2.4. Tabla: `ESTADIO`
* **Descripción:** Representa los estadios utilizados para la realización de partidos.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_estadio` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador del estadio. |
| `id_ciudad` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de cada ciudad. |
| `nombre` | `VARCHAR2(100)` | No | - | - | Ninguna | Nombre del estadio. |
| `capacidad` | `NUMBER` | No | - | - | CHECK (capacidad >= 0) | Capacidad del estadio. |

#### Relaciones (Foreign Keys)
* `id_ciudad` $\rightarrow$ Referencia a `CIUDAD(id_ciudad)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **estadio_ciudad:** `UNIQUE (id_ciudad, nombre)`
* **capacidad_estadio:** `CHECK(capacidad >= 0)`

---

### 2.5. Tabla: `ETAPA_COMPETENCIA`
* **Descripción:** Representa las fases y grupos en los que se divide la competencia de un torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_etapa` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador de la etapa. |
| `id_edicion` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de cada torneo. |
| `id_etapa_padre` | `VARCHAR(20)`  | Si | FK | - | Ninguna | Etapa mayor que contiene a otras etapas (ej: Grupos contiene a Grupo A, B, etc...) |
| `nombre` | `VARCHAR2(50)` | No | - | - | Ninguna | Nombre de la etapa. |
| `tipo_etapa` | `VARCHAR2(30)` | No | - | - | CHECK (tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA')) | Tipo o categoría de la etapa. |
| `orden` | `NUMBER` | No | - | - | Ninguna | Orden secuencial de la etapa en el torneo. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_etapa_padre` $\rightarrow$ Referencia a `ETAPA_COMPETENCIA(id_etapa)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

---

### 2.6. Tabla: `ORGANIZACION_FUTBOL`
* **Descripción:** Representa organizaciones institucionales relacionadas con las selecciones.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_organizacion` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador de la organización. |
| `id_organizacion_padre` | `VARCHAR(20)`  | Si | FK | - | Ninguna | Organización superior que la engloba. |
| `nombre` | `VARCHAR2(100)` | No | - | - | Ninguna | Nombre de la organización. |
| `tipo` | `VARCHAR2(30)` | No | - | - | CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL')) | Tipo de organización. |
| `pais` | `VARCHAR2(80)` | Si | - | - | Ninguna | Nombre del país al que pertenece. |

#### Relaciones (Foreign Keys)
* `id_organizacion_padre` $\rightarrow$ Referencia a `ORGANIZACION_FUTBOL(id_organizacion)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **tipo_organizacion:** `CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL'))`

---

### 2.7. Tabla: `SELECCION`
* **Descripción:** Representa la participación de una selección nacional dentro de una edición determinada del Mundial.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :--- | :--- | :--- |
| `id_seleccion` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador de cada selección. |
| `id_edicion` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de cada torneo. |
| `id_federacion` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de la federación. |
| `id_etapa_grupo` | `VARCHAR(20)`  | Si | FK | - | Ninguna | Identificador de la etapa o grupo al que pertenece. |
| `nombre` | `VARCHAR2(80)` | No | - | - | Ninguna | Nombre de la selección. |
| `codigo_fifa` | `VARCHAR2(3)` | No | - | - | Ninguna | Código otorgado por la FIFA. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_federacion` $\rightarrow$ Referencia a `ORGANIZACION_FUTBOL(id_organizacion)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`.
* `id_etapa_grupo` $\rightarrow$ Referencia a `ETAPA_COMPETENCIA(id_etapa)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

---

### 2.8. Tabla: `PARTIDO`
* **Descripción:** Esta tabla contiene información sobre los partidos (en general).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_partido` | `VARCHAR(20)`  | No | PK | - | Ninguna | Identificador del partido. |
| `id_etapa` | `VARCHAR(20)`  | No | FK | - | Ninguna | Identificador de la etapa. |
| `id_estadio` | ``VARCHAR(20)` ` | No | FK | - | Ninguna | Identificador del estadio. |
| `fecha_hora` | `TIMESTAMP` | No | - | - | Ninguna | Fecha y hora del partido. |
| `fase` | `VARCHAR2(15)` | Si | - | - | Ninguna | Fase del partido. |
| `asistencia_registrada` | `NUMBER` | Si | - | - | CHECK (asistencia_registrada >= 0) | Asistencia de aficionados en el partido. |

#### Relaciones (Foreign Keys)
* `id_etapa` $\rightarrow$ Referencia a `ETAPA_COMPETENCIA(id_etapa)` | Regla: `ON DELETE RESTRICT`, `ON UPDATE RESTRICT`.
* `id_estadio` $\rightarrow$ Referencia a `ESTADIO(id_estadio)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **unico_partido:** `UNIQUE (id_estadio, fecha_hora)`

---

### 2.9. Tabla: `PARTICIPACION_PARTIDO`
* **Descripción:** Tabla asociativa que registra la participación de una selección en un partido específico.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_participacion` | `VARCHAR(20)` | No | PK | - | Ninguna | Identificador de la participación. |
| `id_partido` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador del partido. |
| `id_seleccion` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la selección. |
| `condicion` | `VARCHAR2(10)` | No | - | - | CHECK (condicion IN ('LOCAL', 'VISITANTE')) | Condición de participación en el encuentro. |
| `goles` | `NUMBER` | No | - | 0 | CHECK (goles >= 0) | Goles marcados por la selección en el partido. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `PARTIDO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_seleccion` $\rightarrow$ Referencia a `SELECCION(id_seleccion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **partido_seleccion_uk:** `UNIQUE (id_partido, id_seleccion)`
* **partido_condicion_uk:** `UNIQUE (id_partido, condicion)`

---

### 2.10. Tabla: `PERSONA`
* **Descripción:** Representa actores naturales relacionados con el torneo (jugadores, técnicos, árbitros, periodistas).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_persona` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador  de la persona. |
| `nombre_completo` | `VARCHAR2(120)` | No | - | - | Ninguna | Nombre completo de la persona. |
| `nacionalidad` | `VARCHAR2(80)` | Si | - | - | Ninguna | Nacionalidad de la persona. |
| `fecha_nacimiento` | `DATE` | Si | - | - | Ninguna | Fecha de nacimiento de la persona. |

---

### 2.11. Tabla: `VINCULACION_SELECCION`
* **Descripción:** Entidad asociativa que relaciona personas con selecciones (convocatorias y cuerpos técnicos).

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_vinculacion` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador de la vinculación. |
| `id_persona` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la persona. |
| `id_seleccion` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la selección. |
| `rol` | `VARCHAR2(30)` | No | - | - | CHECK (rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO')) | Rol desempeñado en la selección. |
| `dorsal` | `NUMBER(2)` | Si | - | - | CHECK (dorsal > 0 AND dorsal <= 99) | Número de camiseta asignado. |
| `capitan` | `CHAR(1)` | Si | - | - | CHECK (capitan IN ('S', 'N')) | Indicador de si es el capitán. |
| `posicion` | `VARCHAR2(30)` | Si | - | - | Ninguna | Posición de juego. |
| `club` | `VARCHAR2(100)` | Si | - | - | Ninguna | Club de procedencia. |

#### Relaciones (Foreign Keys)
* `id_persona` $\rightarrow$ Referencia a `PERSONA(id_persona)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_seleccion` $\rightarrow$ Referencia a `SELECCION(id_seleccion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **persona_seleccion_uk:** `UNIQUE (id_persona, id_seleccion)`

---

### 2.12. Tabla: `ASIGNACION_ARBITRAL`
* **Descripción:** Entidad asociativa que representa la asignación de árbitros a los partidos.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_asignacion` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador de la asignación. |
| `id_partido` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador del partido. |
| `id_persona` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la persona (árbitro). |
| `rol_arbitral` | `VARCHAR2(30)` | No | - | - | CHECK (rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR')) | Rol arbitral asignado en el partido. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `PARTIDO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_persona` $\rightarrow$ Referencia a `PERSONA(id_persona)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **partido_persona_arb_uk:** `UNIQUE (id_partido, id_persona)`

---

### 2.13. Tabla: `EVENTO_PARTIDO`
* **Descripción:** Registra acontecimientos deportivos u operativos asociados a un partido.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_evento` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador  del evento. |
| `id_partido` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador del partido. |
| `id_persona` | `VARCHAR(20) ` | Si | FK | - | Ninguna | Identificador de la persona protagonista. |
| `id_persona_relacionada` | `VARCHAR(20) ` | Si | FK | - | Ninguna | Segunda persona relacionada (ej. sustitución). |
| `tipo_evento` | `VARCHAR2(40)` | No | - | - | CHECK (tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS', 'INCIDENCIA_CLIMATICA', 'INCIDENCIA_TECNICA', 'INCIDENCIA_DISCIPLINARIA')) | Tipo de evento registrado. |
| `minuto` | `NUMBER(3)` | Si | - | - | CHECK (minuto >= 1 AND minuto <= 130) | Minuto del partido en que ocurre. |
| `valor_numerico` | `NUMBER` | Si | - | - | Ninguna | Valor numérico auxiliar (ej. minutos jugados). |
| `descripcion` | `VARCHAR2(500)` | Si | - | - | Ninguna | Descripción detallada del suceso. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `PARTIDO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_persona` $\rightarrow$ Referencia a `PERSONA(id_persona)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.
* `id_persona_relacionada` $\rightarrow$ Referencia a `PERSONA(id_persona)` | Regla: `ON DELETE SET NULL`, `ON UPDATE RESTRICT`.

---

### 2.14. Tabla: `ENTRADA`
* **Descripción:** Representa la boletería asociada a los partidos del torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_entrada` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador  de la entrada. |
| `id_partido` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador del partido. |
| `categoria` | `VARCHAR2(30)` | No | - | - | Ninguna | Categoría de la localidad. |
| `zona` | `VARCHAR2(50)` | No | - | - | Ninguna | Zona del estadio. |
| `precio` | `NUMBER(10,2)` | No | - | - | CHECK (precio >= 0) | Precio de la entrada. |
| `estado` | `VARCHAR2(20)` | No | - | - | Ninguna | Estado de disponibilidad de la entrada. |

#### Relaciones (Foreign Keys)
* `id_partido` $\rightarrow$ Referencia a `PARTIDO(id_partido)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

---

### 2.15. Tabla: `ACREDITACION_PRENSA`
* **Descripción:** Representa la acreditación de miembros de medios de comunicación para cubrir el torneo.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_acreditacion` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador  de la acreditación. |
| `id_edicion` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la edición mundial. |
| `id_persona` | `VARCHAR(20) ` | No | FK | - | Ninguna | Identificador de la persona acreditada. |
| `medio_comunicacion` | `VARCHAR2(120)` | No | - | - | Ninguna | Nombre del medio de comunicación. |
| `tipo_acreditacion` | `VARCHAR2(40)` | No | - | - | Ninguna | Tipo de acreditación otorgada. |
| `fecha_emision` | `DATE` | No | - | - | Ninguna | Fecha de emisión de la acreditación. |
| `estado` | `VARCHAR2(20)` | No | - | - | Ninguna | Estado actual de la acreditación. |

#### Relaciones (Foreign Keys)
* `id_edicion` $\rightarrow$ Referencia a `EDICION_MUNDIAL(id_edicion)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.
* `id_persona` $\rightarrow$ Referencia a `PERSONA(id_persona)` | Regla: `ON DELETE CASCADE`, `ON UPDATE RESTRICT`.

#### Restricciones de Tabla (Compuestas o Checks globales)
* **edicion_persona_prensa_uk:** `UNIQUE (id_edicion, id_persona)`

---

### 2.16. Tabla: `AUDITORIA_EVENTO`
* **Descripción:** Almacena la trazabilidad de los cambios realizados sobre información crítica del sistema.

| Campo | Tipo de Dato | Nulo | Clave | Default | Restricciones / Reglas | Descripción |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `id_auditoria` | `VARCHAR(20) ` | No | PK | - | Ninguna | Identificador  del registro de auditoría. |
| `usuario_bd` | `VARCHAR2(100)` | No | - | - | Ninguna | Usuario de base de datos que ejecutó la acción. |
| `tabla_afectada` | `VARCHAR2(50)` | No | - | - | Ninguna | Nombre de la tabla modificada. |
| `id_registro_afectado` | `VARCHAR2(100)` | No | - | - | Ninguna | Identificador del registro afectado. |
| `operacion` | `VARCHAR2(10)` | No | - | - | CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE')) | Tipo de operación realizada. |
| `fecha_hora` | `TIMESTAMP` | No | - | - | Ninguna | Fecha y hora en que ocurrió el evento. |
| `valor_anterior` | `CLOB` | Si | - | - | Ninguna | Contenido previo a la modificación. |
| `valor_nuevo` | `CLOB` | Si | - | - | Ninguna | Contenido posterior a la modificación. |