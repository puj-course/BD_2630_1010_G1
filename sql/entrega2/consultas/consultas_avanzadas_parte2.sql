--consultas_avanzadas_parte2.sql
--1. Árbitro más tarjetero
WITH tarjetas_arbitro AS (
    SELECT pers.id_persona, pers.nombre_completo arbitro, COUNT(ep.id_evento) tarjetas
    FROM asignacion_arbitral aa
    JOIN persona pers ON pers.id_persona = aa.id_persona
    JOIN evento_partido ep ON ep.id_partido = aa.id_partido
    WHERE aa.rol_arbitral = 'CENTRAL'
      AND ep.tipo_evento IN ('TARJETA_AMARILLA', 'TARJETA_ROJA')
    GROUP BY pers.id_persona, pers.nombre_completo
)
SELECT arbitro, tarjetas
FROM tarjetas_arbitro
WHERE tarjetas = (SELECT MAX(tarjetas) FROM tarjetas_arbitro);

--2. Partido con más entradas vendidas
WITH ventas AS (
    SELECT id_partido, COUNT(*) entradas_vendidas
    FROM entrada
    WHERE estado = 'VENDIDA'
    GROUP BY id_partido
)
SELECT p.id_partido, p.fecha_hora, e.nombre estadio, s1.codigo_fifa equipo_1, s2.codigo_fifa equipo_2, v.entradas_vendidas
FROM ventas v
JOIN partido p ON p.id_partido = v.id_partido
JOIN estadio e ON e.id_estadio = p.id_estadio
JOIN participacion_partido pp1 ON pp1.id_partido = p.id_partido
JOIN participacion_partido pp2 ON pp2.id_partido = p.id_partido
                              AND pp1.id_seleccion <> pp2.id_seleccion
JOIN seleccion s1 ON s1.id_seleccion = pp1.id_seleccion
JOIN seleccion s2 ON s2.id_seleccion = pp2.id_seleccion
WHERE v.entradas_vendidas = (SELECT MAX(entradas_vendidas) FROM ventas);

--3. Selecciones con más goles que el promedio
WITH goles_seleccion AS (
    SELECT s.id_seleccion, s.codigo_fifa, COUNT(*) partidos, SUM(pp.goles) total_goles
    FROM seleccion s
    JOIN participacion_partido pp ON pp.id_seleccion = s.id_seleccion
    GROUP BY s.id_seleccion, s.codigo_fifa
)
SELECT codigo_fifa, partidos, total_goles, ROUND(total_goles / partidos, 2) goles_por_partido
FROM goles_seleccion
WHERE total_goles > (SELECT AVG(total_goles) FROM goles_seleccion)
ORDER BY total_goles DESC;

