# Arquitectura de la Aplicación

## 1. Stack Tecnológico

| Capa | Tecnología / Herramienta | Propósito en el Sistema |
| :--- | :--- | :--- |
| **Frontend (Presentación)** | **Java Swing** (`javax.swing`, `java.awt`) | Interfaz gráfica de escritorio organizada por pestañas (`JTabbedPane`), formularios y tablas dinámicas (`JTable`). |
| **Backend (Lógica y Persistencia)** | **Java SE (JDK 26 / 17+)** + **Patrón DAO** | Desacoplamiento entre la vista y el acceso a datos mediante interfaces (`dao`), POJOs (`entidades`) e implementaciones JDBC (`repositorios`). |
| **Conectividad y Configuración** | **JDBC (`ojdbc17.jar`)** + `java.util.Properties` | Gestión de conexiones hacia Oracle y externalización segura de credenciales en `configuracion.properties`. |
| **Base de Datos (BD)** | **Oracle Database** (SQL + PL/SQL) | Almacenamiento relacional normalizado (3FN), restricciones de integridad, triggers de auditoría/consistencia, funciones (`fn_*`) y procedimientos almacenados (`prc_*`, `sp_*`). |

---

## 2. Diagrama de Arquitectura (Frontend / Backend / Base de Datos)

```text
+-----------------------------------------------------------------------------+

|                        FRONTEND (Capa de Presentación)                      |
|                               Java Swing (GUI)                              |
|  +-------------------+  +-----------------------+  +---------------------+  |
|  |  1. Catálogos     |  | 2. Partidos y Eventos |  | 3. Reportes y       |  |
|  |  - Ediciones      |  | - Registro Partido    |  |    Consultas        |  |
|  |  - Ubicaciones    |  | - Participaciones     |  | - Posiciones        |  |
|  |  - Selecciones    |  | - Estadísticas        |  | - Goleadores        |  |
|  |  - Planteles      |  |                       |  | - Incidencias       |  |
|  +---------+---------+  +-----------+-----------+  +----------+----------+  |
+------------|------------------------|-------------------------|-------------+

             |                        |                         |
             +------------------------+-------------------------+
                                      | Invoca (Interfaces)
                                      v
+-----------------------------------------------------------------------------+

|                   BACKEND (Capa de Abstracción y Negocio)                   |
|                                                                             |
|  +-----------------------------------+   +-------------------------------+  |
|  |        Paquete: dao               |   |      Paquete: entidades       |  |
|  |  Interfaces DAO (*Dao.java)       |   |  POJOs del Modelo Relacional  |  |
|  |  (EdicionMundialDao, PartidoDao,  |<->|  (EdicionMundial, Partido,    |  |
|  |   PersonaDao, ReporteDao, etc.)   |   |   Persona, Seleccion, etc.)   |  |
|  +-----------------+-----------------+   +-------------------------------+  |
|                    | Implementa acceso a datos                              |
|                    v                                                        |
|  +-----------------------------------+   +-------------------------------+  |
|  |     Paquete: repositorios         |   |    Paquete: configuracion     |  |
|  |  Implementaciones JDBC (*DaoImpl) |-->|  - ConexionBD.java            |  |
|  |  - PreparedStatement (SQL seguro) |   |  - Constantes.java            |  |
|  |  - CallableStatement (PL/SQL)     |   |  - configuracion.properties   |  |
|  +-----------------+-----------------+   +-------------------------------+  |
+--------------------|--------------------------------------------------------+
                     | Conexión con Driver ojdbc17
                     v
+-----------------------------------------------------------------------------+

|                        BASE DE DATOS (Oracle Database)                      |
|                                                                             |
|  +-----------------------------------+   +-------------------------------+  |
|  |     Esquema Relacional (DDL)      |   |   Programación PL/SQL         |  |
|  |  - Tablas en 3FN + PK/FK/CHECK    |   |  - fn_ranking_goleadores      |  |
|  |  - Índices estratégicos           |   |  - fn_diferencia_gol          |  |
|  |  - Triggers (Auditoría y          |   |  - prc_actualizar_tabla_...   |  |
|  |    consistencia de marcadores)    |   |  - sp_carga_masiva_resultados |  |
|  +-----------------------------------+   +-------------------------------+  |
+-----------------------------------------------------------------------------+
```

---

## 3. Flujo de Comunicación entre Capas

1. **Interacción del Usuario (Frontend):** El usuario ingresa datos en un formulario o aplica filtros en un panel de `vista` y presiona un botón de acción.
2. **Desacoplamiento (Contratos DAO):** El panel invoca únicamente los métodos declarados en la interfaz correspondiente del paquete `dao`, enviando o recibiendo objetos del paquete `entidades`.
3. **Ejecución en Persistencia (Backend):** La clase `*DaoImpl` del paquete `repositorios` solicita una conexión a `ConexionBD` y ejecuta sentencias parametrizadas (`PreparedStatement`) o llamadas a rutinas almacenadas (`CallableStatement`).
4. **Integridad y Respuesta (Base de Datos):** Oracle valida las restricciones (`CHECK`, `UNIQUE`, llaves foráneas y triggers), procesa la operación y retorna los resultados hacia la capa `vista` para actualizar los componentes `JTable` o `JTextArea`.
