# documentacion_programacion_bd
## Funciones
## Procedimientos
## Triggers

## 1. Triggers de Auditoría

> **Dependencia:** Todos los triggers de auditoría utilizan la secuencia `seq_auditoria` (`START WITH 1 INCREMENT BY 1`) para generar la llave primaria `id_auditoria` en la tabla `AUDITORIA`.

### 1.1. `trg_auditar_partido`
* **Tabla asociada:** `PARTIDO`
* **Evento y Momento:** `AFTER INSERT OR DELETE OR UPDATE` (`FOR EACH ROW`)
* **Propósito:** Mantener la trazabilidad histórica en la tabla `AUDITORIA` sobre cualquier creación, modificación o eliminación de partidos en el sistema.
* **Parámetros / Entradas (`:NEW` y `:OLD`):**
  * `id_partido`, `id_etapa`, `id_estadio`, `id_partido_origen_1`, `id_partido_origen_2`, `fecha_hora`, `asistencia_registrada`, `estado`, `resultado_origen_1`, `resultado_origen_2`.
* **Comportamiento esperado:**
  * En **`INSERT`**: Concatena los valores entrantes (`:NEW`) en `valor_nuevo`, asigna `NULL` a `valor_anterior` y registra la operación `'INSERT'`.
  * En **`UPDATE`**: Concatena el estado previo (`:OLD`) en `valor_anterior` y el estado actualizado (`:NEW`) en `valor_nuevo`, registrando la operación `'UPDATE'`.
  * En **`DELETE`**: Concatena los datos eliminados (`:OLD`) en `valor_anterior`, asigna `NULL` a `valor_nuevo` y registra la operación `'DELETE'`.
  * Inserta automáticamente una fila en `AUDITORIA` con el usuario actual (`USER`) y la marca de tiempo (`SYSTIMESTAMP`).

### 1.2. `trg_auditar_participacion`
* **Tabla asociada:** `PARTICIPACION_PARTIDO`
* **Evento y Momento:** `AFTER INSERT OR UPDATE OR DELETE` (`FOR EACH ROW`)
* **Propósito:** Auditar todos los cambios realizados sobre la participación de las selecciones en los partidos y sus marcadores oficiales.
* **Parámetros / Entradas (`:NEW` y `:OLD`):**
  * `id_participacion_partido`, `id_partido`, `id_seleccion`, `condicion`, `goles`, `goles_penales`, `resultado`.
* **Comportamiento esperado:**
  * Evalúa la acción ejecutada (`INSERTING`, `UPDATING`, `DELETING`), construye las cadenas de texto descriptivas para `valor_anterior` y/o `valor_nuevo` con todos los campos de la fila y registra el movimiento en `AUDITORIA` bajo la tabla afectada `'PARTICIPACION_PARTIDO'`.

### 1.3. `trg_auditar_evento`
* **Tabla asociada:** `EVENTO_PARTIDO`
* **Evento y Momento:** `AFTER INSERT OR UPDATE OR DELETE` (`FOR EACH ROW`)
* **Propósito:** Registrar en la bitácora de auditoría cada vez que se añade, modifica o elimina una incidencia o estadística individual (goles, asistencias, tarjetas, sustituciones, minutos jugados) en un partido.
* **Parámetros / Entradas (`:NEW` y `:OLD`):**
  * `id_evento`, `id_partido`, `id_persona`, `id_persona_relacionada`, `tipo_evento`, `minuto`, `valor_numerico`, `descripcion`.
* **Comportamiento esperado:**
  * Captura los valores previos (`:OLD`) y nuevos (`:NEW`) según el tipo de operación DML y almacena el registro detallado en la tabla `AUDITORIA` indicando `'EVENTO_PARTIDO'` como tabla afectada.

---

## 2. Triggers de Validación de Rangos

### 2.1. `trg_valida_eventos_positivos`
* **Tabla asociada:** `EVENTO_PARTIDO`
* **Evento y Momento:** `BEFORE INSERT OR UPDATE` (`FOR EACH ROW`)
* **Propósito:** Impedir el registro de estadísticas individuales con valores numéricos negativos o minutos de juego inválidos.
* **Parámetros / Entradas (`:NEW`):**
  * `:NEW.tipo_evento`, `:NEW.valor_numerico`, `:NEW.minuto`.
* **Comportamiento esperado:**
  * Si `tipo_evento` es `'GOL'`, `'ASISTENCIA'` o `'MINUTOS_JUGADOS'` y `:NEW.valor_numerico < 0`, aborta la operación y lanza la excepción `ORA-20001: Error: El valor para goles o asistencias no puede ser negativo.`
  * Si `:NEW.minuto < 0`, aborta la operación y lanza la excepción `ORA-20002: Error: El minuto del evento no puede ser negativo.`

### 2.2. `trg_valida_asistencia_estadio`
* **Tabla asociada:** `PARTIDO`
* **Evento y Momento:** `BEFORE INSERT OR UPDATE` (`FOR EACH ROW`)
* **Propósito:** Garantizar que la asistencia de público registrada en un partido sea siempre un número mayor o igual a cero.
* **Parámetros / Entradas (`:NEW`):**
  * `:NEW.asistencia_registrada`.
* **Comportamiento esperado:**
  * Si `:NEW.asistencia_registrada < 0`, detiene el `INSERT` o `UPDATE` y arroja el error `ORA-20001: Error: La asistencia de público no puede ser negativa.`

---

## 3. Trigger de Anti-duplicidad

### 3.1. `trg_anti_duplicidad_participacion`
* **Tabla asociada:** `PARTICIPACION_PARTIDO`
* **Evento y Momento:** `BEFORE INSERT OR UPDATE` (`FOR EACH ROW`)
* **Propósito:** Prevenir que una misma selección sea inscrita dos veces en el mismo encuentro o que dos selecciones ocupen la misma condición (`LOCAL` o `VISITANTE`) en un partido.
* **Parámetros / Entradas (`:NEW`):**
  * `:NEW.id_participacion_partido`, `:NEW.id_partido`, `:NEW.id_seleccion`, `:NEW.condicion`.
* **Comportamiento esperado:**
  * Consulta `PARTICIPACION_PARTIDO` excluyendo el propio registro (`id_participacion_partido != NVL(:NEW.id_participacion_partido, -1)`).
  * Si la selección ya participa en ese partido (`v_conteo > 0`), lanza el error `ORA-20003: No duplicados: La selección ya se encuentra registrada participando en este partido.`
  * Si ya existe un equipo con la misma condición (`LOCAL` o `VISITANTE`) en ese partido, lanza el error `ORA-20004: No duplicados: Ya existe un equipo con la condición [CONDICION] en este partido.`

---

## 4. Trigger de Consistencia

### 4.1. `trg_verifica_consistencia`
* **Tabla asociada:** `PARTICIPACION_PARTIDO`
* **Evento y Momento:** `BEFORE INSERT OR UPDATE OF goles` (`FOR EACH ROW`)
* **Propósito:** Asegurar que el marcador oficial (`goles`) asignado a una selección en un partido coincida exactamente con el conteo de eventos individuales de tipo `'GOL'` registrados en `EVENTO_PARTIDO` para los jugadores de dicha selección.
* **Parámetros / Entradas (`:NEW`):**
  * `:NEW.id_partido`, `:NEW.id_seleccion`, `:NEW.goles`.
* **Comportamiento esperado:**
  * Realiza un `COUNT(*)` sobre `EVENTO_PARTIDO` cruzando con `VINCULACION_SELECCION`, `ETAPA_COMPETENCIA` y `PARTIDO` para contar los goles individuales anotados por jugadores de `:NEW.id_seleccion` en `:NEW.id_partido`.
  * Si `:NEW.goles` es diferente de `v_goles_individuales`, rechaza el cambio y lanza el error `ORA-20004: Inconsistencia: Los goles del marcador oficial (X) no coinciden con la suma de goles individuales (Y).`

---

# Funciones
## 1. `fn_diferencia_gol`

### Propósito
Calcular automáticamente la diferencia de gol de una selección: goles a favor menos goles en contra, considerando todos sus partidos finalizados.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Identificador de la selección (`seleccion.id_seleccion`). |

**Retorno:** `NUMBER`. Diferencia de gol (puede ser negativa).

### Comportamiento esperado

- Para cada partido de la selección busca la fila rival en `participacion_partido` (mismo `id_partido`, distinta selección) y suma `goles propios - goles del rival`.
- Solo cuenta partidos con `estado = 'FINALIZADO'`.
- Si la selección existe pero no ha jugado, devuelve `0`.
- Si la selección no existe, lanza el error `ORA-20001` 'La selección no existe'.

---

## 2. `fn_ranking_goleadores`

### Propósito
Obtener el ranking de máximos goleadores de una edición del mundial, ordenado de mayor a menor número de goles, devuelto como un texto con una línea por goleador.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_edicion` | `NUMBER` | Sí | Edición a consultar (`edicion_mundial.id_edicion`). |
| `p_top` | `NUMBER` | No (default `3`) | Cantidad de goleadores a devolver. |

Retorno: VARCHAR2. Texto con el ranking, una línea por goleador, con el formato posición. nombre (PAÍS) - N goles.

### Comportamiento esperado

- Cuenta los eventos 'GOL' de evento_partido en los partidos de las etapas de esa edición.
- Asocia cada jugador a la selección con la que participó en esa edición (la selección cuya id_etapa_grupo pertenece a la edición), para no mezclar goles de otras ediciones.
- Ordenamo por goles de forma descendente (desempata por nombre) y tomamos solo las primeras p_top filas con ROWNUM.
- Recorre esas filas con un cursor implicito en un FOR ... LOOP y vamos armando el texto.
- Si la edición existe pero no hay goles, se devuelve 'Sin goles registrados'.
- Si la edición no existe, se lanza ORA-20002. Si p_top es nulo o menor que 1, lanza ORA-20003.
- El texto está limitado a 4000 caracteres.

---

## 3. `fn_validar_cupo_convocatoria`

### Propósito
Validación lógica del cupo máximo de convocatoria: verificar si a una selección todavía se le puede agregar un jugador sin superar el límite permitido.

### Parámetros / entradas

| Parámetro | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `p_id_seleccion` | `NUMBER` | Sí | Selección a validar. |
| `p_cupo_maximo` | `NUMBER` | No (default `26`) | Máximo de jugadores permitidos en la convocatoria. |

**Retorno:** `NUMBER`. `1` si aún hay cupo para agregar un jugador, `0` si la convocatoria ya está completa. Se usa `NUMBER` y no `BOOLEAN` para poder llamarla también desde SQL.

### Comportamiento esperado

- Cuenta en `vinculacion_seleccion` los registros de esa selección con `rol = 'JUGADOR'`. Cuerpo técnico y otros roles no consumen cupo.
- Devuelve `1` si `convocados < p_cupo_maximo` y `0` en caso contrario.
- Si la selección no existe, lanza `ORA-20004`. Si `p_cupo_maximo` es nulo o menor que 1, lanzamos `ORA-20005`.
- Pensada para llamarse antes de insertar en `vinculacion_seleccion` o desde un trigger `BEFORE INSERT` de esa tabla.

# Procedimientos
## 1. `p_carga_masiva_resultados` 

### Propósito 
Cargar de forma masiva y controlada los resultados de los partidos: aplicar los goles y el resultado (`GANO`, `EMPATO`, `PERDIO`) a cada selección en `participacion_partido` y marcar el partido como `FINALIZADO`.

### Entradas

El Procedimiento carga en bloque (forma masiva) los resultados de partidos desde una **tabla de paso**, validando cada fila, registrando o no los errores y confirmando los cambios por lotes según lo indicado. Cada fila de la tabla de paso representan el resultado de un partido, con los goles de ambos equipos. El procedimiento lee de esta tabla de paso cuyas filas tengan estado_carga = 'PENDIENTE'.

La tabla de paso se llama `carga_resultados` y se compone de:
| Columna	| Descripción |
| --- | --- |
| id_carga	| Identificador de la fila de carga. | 
| id_partido |	Partido al que se le cargará el resultado (partido.id_partido). |
| goles_local, goles_visitante |	Goles de cada equipo en el tiempo de juego. |
| penales_local, penales_visitante | Goles en la tanda de penales (0 si no hubo). |
| estado_carga | 'PENDIENTE' (por procesar), 'CARGADO' (aplicado) o 'ERROR' (rechazado). |
| mensaje_error	| Motivo del rechazo cuando estado_carga = 'ERROR'. |

### Parametros

| Parámetro | Modo | Tipo | Obligatorio | Descripción |
|---|---|---|---|---|
| `p_commit_cada` | IN | `NUMBER` | No (default 100) | Lotes de confirmación. Cada cuántas filas cargadas con éxito se hace COMMIT.|
| `p_detener_en_error` | IN | `NUMBER` | No (default 0) | 0 = continúa y registra los errores; 1 = se detiene en el primer error. |
| `p_procesados`| OUT | `NUMBER` | - | Total de filas pendientes que se intentaron procesar. |
| `p_cargados`| OUT | `NUMBER` | - | Filas aplicadas con éxito. |
| `p_errores`| OUT | `NUMBER` | - | Filas rechazadas. |

### Comportamiento esperado

1. Primero se validan los parámetros: p_commit_cada debe ser mayor o igual a 1 (ORA-20010) y p_detener_en_error debe ser 0 o 1 (ORA-20016).
2. Se recorre las filas PENDIENTE de carga_resultados en orden de id_carga.
3. Para cada fila creamos un punto de control (SAVEPOINT) y se valida:
- El partido existe (ORA-20011).
- El partido no está ya FINALIZADO, para no sobrescribir un resultado (ORA-20012).
- Los goles de ambos equipos no son nulos ni negativos (ORA-20013).
- Los penales no son negativos, y solo pueden ser mayores que 0 si los goles quedaron empatados (ORA-20014).
- El partido tiene exactamente una participación LOCAL y una VISITANTE (ORA-20015).
4. Si todo es válido
- Se determina el resultado de cada equipo: gana quien tiene más goles; si hay empate en goles, gana quien tiene más penales; si también hay empate en penales, ambos quedan en EMPATO.
- Actualiza goles, goles_penales y resultado en las dos filas de participacion_partido.
- Cambia partido.estado a 'FINALIZADO'.
- Marca la fila de carga como CARGADO.
5. Si algo falla en una fila, deshace solo los cambios de esa fila (ROLLBACK TO SAVEPOINT), la marca como ERROR con el mensaje y sigue con la siguiente. Con p_detener_en_error = 1 termina el proceso en el primer error.
6. Hace COMMIT cada p_commit_cada filas cargadas y uno final al terminar, de modo que un error no pierda el trabajo ya confirmado.
7. Devuelve por los parámetros OUT el total de procesados, cargados y con error.
8. Es repetible: solo toma filas PENDIENTE, así que puede ejecutarse varias veces sin duplicar cargas. Para reintentar una fila rechazada, se corrige y se vuelve a poner en 'PENDIENTE'.

