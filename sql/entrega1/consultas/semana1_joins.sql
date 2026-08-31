--semana1_joins.sql

-- ==============================================================================
-- CONSULTA 2 <Porcentaje de ocupación estimado por estadio> 
-- ==============================================================================

select nombre as estadio, ciudad, capacidad, count(id_partido) partidos_jugados, round(avg(asistencia_registrada/capacidad*100),2) ocupacion_pct
from MORENOLUIS.FIFA_ESTADIO JOIN MORENOLUIS.FIFA_PARTIDO USING (id_estadio)
group by nombre, ciudad, capacidad;

-- ==============================================================================
-- CONSULTA 5
-- ==============================================================================
SELECT *
FROM MORENOLUIS.FIFA_ESTADIO; -- ID_ESTADIO, NOMBRE

SELECT *
FROM MORENOLUIS.FIFA_EDICION_MUNDIAL; -- EDICION

SELECT *
FROM MORENOLUIS.FIFA_ESTADIO E JOIN MORENOLUIS.FIFA_PARTIDO P
ON E.ID_ESTADIO = P.ID_ESTADIO; -- NOMBRE, ID_ESTADIO, ID_PARTIDO 

SELECT ID_ESTADIO, COUNT(ID_PARTIDO) 
FROM MORENOLUIS.FIFA_PARTIDO
GROUP BY  ID_ESTADIO; -- ED_ESTADIO, N_PARTIDOS


SELECT E.ID_EDICION, S.NOMBRE ESTADIO, COUNT(P.ID_PARTIDO) N_PARTIDOS
FROM MORENOLUIS.FIFA_EDICION_MUNDIAL E JOIN MORENOLUIS.FIFA_ESTADIO S
    ON E.ID_EDICION = S.ID_EDICION
JOIN MORENOLUIS.FIFA_PARTIDO P
    ON  P.ID_ESTADIO = S.ID_ESTADIO
GROUP BY E.ID_EDICION, S.ID_ESTADIO,S.NOMBRE 
HAVING COUNT(P.ID_PARTIDO) = (SELECT MAX(COUNT(A.ID_PARTIDO)) 
FROM MORENOLUIS.FIFA_PARTIDO A 
JOIN MORENOLUIS.FIFA_ESTADIO B
    ON A.ID_ESTADIO = B.ID_ESTADIO
WHERE E.ID_EDICION = B.ID_EDICION
GROUP BY A.ID_ESTADIO); 

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

-- ===========================================================================
-- CONSULTA 9
-- ===========================================================================

SELECT *
FROM MORENOLUIS.FIFA_PARTIDO; -- DE ACA FASE, ID_PARTIDO 

SELECT *
FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO; -- DE ACÁ LOS GOLES Y EL ID_PARTIDO

SELECT *
FROM MORENOLUIS.FIFA_ESTADIO; -- DE ACA EL NOMBRE

SELECT MAX(SUM(Y.GOLES_MARCADOS))
FROM MORENOLUIS.FIFA_PARTIDO Z 
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO Y
    ON Z.ID_PARTIDO = Y.ID_PARTIDO 
GROUP BY Z.ID_PARTIDO;

SELECT E.NOMBRE, A.ID_PARTIDO, A.FASE, SUM(P.GOLES_MARCADOS) GOLES_TOTALES 
FROM MORENOLUIS.FIFA_PARTIDO A JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO P 
    ON A.ID_PARTIDO = P.ID_PARTIDO
JOIN MORENOLUIS.FIFA_ESTADIO E
    ON A.ID_ESTADIO = E.ID_ESTADIO
GROUP BY A.ID_PARTIDO, E.NOMBRE, A.ID_ESTADIO, A.FASE
HAVING SUM(P.GOLES_MARCADOS) = (SELECT MAX(SUM(Y.GOLES_MARCADOS))
FROM MORENOLUIS.FIFA_PARTIDO Z 
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO Y
    ON Z.ID_PARTIDO = Y.ID_PARTIDO 
WHERE Z.ID_ESTADIO = A.ID_ESTADIO 
GROUP BY Z.ID_PARTIDO)
ORDER BY NOMBRE; 

-- ===========================================================================
-- CONSULTA 12
-- ===========================================================================

SELECT *
FROM MORENOLUIS.FIFA_SELECCION; --PAÍS, ID SELECCION

SELECT *
FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO; -- ID SLECCION, ID PARTIDO, GOLES MARCADOS,  

SELECT *
FROM MORENOLUIS.FIFA_PARTIDO; -- ID PARTIDO, FASE 

SELECT S.PAIS, 
    SUM(CASE WHEN P.FASE = 'Fase de Grupos' THEN PP.GOLES_MARCADOS ELSE 0 END) GOLES_FASE_GRUPOS,
    SUM(CASE WHEN P.FASE in ('Semifinal', 'Tercer Puesto', 'Final') THEN PP.GOLES_MARCADOS ELSE 0 END) GOLES_ELIMINATORIA
FROM MORENOLUIS.FIFA_SELECCION S JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP
    ON S.ID_SELECCION = PP.ID_SELECCION
JOIN MORENOLUIS.FIFA_PARTIDO P
    ON PP.ID_PARTIDO = P.ID_PARTIDO
GROUP BY S.PAIS
ORDER BY S.PAIS; 
 