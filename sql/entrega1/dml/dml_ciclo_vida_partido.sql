--sql/entrega1/dml/dml_ciclo_vida_partido.sql
-- Corea del Sur vs Brasil 1-4 Fase de grupos Edicion 1

INSERT INTO MORENOLUIS.FIFA_PARTIDO (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada)
VALUES (24, 1, 1, '2026-06-11 14:30:00', 'Fase de Grupos', 79990);

INSERT INTO MORENOLUIS.FIFA_PARTICIPACION_PARTIDO (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (47, 24, 14, 'local',null);

INSERT INTO MORENOLUIS.FIFA_PARTICIPACION_PARTIDO (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (48, 24, 1, 'visitante',null);

UPDATE MORENOLUIS.FIFA_PARTICIPACION_PARTIDO
SET goles_marcados = 1
WHERE id_participacion=47;

UPDATE MORENOLUIS.FIFA_PARTICIPACION_PARTIDO
SET goles_marcados = 4
WHERE id_participacion = 48;