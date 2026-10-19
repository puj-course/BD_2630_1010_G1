# Pruebas de Privilegios de Usuarios

En este documento se harán las pruebas de que efectivamnete los roles y sus respectivos privilegios funcionan correctamente.

## 1. Tabla de Usuarios y Roles

| Usuario | Rol Asignado | Permisos Esperados |
| :--- | :--- | :--- |
| `IS101001` | Administrador | Control total (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) |
| `IS101008` | Administrador del Torneo | `SELECT`, `INSERT`, `UPDATE` en todas las tablas menos en `AUDITORIA`, donde solo hay `SELECT` |
| `IS101008` | Analísta deportivo| `SELECT` sobre todas las tablas menos sobre `AUDITORIA`, donde no se tiene ningún privilegio |
| `IS101008` | Auditor | `SELECT` sobre todas las tablas|

Dado que solo somos 2 en el equipo, el admin total le fue otorgando y revocando los roles al otro integrante a medida de que se hicieron las pruebas. 

---

## 2. Evidencia de pruebas del Administrador del torneo

Las siguientes pruebas fueron realizadas sobre el usuario de consulta `IS101008`, con el objetivo de verificar que tenga permiso de seleccion, insercion y actualizacion sobre todas las tablas, menos dobre auditoria, sonde solo se le permite hacer select. Las tablas están nativamente en el usuario `IS101001`. 

### Prueba 1: Lectura autorizada

**Usuario:** `IS101008`  
**Acción:** Consultar información de la tabla `SELECCION`.

```sql
SELECT *
FROM IS101001.SELECCION;
```

**Resultado obtenido:**

La consulta se ejecutó correctamente y mostró los registros almacenados en la tabla.

**Estado:** APROBADO. El usuario puede realizar operaciones `SELECT` correctamente.

---

### Prueba 2: INSERT autorizado

**Usuario:** `IS101008`  
**Acción:** Intentar insertar un nuevo registro en la tabla `SELECCION`.

```sql
INSERT INTO IS101001.ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
VALUES (777, 'Liga de Prueba Test', 'FEDERACION_NACIONAL', 'Colombia', 1);

COMMIT;
```

**Resultado obtenido:**

```text
1 row inserted.
```

**Estado:** APROBADO. Oracle permitió la inserción. 

---

### Prueba 3: UPDATE autorizado

**Usuario:** `IS101008`  
**Acción:** Intentar modificar información de la tabla `ORGANIZACIONES_FUTBOL`.

```sql
UPDATE IS101001.ORGANIZACIONES_FUTBOL 
SET nombre = 'Liga Actualizada Test' 
WHERE id_organizacion = 777;
```

**Resultado obtenido:**

```text
1 row updated.
```

**Estado:** APROBADO. Oracle permitió actualizar la fila correctamnete en la tabla `ORGANIZACIONES_FUTBOL`.

---

### Prueba 4: DELETE no autorizado

**Usuario:** `IS101008`  
**Acción:** Intentar eliminar un registro de la tabla `SELECCION`.

```sql
DELETE FROM IS101001.ORGANIZACIONES_FUTBOL WHERE id_organizacion = 777;
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
DELETE FROM IS101001.ORGANIZACIONES_FUTBOL WHERE id_organizacion = 777
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Oracle rechazó la operación debido a que el usuario no posee privilegio `DELETE` en esta ni en otra tabla.

---

### Prueba 5: INSERT no autorizado en AUDITORIA

**Usuario:** `IS101008`  
**Acción:** Intentar insertar un registro de la tabla `AUDITORIA`.

```sql
INSERT INTO is101001.AUDITORIA (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora) 
VALUES (999, 'TEST_USER', 'ORGANIZACIONES_FUTBOL', 777, 'INSERT', SYSTIMESTAMP);
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
INSERT INTO is101001.AUDITORIA (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora) 
VALUES (999, 'TEST_USER', 'ORGANIZACIONES_FUTBOL', 777, 'INSERT', SYSTIMESTAMP)
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Oracle rechazó la operación debido a que el usuario no posee privilegio `INSERT` sobre AUDITORIA.

---

## 3. Conclusión

Las pruebas realizadas confirman que el usuario `IS101008` tiene acceso de lectura, insercion y actualizacion sobre las tablas autorizadas del esquema `IS101001`, menos en auditoria.

Por lo tanto, el comportamiento observado corresponde al nivel de acceso esperado para un usuario de consulta.

---

## 3. Evidencia de pruebas del Analista deportivo

Las siguientes pruebas fueron realizadas con el usuario `IS101008` después de asignarle los privilegios correspondientes al rol de Analisra.

El objetivo es demostrar que no tiene capacidad de sleccion todas las tabas y no puede seleccionar en la tabal AUDITORIA. 

### 3.1. Pruebas Analista deportivo
---

#### Prueba 1: SELECT

**Usuario:** `IS101008`  
**Acción:** Consultar información de la tabla `ORGANIZACIONES_FUTBOL`.

```sql
SELECT * FROM ORGANIZACIONES_FUTBOL;
```

**Resultado obtenido:**

La consulta se ejecutó correctamente y mostró los registros almacenados en la tabla.

**Estado:** APROBADO. El usuario puede realizar operaciones `SELECT` correctamente.

---

#### Prueba 2: INSERT sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar insertar una nueva organización.

```sql
INSERT INTO IS101001.ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
VALUES (888, 'Federación Bloqueada', 'FEDERACION_NACIONAL', 'Chile', 1);
```

**Resultado obtenido:**

```text
INSERT INTO is101001.ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
VALUES (888, 'Federación Bloqueada', 'FEDERACION_NACIONAL', 'Chile', 1)
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Se denego la insercion dado que no tienen el privilegio de `INSERT`.

---

#### Prueba 3: UPDATE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar actualizar información de una organizacion.

```sql
UPDATE is101001.ORGANIZACIONES_FUTBOL 
SET nombre = 'Intento de Cambio' 
WHERE id_organizacion = 1;
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
UPDATE is101001.ORGANIZACIONES_FUTBOL 
SET nombre = 'Intento de Cambio' 
WHERE id_organizacion = 1
Error at Command Line : 1 Column : 17
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. el usuario no tiene el privilegio de `UPDATE`.

---

#### Prueba 4: DELETE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar eliminar una organizacion.

```sql
DELETE FROM is101001.ORGANIZACIONES_FUTBOL 
WHERE id_organizacion = 1;
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
DELETE FROM is101001.ORGANIZACIONES_FUTBOL WHERE id_organizacion = 1
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Is101008 no tiene el privilegio`DELETE`.

---

#### Prueba 5: SELECT no autorizado en AUDITORIA

**Sentencia ejecutada:**

```sql
SELECT * FROM IS101001.AUDITORIA;
```

**Resultado obtenido:**

ORA-01031: insufficient privileges

**Estado:** APROBADO. El usuario `IS101008` NO puede realizar operaciones `SELECT` sobre AUDITORIA.

---

### Conclusión del usuario operativo

Las pruebas realizadas confirman que el usuario `IS101008` puede ejecutar operaciones `SELECT` sobre todas las tablas menos sobre AUDITORIA. No puede hacer operaciones `INSERT`, `UPDATE` o `DELETE`. 

---




## 3. Evidencia de pruebas del Auditor

Las siguientes pruebas fueron realizadas con el usuario `IS101008`  después de asignarle los privilegios correspondientes al Auditor.

El objetivo es demostrar que tiene capacidad de selección sobre todas las tablas, incluso auditoria. 

### 3.1. Pruebas Analista deportivo

#### Prueba 1: SELECT

**Usuario:** `IS101008`  
**Acción:** Consultar información de la tabla `ORGANIZACIONES_FUTBOL`.

```sql
SELECT * FROM ORGANIZACIONES_FUTBOL;
```

**Resultado obtenido:**

La consulta se ejecutó correctamente y mostró los registros almacenados en la tabla.

**Estado:** APROBADO. El usuario puede realizar operaciones `SELECT` correctamente.

---

#### Prueba 2: INSERT sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar insertar una nueva organización.

```sql
INSERT INTO IS101001.ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
VALUES (888, 'Federación Bloqueada', 'FEDERACION_NACIONAL', 'Chile', 1);
```

**Resultado obtenido:**

```text
INSERT INTO is101001.ORGANIZACIONES_FUTBOL (id_organizacion, nombre, tipo, pais, id_organizacion_padre) 
VALUES (888, 'Federación Bloqueada', 'FEDERACION_NACIONAL', 'Chile', 1)
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Se denego la insercion dado que no tienen el privilegio de `INSERT`.

---

#### Prueba 3: UPDATE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar actualizar información de una organizacion.

```sql
UPDATE is101001.ORGANIZACIONES_FUTBOL 
SET nombre = 'Intento de Cambio' 
WHERE id_organizacion = 1;
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
UPDATE is101001.ORGANIZACIONES_FUTBOL 
SET nombre = 'Intento de Cambio' 
WHERE id_organizacion = 1
Error at Command Line : 1 Column : 17
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. el usuario no tiene el privilegio de `UPDATE`.

---

#### Prueba 4: DELETE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar eliminar una organizacion.

```sql
DELETE FROM is101001.ORGANIZACIONES_FUTBOL 
WHERE id_organizacion = 1;
```

**Resultado obtenido:**

```text
Error starting at line : 1 in command -
DELETE FROM is101001.ORGANIZACIONES_FUTBOL WHERE id_organizacion = 1
Error at Command Line : 1 Column : 22
Error report -
SQL Error: ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Is101008 no tiene el privilegio`DELETE`.

---

#### Prueba 5: SELECT autorizado en AUDITORIA

**Sentencia ejecutada:**

```sql
SELECT * FROM IS101001.AUDITORIA;
```

**Resultado obtenido:**

Aparece la seleccion de toda la tabla de AUDITORIA 

**Estado:** APROBADO. El usuario `IS101008` puede realizar operaciones `SELECT` sobre AUDITORIA.

---

### Conclusión del usuario operativo

Las pruebas realizadas confirman que el usuario `IS101008` puede ejecutar operaciones `SELECT` sobre todas las tablas. No puede hacer operaciones `INSERT`, `UPDATE` o `DELETE`. 

