# Pruebas de Privilegios de Usuarios

Este documento contiene la evidencia de control de acceso para la base de datos del Mundial.

## 1. Tabla de Usuarios y Roles

| Usuario | Rol Asignado | Permisos Esperados |
| :--- | :--- | :--- |
| `is101001` | Administrador | Control total (SELECT, INSERT, UPDATE, DELETE) |
| `is101000` | Consulta | Solo lectura (SELECT) |
| `is101008` | Operativo | Control intermedio (SELECT, INSERT, UPDATE) |

---

## 2. Evidencia de Pruebas

### Prueba 1: Lectura autorizada (Usuario Consultor)
* **Usuario:** `usr_lector`
* **Acción:** Consultar la tabla de ediciones.

```sql
SELECT id_edicion, anio, pais_sede FROM EDICION_MUNDIAL;
```

**Resultado obtenido:**
```text
ID_EDICION  ANIO  PAIS_SEDE
WC-2026     2026  USA / Mexico / Canada
```
> **Estado:** APROBADO (Permite la lectura correctamente).

---

### Prueba 2: Modificación no autorizada (Usuario Consultor)
* **Usuario:** `usr_lector`
* **Acción:** Intentar modificar datos sin tener permiso de actualización.

```sql
UPDATE EDICION_MUNDIAL SET lema = 'Nuevo Lema' WHERE id_edicion = 'WC-2026';
```

**Resultado obtenido:**
```text
ERROR: permission denied for table EDICION_MUNDIAL
```
> **Estado:** APROBADO (El motor de base de datos deniega la operación como se esperaba).