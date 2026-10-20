-- ================================
-- consultas_avanzadas_parte1.sql
-- ================================

--Maximo goleador en la historia de los mundiales
select *
from (
select p.id_persona, p.nombre_completo, count(ep.id_persona) goles
from etapa_competencia ec  
join partido p on p.id_etapa = ec.id_etapa 
join evento_partido ep on ep.id_partido = p.id_partido
join persona p on p.id_persona = ep.id_persona
where ep.tipo_evento = 'GOL'
group by p.id_persona, p.nombre_completo
having count(ep.id_persona) = (select max(goles) from (select count(ep1.id_persona) goles
                                                      from evento_partido ep1
                                                      where ep1.tipo_evento = 'GOL'
                                                      group by ep1.id_persona))
order by goles desc)
where rownum <= 1;

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
SELECT of1.id_organizacion, of1.nombre, of1.pais, ec.id_edicion, 
    sum(case when pp.resultado = 'PERDIO' then 1 else 0 end) perdidos, sum(case when pp.resultado = 'GANO' then 1 else 0 end) ganados
FROM organizaciones_futbol of1
JOIN seleccion s ON s.id_organizacion = of1.id_organizacion
JOIN etapa_competencia ec ON ec.id_etapa = s.id_etapa_grupo
join participacion_partido pp on s.id_seleccion = pp.id_seleccion 
WHERE NOT EXISTS (
    SELECT 1
    FROM seleccion s1
    JOIN etapa_competencia ec1 ON ec1.id_etapa = s1.id_etapa_grupo
    JOIN participacion_partido pp ON pp.id_seleccion = s1.id_seleccion
    WHERE s1.id_organizacion = of1.id_organizacion
      AND ec1.id_edicion = ec.id_edicion
      AND pp.resultado = 'GANO'
)
group by of1.id_organizacion, of1.nombre, of1.pais, ec.id_edicion
ORDER BY of1.nombre, ec.id_edicion;

