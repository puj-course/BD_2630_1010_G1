# Modelo Lógico Ampliado

## 1. Introducción

El presente documento describe el modelo lógico ampliado propuesto para la Entrega 2 del proyecto **Sistema de Información para la Gestión Integral de la Copa Mundial de la FIFA**.

El modelo parte de la estructura desarrollada durante la Entrega 1 y de la evaluación crítica realizada sobre el modelo inicial. Su objetivo es representar de manera más completa la organización y operación de una Copa Mundial, incluyendo organización geográfica, competencia deportiva, selecciones, jugadores, cuerpo técnico, arbitraje, estadísticas, boletería, medios, incidencias y auditoría.

Para mantener el modelo dentro del rango establecido de 12 a 16 tablas, se adoptaron algunas estructuras generales que permiten representar conceptos relacionados sin crear entidades independientes para cada uno de ellos.

El modelo ampliado está compuesto por las siguientes 16 tablas:

1. `EDICION_MUNDIAL`
2. `SEDE`
3. `CIUDAD`
4. `ESTADIO`
5. `ETAPA_COMPETENCIA`
6. `ORGANIZACION_FUTBOL`
7. `SELECCION`
8. `PARTIDO`
9. `PARTICIPACION_PARTIDO`
10. `PERSONA`
11. `VINCULACION_SELECCION`
12. `ASIGNACION_ARBITRAL`
13. `EVENTO_PARTIDO`
14. `ENTRADA`
15. `ACREDITACION_PRENSA`
16. `AUDITORIA_EVENTO`

---

# 2. Entidades del modelo lógico

## 2.1. EDICION_MUNDIAL

Representa cada edición de la Copa Mundial registrada en el sistema.

### Clave primaria

- `id_edicion`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_edicion` | `NUMBER` | PK |
| `anio` | `NUMBER(4)` | NOT NULL, UNIQUE |
| `nombre` | `VARCHAR2(100)` | NOT NULL |
| `fecha_inicio` | `DATE` | NOT NULL |
| `fecha_fin` | `DATE` | NOT NULL |

### Reglas principales

- `fecha_fin` debe ser posterior a `fecha_inicio`.
- Cada edición debe tener un año único dentro del sistema.

### Relaciones

- Una edición puede tener varias sedes.
- Una edición puede contener varias etapas de competencia.
- Una edición puede tener varias selecciones participantes.
- Una edición puede tener múltiples acreditaciones de prensa.

### Cardinalidades

- `EDICION_MUNDIAL 1:N SEDE`
- `EDICION_MUNDIAL 1:N ETAPA_COMPETENCIA`
- `EDICION_MUNDIAL 1:N SELECCION`
- `EDICION_MUNDIAL 1:N ACREDITACION_PRENSA`

---

## 2.2. SEDE

Representa cada país anfitrión de una edición del Mundial.

### Clave primaria

- `id_sede`

### Clave foránea

- `id_edicion` → `EDICION_MUNDIAL(id_edicion)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_sede` | `NUMBER` | PK |
| `id_edicion` | `NUMBER` | FK, NOT NULL |
| `pais` | `VARCHAR2(80)` | NOT NULL |

### Reglas principales

- Un país no debe aparecer más de una vez como sede dentro de una misma edición.
- Se propone una restricción `UNIQUE(id_edicion, pais)`.

### Relaciones

- Una edición puede tener varias sedes.
- Cada sede pertenece a una sola edición.
- Una sede puede contener varias ciudades.

### Cardinalidades

- `EDICION_MUNDIAL 1:N SEDE`
- `SEDE 1:N CIUDAD`

---

## 2.3. CIUDAD

Representa cada ciudad anfitriona perteneciente a una sede.

### Clave primaria

- `id_ciudad`

### Clave foránea

- `id_sede` → `SEDE(id_sede)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_ciudad` | `NUMBER` | PK |
| `id_sede` | `NUMBER` | FK, NOT NULL |
| `nombre` | `VARCHAR2(80)` | NOT NULL |

### Reglas principales

- El mismo nombre de ciudad no debe repetirse dentro de la misma sede.
- Se propone `UNIQUE(id_sede, nombre)`.

### Relaciones

- Una sede puede tener varias ciudades.
- Una ciudad pertenece a una sola sede.
- Una ciudad puede contener varios estadios.

### Cardinalidades

- `SEDE 1:N CIUDAD`
- `CIUDAD 1:N ESTADIO`

---

## 2.4. ESTADIO

Representa los estadios utilizados para la realización de partidos.

### Clave primaria

- `id_estadio`

### Clave foránea

- `id_ciudad` → `CIUDAD(id_ciudad)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_estadio` | `NUMBER` | PK |
| `id_ciudad` | `NUMBER` | FK, NOT NULL |
| `nombre` | `VARCHAR2(100)` | NOT NULL |
| `capacidad` | `NUMBER` | NOT NULL |

### Reglas principales

- La capacidad debe ser mayor que cero.
- El mismo estadio no debe repetirse dentro de una ciudad.
- Se propone `UNIQUE(id_ciudad, nombre)`.

### Relaciones

- Una ciudad puede contener varios estadios.
- Un estadio pertenece a una sola ciudad.
- Un estadio puede albergar múltiples partidos.

### Cardinalidades

- `CIUDAD 1:N ESTADIO`
- `ESTADIO 1:N PARTIDO`

---

## 2.5. ETAPA_COMPETENCIA

Representa la estructura deportiva de la competición.

Esta entidad permite modelar de forma jerárquica conceptos como:

- Fase de grupos.
- Grupos individuales.
- Dieciseisavos.
- Octavos.
- Cuartos de final.
- Semifinal.
- Tercer puesto.
- Final.

### Clave primaria

- `id_etapa`

### Claves foráneas

- `id_edicion` → `EDICION_MUNDIAL(id_edicion)`
- `id_etapa_padre` → `ETAPA_COMPETENCIA(id_etapa)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_etapa` | `NUMBER` | PK |
| `id_edicion` | `NUMBER` | FK, NOT NULL |
| `id_etapa_padre` | `NUMBER` | FK, NULL permitido |
| `nombre` | `VARCHAR2(50)` | NOT NULL |
| `tipo_etapa` | `VARCHAR2(30)` | NOT NULL |
| `orden` | `NUMBER` | NOT NULL |

### Valores previstos para `tipo_etapa`

- `FASE`
- `GRUPO`
- `INSTANCIA_ELIMINATORIA`

### Relaciones

- Una edición contiene múltiples etapas.
- Una etapa puede contener otras etapas.
- Una etapa puede agrupar varias selecciones.
- Una etapa puede contener varios partidos.

### Cardinalidades

- `EDICION_MUNDIAL 1:N ETAPA_COMPETENCIA`
- `ETAPA_COMPETENCIA 1:N ETAPA_COMPETENCIA`
- `ETAPA_COMPETENCIA 1:N SELECCION`
- `ETAPA_COMPETENCIA 1:N PARTIDO`

---

## 2.6. ORGANIZACION_FUTBOL

Representa organizaciones institucionales relacionadas con las selecciones.

Esta entidad permite manejar de forma jerárquica:

- Confederaciones.
- Federaciones nacionales.

Ejemplo:

`CONMEBOL → Federación Colombiana de Fútbol`

### Clave primaria

- `id_organizacion`

### Clave foránea

- `id_organizacion_padre` → `ORGANIZACION_FUTBOL(id_organizacion)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_organizacion` | `NUMBER` | PK |
| `id_organizacion_padre` | `NUMBER` | FK, NULL permitido |
| `nombre` | `VARCHAR2(100)` | NOT NULL |
| `tipo` | `VARCHAR2(30)` | NOT NULL |
| `pais` | `VARCHAR2(80)` | NULL permitido |

### Valores previstos para `tipo`

- `CONFEDERACION`
- `FEDERACION_NACIONAL`

### Reglas principales

- Una confederación no necesita organización padre.
- Una federación nacional debe pertenecer a una confederación.
- Una selección debe relacionarse con una organización de tipo `FEDERACION_NACIONAL`.

### Relaciones

- Una confederación puede contener varias federaciones.
- Una federación puede estar asociada a varias participaciones históricas de una selección.

### Cardinalidades

- `ORGANIZACION_FUTBOL 1:N ORGANIZACION_FUTBOL`
- `ORGANIZACION_FUTBOL 1:N SELECCION`

---

## 2.7. SELECCION

Representa la participación de una selección nacional dentro de una edición determinada del Mundial.

### Clave primaria

- `id_seleccion`

### Claves foráneas

- `id_edicion` → `EDICION_MUNDIAL(id_edicion)`
- `id_federacion` → `ORGANIZACION_FUTBOL(id_organizacion)`
- `id_etapa_grupo` → `ETAPA_COMPETENCIA(id_etapa)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_seleccion` | `NUMBER` | PK |
| `id_edicion` | `NUMBER` | FK, NOT NULL |
| `id_federacion` | `NUMBER` | FK, NOT NULL |
| `id_etapa_grupo` | `NUMBER` | FK, NULL permitido |
| `nombre` | `VARCHAR2(80)` | NOT NULL |
| `codigo_fifa` | `VARCHAR2(3)` | NOT NULL |

### Reglas principales

- `id_federacion` debe referenciar una organización de tipo `FEDERACION_NACIONAL`.
- `id_etapa_grupo`, cuando exista, debe referenciar una etapa cuyo `tipo_etapa` sea `GRUPO`.
- Una selección no debe aparecer dos veces dentro de una misma edición.

### Relaciones

- Una edición tiene múltiples selecciones.
- Una federación puede estar relacionada con selecciones en diferentes ediciones.
- Un grupo contiene varias selecciones.
- Una selección participa en múltiples partidos.
- Una selección puede tener varias personas vinculadas.

### Cardinalidades

- `EDICION_MUNDIAL 1:N SELECCION`
- `ORGANIZACION_FUTBOL 1:N SELECCION`
- `ETAPA_COMPETENCIA 1:N SELECCION`
- `SELECCION N:M PARTIDO`
- `SELECCION N:M PERSONA`

---

## 2.8. PARTIDO

Representa cada encuentro disputado dentro del torneo.

### Clave primaria

- `id_partido`

### Claves foráneas

- `id_etapa` → `ETAPA_COMPETENCIA(id_etapa)`
- `id_estadio` → `ESTADIO(id_estadio)`
- `id_partido_origen_1` → `PARTIDO(id_partido)`
- `id_partido_origen_2` → `PARTIDO(id_partido)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_partido` | `NUMBER` | PK |
| `id_etapa` | `NUMBER` | FK, NOT NULL |
| `id_estadio` | `NUMBER` | FK, NOT NULL |
| `fecha_hora` | `TIMESTAMP` | NOT NULL |
| `asistencia_registrada` | `NUMBER` | >= 0 |
| `estado` | `VARCHAR2(20)` | NOT NULL |
| `id_partido_origen_1` | `NUMBER` | FK, NULL |
| `id_partido_origen_2` | `NUMBER` | FK, NULL |
| `criterio_origen_1` | `VARCHAR2(10)` | NULL |
| `criterio_origen_2` | `VARCHAR2(10)` | NULL |

### Valores posibles de criterios de origen

- `GANADOR`
- `PERDEDOR`

### Reglas principales

- Un partido pertenece a una única etapa.
- Un partido se disputa en un único estadio.
- No deben programarse dos partidos en el mismo estadio a la misma fecha y hora.
- Las referencias a partidos anteriores permiten reconstruir las llaves de eliminación directa.

### Relaciones

- Un estadio puede albergar múltiples partidos.
- Una etapa puede contener múltiples partidos.
- Un partido contiene exactamente dos selecciones mediante `PARTICIPACION_PARTIDO`.
- Un partido puede tener múltiples asignaciones arbitrales.
- Un partido puede generar múltiples eventos.
- Un partido puede tener múltiples entradas.

### Cardinalidades

- `ESTADIO 1:N PARTIDO`
- `ETAPA_COMPETENCIA 1:N PARTIDO`
- `PARTIDO N:M SELECCION`
- `PARTIDO N:M PERSONA` mediante arbitraje
- `PARTIDO 1:N EVENTO_PARTIDO`
- `PARTIDO 1:N ENTRADA`
- `PARTIDO 1:N PARTIDO` como autorrelación de avance

---

## 2.9. PARTICIPACION_PARTIDO

Entidad asociativa que resuelve la relación muchos-a-muchos entre `PARTIDO` y `SELECCION`.

### Clave primaria

- `id_participacion`

### Claves foráneas

- `id_partido` → `PARTIDO(id_partido)`
- `id_seleccion` → `SELECCION(id_seleccion)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_participacion` | `NUMBER` | PK |
| `id_partido` | `NUMBER` | FK, NOT NULL |
| `id_seleccion` | `NUMBER` | FK, NOT NULL |
| `condicion` | `VARCHAR2(10)` | NOT NULL |
| `goles` | `NUMBER` | >= 0 |
| `goles_penales` | `NUMBER` | >= 0 |
| `resultado` | `VARCHAR2(10)` | NULL permitido |

### Valores posibles de `condicion`

- `LOCAL`
- `VISITANTE`

### Valores posibles de `resultado`

- `GANO`
- `PERDIO`
- `EMPATO`

### Reglas principales

- Una selección no puede registrarse dos veces en el mismo partido.
- Un partido no puede tener dos selecciones con la misma condición.
- Cada partido debe tener exactamente dos registros de participación.
- En partidos definidos por penales pueden almacenarse los goles obtenidos en la tanda.

### Restricciones propuestas

- `UNIQUE(id_partido, id_seleccion)`
- `UNIQUE(id_partido, condicion)`

### Cardinalidad

- `PARTIDO N:M SELECCION`, resuelta por `PARTICIPACION_PARTIDO`.

---

## 2.10. PERSONA

Representa actores naturales relacionados con el torneo.

Una misma estructura permite registrar personas que posteriormente pueden desempeñar funciones como:

- Jugador.
- Director técnico.
- Asistente.
- Preparador físico.
- Árbitro.
- Periodista.

### Clave primaria

- `id_persona`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_persona` | `NUMBER` | PK |
| `nombre_completo` | `VARCHAR2(120)` | NOT NULL |
| `nacionalidad` | `VARCHAR2(80)` | NULL permitido |
| `fecha_nacimiento` | `DATE` | NULL permitido |

### Reglas principales

- No se almacenarán datos personales sensibles reales.
- El rol de una persona se determina mediante las relaciones que tenga dentro del sistema y no mediante un único atributo fijo.

---

## 2.11. VINCULACION_SELECCION

Entidad asociativa que relaciona personas con selecciones.

Permite representar tanto la convocatoria de jugadores como los integrantes del cuerpo técnico.

### Clave primaria

- `id_vinculacion`

### Claves foráneas

- `id_persona` → `PERSONA(id_persona)`
- `id_seleccion` → `SELECCION(id_seleccion)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_vinculacion` | `NUMBER` | PK |
| `id_persona` | `NUMBER` | FK, NOT NULL |
| `id_seleccion` | `NUMBER` | FK, NOT NULL |
| `rol` | `VARCHAR2(30)` | NOT NULL |
| `dorsal` | `NUMBER(2)` | NULL |
| `capitan` | `CHAR(1)` | NULL |
| `posicion` | `VARCHAR2(30)` | NULL |
| `club` | `VARCHAR2(100)` | NULL |

### Roles previstos

- `JUGADOR`
- `DIRECTOR_TECNICO`
- `ASISTENTE`
- `PREPARADOR_FISICO`

### Reglas principales

- Una misma persona no debe tener duplicada la misma vinculación con una selección.
- El dorsal no debe repetirse entre jugadores de una misma selección.
- Solo un jugador puede ser identificado como capitán de la selección.
- `dorsal`, `posicion` y `capitan` se utilizan principalmente cuando el rol es `JUGADOR`.
- La cantidad de jugadores convocados deberá respetar el límite establecido para la edición.

### Restricción propuesta

- `UNIQUE(id_persona, id_seleccion)`

### Cardinalidad

- `PERSONA N:M SELECCION`, resuelta mediante `VINCULACION_SELECCION`.

---

## 2.12. ASIGNACION_ARBITRAL

Entidad asociativa que representa la asignación de árbitros a los partidos.

### Clave primaria

- `id_asignacion`

### Claves foráneas

- `id_partido` → `PARTIDO(id_partido)`
- `id_persona` → `PERSONA(id_persona)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_asignacion` | `NUMBER` | PK |
| `id_partido` | `NUMBER` | FK, NOT NULL |
| `id_persona` | `NUMBER` | FK, NOT NULL |
| `rol_arbitral` | `VARCHAR2(30)` | NOT NULL |

### Roles arbitrales previstos

- `CENTRAL`
- `ASISTENTE_1`
- `ASISTENTE_2`
- `CUARTO_ARBITRO`
- `VAR`
- `AVAR`

### Reglas principales

- Una persona no puede estar duplicada dentro del equipo arbitral de un partido.
- Un mismo rol arbitral no debe asignarse dos veces dentro del mismo partido cuando el rol sea único.
- Un árbitro no puede estar asignado simultáneamente a dos partidos.

### Restricciones propuestas

- `UNIQUE(id_partido, id_persona)`
- `UNIQUE(id_partido, rol_arbitral)`

### Cardinalidad

- `PERSONA N:M PARTIDO`, resuelta mediante `ASIGNACION_ARBITRAL`.

---

## 2.13. EVENTO_PARTIDO

Representa acontecimientos deportivos u operativos asociados a un partido.

Esta entidad general permite registrar diferentes clases de eventos sin crear una tabla independiente para cada uno.

### Clave primaria

- `id_evento`

### Claves foráneas

- `id_partido` → `PARTIDO(id_partido)`
- `id_persona` → `PERSONA(id_persona)`
- `id_persona_relacionada` → `PERSONA(id_persona)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_evento` | `NUMBER` | PK |
| `id_partido` | `NUMBER` | FK, NOT NULL |
| `id_persona` | `NUMBER` | FK, NULL permitido |
| `id_persona_relacionada` | `NUMBER` | FK, NULL permitido |
| `tipo_evento` | `VARCHAR2(40)` | NOT NULL |
| `minuto` | `NUMBER(3)` | NULL permitido |
| `valor_numerico` | `NUMBER` | NULL permitido |
| `descripcion` | `VARCHAR2(500)` | NULL permitido |

### Tipos de evento previstos

- `GOL`
- `ASISTENCIA`
- `TARJETA_AMARILLA`
- `TARJETA_ROJA`
- `SUSTITUCION`
- `MINUTOS_JUGADOS`
- `INCIDENCIA_CLIMATICA`
- `INCIDENCIA_TECNICA`
- `INCIDENCIA_DISCIPLINARIA`

### Reglas principales

Para determinados tipos de evento se requieren campos específicos:

**Gol**
- Debe existir `id_persona`.
- Debe existir el minuto correspondiente.

**Asistencia**
- Debe existir `id_persona`.

**Tarjeta**
- Debe existir `id_persona`.
- Debe existir el minuto.

**Sustitución**
- `id_persona` representa al jugador que sale.
- `id_persona_relacionada` representa al jugador que entra.
- Debe registrarse el minuto.

**Minutos jugados**
- `valor_numerico` representa la cantidad de minutos.

**Incidencia**
- La relación con una persona puede ser opcional.
- Debe contener una descripción cuando sea necesario explicar el evento.

### Relaciones

- Un partido puede generar múltiples eventos.
- Una persona puede estar relacionada con múltiples eventos.

### Cardinalidades

- `PARTIDO 1:N EVENTO_PARTIDO`
- `PERSONA 1:N EVENTO_PARTIDO`

---

## 2.14. ENTRADA

Representa la boletería asociada a los partidos.

### Clave primaria

- `id_entrada`

### Clave foránea

- `id_partido` → `PARTIDO(id_partido)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_entrada` | `NUMBER` | PK |
| `id_partido` | `NUMBER` | FK, NOT NULL |
| `categoria` | `VARCHAR2(30)` | NOT NULL |
| `zona` | `VARCHAR2(50)` | NOT NULL |
| `precio` | `NUMBER(10,2)` | >= 0 |
| `estado` | `VARCHAR2(20)` | NOT NULL |

### Reglas principales

- El precio no puede ser negativo.
- Toda entrada debe estar asociada a un partido.
- No es necesario almacenar información personal del espectador.

### Cardinalidad

- `PARTIDO 1:N ENTRADA`

---

## 2.15. ACREDITACION_PRENSA

Representa la acreditación de miembros de medios de comunicación para cubrir una edición del torneo.

### Clave primaria

- `id_acreditacion`

### Claves foráneas

- `id_edicion` → `EDICION_MUNDIAL(id_edicion)`
- `id_persona` → `PERSONA(id_persona)`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_acreditacion` | `NUMBER` | PK |
| `id_edicion` | `NUMBER` | FK, NOT NULL |
| `id_persona` | `NUMBER` | FK, NOT NULL |
| `medio_comunicacion` | `VARCHAR2(120)` | NOT NULL |
| `tipo_acreditacion` | `VARCHAR2(40)` | NOT NULL |
| `fecha_emision` | `DATE` | NOT NULL |
| `estado` | `VARCHAR2(20)` | NOT NULL |

### Reglas principales

- Una persona no debe tener duplicada su acreditación para la misma edición.
- El medio de comunicación debe quedar identificado en cada acreditación.

### Restricción propuesta

- `UNIQUE(id_edicion, id_persona)`

### Cardinalidades

- `EDICION_MUNDIAL 1:N ACREDITACION_PRENSA`
- `PERSONA 1:N ACREDITACION_PRENSA`

---

## 2.16. AUDITORIA_EVENTO

Representa la trazabilidad de los cambios realizados sobre información crítica del sistema.

### Clave primaria

- `id_auditoria`

### Atributos

| Atributo | Tipo propuesto | Restricción |
|---|---|---|
| `id_auditoria` | `NUMBER` | PK |
| `usuario_bd` | `VARCHAR2(100)` | NOT NULL |
| `tabla_afectada` | `VARCHAR2(50)` | NOT NULL |
| `id_registro_afectado` | `VARCHAR2(100)` | NOT NULL |
| `operacion` | `VARCHAR2(10)` | NOT NULL |
| `fecha_hora` | `TIMESTAMP` | NOT NULL |
| `valor_anterior` | `CLOB` | NULL permitido |
| `valor_nuevo` | `CLOB` | NULL permitido |

### Operaciones previstas

- `INSERT`
- `UPDATE`
- `DELETE`

### Reglas principales

Cada registro de auditoría debe permitir identificar:

- quién realizó la operación;
- cuándo se realizó;
- sobre qué tabla;
- sobre qué registro;
- qué operación se realizó;
- qué información existía antes;
- qué información quedó después de la modificación.

---

# 3. Resumen de relaciones y cardinalidades

| Entidad origen | Relación | Entidad destino | Cardinalidad |
|---|---|---|---|
| `EDICION_MUNDIAL` | contiene | `SEDE` | 1:N |
| `SEDE` | contiene | `CIUDAD` | 1:N |
| `CIUDAD` | contiene | `ESTADIO` | 1:N |
| `ESTADIO` | alberga | `PARTIDO` | 1:N |
| `EDICION_MUNDIAL` | contiene | `ETAPA_COMPETENCIA` | 1:N |
| `ETAPA_COMPETENCIA` | contiene | `ETAPA_COMPETENCIA` | 1:N |
| `ETAPA_COMPETENCIA` | agrupa | `SELECCION` | 1:N |
| `ETAPA_COMPETENCIA` | contiene | `PARTIDO` | 1:N |
| `ORGANIZACION_FUTBOL` | contiene | `ORGANIZACION_FUTBOL` | 1:N |
| `ORGANIZACION_FUTBOL` | representa | `SELECCION` | 1:N |
| `EDICION_MUNDIAL` | tiene | `SELECCION` | 1:N |
| `PARTIDO` | enfrenta | `SELECCION` | N:M |
| `SELECCION` | vincula | `PERSONA` | N:M |
| `PARTIDO` | asigna | `PERSONA` | N:M |
| `PARTIDO` | genera | `EVENTO_PARTIDO` | 1:N |
| `PERSONA` | participa en | `EVENTO_PARTIDO` | 1:N |
| `PARTIDO` | tiene | `ENTRADA` | 1:N |
| `EDICION_MUNDIAL` | genera | `ACREDITACION_PRENSA` | 1:N |
| `PERSONA` | recibe | `ACREDITACION_PRENSA` | 1:N |
| `PARTIDO` | precede | `PARTIDO` | 1:N |

---

# 4. Relaciones muchos-a-muchos

El modelo contiene varias relaciones muchos-a-muchos que se resuelven mediante entidades asociativas.

## Partido - Selección

Un partido contiene dos selecciones y una selección participa en múltiples partidos.

Se resuelve mediante:

`PARTICIPACION_PARTIDO`

```text
PARTIDO 1:N PARTICIPACION_PARTIDO N:1 SELECCION
```

---

## Persona - Selección

Una selección puede tener múltiples jugadores y miembros del cuerpo técnico, mientras que una persona puede aparecer en diferentes ediciones.

Se resuelve mediante:

`VINCULACION_SELECCION`

```text
PERSONA 1:N VINCULACION_SELECCION N:1 SELECCION
```

---

## Persona - Partido en arbitraje

Un partido tiene varios árbitros y un árbitro puede participar en múltiples encuentros.

Se resuelve mediante:

`ASIGNACION_ARBITRAL`

```text
PERSONA 1:N ASIGNACION_ARBITRAL N:1 PARTIDO
```

---

# 5. Organización jerárquica del modelo

## Organización geográfica

```text
EDICION_MUNDIAL
        |
        N
       SEDE
        |
        N
      CIUDAD
        |
        N
     ESTADIO
        |
        N
      PARTIDO
```

---

## Organización institucional del fútbol

```text
ORGANIZACION_FUTBOL
(CONFEDERACION)
        |
        N
ORGANIZACION_FUTBOL
(FEDERACION_NACIONAL)
        |
        N
     SELECCION
```

---

## Organización deportiva

```text
EDICION_MUNDIAL
        |
        N
ETAPA_COMPETENCIA
        |
        +---- GRUPOS
        |
        +---- INSTANCIAS ELIMINATORIAS
        |
        N
      PARTIDO
```

---

## Selecciones y personas

```text
SELECCION
    |
    N
VINCULACION_SELECCION
    |
    1
 PERSONA
```

---

## Desarrollo de un partido

```text
PARTIDO
│
├── PARTICIPACION_PARTIDO
│       └── SELECCION
│
├── ASIGNACION_ARBITRAL
│       └── PERSONA
│
├── EVENTO_PARTIDO
│       └── PERSONA
│
└── ENTRADA
```

---

# 6. Decisiones de diseño

## 6.1. ETAPA_COMPETENCIA

Se decidió utilizar una entidad general `ETAPA_COMPETENCIA` en lugar de crear tablas independientes para fase, grupo e instancia eliminatoria.

La autorrelación mediante `id_etapa_padre` permite representar estructuras jerárquicas como:

```text
Fase de Grupos
├── Grupo A
├── Grupo B
└── Grupo C

Fase Eliminatoria
├── Octavos
├── Cuartos
├── Semifinal
└── Final
```

Esta decisión reduce el número de entidades y permite representar diferentes formatos de competencia.

---

## 6.2. ORGANIZACION_FUTBOL

Se decidió representar confederaciones y federaciones nacionales mediante una misma entidad jerárquica.

El atributo `tipo` permite diferenciarlas y `id_organizacion_padre` permite establecer la relación:

```text
CONFEDERACION
      ↓
FEDERACION_NACIONAL
      ↓
SELECCION
```

---

## 6.3. PERSONA

Jugadores, miembros del cuerpo técnico, árbitros y periodistas comparten información personal básica.

Por este motivo se creó una entidad general `PERSONA` y los roles se representan mediante las relaciones de dicha persona con las diferentes entidades del sistema.

Esto evita duplicar atributos comunes en múltiples tablas.

---

## 6.4. EVENTO_PARTIDO

Se decidió utilizar una estructura general para registrar acontecimientos asociados a los partidos.

Esto permite representar dentro de una misma estructura:

- goles;
- asistencias;
- tarjetas;
- sustituciones;
- minutos jugados;
- incidencias climáticas;
- incidencias técnicas;
- incidencias disciplinarias.

Las reglas de negocio asociadas a cada tipo de evento deberán ser verificadas posteriormente durante la implementación física del modelo.

---

# 7. Consideraciones de normalización

El modelo fue diseñado buscando reducir redundancias y mantener dependencias funcionales coherentes.

Por ejemplo, `ESTADIO` no almacena directamente la ciudad, el país sede o la edición, debido a que esta información puede obtenerse mediante:

```text
ESTADIO
→ CIUDAD
→ SEDE
→ EDICION_MUNDIAL
```

De la misma manera, `SELECCION` no almacena directamente su confederación, ya que puede obtenerse mediante:

```text
SELECCION
→ ORGANIZACION_FUTBOL (FEDERACION_NACIONAL)
→ ORGANIZACION_FUTBOL (CONFEDERACION)
```

Asimismo, `PARTIDO` no almacena directamente `id_edicion`, ya que la edición puede determinarse mediante:

```text
PARTIDO
→ ETAPA_COMPETENCIA
→ EDICION_MUNDIAL
```

Estas decisiones buscan evitar redundancias y preparar el modelo para su posterior normalización formal hasta Tercera Forma Normal (3FN).

---

# 8. Cobertura de los frentes funcionales

## Organización del Torneo

Cubierta mediante:

- `EDICION_MUNDIAL`
- `SEDE`
- `CIUDAD`
- `ESTADIO`

## Competencia Deportiva

Cubierta mediante:

- `ETAPA_COMPETENCIA`
- `SELECCION`
- `PARTIDO`
- `PARTICIPACION_PARTIDO`

## Selecciones, Jugadores y Cuerpo Técnico

Cubierta mediante:

- `ORGANIZACION_FUTBOL`
- `SELECCION`
- `PERSONA`
- `VINCULACION_SELECCION`

## Arbitraje

Cubierto mediante:

- `PERSONA`
- `ASIGNACION_ARBITRAL`
- `PARTIDO`

## Estadísticas de Juego

Cubiertas mediante:

- `PERSONA`
- `PARTIDO`
- `EVENTO_PARTIDO`

## Logística, Público, Medios e Incidencias

Cubierto mediante:

- `ENTRADA`
- `ACREDITACION_PRENSA`
- `EVENTO_PARTIDO`
- `AUDITORIA_EVENTO`

---

# 9. Conclusión

El modelo lógico ampliado propuesto está compuesto por 16 tablas y extiende el modelo inicial de la Entrega 1 para representar de forma más completa las necesidades operativas y deportivas de una Copa Mundial.

La estructura permite gestionar múltiples ediciones, países sede, ciudades, estadios, fases, grupos, selecciones, partidos, jugadores, cuerpo técnico, árbitros, eventos deportivos, incidencias, boletería, acreditaciones y auditoría.

Las relaciones muchos-a-muchos se resuelven mediante entidades asociativas y se evita almacenar información redundante cuando esta puede obtenerse mediante relaciones existentes.

Este modelo constituye la base para la construcción posterior del diagrama lógico, el diccionario de datos ampliado y la implementación física de las tablas durante las siguientes etapas de la Entrega 2.