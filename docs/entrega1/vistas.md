**\# Justificación de vistas — Entrega 1**

**1\. vw\_partidos\_estadio**

Esta vista permite consultar de forma directa la información de los partidos junto con el estadio y la ciudad donde se disputan. Su propósito es simplificar consultas frecuentes que requieren relacionar las tablas PARTIDO y ESTADIO, evitando repetir el JOIN cada vez que se necesite consultar esta información.

**2\. vw\_goles\_seleccion**

Esta vista resume la cantidad total de goles marcados por cada selección. Su propósito es reutilizar una agregación frecuente sobre las participaciones de los partidos y facilitar consultas posteriores relacionadas con rendimiento ofensivo, rankings y comparación entre selecciones.

**3\. vw\_participaciones\_partido**

Esta vista presenta de manera integrada la participación de cada selección en los partidos, incluyendo su condición y los goles marcados. Su propósito es simplificar la consulta de la relación entre SELECCION y PARTICIPACION\_PARTIDO y facilitar el análisis de resultados por selección.

**4\. vw\_partidos\_por\_fase**

Esta vista muestra la cantidad de partidos disputados en cada fase del torneo. Su propósito es reutilizar una operación de agrupación frecuente y facilitar consultas estadísticas sobre la distribución de los partidos a lo largo de las diferentes fases.  
