# documentacion_programacion_bd
## Funciones
## Procedimientos
## Triggers


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
