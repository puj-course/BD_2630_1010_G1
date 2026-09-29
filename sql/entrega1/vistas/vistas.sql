-- Vista 1: Muestra los partidos junto con el estadio y la ciudad donde se disputan

CREATE OR REPLACE VIEW vw_partidos_estadio AS
SELECT p.id_partido,
       p.fecha_hora,
       p.fase,
       e.nombre AS estadio,
       e.ciudad,
       e.capacidad
FROM MORENOLUIS.FIFA_PARTIDO p
JOIN MORENOLUIS.FIFA_ESTADIO e
    ON p.id_estadio = e.id_estadio;


-- Vista 2: Resume la cantidad total de goles marcados por cada seleccion

CREATE OR REPLACE VIEW vw_goles_seleccion AS
SELECT s.id_seleccion,
       s.pais,
       SUM(pp.goles_marcados) AS total_goles
FROM MORENOLUIS.FIFA_SELECCION s
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
    ON s.id_seleccion = pp.id_seleccion
GROUP BY s.id_seleccion, s.pais;


-- Vista 3: Muestra la participacion de cada seleccion en los partidos y los goles marcados

CREATE OR REPLACE VIEW vw_participaciones_partido AS
SELECT pp.id_participacion,
       pp.id_partido,
       s.id_seleccion,
       s.pais,
       pp.condicion,
       pp.goles_marcados
FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO pp
JOIN MORENOLUIS.FIFA_SELECCION s
    ON pp.id_seleccion = s.id_seleccion;
    
    
-- Vista 4: Resume la cantidad de partidos disputados en cada fase del torneo

CREATE OR REPLACE VIEW vw_partidos_por_fase AS
SELECT fase,
       COUNT(*) AS cantidad_partidos
FROM MORENOLUIS.FIFA_PARTIDO
GROUP BY fase;


 -- Vista 5
-- ===============================================================================================
-- Asistencia total y promedio por estadio 
-- ===============================================================================================

CREATE OR REPLACE VIEW V_OCUPACION_POR_ESTADIO AS
SELECT E.ID_ESTADIO, E.NOMBRE ESTADIO, E.CIUDAD, E.CAPACIDAD, COUNT(P.ID_PARTIDO) TOTAL_PARTIDOS,
SUM(P.ASISTENCIA_REGISTRADA) ASISTENCIA_TOTAL , ROUND(AVG(P.ASISTENCIA_REGISTRADA), 2) ASISTENCIA_PROMEDIO,
ROUND(AVG(P.ASISTENCIA_REGISTRADA) / E.CAPACIDAD * 100, 2) PORCENTAJE_OCUPACION
FROM MORENOLUIS.FIFA_ESTADIO E LEFT JOIN MORENOLUIS.FIFA_PARTIDO P
    ON E.ID_ESTADIO = P.ID_ESTADIO 
GROUP BY E.ID_ESTADIO, E.NOMBRE, E.CIUDAD, E.CAPACIDAD;

 main
