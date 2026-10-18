
# Definición de Roles

## Integrantes

- Sara Daiana Barreto
- Jerónimo Lievano

---

## 1. Administrador del torneo

Este rol requiere los permisos más amplios, dado que se encarga de administrar las ediciones, registrar las sedes, organizar los partidos y las selecciones, y mantener los registros operativos. Así serán los permisos dados según la tabla:

| Tabla | Consultar | Insertar | Modificar | Eliminar |
|---|---|---|---|---|
| `EDICION_MUNDIAL` | Sí | Sí | Sí | No |
| `ETAPA_COMPETENCIA` | Sí | Sí | Sí | No |
| `SEDE` | Sí | Sí | Sí | No |
| `CIUDAD` | Sí | Sí | Sí | No |
| `ESTADIO` | Sí | Sí | Sí | No |
| `ORGANIZACIONES_FUTBOL` | Sí | Sí | Sí | No |
| `SELECCION` | Sí | Sí | Sí | No |
| `PERSONA` | Sí | Sí | Sí | No |
| `VINCULACION_SELECCION` | Sí | Sí | Sí | No |
| `PARTIDO` | Sí | Sí | Sí | No |
| `PARTICIPACION_PARTIDO` | Sí | Sí | Sí | No |
| `EVENTO_PARTIDO` | Sí | Sí | Sí | No |
| `ASIGNACION_ARBITRAL` | Sí | Sí | Sí | No |
| `ENTRADA` | Sí | Sí | Sí | No |
| `ACREDITACION_PRENSA` | Sí | Sí | Sí | No |
| `AUDITORIA` | Sí | No | No | No |

**Justificación:** Este rol necesita gestionar las ediciones, etapas, sedes, estadios, selecciones, participantes, partidos, eventos, árbitros, entradas y acreditaciones. Las eliminaciones se restringen porque pueden afectar claves foráneas, el historial y la consistencia del torneo. Además, las modificaciones de los partidos finalizados y sus eventos deben someterse a validación y quedar registradas en la tabla `AUDITORIA`.

---

## 2. Analista deportivo

Este rol debe poder consultar los datos necesarios para estudiar los resultados y el rendimiento de las selecciones, incluyendo goles, eventos generales y estadísticas del torneo. No puede modificar la información original.

| Tabla | Consultar | Insertar | Modificar | Eliminar |
|---|---|---|---|---|
| `EDICION_MUNDIAL` | Sí | No | No | No |
| `ETAPA_COMPETENCIA` | Sí | No | No | No |
| `SEDE` | Sí | No | No | No |
| `CIUDAD` | Sí | No | No | No |
| `ESTADIO` | Sí | No | No | No |
| `ORGANIZACIONES_FUTBOL` | Sí | No | No | No |
| `SELECCION` | Sí | No | No | No |
| `PERSONA` | Sí* | No | No | No |
| `VINCULACION_SELECCION` | Sí | No | No | No |
| `PARTIDO` | Sí | No | No | No |
| `PARTICIPACION_PARTIDO` | Sí | No | No | No |
| `EVENTO_PARTIDO` | Sí | No | No | No |
| `ASIGNACION_ARBITRAL` | Sí* | No | No | No |
| `ENTRADA` | Sí* | No | No | No |
| `ACREDITACION_PRENSA` | Sí* | No | No | No |
| `AUDITORIA` | No | No | No | No |

**Justificación:** El analista necesita consultar principalmente las tablas `PARTIDO`, `PARTICIPACION_PARTIDO`, `EVENTO_PARTIDO`, `SELECCION`, `VINCULACION_SELECCION` y `ETAPA_COMPETENCIA`. Las demás tablas puede consultarlas más por contexto que por análisis. En donde pusimos Sí*, queremos decir que tienen permiso de consulta, pero parcial por datos sensibles y demás. No tiene permiso de escritura porque su función es analizar los registros, no alterarlos.

---

## 3. Auditor/Consulta

Este rol se encarga de verificar la información del torneo y examinar el historial de operaciones. No debe modificar los registros a los que se les está haciendo auditoría.

| Tabla | Consultar | Insertar | Modificar | Eliminar |
|---|---|---|---|---|
| `EDICION_MUNDIAL` | Sí | No | No | No |
| `ETAPA_COMPETENCIA` | Sí | No | No | No |
| `SEDE` | Sí | No | No | No |
| `CIUDAD` | Sí | No | No | No |
| `ESTADIO` | Sí | No | No | No |
| `ORGANIZACIONES_FUTBOL` | Sí | No | No | No |
| `SELECCION` | Sí | No | No | No |
| `PERSONA` | Sí* | No | No | No |
| `VINCULACION_SELECCION` | Sí | No | No | No |
| `PARTIDO` | Sí | No | No | No |
| `PARTICIPACION_PARTIDO` | Sí | No | No | No |
| `EVENTO_PARTIDO` | Sí | No | No | No |
| `ASIGNACION_ARBITRAL` | Sí | No | No | No |
| `ENTRADA` | Sí | No | No | No |
| `ACREDITACION_PRENSA` | Sí* | No | No | No |
| `AUDITORIA` | Sí | No | No | No |

**Justificación:** Al auditor se le permite consultar todas las tablas para que pueda contrastar la información y así detectar inconsistencias. Además, para este rol es que específicamente está diseñada la tabla `AUDITORIA`, que tiene la trazabilidad de los cambios, permitiendo ver los valores anteriores y nuevos, el usuario que hizo la modificación, en qué fecha, etc. Al igual que al analista, las tablas donde se encuentra el Sí* deben tener acceso parcial (implementando vistas).
