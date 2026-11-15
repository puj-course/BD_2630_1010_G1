# Tests (Casos de Prueba SQL)

A continuación se presentan las sentencias SQL para comprobar el funcionamiento de los triggers sobre los datos cargados en la base de datos:

---

## 1. Tests para Validación de Rangos (Eventos y Asistencia de Estadio)

### Test 1.1: Intentar insertar un gol con `valor_numerico` negativo
* **Trigger evaluado:** `trg_valida_eventos_positivos`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20001`[cite: 31].

**Sentencia SQL:**
```sql
INSERT INTO EVENTO_PARTIDO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES (901, 1, 1, NULL, 'GOL', 45, -1, 'Prueba gol negativo');
```

**Error obtenido en SQL:**
```text
Error starting at line : 6 in command -
INSERT INTO EVENTO_PARTIDO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES (901, 1, 1, NULL, 'GOL', 45, -1, 'Prueba gol negativo')
Error at Command Line : 6 Column : 13
Error report -
SQL Error: ORA-20001: Error: El valor para goles o asistencias no puede ser negativo.
ORA-06512: at "IS101001.TRG_VALIDA_EVENTOS_POSITIVOS", line 5
ORA-04088: error during execution of trigger 'IS101001.TRG_VALIDA_EVENTOS_POSITIVOS'

https://docs.oracle.com/error-help/db/ora-20001/

More Details :
https://docs.oracle.com/error-help/db/ora-20001/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/

```

---

### Test 1.2: Intentar insertar un evento con `minuto` negativo
* **Trigger evaluado:** `trg_valida_eventos_positivos`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20002`[cite: 31].

**Sentencia SQL:**
```sql
INSERT INTO EVENTO_PARTIDO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES (902, 1, 1, NULL, 'TARJETA_AMARILLA', -10, 1, 'Prueba minuto negativo');
```

**Error obtenido en SQL:**
```text
Error starting at line : 10 in command -
INSERT INTO EVENTO_PARTIDO (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES (902, 1, 1, NULL, 'TARJETA_AMARILLA', -10, 1, 'Prueba minuto negativo')
Error at Command Line : 10 Column : 13
Error report -
SQL Error: ORA-20002: Error: El minuto del evento no puede ser negativo.
ORA-06512: at "IS101001.TRG_VALIDA_EVENTOS_POSITIVOS", line 11
ORA-04088: error during execution of trigger 'IS101001.TRG_VALIDA_EVENTOS_POSITIVOS'

https://docs.oracle.com/error-help/db/ora-20002/

More Details :
https://docs.oracle.com/error-help/db/ora-20002/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/
```

---

### Test 1.3: Intentar insertar o actualizar un partido con asistencia negativa
* **Trigger evaluado:** `trg_valida_asistencia_estadio`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20001`[cite: 31].

**Sentencia SQL:**
```sql
UPDATE PARTIDO 
SET asistencia_registrada = -500 
WHERE id_partido = 1;
```

**Error obtenido en SQL:**
```text
Error starting at line : 14 in command -
UPDATE PARTIDO 
SET asistencia_registrada = -500 
WHERE id_partido = 1
Error at Command Line : 14 Column : 8
Error report -
SQL Error: ORA-04098: trigger 'IS101001.TRG_AUDITAR_PARTIDO' is invalid and failed re-validation

https://docs.oracle.com/error-help/db/ora-04098/04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

More Details :
https://docs.oracle.com/error-help/db/ora-04098/

```

---

## 2. Tests para No duplicidad en `PARTICIPACION_PARTIDO`

### Test 2.1: Intentar registrar nuevamente a Argentina (`id_seleccion = 1`) en el partido 1
* **Trigger evaluado:** `trg_anti_duplicidad_participacion`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20003`[cite: 31].

**Sentencia SQL:**
```sql
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (901, 1, 1, 'VISITANTE', 2, 0, 'GANO');
```

**Error obtenido en SQL:**
```text
Error starting at line : 24 in command -
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (901, 1, 1, 'VISITANTE', 2, 0, 'GANO')
Error at Command Line : 24 Column : 13
Error report -
SQL Error: ORA-20003: No duplicados: La selección ya se encuentra registrada participando en este partido.
ORA-06512: at "IS101001.TRG_ANTI_DUPLICIDAD_PARTICIPACION", line 13
ORA-04088: error during execution of trigger 'IS101001.TRG_ANTI_DUPLICIDAD_PARTICIPACION'

https://docs.oracle.com/error-help/db/ora-20003/

More Details :
https://docs.oracle.com/error-help/db/ora-20003/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/
```

---

### Test 2.2: Intentar registrar una selección distinta en el partido 1 con condición `'LOCAL'` ya ocupada
* **Trigger evaluado:** `trg_anti_duplicidad_participacion`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20004`[cite: 31].

**Sentencia SQL:**
```sql
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (902, 1, 3, 'LOCAL', 0, 0, 'EMPATO');
```

**Error obtenido en SQL:**
```text
Error starting at line : 28 in command -
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (902, 1, 3, 'LOCAL', 0, 0, 'EMPATO')
Error at Command Line : 28 Column : 13
Error report -
SQL Error: ORA-20004: No duplicados: Ya existe un equipo con la condición LOCAL en este partido.
ORA-06512: at "IS101001.TRG_ANTI_DUPLICIDAD_PARTICIPACION", line 25
ORA-04088: error during execution of trigger 'IS101001.TRG_ANTI_DUPLICIDAD_PARTICIPACION'

https://docs.oracle.com/error-help/db/ora-20004/

More Details :
https://docs.oracle.com/error-help/db/ora-20004/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/
```

---

## 3. Tests para Consistencia de Marcador (Marcador vs. Goles Individuales)

### Test 3.1: Actualizar goles oficiales de Argentina en el partido 1 a 5 (solo tiene 2 goles en `EVENTO_PARTIDO`)
* **Trigger evaluado:** `trg_verifica_consistencia`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20004`[cite: 31].

**Sentencia SQL:**
```sql
UPDATE PARTICIPACION_PARTIDO
SET goles = 5
WHERE id_partido = 1 AND id_seleccion = 1;
```

**Error obtenido en SQL:**
```text
Error starting at line : 37 in command -
UPDATE PARTICIPACION_PARTIDO
SET goles = 5
WHERE id_partido = 1 AND id_seleccion = 1
Error at Command Line : 37 Column : 8
Error report -
SQL Error: ORA-20004: Inconsistencia: Los goles del marcador oficial (5) no coinciden con la suma de goles individuales (2).
ORA-06512: at "IS101001.TRG_VERIFICA_CONSISTENCIA", line 17
ORA-04088: error during execution of trigger 'IS101001.TRG_VERIFICA_CONSISTENCIA'

https://docs.oracle.com/error-help/db/ora-20004/

More Details :
https://docs.oracle.com/error-help/db/ora-20004/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/
```

---

### Test 3.2: Insertar una participación en el partido 6 con 3 goles cuando no hay eventos de gol registrados
* **Trigger evaluado:** `trg_verifica_consistencia`[cite: 31]
* **Comportamiento esperado:** Debe fallar con `ORA-20004`[cite: 31].

**Sentencia SQL:**
```sql
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (903, 6, 1, 'LOCAL', 3, 0, 'GANO');
```

**Error obtenido en SQL:**
```text
Error starting at line : 42 in command -
INSERT INTO PARTICIPACION_PARTIDO (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES (903, 6, 1, 'LOCAL', 3, 0, 'GANO')
Error at Command Line : 42 Column : 13
Error report -
SQL Error: ORA-20004: Inconsistencia: Los goles del marcador oficial (3) no coinciden con la suma de goles individuales (0).
ORA-06512: at "IS101001.TRG_VERIFICA_CONSISTENCIA", line 17
ORA-04088: error during execution of trigger 'IS101001.TRG_VERIFICA_CONSISTENCIA'

https://docs.oracle.com/error-help/db/ora-20004/

More Details :
https://docs.oracle.com/error-help/db/ora-20004/
https://docs.oracle.com/error-help/db/ora-06512/
https://docs.oracle.com/error-help/db/ora-04088/
```

---

## 4. Tests para Triggers de Auditoría (Operaciones Válidas y Verificación)

### Test 4.1: Actualizar estado y asistencia válida en `PARTIDO`
* **Trigger evaluado:** `trg_auditar_partido`[cite: 31]

**Sentencia SQL:**
```sql
UPDATE PARTIDO 
SET asistencia_registrada = 72000, estado = 'FINALIZADO' 
WHERE id_partido = 2;
```

**Salida / Resultado obtenido en SQL:**
```text
Error starting at line : 51 in command -
UPDATE PARTIDO 
SET asistencia_registrada = 72000, estado = 'FINALIZADO' 
WHERE id_partido = 2
Error at Command Line : 51 Column : 8
Error report -
SQL Error: ORA-04098: trigger 'IS101001.TRG_AUDITAR_PARTIDO' is invalid and failed re-validation

https://docs.oracle.com/error-help/db/ora-04098/04098. 00000 -  "trigger '%s.%s' is invalid and failed re-validation"
*Cause:    A trigger was attempted to be retrieved for execution and was
           found to be invalid.  This also means that compilation/authorization
           failed for the trigger.
*Action:   Options are to resolve the compilation/authorization errors,
           disable the trigger, or drop the trigger.

More Details :
https://docs.oracle.com/error-help/db/ora-04098/
```

---

### Test 4.2: Insertar y eliminar un evento válido en `EVENTO_PARTIDO`
* **Trigger evaluado:** `trg_auditar_evento`[cite: 31]

**Sentencia SQL:**
```sql
INSERT INTO EVENTO_PARTIDO VALUES (905, 2, 5, NULL, 'TARJETA_AMARILLA', 20, 1, 'Falta táctica');
DELETE FROM EVENTO_PARTIDO WHERE id_evento = 905;
```

**Salida / Resultado obtenido en SQL:**
```text
0 rows deleted.


1 row inserted.


1 row deleted.
```

---

### Test 4.3: Insertar una participación válida (0 goles en partido sin goles)
* **Trigger evaluado:** `trg_auditar_participacion`[cite: 31]

**Sentencia SQL:**
```sql
INSERT INTO PARTICIPACION_PARTIDO VALUES (905, 6, 1, 'LOCAL', 0, 0, 'EMPATO');
```

**Salida / Resultado obtenido en SQL:**
```text
Error starting at line : 60 in command -
INSERT INTO PARTICIPACION_PARTIDO VALUES (905, 6, 1, 'LOCAL', 0, 0, 'EMPATO')
Error report -
ORA-00001: unique constraint (IS101001.PARTICIPACION_PARTIDO_PK) violated

https://docs.oracle.com/error-help/db/ora-00001/

More Details :
https://docs.oracle.com/error-help/db/ora-00001/
```

