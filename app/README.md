# Aplicación de Escritorio — Gestión Integral Copa Mundial de la FIFA

Aplicación de escritorio desarrollada en **Java (Swing)** conectada a **Oracle Database** mediante **JDBC (`ojdbc17`)**, implementada bajo una arquitectura en 3 capas con el **Patrón DAO**.

---

## 1. Requisitos Previos

* **Java Development Kit (JDK):** Versión 17 o superior.
* **IDE recomendado:** IntelliJ IDEA (o Eclipse / NetBeans).
* **Driver JDBC:** `ojdbc17.jar` (incluido en las librerías externas del módulo `app`).
* **Conexión de red:** Acceso a la red de la Pontificia Universidad Javeriana o conexión activa a la **VPN institucional** para alcanzar el servidor `orion.javeriana.edu.co`.

---

## 2. Configuración de Credenciales (`.properties`)

El archivo con las credenciales reales de la base de datos está excluido del repositorio mediante `.gitignore`. Antes de ejecutar el proyecto por primera vez:

1. Ubícate dentro de la carpeta `app/`.
2. Duplica el archivo plantilla **`configuracion.properties.example`** y renombra la copia exactamente como **`configuracion.properties`**.
3. Abre `app/configuracion.properties` y completa tus credenciales asignadas:

```properties
db.user=TU_USUARIO_ORACLE
db.password=TU_CONTRASEÑA_ORACLE
db.url=jdbc:oracle:thin:@orion.javeriana.edu.co:1521/LAB
```

---

## 3. Pasos para Ejecutar la Aplicación

1. **Abrir el proyecto:** Abre la carpeta raíz `BD_2630_1010_G1` en IntelliJ IDEA.
2. **Verificar el driver JDBC:**
4. **Ejecutar:** Corre la clase **`src/Main.java`** (o `vista/VentanaPrincipal.java`).

---

## 4. Módulos Disponibles en la Interfaz

* **1. Catálogos:** Administración CRUD de *Edición Mundial*, *Sedes, Ciudades y Estadios*, *Organizaciones, Etapas/Grupos y Selecciones*, y *Personas y Convocatorias (Jugadores / Cuerpo Técnico)*.
* **2. Registro Partidos y Estadísticas:** Creación de partidos, asignación de participaciones (*Local / Visitante*) y registro de eventos/incidencias de juego.
* **3. Consultas y Reportes:** Consulta dinámica de *Tabla de Posiciones*, *Resultados Consolidados*, *Incidencias Disciplinarias* y *Ranking de Goleadores*.
