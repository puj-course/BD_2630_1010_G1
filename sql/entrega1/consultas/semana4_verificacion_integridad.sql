-- ================================================================================
-- Consulta 14: Identifica participaciones duplicadas de una seleccion
-- en un mismo partido para verificar la restriccion anti-duplicidad
-- ================================================================================

SELECT id_partido,
       id_seleccion,
       COUNT(*) AS cantidad_participaciones
FROM IS101001.PARTICIPACION_PARTIDO
GROUP BY id_partido, id_seleccion
HAVING COUNT(*) > 1;