# Evaluación Crítica del Modelo Inicial

## 1. Introducción

El modelo genérico inicial utilizado durante la Entrega 1 permitió representar los elementos fundamentales de una Copa Mundial mediante las entidades `EDICION_MUNDIAL`, `ESTADIO`, `SELECCION`, `PARTIDO` y `PARTICIPACION_PARTIDO`.

Este modelo resultó suficiente para desarrollar consultas, vistas, operaciones DML, restricciones de integridad y pruebas de privilegios sobre una estructura reducida. Sin embargo, su alcance es limitado frente a las necesidades de un sistema integral para la gestión de una Copa Mundial.

A partir del análisis realizado durante la Entrega 1 y de las reglas de negocio planteadas en el enunciado, se identifican varias limitaciones que deberán ser abordadas en la construcción del modelo ampliado de la Entrega 2.

---

## 2. Problemas identificados y mejoras propuestas

### 2.1. Confederación almacenada como atributo de texto

**Problema identificado:**  
En el modelo inicial, la confederación se almacena directamente como un atributo de `SELECCION`. Esto genera dependencia de valores escritos manualmente y puede producir inconsistencias en los nombres o abreviaturas utilizadas.

**Mejora propuesta:**  
Crear una entidad independiente `CONFEDERACION` y relacionarla con las selecciones o federaciones nacionales mediante una clave foránea.

**Justificación:**  
Esta modificación mejora la normalización, reduce duplicidad de información y garantiza que las selecciones se relacionen únicamente con confederaciones previamente registradas.

---

### 2.2. Ausencia de federaciones nacionales

**Problema identificado:**  
El modelo actual relaciona directamente una selección con una confederación, pero no representa la federación nacional correspondiente.

**Mejora propuesta:**  
Incorporar la entidad `FEDERACION_NACIONAL` entre `SELECCION` y `CONFEDERACION`.

**Justificación:**  
Esto permite representar con mayor precisión la estructura organizativa del fútbol internacional y evita mantener información institucional directamente dentro de la selección.

---

### 2.3. Fase almacenada como atributo de texto

**Problema identificado:**  
En `PARTIDO`, la fase se almacena como un atributo textual. Esto dificulta representar adecuadamente las distintas etapas del torneo y controlar los valores permitidos.

**Mejora propuesta:**  
Crear una entidad `FASE`, relacionada con `EDICION_MUNDIAL` y `PARTIDO`.

**Justificación:**  
Esto permite controlar las fases disponibles para una edición, evitar valores inconsistentes y realizar análisis de partidos por fase de manera más estructurada.

---

### 2.4. Falta de una entidad para grupos

**Problema identificado:**  
El modelo inicial no representa formalmente los grupos de la primera fase del Mundial. En algunos ajustes de la Entrega 1 se incorporó `grupo` como atributo de `SELECCION`, pero esta solución sigue siendo limitada.

**Mejora propuesta:**  
Crear la entidad `GRUPO`, vinculada a una edición y a las selecciones participantes.

**Justificación:**  
Esto permite modelar correctamente la fase de grupos y facilita posteriormente la generación de tablas de posiciones, clasificación y avance entre fases.

---

### 2.5. Ausencia de jugadores y convocatorias

**Problema identificado:**  
El modelo inicial únicamente representa selecciones, pero no permite conocer qué jugadores fueron convocados en una edición determinada.

**Mejora propuesta:**  
Incorporar las entidades `JUGADOR` y `CONVOCATORIA`, junto con una entidad asociativa como `CONVOCATORIA_JUGADOR`.

**Justificación:**  
Esto permite mantener el historial de jugadores, registrar diferentes convocatorias por edición, asignar dorsales y distinguir qué jugadores participaron en cada Mundial.

---

### 2.6. Falta de representación del cuerpo técnico

**Problema identificado:**  
El modelo actual no permite registrar entrenadores, asistentes u otros miembros del cuerpo técnico de cada selección.

**Mejora propuesta:**  
Incorporar una entidad `CUERPO_TECNICO` o una estructura equivalente relacionada con `SELECCION` y la edición correspondiente.

**Justificación:**  
Esto amplía la representación de los actores involucrados en la participación de una selección y permite mantener información diferenciada del personal técnico.

---

### 2.7. Ausencia de información arbitral

**Problema identificado:**  
No existe una forma de registrar los árbitros que participan en cada partido ni el rol que desempeñan.

**Mejora propuesta:**  
Crear las entidades `ARBITRO` y `ASIGNACION_ARBITRAL`.

**Justificación:**  
La relación entre árbitros y partidos es muchos-a-muchos, ya que un partido puede tener varios árbitros y un árbitro puede participar en distintos partidos. La entidad `ASIGNACION_ARBITRAL` permitiría registrar además el rol específico de cada árbitro en cada encuentro.

---

### 2.8. Falta de estadísticas individuales

**Problema identificado:**  
El modelo inicial solo permite registrar los goles de una selección mediante `PARTICIPACION_PARTIDO`, pero no identifica qué jugador anotó ni otras estadísticas individuales.

**Mejora propuesta:**  
Crear una entidad `ESTADISTICA_JUGADOR_PARTIDO`.

**Justificación:**  
Esto permitiría registrar goles, asistencias, tarjetas, minutos jugados y otras métricas por jugador y partido, posibilitando consultas de goleadores, asistidores y disciplina.

---

### 2.9. Falta de sustituciones

**Problema identificado:**  
No existe una estructura para registrar cambios de jugadores durante un partido.

**Mejora propuesta:**  
Agregar una entidad `SUSTITUCION`.

**Justificación:**  
Esto permitiría registrar el jugador que entra, el jugador que sale y el minuto del cambio, enriqueciendo el seguimiento del desarrollo de cada partido.

---

### 2.10. Limitaciones en sedes y organización geográfica

**Problema identificado:**  
En el modelo inicial, `pais_sede` y `ciudad` son atributos de texto. Esto limita la representación de ediciones con múltiples países anfitriones y varias ciudades.

**Mejora propuesta:**  
Incorporar entidades como `SEDE` y `CIUDAD`, relacionadas con `EDICION_MUNDIAL` y `ESTADIO`.

**Justificación:**  
Esto permite representar de forma más adecuada la organización geográfica del torneo y facilita consultas agregadas por país o ciudad sede.

---

### 2.11. Falta de incidencias de partido

**Problema identificado:**  
El modelo no permite registrar eventos extraordinarios ocurridos durante los partidos, como problemas climáticos, suspensiones o incidentes operativos.

**Mejora propuesta:**  
Agregar una entidad `INCIDENCIA`.

**Justificación:**  
Esto permite registrar y analizar eventos irregulares asociados a partidos, estadios o fases del torneo.

---

### 2.12. Falta de auditoría y trazabilidad

**Problema identificado:**  
El modelo inicial no permite conocer quién modificó información crítica ni cuándo ocurrió el cambio.

**Mejora propuesta:**  
Agregar una entidad `AUDITORIA_EVENTO`.

**Justificación:**  
Esto permitiría registrar operaciones realizadas sobre información crítica del torneo y mejorar la trazabilidad de los cambios.

---

## 3. Nuevas entidades previstas

A partir de los problemas identificados, se anticipa la necesidad de incorporar las siguientes entidades en el modelo ampliado:

- `CONFEDERACION`
- `FEDERACION_NACIONAL`
- `FASE`
- `GRUPO`
- `JUGADOR`
- `CONVOCATORIA`
- `CONVOCATORIA_JUGADOR`
- `CUERPO_TECNICO`
- `ARBITRO`
- `ASIGNACION_ARBITRAL`
- `ESTADISTICA_JUGADOR_PARTIDO`
- `SUSTITUCION`
- `SEDE`
- `CIUDAD`
- `INCIDENCIA`
- `AUDITORIA_EVENTO`

Este listado representa una propuesta conceptual inicial y podrá ser ajustado durante la construcción del modelo lógico ampliado de la Entrega 2.

---

## 4. Boceto conceptual del modelo ampliado

El modelo ampliado propuesto busca conservar las entidades principales del modelo inicial y complementarlas con nuevas estructuras que permitan representar de forma más completa la organización, competencia deportiva, jugadores, arbitraje, estadísticas y operación del torneo.

El boceto conceptual del modelo ampliado se encuentra en:

`docs/entrega1/boceto_modelo_ampliado.png`

Este diagrama representa únicamente las principales entidades y relaciones previstas. No incluye todavía el detalle de atributos, tipos de dato ni restricciones, ya que estos elementos serán definidos durante la Entrega 2.

---

## 5. Conclusión

El modelo inicial permitió representar correctamente una versión simplificada del dominio y resultó suficiente para trabajar los conceptos fundamentales de SQL, integridad, vistas, DML y privilegios durante la Entrega 1.

Sin embargo, para representar de manera más completa el funcionamiento de una Copa Mundial, es necesario ampliar el modelo incorporando estructuras específicas para organización del torneo, grupos y fases, jugadores y convocatorias, arbitraje, estadísticas e incidencias.

Las mejoras propuestas buscan reducir atributos de texto libre, aumentar la normalización, representar nuevas relaciones del dominio y preparar la base de datos para consultas y procesos más complejos durante la Entrega 2.