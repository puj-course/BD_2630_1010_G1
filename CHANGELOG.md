# CHANGELOG


## Equipo del Proyecto
| Nombre        | GitHub / Perfil |
|--------------|-----------------|
| Estudiante 1 | github.com/Daiana-07        |
| Estudiante 2 | github.com/jlievanob-ops    |
| Estudiante 3 | github.com/kmilo1147-glitch |

---

## Semana 1 (24–30 agosto)

### Objetivos de la semana

- Hacer Documento técnico. 
- Hacer consultas 1, 2, 3, 4, 5, 6, 9, 12 y 13

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Archivo(s) |
|------|------|------|------|
|Hacer documento técnico | Camilo Aguilar | feature/documento-tecnico|documento_tecnico.md |
|Consultas 1 y 3 | Camilo Aguilar | feature/semana2_agregaciones | semana2_agregaciones.sql|
|Consultas 2, 4 y 6 | Jerónimo Lievano | release/semana1_joins | semana1_joins.sql |
|Diagrama ER | Jerónimo Lievano | feature/modelo_er_inicial | modelo_er_inicial.png |
|Consultas 5, 9, 12, 13 | Sara Barreto  | feature/semana2_agregaciones | semana2__agregaciones.sql|
|Actualización Changelog | Sara Barreto | feature/actualizar_changelog | CHANGELOG.md |


### Cambios principales
- Se reconoció visualmente las relaciones y las tablas por el ERD
- Se hicieron y definieron 9 consultas 

### Problemas encontrados
--

---

## Semana 2 (24–30 agosto)

### Objetivos de la semana

(Describan qué querían lograr esta semana)

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
| Consultas 7, 8, 10, 11 | Jerónimo Lievano | release/semana3_subconsultas | semana3_subconsultas.sql|
| Creacion de vistas |Camilo Aguilar & Sara Barreto|feature/vistas | vistas.sql|
| Consulta 15| Sara Barreto| release/semana3_subconsultas | semana3_subconsultas|
|Actualización Changelog | Sara Barreto | feature/actualizar_changelog | CHANGELOG.md |

### Cambios principales
- Creacion de vistas 
- Continuación de consultas

### Problemas encontrados
- No se tuvo los permisos suficientes para crear las vistas así que hizo el código de creación pero no se pudieron crear realmente. 
- Dado el problema anterior, la consulta 15 fue hecha suponiendo que la vista 'V_OCUPACION_POR_ESTADIO' funcionaba correctamente. 

---

## Semana 3 (6–12 abril)

### Objetivos de la semana

- Implementar el DDL del modelo inicial con tablas, claves primarias, claves foráneas, restricciones e índices.
- Actualizar las pruebas DML con operaciones inválidas y validaciones de comportamiento `ON DELETE`.
- Implementar la Consulta 14 para verificar la integridad de las participaciones.
- Configurar y documentar privilegios para usuarios de consulta y operativo.
- Actualizar la evidencia de pruebas y el registro de cambios de la semana.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
| Punto 1 — `sql/entrega1/ddl/ddl_modelo_inicial.sql` | IS101000 — Sara Barreto | [Agregar rama utilizada] | Definición de tablas, PK y FK con `ON DELETE` / `ON UPDATE` explícito y justificado; implementación de restricciones `CHECK` y `UNIQUE`; creación de índices estratégicos con su respectiva justificación. |
| Punto 4.1 — Creación de usuarios/roles | IS101000 — Sara Barreto | [Agregar rama utilizada] | Creación de al menos dos usuarios/roles: uno de solo consulta y otro operativo. |
| Punto 4.2 — `GRANT` / `REVOKE` | IS101000 — Sara Barreto | [Agregar rama utilizada] | Implementación de las sentencias `GRANT` y `REVOKE` correspondientes para controlar los privilegios asignados a los usuarios/roles. |
| Punto 3 — `sql/entrega1/consultas/semana4_verificacion_integridad.sql` | IS101001 — Camilo Aguilar | `feature/consulta-14-integridad` | Implementación de la Consulta 14 para identificar participaciones duplicadas de una selección en un mismo partido y verificar la restricción anti-duplicidad. |
| Punto 4.3 — `tests/entrega1/pruebas_privilegios.md` | IS101001 — Camilo Aguilar | `feature/pruebas-privilegios` | Documentación de las pruebas de privilegios realizadas sobre los usuarios de consulta y operativo, incluyendo operaciones permitidas, operaciones rechazadas y resultados obtenidos. |
| Punto 5 — `CHANGELOG.md` | IS101001 — Camilo Aguilar | [Agregar rama utilizada] | Actualización del `CHANGELOG.md` con los objetivos, tareas realizadas, responsables, ramas utilizadas y problemas encontrados durante la Semana 3. |
| Punto 2 — `sql/entrega1/dml/dml_ciclo_vida_partido.sql` | IS101008 — Jerónimo Lievano | [Agregar rama utilizada] | Implementación de al menos tres intentos de operación inválida y demostración del comportamiento `ON DELETE` en al menos dos relaciones distintas. |
| Punto 2 — `tests/entrega1/pruebas_dml.md` | IS101008 — Jerónimo Lievano | [Agregar rama utilizada] | Documentación de cada caso inválido y de cada prueba de borrado, describiendo la operación ejecutada y el resultado obtenido. |

### Cambios principales

- Se completó la definición inicial del modelo mediante DDL.
- Se agregaron restricciones de integridad e índices estratégicos.
- Se incorporaron pruebas DML para validar operaciones inválidas y relaciones con `ON DELETE`.
- Se agregó la Consulta 14 de verificación de integridad.
- Se documentaron los privilegios de los usuarios de consulta y operativo.
- Se actualizaron las evidencias de pruebas correspondientes a la semana.

### Problemas encontrados

- El usuario de consulta `IS101000` recibió correctamente privilegios de solo lectura. Las operaciones `INSERT`, `UPDATE` y `DELETE` fueron rechazadas con el error `ORA-01031: privilegios insuficientes`, tal como se esperaba.
- Durante las pruebas del usuario operativo `IS101008` fue necesario verificar los privilegios antes y después de su asignación para comprobar el comportamiento esperado.
- Se revisó la configuración de permisos para asegurar que cada usuario pudiera realizar únicamente las operaciones correspondientes a su nivel de acceso.

---
## Semana 4 (13–22 abril)

### Objetivos de la semana

(Describan qué querían lograr esta semana)

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
| | | | |
| | | | |
| | | | |

### Cambios principales


### Problemas encontrados
