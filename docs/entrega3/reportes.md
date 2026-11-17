# Módulo de Consultas y Reportes

Aca se describe el funcionamiento, los filtros disponibles y la integración con la base de datos Oracle de los reportes implementados en la aplicación (`vista/PanelReportes.java` y `repositorios/ReporteDaoImpl.java`).

---

## 1. Filtros Disponibles en la Interfaz

El panel de reportes dispone de una barra superior de filtros que permite limitar los resultados dinámicamente:

* **ID Edición (Obligatorio):** Filtra toda la información deportiva y disciplinaria correspondiente a una edición específica del Mundial (`EDICION_MUNDIAL.id_edicion`).
* **ID Grupo / Fase (Opcional en Resultados e Incidencias / Obligatorio en Tabla de Posiciones):** Permite consultar una etapa específica (`ETAPA_COMPETENCIA.id_etapa`), ya sea un grupo de primera fase (`GRUPO`) o una llave eliminatoria (`INSTANCIA_ELIMINATORIA`).
* **ID Selección (Opcional en Resultados):** Filtra los encuentros en los que participó una selección específica (`SELECCION.id_seleccion`), sin importar si actuó como `LOCAL` o `VISITANTE`.
* **Top Goleadores:** Define el límite máximo de jugadores a mostrar en el ranking de máximos anotadores (por defecto `5`).

> **Manejo técnico de filtros opcionales:** En SQL se implementa el patrón `WHERE (? IS NULL OR columna = ?)`. Si el usuario deja el campo vacío en la interfaz gráfica, Java envía `NULL` al `PreparedStatement` y Oracle retorna todos los registros de la edición sin restringir por ese filtro.

---

## 2. Indicadores y Reportes Implementados

### 2.1. Tabla de Posiciones por Grupo
* **Objetivo:** Calcular y ordenar la clasificación de las selecciones dentro de un grupo.
* **Integración con Base de Datos:**
  1. Invoca mediante `CallableStatement` el procedimiento almacenado **`prc_actualizar_tabla_posiciones(p_id_etapa_grupo)`** para garantizar que los estados (`GANO`, `EMPATO`, `PERDIO`) de todos los partidos finalizados estén sincronizados.
  2. Ejecuta una consulta agregada sobre `SELECCION` y `PARTICIPACION_PARTIDO`, utilizando la función almacenada **`fn_diferencia_gol(id_seleccion)`** para calcular y desempatar la diferencia de goles.
* **Columnas visualizadas:** Posición (`Pos`), Código FIFA, Partidos Jugados (`PJ`), Ganados (`PG`), Empatados (`PE`), Perdidos (`PP`), Goles a Favor (`GF`), Goles en Contra (`GC`), Diferencia de Gol (`DG`) y Puntos (`Pts`).

### 2.2. Ranking de Goleadores por Edición
* **Objetivo:** Listar los máximos anotadores de una edición del torneo ordenados descendentemente por cantidad de goles.
* **Integración con Base de Datos:** Invoca directamente mediante `CallableStatement` la función almacenada **`fn_ranking_goleadores(p_id_edicion, p_top)`**, la cual agrupa los eventos de tipo `'GOL'` en `EVENTO_PARTIDO` y retorna el ranking formateado.
* **Visualización:** Se despliega en el panel lateral derecho (`JTextArea`) indicando posición, nombre del jugador, código FIFA de su selección y total de goles convertidos.

### 2.3. Resultados Consolidados
* **Objetivo:** Presentar el historial y calendario de partidos de una edición con sus marcadores oficiales y sedes.
* **Integración con Base de Datos:** Realiza múltiples `JOIN` entre `PARTIDO`, `ETAPA_COMPETENCIA`, `ESTADIO`, `PARTICIPACION_PARTIDO` (cruzando `LOCAL` y `VISITANTE`) y `SELECCION`, aplicando los filtros opcionales por etapa/grupo y selección.
* **Columnas visualizadas:** ID Partido, Fecha y Hora, Etapa, Estadio, Selección Local, Goles Local, Selección Visitante, Goles Visitante y Estado del encuentro (`PROGRAMADO`, `EN_JUEGO`, `FINALIZADO`).

### 2.4. Reporte de Incidencias Disciplinarias
* **Objetivo:** Monitorear las sanciones disciplinarias ocurridas durante los encuentros de una edición o fase específica.
* **Integración con Base de Datos:** Consulta la tabla `EVENTO_PARTIDO` filtrando los registros de tipo `'TARJETA_AMARILLA'` y `'TARJETA_ROJA'`, cruzándolos con `PARTIDO`, `ETAPA_COMPETENCIA` y `PERSONA`.
* **Columnas visualizadas:** ID Partido, Etapa, Tipo de Evento, Minuto, Jugador sancionado y Descripción de la incidencia.
