--semana2_agregaciones.sql

-- =====================================
-- Consulta 4 <Partidos jugados por fase> 
-- =====================================

select fase, count(id_partido) num_partidos
from MORENOLUIS.FIFA_PARTIDO
group by fase
order by num_partidos desc;