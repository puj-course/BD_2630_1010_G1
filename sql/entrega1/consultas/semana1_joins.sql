--semana1_joins.sql

-- ==============================================================================
-- CONSULTA 2 <Porcentaje de ocupación estimado por estadio> 
-- ==============================================================================

select nombre as estadio, ciudad, capacidad, count(id_partido) partidos_jugados, round(avg(asistencia_registrada/capacidad*100),2) ocupacion_pct
from MORENOLUIS.FIFA_ESTADIO JOIN MORENOLUIS.FIFA_PARTIDO USING (id_estadio)
group by nombre, ciudad, capacidad;

-- ============================================================================
-- CONSULTA 6 <Identificación de partidos con patrones atípicos> 
-- ============================================================================

select P.id_partido, P.id_edicion, P.fase, sum(goles_marcados) goles_totales, 
CASE WHEN sum(goles_marcados) > 5 THEN 'MARCADOR ALTO' WHEN sum(goles_marcados) = 0 THEN 'SIN GOLES' END patron
from MORENOLUIS.FIFA_PARTIDO P 
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP on p.id_partido = pp.id_partido 
JOIN MORENOLUIS.FIFA_SELECCION S ON pp.id_seleccion = s.id_seleccion 
group by P.id_partido, P.id_edicion, P.fase
having sum(goles_marcados) = 0 OR sum(goles_marcados)>5
order by goles_totales desc;
