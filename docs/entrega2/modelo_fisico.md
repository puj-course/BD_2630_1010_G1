# Modelo Físico Ampliado

## 1\. Introducción

El presente documento describe el modelo físico ampliado correspondiente a la Entrega 2 del proyecto **Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA**.

El modelo físico se obtiene a partir del modelo lógico ampliado mediante la ingeniería hacia el modelo relacional en Oracle SQL Developer Data Modeler. En él se definen los tipos de datos concretos de Oracle, la nulabilidad de cada columna, las claves primarias, las claves foráneas con su política de eliminación, las restricciones `UNIQUE` y `CHECK`, y los índices de apoyo a las consultas más frecuentes.

El script de creación se encuentra en el archivo `ddl\_modelo\_ampliado.ddl`.

El modelo físico está compuesto por las siguientes 16 tablas:

1. `EDICION\_MUNDIAL`
2. `SEDE`
3. `CIUDAD`
4. `Estadio`
5. `ETAPA\_COMPETENCIA`
6. `ORGANIZACIONES\_FUTBOL`
7. `SELECCION`
8. `PARTIDO`
9. `PARTICIPACION\_PARTIDO`
10. `PERSONA`
11. `VINCULACION\_SELECCION`
12. `ASIGNACION\_ARBITRAL`
13. `EVENTO\_PARTIDO`
14. `ENTRADA`
15. `ACREDITACION\_PRENSA`
16. `AUDITORIA`

Resumen de objetos definidos en el DDL:

|Objeto|Cantidad|
|-|-|
|Tablas|16|
|Claves primarias|16|
|Claves foráneas|24|
|Restricciones `UNIQUE`|9|
|Restricciones `CHECK`|13|
|Índices adicionales|3|

\---

# 2\. Tablas del modelo físico

> \*\*Convenciones utilizadas en este documento\*\*
>
> - Los identificadores se definen como `INTEGER` y son claves subrogadas.
> - Las columnas de texto usan semántica de caracteres (`VARCHAR2(n CHAR)`) en la mayoría de los casos.
> - En la columna \*\*Nulo\*\* se indica `NOT NULL` cuando la columna es obligatoria y `NULL` cuando es opcional.
> - Todas las claves foráneas se declaran con una política `ON DELETE` explícita (ver sección 7).

\---

## 2.1. EDICION\_MUNDIAL

Representa cada edición de la Copa Mundial registrada en el sistema.

### Clave primaria

* `EDICION\_MUNDIAL\_PK` → `id\_edicion`

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_edicion`|`INTEGER`|NOT NULL|PK|
|`anio`|`NUMBER`|NOT NULL|UNIQUE (`anio`)|
|`nombre`|`VARCHAR2(100 CHAR)`|NOT NULL||
|`fecha\_inicio`|`DATE`|NOT NULL||
|`fecha\_fin`|`DATE`|NOT NULL|CHECK (`edicion\_fechas`)|

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`EDICION\_MUNDIAL\_PK`|PRIMARY KEY|`id\_edicion`|
|`anio`|UNIQUE|`anio`|
|`edicion\_fechas`|CHECK|`fecha\_fin > fecha\_inicio`|

### Relaciones (tabla padre de)

* `SEDE` mediante `tiene`.
* `ETAPA\_COMPETENCIA` mediante `cuenta\_con`.
* `ACREDITACION\_PRENSA` mediante `acredita`.

\---

## 2.2. SEDE

Representa cada país anfitrión de una edición del Mundial.

### Clave primaria

* `SEDE\_PK` → `id\_sede`

### Clave foránea

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`tiene`|`id\_edicion`|`EDICION\_MUNDIAL(id\_edicion)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_sede`|`INTEGER`|NOT NULL|PK|
|`id\_edicion`|`INTEGER`|NOT NULL|FK|
|`pais`|`VARCHAR2(80 CHAR)`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`SEDE\_PK`|PRIMARY KEY|`id\_sede`|
|`Unique\_Keyv1`|UNIQUE|`(pais, id\_edicion)`|

### Reglas implementadas

* Un país no puede repetirse como sede dentro de una misma edición.
* No se puede eliminar una edición que tenga sedes asignadas.

### Relaciones (tabla padre de)

* `CIUDAD` mediante `posee`.

\---

## 2.3. CIUDAD

Representa cada ciudad anfitriona perteneciente a una sede.

### Clave primaria

* `CIUDAD\_PK` → `id\_ciudad`

### Clave foránea

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`posee`|`id\_sede`|`SEDE(id\_sede)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_ciudad`|`INTEGER`|NOT NULL|PK|
|`id\_sede`|`INTEGER`|NOT NULL|FK|
|`nombre`|`VARCHAR2(80 CHAR)`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`CIUDAD\_PK`|PRIMARY KEY|`id\_ciudad`|
|`Unique\_Key`|UNIQUE|`(id\_sede, nombre)`|

### Reglas implementadas

* El nombre de una ciudad no puede repetirse dentro de la misma sede.
* No se puede eliminar una sede que tenga ciudades registradas.

### Relaciones (tabla padre de)

* `Estadio` mediante `dispone`.

\---

## 2.4. Estadio

Representa los estadios utilizados para la realización de partidos.

### Clave primaria

* `Estadio\_PK` → `id\_estadio`

### Clave foránea

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`dispone`|`id\_ciudad`|`CIUDAD(id\_ciudad)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_estadio`|`INTEGER`|NOT NULL|PK|
|`id\_ciudad`|`INTEGER`|NOT NULL|FK|
|`nombre`|`VARCHAR2(100 CHAR)`|NOT NULL||
|`capacidad`|`INTEGER`|NOT NULL|CHECK (`estadio\_capacidad`)|

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`Estadio\_PK`|PRIMARY KEY|`id\_estadio`|
|`Unique\_Keyv4`|UNIQUE|`(nombre, id\_ciudad)`|
|`estadio\_capacidad`|CHECK|`capacidad > 0`|

### Reglas implementadas

* La capacidad debe ser mayor que cero.
* Un estadio no puede repetirse dentro de una misma ciudad.
* No se puede eliminar una ciudad que tenga estadios registrados.

### Relaciones (tabla padre de)

* `PARTIDO` mediante `alberga`.

\---

## 2.5. ETAPA\_COMPETENCIA

Representa la estructura deportiva de la competición de forma jerárquica (fase de grupos, grupos, dieciseisavos, octavos, cuartos, semifinal, tercer puesto y final).

### Clave primaria

* `ETAPA\_COMPETENCIA\_PK` → `id\_etapa`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`cuenta\_con`|`id\_edicion`|`EDICION\_MUNDIAL(id\_edicion)`|RESTRICT|
|`se\_conforma`|`id\_etapa\_padre`|`ETAPA\_COMPETENCIA(id\_etapa)`|SET NULL|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_etapa`|`INTEGER`|NOT NULL|PK|
|`id\_edicion`|`INTEGER`|NOT NULL|FK|
|`id\_etapa\_padre`|`INTEGER`|NULL|FK (autorrelación)|
|`nombre`|`VARCHAR2(80 CHAR)`|NOT NULL||
|`tipo\_etapa`|`VARCHAR2(40)`|NOT NULL|CHECK (`etapa\_tipo`)|
|`orden`|`INTEGER`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`ETAPA\_COMPETENCIA\_PK`|PRIMARY KEY|`id\_etapa`|
|`etapa\_tipo`|CHECK|`tipo\_etapa IN ('FASE', 'GRUPO', 'INSTANCIA\_ELIMINATORIA')`|

### Reglas implementadas

* `tipo\_etapa` solo admite los valores `FASE`, `GRUPO` e `INSTANCIA\_ELIMINATORIA`.
* No se puede eliminar una edición que ya tenga etapas registradas.
* Si se elimina una etapa, sus subetapas no se borran: quedan con `id\_etapa\_padre = NULL`.

### Relaciones (tabla padre de)

* `ETAPA\_COMPETENCIA` (autorrelación) mediante `se\_conforma`.
* `SELECCION` mediante `agrupa`.
* `PARTIDO` mediante `contiene`.

\---

## 2.6. ORGANIZACIONES\_FUTBOL

Representa organizaciones institucionales relacionadas con las selecciones: confederaciones y federaciones nacionales, de forma jerárquica.

Ejemplo: `CONMEBOL → Federación Colombiana de Fútbol`

### Clave primaria

* `ORGANIZACIONES\_FUTBOL\_PK` → `id\_organizacion`

### Clave foránea

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`se\_forma\_de`|`id\_organizacion\_padre`|`ORGANIZACIONES\_FUTBOL(id\_organizacion)`|SET NULL|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_organizacion`|`INTEGER`|NOT NULL|PK|
|`nombre`|`VARCHAR2(100 CHAR)`|NOT NULL||
|`tipo`|`VARCHAR2(30 CHAR)`|NOT NULL|CHECK (`organizacion\_tipo`)|
|`pais`|`VARCHAR2(80 CHAR)`|NOT NULL||
|`id\_organizacion\_padre`|`INTEGER`|NULL|FK (autorrelación)|

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`ORGANIZACIONES\_FUTBOL\_PK`|PRIMARY KEY|`id\_organizacion`|
|`organizacion\_tipo`|CHECK|`tipo IN ('CONFEDERACION', 'FEDERACION\_NACIONAL')`|

### Reglas implementadas

* `tipo` solo admite `CONFEDERACION` o `FEDERACION\_NACIONAL`.
* Si se elimina una organización, las suborganizaciones quedan independientes (`id\_organizacion\_padre = NULL`).

### Relaciones (tabla padre de)

* `ORGANIZACIONES\_FUTBOL` (autorrelación) mediante `se\_forma\_de`.
* `SELECCION` mediante `representa`.

\---

## 2.7. SELECCION

Representa una selección nacional dentro del torneo, asociada a su organización (federación) y al grupo en el que compite.

### Clave primaria

* `SELECCION\_PK` → `id\_seleccion`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`representa`|`id\_organizacion`|`ORGANIZACIONES\_FUTBOL(id\_organizacion)`|RESTRICT|
|`agrupa`|`id\_etapa\_grupo`|`ETAPA\_COMPETENCIA(id\_etapa)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_seleccion`|`INTEGER`|NOT NULL|PK|
|`id\_organizacion`|`INTEGER`|NOT NULL|FK|
|`id\_etapa\_grupo`|`INTEGER`|NOT NULL|FK|
|`codigo\_fifa`|`VARCHAR2(3 CHAR)`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`SELECCION\_PK`|PRIMARY KEY|`id\_seleccion`|

### Reglas implementadas

* No se puede eliminar una organización que tenga selecciones asociadas.
* No se puede eliminar una etapa que tenga selecciones asociadas.
* La edición de una selección se obtiene a través de `SELECCION → ETAPA\_COMPETENCIA → EDICION\_MUNDIAL`.

### Relaciones (tabla padre de)

* `PARTICIPACION\_PARTIDO` mediante `registra`.
* `VINCULACION\_SELECCION` mediante `vincula`.

\---

## 2.8. PARTIDO

Representa cada encuentro disputado dentro del torneo.

### Clave primaria

* `PARTIDO\_PK` → `id\_partido`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`contiene`|`id\_etapa`|`ETAPA\_COMPETENCIA(id\_etapa)`|RESTRICT|
|`alberga`|`id\_estadio`|`Estadio(id\_estadio)`|RESTRICT|
|`P2precede`|`id\_partido\_origen\_1`|`PARTIDO(id\_partido)`|SET NULL|
|`precede`|`id\_partido\_origen\_2`|`PARTIDO(id\_partido)`|SET NULL|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_partido`|`INTEGER`|NOT NULL|PK|
|`id\_etapa`|`INTEGER`|NOT NULL|FK|
|`id\_estadio`|`INTEGER`|NOT NULL|FK|
|`id\_partido\_origen\_1`|`INTEGER`|NULL|FK (autorrelación)|
|`id\_partido\_origen\_2`|`INTEGER`|NULL|FK (autorrelación)|
|`fecha\_hora`|`DATE`|NOT NULL||
|`asistencia\_registrada`|`INTEGER`|NOT NULL|CHECK (`partido\_asistencia`)|
|`estado`|`VARCHAR2(30 CHAR)`|NOT NULL||
|`resultado\_origen\_1`|`VARCHAR2(20 CHAR)`|NULL||
|`resultado\_origen\_2`|`VARCHAR2(20 CHAR)`|NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`PARTIDO\_PK`|PRIMARY KEY|`id\_partido`|
|`partido\_asistencia`|CHECK|`asistencia\_registrada >= 0`|

### Índices

|Nombre|Columnas|Justificación|
|-|-|-|
|`idx\_partido\_fecha`|`fecha\_hora`|Consultas frecuentes por fecha o en orden cronológico.|

### Reglas implementadas

* La asistencia registrada no puede ser negativa.
* No se puede eliminar un estadio ni una etapa que tengan partidos.
* Si se elimina un partido previo, el partido siguiente conserva su registro y pierde únicamente la referencia al origen correspondiente (`SET NULL`).
* Los atributos `resultado\_origen\_1` y `resultado\_origen\_2` indican qué resultado del partido de origen clasifica al equipo (por ejemplo, ganador o perdedor).

### Relaciones (tabla padre de)

* `PARTIDO` (autorrelación) mediante `P2precede` y `precede`.
* `PARTICIPACION\_PARTIDO` mediante `rellena`.
* `ASIGNACION\_ARBITRAL` mediante `tienev2`.
* `EVENTO\_PARTIDO` mediante `genera`.
* `ENTRADA` mediante `tienev1`.

\---

## 2.9. PARTICIPACION\_PARTIDO

Tabla asociativa que resuelve la relación muchos-a-muchos entre `PARTIDO` y `SELECCION`.

### Clave primaria

* `PARTICIPACION\_PARTIDO\_PK` → `id\_participacion\_partido`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`rellena`|`id\_partido`|`PARTIDO(id\_partido)`|CASCADE|
|`registra`|`id\_seleccion`|`SELECCION(id\_seleccion)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_participacion\_partido`|`INTEGER`|NOT NULL|PK|
|`id\_partido`|`INTEGER`|NOT NULL|FK|
|`id\_seleccion`|`INTEGER`|NOT NULL|FK|
|`condicion`|`VARCHAR2(10 CHAR)`|NOT NULL|CHECK (`partido\_condicion`)|
|`goles`|`INTEGER`|NOT NULL|CHECK (`part\_goles`)|
|`goles\_penales`|`INTEGER`|NOT NULL|CHECK (`part\_goles`)|
|`resultado`|`VARCHAR2(10)`|NULL|CHECK (`part\_resultado`)|

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`PARTICIPACION\_PARTIDO\_PK`|PRIMARY KEY|`id\_participacion\_partido`|
|`Unique\_Key\_1v2`|UNIQUE|`(id\_seleccion, id\_partido)`|
|`Unique\_Key\_2v2`|UNIQUE|`(condicion, id\_seleccion)`|
|`partido\_condicion`|CHECK|`condicion IN ('LOCAL', 'VISITANTE')`|
|`part\_goles`|CHECK|`goles >= 0 AND goles\_penales >= 0`|
|`part\_resultado`|CHECK|`resultado IN ('GANO', 'PERDIO', 'EMPATO')`|

### Reglas implementadas

* Una selección no puede registrarse dos veces en el mismo partido.
* `condicion` solo admite `LOCAL` o `VISITANTE`.
* Los goles y los goles de penales no pueden ser negativos.
* `resultado` solo admite `GANO`, `PERDIO` o `EMPATO`.
* Si se elimina un partido, sus participaciones se eliminan automáticamente.
* No se puede eliminar una selección con participaciones registradas.

\---

## 2.10. PERSONA

Representa actores naturales relacionados con el torneo (jugadores, cuerpo técnico, árbitros y periodistas).

### Clave primaria

* `PERSONA\_PK` → `id\_persona`

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_persona`|`INTEGER`|NOT NULL|PK|
|`nombre\_completo`|`VARCHAR2(120 CHAR)`|NOT NULL||
|`nacionalidad`|`VARCHAR2(80 CHAR)`|NULL||
|`fecha\_de\_nacimiento`|`DATE`|NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`PERSONA\_PK`|PRIMARY KEY|`id\_persona`|

### Reglas implementadas

* El rol de una persona no se almacena en esta tabla; se determina por sus relaciones con otras tablas.
* Una persona no puede eliminarse si tiene vínculos con selecciones, asignaciones arbitrales, acreditaciones o eventos principales (`RESTRICT`).

### Relaciones (tabla padre de)

* `VINCULACION\_SELECCION` mediante `crea`.
* `ASIGNACION\_ARBITRAL` mediante `es`.
* `ACREDITACION\_PRENSA` mediante `recibe`.
* `EVENTO\_PARTIDO` mediante `relaciona` e `involucra`.

\---

## 2.11. VINCULACION\_SELECCION

Tabla asociativa que resuelve la relación muchos-a-muchos entre `PERSONA` y `SELECCION`. Permite representar tanto a los jugadores convocados como al cuerpo técnico.

### Clave primaria

* `VINCULACION\_SELECCION\_PK` → `id\_vinculacion`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`crea`|`id\_persona`|`PERSONA(id\_persona)`|RESTRICT|
|`vincula`|`id\_seleccion`|`SELECCION(id\_seleccion)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_vinculacion`|`INTEGER`|NOT NULL|PK|
|`id\_persona`|`INTEGER`|NOT NULL|FK|
|`id\_seleccion`|`INTEGER`|NOT NULL|FK|
|`capitan`|`CHAR(1 CHAR)`|NULL||
|`dorsal`|`SMALLINT`|NULL||
|`posicion`|`VARCHAR2(30)`|NULL||
|`rol`|`VARCHAR2(30 CHAR)`|NOT NULL|CHECK (`vinculacion\_rol`)|
|`club`|`VARCHAR2(120 CHAR)`|NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`VINCULACION\_SELECCION\_PK`|PRIMARY KEY|`id\_vinculacion`|
|`Unique\_Keyv2`|UNIQUE|`(id\_seleccion, id\_persona)`|
|`vinculacion\_rol`|CHECK|`rol IN ('JUGADOR', 'DIRECTOR\_TECNICO', 'ASISTENTE', 'PREPARADOR\_FISICO')`|

### Reglas implementadas

* Una persona no puede vincularse dos veces a la misma selección.
* `rol` solo admite `JUGADOR`, `DIRECTOR\_TECNICO`, `ASISTENTE` o `PREPARADOR\_FISICO`.
* `dorsal`, `posicion` y `capitan` aplican principalmente cuando el rol es `JUGADOR`.
* No se puede eliminar una persona ni una selección que mantengan vínculos.

\---

## 2.12. ASIGNACION\_ARBITRAL

Tabla asociativa que resuelve la relación muchos-a-muchos entre `PARTIDO` y `PERSONA` en el contexto del arbitraje.

### Clave primaria

* `ASIGNACION\_ARBITRAL\_PK` → `id\_asignacion`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`tienev2`|`id\_partido`|`PARTIDO(id\_partido)`|CASCADE|
|`es`|`id\_persona`|`PERSONA(id\_persona)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_asignacion`|`INTEGER`|NOT NULL|PK|
|`id\_partido`|`INTEGER`|NOT NULL|FK|
|`id\_persona`|`INTEGER`|NOT NULL|FK|
|`rol\_arbitral`|`VARCHAR2(40 CHAR)`|NOT NULL|CHECK (`asignacion\_rol`)|

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`ASIGNACION\_ARBITRAL\_PK`|PRIMARY KEY|`id\_asignacion`|
|`Unique\_Key\_1`|UNIQUE|`(rol\_arbitral, id\_partido)`|
|`Unique\_Key\_2`|UNIQUE|`(id\_partido, id\_persona)`|
|`asignacion\_rol`|CHECK|`rol\_arbitral IN ('CENTRAL', 'ASISTENTE\_1', 'ASISTENTE\_2', 'CUARTO\_ARBITRO', 'VAR', 'AVAR')`|

### Reglas implementadas

* Una persona no puede estar duplicada dentro del equipo arbitral de un partido.
* Un mismo rol arbitral no puede asignarse dos veces en el mismo partido.
* Si se elimina un partido, sus asignaciones se eliminan automáticamente.
* No se puede eliminar una persona con asignaciones arbitrales.

\---

## 2.13. EVENTO\_PARTIDO

Representa acontecimientos deportivos asociados a un partido mediante una estructura general.

### Clave primaria

* `EVENTO\_PARTIDO\_PK` → `id\_evento`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`genera`|`id\_partido`|`PARTIDO(id\_partido)`|CASCADE|
|`relaciona`|`id\_persona`|`PERSONA(id\_persona)`|RESTRICT|
|`involucra`|`id\_persona\_relacionada`|`PERSONA(id\_persona)`|SET NULL|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_evento`|`INTEGER`|NOT NULL|PK|
|`id\_partido`|`INTEGER`|NOT NULL|FK|
|`id\_persona`|`INTEGER`|NULL|FK|
|`id\_persona\_relacionada`|`INTEGER`|NULL|FK|
|`tipo\_evento`|`VARCHAR2(40 CHAR)`|NOT NULL|CHECK (`evento\_tipo`)|
|`minuto`|`SMALLINT`|NULL||
|`valor\_numerico`|`SMALLINT`|NULL||
|`descripcion`|`VARCHAR2(400 CHAR)`|NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`EVENTO\_PARTIDO\_PK`|PRIMARY KEY|`id\_evento`|
|`evento\_tipo`|CHECK|`tipo\_evento IN ('GOL', 'ASISTENCIA', 'TARJETA\_AMARILLA', 'TARJETA\_ROJA', 'SUSTITUCION', 'MINUTOS\_JUGADOS')`|

### Índices

|Nombre|Columnas|Justificación|
|-|-|-|
|`idx\_evento\_partido`|`id\_partido`|Optimiza la consulta de todo lo ocurrido en un partido (goles, tarjetas y tiempos).|

### Reglas implementadas

* `tipo\_evento` solo admite los valores previstos en el `CHECK`.
* Si se elimina un partido, sus eventos se eliminan automáticamente.
* Si se elimina la persona relacionada (`id\_persona\_relacionada`), el evento se conserva con ese campo en `NULL`.
* No se puede eliminar una persona que sea protagonista principal (`id\_persona`) de un evento.
* En una `SUSTITUCION`, `id\_persona` representa al jugador que sale e `id\_persona\_relacionada` al que entra.
* En `MINUTOS\_JUGADOS`, `valor\_numerico` representa la cantidad de minutos.

\---

## 2.14. ENTRADA

Representa la boletería asociada a los partidos.

### Clave primaria

* `ENTRADA\_PK` → `id\_entrada`

### Clave foránea

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`tienev1`|`id\_partido`|`PARTIDO(id\_partido)`|CASCADE|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_entrada`|`INTEGER`|NOT NULL|PK|
|`id\_partido`|`INTEGER`|NOT NULL|FK|
|`categoria`|`VARCHAR2(30 CHAR)`|NOT NULL||
|`zona`|`VARCHAR2(50 CHAR)`|NOT NULL||
|`precio`|`NUMBER(2,10)`|NOT NULL|CHECK (`entrada\_precio`)|
|`estado`|`VARCHAR2(20)`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`ENTRADA\_PK`|PRIMARY KEY|`id\_entrada`|
|`entrada\_precio`|CHECK|`precio >= 0`|

### Índices

|Nombre|Columnas|Justificación|
|-|-|-|
|`idx\_entrada\_partido\_estado`|`(id\_partido, estado)`|Consulta frecuente de disponibilidad: entradas disponibles o vendidas por partido.|

### Reglas implementadas

* El precio no puede ser negativo.
* Si se elimina un partido de forma definitiva, sus entradas se eliminan automáticamente.
* No se almacena información personal del espectador.

\---

## 2.15. ACREDITACION\_PRENSA

Representa la acreditación de miembros de medios de comunicación para cubrir una edición del torneo.

### Clave primaria

* `ACREDITACION\_PRENSA\_PK` → `id\_acreditacion`

### Claves foráneas

|Nombre|Columna|Referencia|ON DELETE|
|-|-|-|-|
|`acredita`|`id\_edicion`|`EDICION\_MUNDIAL(id\_edicion)`|RESTRICT|
|`recibe`|`id\_persona`|`PERSONA(id\_persona)`|RESTRICT|

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_acreditacion`|`INTEGER`|NOT NULL|PK|
|`id\_persona`|`INTEGER`|NOT NULL|FK|
|`id\_edicion`|`INTEGER`|NOT NULL|FK|
|`medio\_comunicacio`|`VARCHAR2(120 CHAR)`|NOT NULL||
|`fecha\_emision`|`DATE`|NOT NULL||
|`tipo\_acreditacion`|`VARCHAR2(40 CHAR)`|NOT NULL||
|`estado`|`VARCHAR2(20 CHAR)`|NOT NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`ACREDITACION\_PRENSA\_PK`|PRIMARY KEY|`id\_acreditacion`|

### Reglas implementadas

* No se puede eliminar una edición con acreditaciones emitidas.
* No se puede eliminar una persona con acreditaciones registradas.
* El medio de comunicación es obligatorio en cada acreditación.

\---

## 2.16. AUDITORIA

Representa la trazabilidad de los cambios realizados sobre la información crítica del sistema. Es una tabla independiente, sin claves foráneas, de modo que sus registros se conserven aunque se eliminen los datos auditados.

### Clave primaria

* `AUDITORIA\_PK` → `id\_auditoria`

### Atributos

|Atributo|Tipo físico|Nulo|Restricción|
|-|-|-|-|
|`id\_auditoria`|`INTEGER`|NOT NULL|PK|
|`usuario\_bd`|`VARCHAR2(100 CHAR)`|NOT NULL||
|`tabla\_afectada`|`VARCHAR2(50 CHAR)`|NOT NULL||
|`id\_registro\_afectado`|`INTEGER`|NOT NULL||
|`operacion`|`VARCHAR2(10 CHAR)`|NOT NULL|CHECK (`auditoria\_operacion`)|
|`fecha\_hora`|`TIMESTAMP`|NOT NULL||
|`valor\_anterior`|`CLOB`|NULL||
|`valor\_nuevo`|`CLOB`|NULL||

### Restricciones

|Nombre|Tipo|Definición|
|-|-|-|
|`AUDITORIA\_PK`|PRIMARY KEY|`id\_auditoria`|
|`auditoria\_operacion`|CHECK|`operacion IN ('INSERT', 'UPDATE', 'DELETE')`|

### Reglas implementadas

Cada registro permite identificar quién realizó la operación, cuándo, sobre qué tabla, sobre qué registro, qué operación se ejecutó y qué información existía antes y después del cambio.

\---

# 3\. Resumen de claves foráneas

|Constraint|Tabla hija|Columna|Tabla padre|ON DELETE|Cardinalidad|
|-|-|-|-|-|-|
|`tiene`|`SEDE`|`id\_edicion`|`EDICION\_MUNDIAL`|RESTRICT|1:N|
|`posee`|`CIUDAD`|`id\_sede`|`SEDE`|RESTRICT|1:N|
|`dispone`|`Estadio`|`id\_ciudad`|`CIUDAD`|RESTRICT|1:N|
|`alberga`|`PARTIDO`|`id\_estadio`|`Estadio`|RESTRICT|1:N|
|`cuenta\_con`|`ETAPA\_COMPETENCIA`|`id\_edicion`|`EDICION\_MUNDIAL`|RESTRICT|1:N|
|`se\_conforma`|`ETAPA\_COMPETENCIA`|`id\_etapa\_padre`|`ETAPA\_COMPETENCIA`|SET NULL|1:N|
|`contiene`|`PARTIDO`|`id\_etapa`|`ETAPA\_COMPETENCIA`|RESTRICT|1:N|
|`agrupa`|`SELECCION`|`id\_etapa\_grupo`|`ETAPA\_COMPETENCIA`|RESTRICT|1:N|
|`se\_forma\_de`|`ORGANIZACIONES\_FUTBOL`|`id\_organizacion\_padre`|`ORGANIZACIONES\_FUTBOL`|SET NULL|1:N|
|`representa`|`SELECCION`|`id\_organizacion`|`ORGANIZACIONES\_FUTBOL`|RESTRICT|1:N|
|`P2precede`|`PARTIDO`|`id\_partido\_origen\_1`|`PARTIDO`|SET NULL|1:N|
|`precede`|`PARTIDO`|`id\_partido\_origen\_2`|`PARTIDO`|SET NULL|1:N|
|`rellena`|`PARTICIPACION\_PARTIDO`|`id\_partido`|`PARTIDO`|CASCADE|1:N|
|`registra`|`PARTICIPACION\_PARTIDO`|`id\_seleccion`|`SELECCION`|RESTRICT|1:N|
|`crea`|`VINCULACION\_SELECCION`|`id\_persona`|`PERSONA`|RESTRICT|1:N|
|`vincula`|`VINCULACION\_SELECCION`|`id\_seleccion`|`SELECCION`|RESTRICT|1:N|
|`tienev2`|`ASIGNACION\_ARBITRAL`|`id\_partido`|`PARTIDO`|CASCADE|1:N|
|`es`|`ASIGNACION\_ARBITRAL`|`id\_persona`|`PERSONA`|RESTRICT|1:N|
|`genera`|`EVENTO\_PARTIDO`|`id\_partido`|`PARTIDO`|CASCADE|1:N|
|`relaciona`|`EVENTO\_PARTIDO`|`id\_persona`|`PERSONA`|RESTRICT|1:N|
|`involucra`|`EVENTO\_PARTIDO`|`id\_persona\_relacionada`|`PERSONA`|SET NULL|1:N|
|`tienev1`|`ENTRADA`|`id\_partido`|`PARTIDO`|CASCADE|1:N|
|`acredita`|`ACREDITACION\_PRENSA`|`id\_edicion`|`EDICION\_MUNDIAL`|RESTRICT|1:N|
|`recibe`|`ACREDITACION\_PRENSA`|`id\_persona`|`PERSONA`|RESTRICT|1:N|

\---

# 4\. Restricciones `UNIQUE`

|Tabla|Constraint|Columnas|Propósito|
|-|-|-|-|
|`EDICION\_MUNDIAL`|`anio`|`anio`|Un solo registro por año.|
|`SEDE`|`Unique\_Keyv1`|`(pais, id\_edicion)`|Un país es sede una sola vez por edición.|
|`CIUDAD`|`Unique\_Key`|`(id\_sede, nombre)`|Sin ciudades repetidas dentro de una sede.|
|`Estadio`|`Unique\_Keyv4`|`(nombre, id\_ciudad)`|Sin estadios repetidos dentro de una ciudad.|
|`PARTICIPACION\_PARTIDO`|`Unique\_Key\_1v2`|`(id\_seleccion, id\_partido)`|Una selección participa una sola vez por partido.|
|`PARTICIPACION\_PARTIDO`|`Unique\_Key\_2v2`|`(condicion, id\_seleccion)`|Control de la condición local/visitante por selección.|
|`VINCULACION\_SELECCION`|`Unique\_Keyv2`|`(id\_seleccion, id\_persona)`|Una persona se vincula una sola vez a una selección.|
|`ASIGNACION\_ARBITRAL`|`Unique\_Key\_1`|`(rol\_arbitral, id\_partido)`|Un rol arbitral se asigna una sola vez por partido.|
|`ASIGNACION\_ARBITRAL`|`Unique\_Key\_2`|`(id\_partido, id\_persona)`|Una persona aparece una sola vez en el equipo arbitral.|

\---

# 5\. Restricciones `CHECK`

|Tabla|Constraint|Condición|
|-|-|-|
|`EDICION\_MUNDIAL`|`edicion\_fechas`|`fecha\_fin > fecha\_inicio`|
|`Estadio`|`estadio\_capacidad`|`capacidad > 0`|
|`ETAPA\_COMPETENCIA`|`etapa\_tipo`|`tipo\_etapa IN ('FASE', 'GRUPO', 'INSTANCIA\_ELIMINATORIA')`|
|`ORGANIZACIONES\_FUTBOL`|`organizacion\_tipo`|`tipo IN ('CONFEDERACION', 'FEDERACION\_NACIONAL')`|
|`PARTIDO`|`partido\_asistencia`|`asistencia\_registrada >= 0`|
|`PARTICIPACION\_PARTIDO`|`partido\_condicion`|`condicion IN ('LOCAL', 'VISITANTE')`|
|`PARTICIPACION\_PARTIDO`|`part\_goles`|`goles >= 0 AND goles\_penales >= 0`|
|`PARTICIPACION\_PARTIDO`|`part\_resultado`|`resultado IN ('GANO', 'PERDIO', 'EMPATO')`|
|`VINCULACION\_SELECCION`|`vinculacion\_rol`|`rol IN ('JUGADOR', 'DIRECTOR\_TECNICO', 'ASISTENTE', 'PREPARADOR\_FISICO')`|
|`ASIGNACION\_ARBITRAL`|`asignacion\_rol`|`rol\_arbitral IN ('CENTRAL', 'ASISTENTE\_1', 'ASISTENTE\_2', 'CUARTO\_ARBITRO', 'VAR', 'AVAR')`|
|`EVENTO\_PARTIDO`|`evento\_tipo`|`tipo\_evento IN ('GOL', 'ASISTENCIA', 'TARJETA\_AMARILLA', 'TARJETA\_ROJA', 'SUSTITUCION', 'MINUTOS\_JUGADOS')`|
|`ENTRADA`|`entrada\_precio`|`precio >= 0`|
|`AUDITORIA`|`auditoria\_operacion`|`operacion IN ('INSERT', 'UPDATE', 'DELETE')`|

\---

# 6\. Índices adicionales

Además de los índices que Oracle crea automáticamente para las claves primarias y las restricciones `UNIQUE`, se definieron tres índices orientados a las consultas más frecuentes del sistema.

|Índice|Tabla|Columnas|Justificación|
|-|-|-|-|
|`idx\_partido\_fecha`|`PARTIDO`|`fecha\_hora`|Búsquedas por fecha y ordenamiento cronológico del calendario.|
|`idx\_evento\_partido`|`EVENTO\_PARTIDO`|`id\_partido`|Consulta de goles, tarjetas y tiempos de un partido.|
|`idx\_entrada\_partido\_estado`|`ENTRADA`|`(id\_partido, estado)`|Consulta de disponibilidad: entradas disponibles y vendidas por partido.|

\---

# 7\. Política de integridad referencial

Cada clave foránea declara explícitamente su acción `ON DELETE`. Oracle no admite la cláusula `ON UPDATE`; como los identificadores son claves subrogadas que no se modifican, la intención `ON UPDATE RESTRICT` queda documentada como comentario en el DDL.

## 7.1. `ON DELETE RESTRICT`

Protege el historial: impide eliminar un registro padre mientras existan registros hijos.

Se aplica en: `tiene`, `posee`, `dispone`, `alberga`, `cuenta\_con`, `contiene`, `agrupa`, `representa`, `registra`, `crea`, `vincula`, `es`, `relaciona`, `acredita` y `recibe`.

Ejemplos:

* No se puede borrar un estadio que ya albergó o tiene programados partidos.
* No se puede borrar una persona con vínculos, asignaciones, acreditaciones o eventos.
* No se puede borrar una edición con sedes, etapas o acreditaciones.

## 7.2. `ON DELETE CASCADE`

Se usa cuando el registro hijo carece de sentido sin su padre. Elimina automáticamente los hijos.

Se aplica en: `rellena`, `tienev1`, `tienev2` y `genera`, todas sobre `PARTIDO`.

Al eliminar un partido se eliminan sus participaciones, entradas, asignaciones arbitrales y eventos.

## 7.3. `ON DELETE SET NULL`

Se usa en relaciones opcionales o jerárquicas, para que el hijo sobreviva sin su referencia.

Se aplica en: `se\_conforma`, `se\_forma\_de`, `P2precede`, `precede` e `involucra`.

Ejemplos:

* Si se elimina una etapa, sus subetapas quedan sin padre.
* Si se elimina una organización, sus suborganizaciones quedan independientes.
* Si se elimina un partido previo, el partido siguiente conserva su registro.
* Si se elimina la persona relacionada de un evento, el evento se conserva.

\---

# 8\. Relaciones muchos-a-muchos resueltas

|Relación|Tabla asociativa|Estructura|
|-|-|-|
|Partido – Selección|`PARTICIPACION\_PARTIDO`|`PARTIDO 1:N PARTICIPACION\_PARTIDO N:1 SELECCION`|
|Persona – Selección|`VINCULACION\_SELECCION`|`PERSONA 1:N VINCULACION\_SELECCION N:1 SELECCION`|
|Persona – Partido (arbitraje)|`ASIGNACION\_ARBITRAL`|`PERSONA 1:N ASIGNACION\_ARBITRAL N:1 PARTIDO`|

\---

# 11\. Conclusión

El modelo físico implementa en Oracle las 16 tablas del modelo lógico ampliado, con claves primarias y foráneas, restricciones de unicidad y de dominio, políticas de eliminación explícitas e índices de apoyo.

La política de integridad referencial combina tres criterios: `RESTRICT` para proteger el historial deportivo y administrativo, `CASCADE` para los datos que dependen por completo de un partido y `SET NULL` para las jerarquías y referencias opcionales.



