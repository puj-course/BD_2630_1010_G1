-- Consulta 15: Fase del torneo con mayor cantidad de partidos
-- utilizando la vista vw_partidos_por_fase

SELECT fase,
       cantidad_partidos
FROM vw_partidos_por_fase
WHERE cantidad_partidos = (
    SELECT MAX(cantidad_partidos)
    FROM vw_partidos_por_fase
);