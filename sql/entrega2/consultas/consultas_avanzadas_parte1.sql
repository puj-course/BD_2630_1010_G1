-- ================================
-- consultas_avanzadas_parte1.sql
-- ================================

--Top 3 goleadores por edicion mundial

SELECT id_edicion, mundial, nombre_completo, pais, posicion, goles
FROM (
    SELECT t.*,
           ROW_NUMBER() OVER (PARTITION BY t.id_edicion ORDER BY t.goles DESC) rn
    FROM (
        SELECT em.id_edicion, em.nombre mundial, pers.nombre_completo, s.codigo_fifa pais, vs.posicion, COUNT(*) goles
        FROM edicion_mundial em
        JOIN etapa_competencia ec ON ec.id_edicion = em.id_edicion
        JOIN partido p ON p.id_etapa = ec.id_etapa
        JOIN evento_partido ep ON ep.id_partido = p.id_partido
        JOIN persona pers ON pers.id_persona = ep.id_persona
        JOIN vinculacion_seleccion vs ON vs.id_persona = pers.id_persona
        JOIN seleccion s ON s.id_seleccion = vs.id_seleccion
        JOIN etapa_competencia eg ON eg.id_etapa = s.id_etapa_grupo AND eg.id_edicion = em.id_edicion
        WHERE ep.tipo_evento = 'GOL'
        GROUP BY em.id_edicion, em.nombre, pers.nombre_completo,
                 s.codigo_fifa, vs.posicion
    ) t
)
WHERE rn <= 3
ORDER BY id_edicion, rn;

-- Estadio con más partidos albergados en la fase de grupos por edicion

WITH estadios_fase_grupos AS (
    SELECT s.id_edicion, e.id_estadio, e.nombre, COUNT(p.id_partido) partidos_albergados
    FROM estadio e
    JOIN ciudad c ON c.id_ciudad = e.id_ciudad
    JOIN sede s ON s.id_sede = c.id_sede
    JOIN partido p ON p.id_estadio = e.id_estadio
    JOIN etapa_competencia ec ON ec.id_etapa = p.id_etapa AND ec.id_edicion = s.id_edicion
    WHERE ec.tipo_etapa = 'GRUPO'
    GROUP BY s.id_edicion, e.id_estadio, e.nombre
)
SELECT em.nombre mundial, efg.nombre estadio, efg.partidos_albergados
FROM estadios_fase_grupos efg
JOIN edicion_mundial em ON em.id_edicion = efg.id_edicion
WHERE efg.partidos_albergados = (
    SELECT MAX(x.partidos_albergados)
    FROM estadios_fase_grupos x
    WHERE x.id_edicion = efg.id_edicion
)
ORDER BY em.nombre;

-- Federaciones que no hayan ganado ningun partido en alguna edicion
SELECT DISTINCT of1.id_organizacion, of1.nombre, of1.pais, ec.id_edicion
FROM organizaciones_futbol of1
JOIN seleccion s ON s.id_organizacion = of1.id_organizacion
JOIN etapa_competencia ec ON ec.id_etapa = s.id_etapa_grupo
WHERE NOT EXISTS (
    SELECT 1
    FROM seleccion s1
    JOIN etapa_competencia ec1 ON ec1.id_etapa = s1.id_etapa_grupo
    JOIN participacion_partido pp ON pp.id_seleccion = s1.id_seleccion
    WHERE s1.id_organizacion = of1.id_organizacion
      AND ec1.id_edicion = ec.id_edicion
      AND pp.resultado = 'GANO'
)
ORDER BY of1.nombre, ec.id_edicion;

    
