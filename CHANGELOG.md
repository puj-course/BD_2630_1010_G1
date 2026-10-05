## Semana 6 (28 septiembre - 4 octubre)

### Objetivos de la semana

- Crear el documento y diagrama del modelo físico ampliado.
- Crear el DDL correspondiente al nuevo modelo.
- Definir PK, FK, restricciones CHECK y UNIQUE e índices.
- Crear un conjunto de datos de prueba coherente para todas las entidades del modelo ampliado.
- Verificar la correcta ejecución del DDL y de la carga de datos.

### Tareas realizadas

| Tarea | Responsable(s) | Rama utilizada | Descripción |
|------|------|------|------|
| Set de datos de prueba | Camilo Aguilar — Persona 3 (`kmilo1147-glitch`) | `develop/semana2_ddl_modelo_ampliado` | Se creó `carga_datos_prueba.sql` con datos coherentes para las 16 tablas del modelo ampliado. |
| Documento y diagrama del modelo físico ampliado | Jerónimo Lievano — Persona 1 (`jlievanob-ops`) y Sara Daiana Barreto — Persona 2 (`Daiana-07`) | `develop/semana2_ddl_modelo_ampliado` | Se elaboró la documentación y el diagrama correspondiente al modelo físico ampliado. |
| Creación del DDL del nuevo modelo | Jerónimo Lievano — Persona 1 (`jlievanob-ops`) y Sara Daiana Barreto — Persona 2 (`Daiana-07`) | `develop/semana2_ddl_modelo_ampliado` | Se implementaron las 16 tablas junto con PK, FK, restricciones CHECK y UNIQUE, índices y políticas ON DELETE. |
| Revisión y pruebas del DDL | Camilo Aguilar — Persona 3 (`kmilo1147-glitch`) | `develop/semana2_ddl_modelo_ampliado` | Se revisó la compatibilidad del DDL con Oracle y se realizaron los ajustes necesarios antes de ejecutar la carga de datos. |

### Cambios principales

- Se elaboró el documento y el diagrama del modelo físico ampliado.
- Se implementó el DDL correspondiente a las 16 tablas del nuevo modelo.
- Se definieron claves primarias, claves foráneas, restricciones `CHECK`, `UNIQUE` e índices.
- Se corrigió la implementación de las relaciones con comportamiento `RESTRICT`, debido a que Oracle lo aplica por defecto cuando una clave foránea no contiene `ON DELETE CASCADE` ni `ON DELETE SET NULL`.
- Se corrigió la restricción de `PARTICIPACION_PARTIDO` a `UNIQUE (id_partido, condicion)` para garantizar un único local y visitante por partido.
- Se corrigió el tipo de dato de `ENTRADA.precio` de `NUMBER(2,10)` a `NUMBER(10,2)`.
- Se creó el archivo `carga_datos_prueba.sql`.
- Se insertaron 93 registros distribuidos entre las 16 tablas del modelo.
- Se verificó correctamente la integridad de los datos y las relaciones entre partidos y selecciones.

### Problemas encontrados

- Oracle no admite la sintaxis explícita `ON DELETE RESTRICT`. Se corrigió el DDL eliminando dicha cláusula, manteniendo el mismo comportamiento restrictivo mediante la clave foránea.
- Se detectó que la restricción `UNIQUE (condicion, id_seleccion)` impedía que una selección pudiera volver a participar con la misma condición en otros partidos. Se cambió por `UNIQUE (id_partido, condicion)`.
- Se detectó que `NUMBER(2,10)` no era adecuado para almacenar el precio de las entradas, por lo que se cambió a `NUMBER(10,2)`.
- Después de realizar los ajustes, el DDL y la carga de datos de prueba se ejecutaron correctamente sin errores.