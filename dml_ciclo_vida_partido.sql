--sql/entrega1/dml/dml_ciclo_vida_partido.sql
-- Brasil vs Japon 1-4 Fase de grupos Edicion 1
INSERT INTO is101001.partido (id_partido, id_edicion, id_estadio, fecha_hora, fase, asistencia_registrada)
VALUES (9004, 3, 3, '11-JUN-2026 2:30:00', 'Fase de Grupos', 79990);

INSERT INTO is101001.participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (8007, 9004, 107, 'local',null);

INSERT INTO is101001.participacion_partido (id_participacion, id_partido, id_seleccion, condicion, goles_marcados)
VALUES (8008, 24, 108, 'visitante',null);

UPDATE is101001.participacion_partido
SET goles_marcados = 4
WHERE id_participacion=8007;

UPDATE is101001.participacion_partido
SET goles_marcados = 1
WHERE id_participacion = 8007;

--Semana 3 update del archivo sql/entrega1/dml/dml_ciclo_vida_partido.sql
-- Se hace el ciclo de vida partido pero ahora en nuestra versión de la base de datos del mundial

-- Evidencia de insert, select, update y delete para evidenciar que me dieron el rol de operativo a mi is101008
select *
from is101001.jugador;

INSERT INTO is101001.jugador (id_jugador, nombre, fecha_nacimiento, altura, peso, nacionalidad)
VALUES ('1011', 'James Rodriguez', '12-JUL-1991', null, 78, 'Colombia');

UPDATE is101001.jugador
SET altura = 180
WHERE id_jugador='1011';

delete from is101001.jugador
where id_jugador='1011';


--intento de 3 operaciones invalidas 

INSERT INTO is101001.edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, fecha_fin)
VALUES (56, 1926, 'Colombia', 'Amor y paz', '11-JUN-1926','11-JUL-1926');
-- No deja por la restriccion check min_anio_edicion que la que se inserta es menor a 1930 que fue el primer mundial

INSERT INTO is101001.seleccion (id_seleccion, id_edicion, pais, confederacion, grupo, convocados)
VALUES (90, null, 'RD Congo', 'AFC', 'H', 24);
-- Restriccion de not null en edicion_mundial

INSERT INTO is101001.jugador (id_jugador, nombre, fecha_nacimiento, altura, peso, nacionalidad)
VALUES ('1001', 'Cristiano Ronaldo', '05-FEB-1985', 187, 83, 'Portugal');
-- Restriccion de primary key especificamente unique ya que el id ya fue insertado



--Prueba eliminacion cascade de seleccion
delete from is101001.edicion_mundial
where id_edicion = 1;

--Prueba eliminacion on restriction
delete from is101001.seleccion
where id_seleccion = 101;



