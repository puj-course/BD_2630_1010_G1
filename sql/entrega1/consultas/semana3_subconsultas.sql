--ssemana3_subconsultas.sql

-- =====================================
-- Consulta 7 <Selecciones invictas> 
-- =====================================
select s.pais
from MORENOLUIS.FIFA_SELECCION S
where NOT EXISTS 
 (select 1
  from MORENOLUIS.FIFA_PARTIDO P JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP ON p.id_partido = pp.id_partido
  where pp.id_seleccion = S.id_seleccion 
  AND ( 
      (pp.condicion = 'local' 
      AND pp.goles_marcados <
      (select max(ppv.goles_marcados)
       from MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPV 
       where ppv.id_partido = p.id_partido AND  ppv.condicion = 'visitante')) 
      OR
      (pp.condicion = 'visitante' 
      AND pp.goles_marcados < 
          (select max(ppl.goles_marcados)
          from MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPL 
          where ppl.id_partido = p.id_partido AND ppl.condicion = 'local'))
     )
  );           

-- ===================================================
-- Consulta 8 <Estadios sobre el promedio de ocupacion> 
-- ===================================================

select nombre as estadio, ciudad, round(avg(asistencia_registrada/capacidad*100),2) ocupacion_pct
from MORENOLUIS.FIFA_ESTADIO E JOIN MORENOLUIS.FIFA_PARTIDO P on e.id_estadio = p.id_estadio
group by e.nombre, e.ciudad
having round(avg(asistencia_registrada/capacidad*100),2) > (
select round(avg(asistencia_registrada/capacidad*100),2)
from MORENOLUIS.FIFA_ESTADIO E1 JOIN  MORENOLUIS.FIFA_PARTIDO P1 on e1.id_estadio = p1.id_estadio)
;

-- ===================================================
-- Consulta 10 <Selecciones con condición exclusiva> 
-- ===================================================

select S.pais,
       SUM(CASE WHEN PP.condicion = 'local' THEN 1 ELSE 0 END) partidos_local,
       SUM(CASE WHEN PP.condicion = 'visitante' THEN 1 ELSE 0 END)  partidos_visitante,
       COUNT(PP.id_participacion) total_partidos
from MORENOLUIS.FIFA_SELECCION S
JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP 
     ON S.id_seleccion = PP.id_seleccion
group by S.pais
having SUM(CASE WHEN PP.condicion = 'local' THEN 1 ELSE 0 END) = 0 OR SUM(CASE WHEN PP.condicion = 'visitante' THEN 1 ELSE 0 END) = 0
order by S.pais;

-- ===================================================
-- Consulta 11 <Selecciones con condición exclusiva> 
-- ===================================================

WITH diferencia_por_seleccion AS (
    SELECT S.id_seleccion,
           S.pais,
           SUM(
             CASE WHEN PP.condicion = 'local' 
                  THEN PP.goles_marcados 
                  ELSE 0 END
           )
           + SUM(
             CASE WHEN PP.condicion = 'visitante' 
                  THEN PP.goles_marcados 
                  ELSE 0 END
           )
           - SUM(
             CASE WHEN PP.condicion = 'local' 
                  THEN (
                    SELECT MAX(PPV.goles_marcados)
                    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPV
                    WHERE PPV.id_partido = PP.id_partido
                      AND PPV.condicion = 'visitante'
                  )
                  ELSE (
                    SELECT MAX(PPL.goles_marcados)
                    FROM MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PPL
                    WHERE PPL.id_partido = PP.id_partido
                      AND PPL.condicion = 'local'
                  )
             END
           ) AS diferencia_gol
    FROM MORENOLUIS.FIFA_SELECCION S
    JOIN MORENOLUIS.FIFA_PARTICIPACION_PARTIDO PP 
         ON S.id_seleccion = PP.id_seleccion
    GROUP BY S.id_seleccion, S.pais
),
promedio_global AS (
    SELECT AVG(diferencia_gol) AS promedio
    FROM diferencia_por_seleccion
)
SELECT d.pais, d.diferencia_gol
FROM diferencia_por_seleccion d, promedio_global pg
WHERE d.diferencia_gol > pg.promedio
ORDER BY d.diferencia_gol DESC;