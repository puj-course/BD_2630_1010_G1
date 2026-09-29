# Pruebas de Privilegios de Usuarios

Este documento contiene la evidencia de control de acceso para la base de datos del Mundial.

## 1. Tabla de Usuarios y Roles

| Usuario | Rol Asignado | Permisos Esperados |
| :--- | :--- | :--- |
| `IS101001` | Administrador | Control total (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) |
| `IS101000` | Consulta | Solo lectura (`SELECT`) |
| `IS101008` | Operativo | Control intermedio (`SELECT`, `INSERT`, `UPDATE`) |

---

## 2. Evidencia de pruebas del usuario de consulta

Las siguientes pruebas fueron realizadas sobre el usuario de consulta `IS101000`, con el objetivo de verificar que únicamente tenga permisos de lectura sobre las tablas autorizadas del esquema `IS101001`.

### Prueba 1: Lectura autorizada

**Usuario:** `IS101000`  
**Acción:** Consultar información de la tabla `SELECCION`.

```sql
SELECT *
FROM IS101001.SELECCION;
```

**Resultado obtenido:**

La consulta se ejecutó correctamente y mostró los registros almacenados en la tabla.

**Estado:** APROBADO. El usuario puede realizar operaciones `SELECT` correctamente.

---

### Prueba 2: UPDATE no autorizado

**Usuario:** `IS101000`  
**Acción:** Intentar modificar información de la tabla `SELECCION`.

```sql
UPDATE IS101001.SELECCION
SET pais = 'PRUEBA'
WHERE id_seleccion = -999;
```

**Resultado obtenido:**

```text
ORA-01031: privilegios insuficientes
```

**Estado:** APROBADO. Oracle rechazó la operación debido a que el usuario no posee privilegio `UPDATE`.

---

### Prueba 3: INSERT no autorizado

**Usuario:** `IS101000`  
**Acción:** Intentar insertar un nuevo registro en la tabla `SELECCION`.

```sql
INSERT INTO IS101001.SELECCION (
    id_seleccion,
    id_edicion,
    pais,
    confederacion
)
VALUES (
    -999,
    1,
    'PRUEBA',
    'PRUEBA'
);
```

**Resultado obtenido:**

```text
ORA-01031: privilegios insuficientes
```

**Estado:** APROBADO. Oracle rechazó la operación debido a que el usuario no posee privilegio `INSERT`.

---

### Prueba 4: DELETE no autorizado

**Usuario:** `IS101000`  
**Acción:** Intentar eliminar un registro de la tabla `SELECCION`.

```sql
DELETE FROM IS101001.SELECCION
WHERE id_seleccion = -999;
```

**Resultado obtenido:**

```text
ORA-01031: privilegios insuficientes
```

**Estado:** APROBADO. Oracle rechazó la operación debido a que el usuario no posee privilegio `DELETE`.

---

## 3. Conclusión

Las pruebas realizadas confirman que el usuario `IS101000` tiene acceso de solo lectura sobre las tablas autorizadas del esquema `IS101001`.

El usuario puede ejecutar correctamente operaciones `SELECT`, mientras que las operaciones `UPDATE`, `INSERT` y `DELETE` son rechazadas por Oracle con el error `ORA-01031: privilegios insuficientes`.

Por lo tanto, el comportamiento observado corresponde al nivel de acceso esperado para un usuario de consulta.




## 3. Evidencia de pruebas del usuario operativo

Las siguientes pruebas fueron realizadas con el usuario `IS101008` antes y después de asignarle los privilegios correspondientes al rol operativo.

El objetivo es comprobar que inicialmente el usuario no puede realizar operaciones sobre las tablas del esquema `IS101001` y que, después de asignar el rol, puede ejecutar las operaciones permitidas para un usuario operativo.

### 3.1. Pruebas antes de asignar el rol operativo

#### Prueba 1: SELECT sin privilegios

**Usuario:** `IS101008`  
**Acción:** Consultar información de la tabla `JUGADOR`.

```sql
SELECT *
FROM IS101001.JUGADOR;
```

**Resultado obtenido:**

```text
ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Antes de asignar el rol operativo, el usuario no tenía privilegio `SELECT` sobre la tabla.

---

#### Prueba 2: INSERT sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar insertar un nuevo jugador.

```sql
INSERT INTO IS101001.JUGADOR (
    id_jugador,
    nombre,
    fecha_nacimiento,
    altura,
    peso,
    nacionalidad
)
VALUES (
    '1011',
    'James Rodriguez',
    '12-JUL-1991',
    NULL,
    78,
    'Colombia'
);
```

**Resultado obtenido:**

```text
ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Antes de asignar el rol operativo, el usuario no tenía privilegio `INSERT`.

---

#### Prueba 3: UPDATE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar actualizar información de un jugador.

```sql
UPDATE IS101001.JUGADOR
SET altura = 180
WHERE id_jugador = '1011';
```

**Resultado obtenido:**

```text
ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Antes de asignar el rol operativo, el usuario no tenía privilegio `UPDATE`.

---

#### Prueba 4: DELETE sin privilegios

**Usuario:** `IS101008`  
**Acción:** Intentar eliminar un jugador.

```sql
DELETE FROM IS101001.JUGADOR
WHERE id_jugador = '1011';
```

**Resultado obtenido:**

```text
ORA-01031: insufficient privileges
```

**Estado:** APROBADO. Antes de asignar el rol operativo, el usuario no tenía privilegio `DELETE`.

---

### 3.2. Pruebas después de asignar el rol operativo


### 3.2. Pruebas después de asignar los privilegios al usuario operativo

Después de asignar los privilegios correspondientes al usuario `IS101008`, se repitieron las operaciones sobre la tabla `IS101001.JUGADOR`.

#### Prueba 1: SELECT autorizado

**Sentencia ejecutada:**

```sql
SELECT *
FROM IS101001.JUGADOR;
```

**Resultado obtenido:**

La consulta se ejecutó correctamente y mostró los registros de la tabla `JUGADOR`.

**Estado:** APROBADO. El usuario `IS101008` puede realizar operaciones `SELECT`.

---

#### Prueba 2: INSERT autorizado

**Sentencia ejecutada:**

```sql
INSERT INTO IS101001.JUGADOR (
    id_jugador,
    nombre,
    fecha_nacimiento,
    altura,
    peso,
    nacionalidad
)
VALUES (
    '1011',
    'James Rodriguez',
    '12-JUL-1991',
    NULL,
    78,
    'Colombia'
);
```

**Resultado obtenido:**

La operación se ejecutó correctamente y el nuevo registro fue insertado en la tabla `JUGADOR`.

**Estado:** APROBADO. El usuario `IS101008` puede realizar operaciones `INSERT`.

---

#### Prueba 3: UPDATE autorizado

**Sentencia ejecutada:**

```sql
UPDATE IS101001.JUGADOR
SET altura = 180
WHERE id_jugador = '1011';
```

**Resultado obtenido:**

La operación se ejecutó correctamente y el registro fue actualizado.

**Estado:** APROBADO. El usuario `IS101008` puede realizar operaciones `UPDATE`.

---

#### Prueba 4: DELETE

**Sentencia ejecutada:**

```sql
DELETE FROM IS101001.JUGADOR
WHERE id_jugador = '1011';
```

**Resultado obtenido:**

La operación se ejecutó correctamente y el registro fue eliminado.

**Estado:** La prueba confirma que el usuario `IS101008` posee actualmente privilegio `DELETE` sobre la tabla `JUGADOR`.

---

### Conclusión del usuario operativo

Las pruebas realizadas confirman que el usuario `IS101008` puede ejecutar operaciones `SELECT`, `INSERT`, `UPDATE` y `DELETE` sobre la tabla `IS101001.JUGADOR`.

Las operaciones `SELECT`, `INSERT` y `UPDATE` corresponden al acceso esperado para el usuario operativo.