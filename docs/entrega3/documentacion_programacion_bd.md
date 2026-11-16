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
- Ordena por goles de forma descendente (desempata por nombre) y toma solo las primeras p_top filas con ROWNUM.
- Recorre esas filas con un FOR ... LOOP y va armando el texto.
- Si la edición existe pero no hay goles, devuelve 'Sin goles registrados'.
- Si la edición no existe, lanza ORA-20002. Si p_top es nulo o menor que 1, lanza ORA-20003.
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
- Si la selección no existe, lanza `ORA-20004`. Si `p_cupo_maximo` es nulo o menor que 1, lanza `ORA-20005`.
- Pensada para llamarse antes de insertar en `vinculacion_seleccion` o desde un trigger `BEFORE INSERT` de esa tabla.

# Procedimientos
