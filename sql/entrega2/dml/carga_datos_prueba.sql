-- ============================================================
-- CARGA DE DATOS DE PRUEBA - ENTREGA 2
-- Sistema de Informacion para la Gestion Integral de la Copa Mundial
-- Datos ficticios y coherentes con ddl_modelo_ampliado.ddl
-- Ejecutar despues de crear correctamente todas las tablas y restricciones.
-- ============================================================

-- ============================================================
-- 1. EDICION_MUNDIAL
-- ============================================================

INSERT INTO EDICION_MUNDIAL
    (id_edicion, anio, nombre, fecha_inicio, fecha_fin)
VALUES
    (1, 2026, 'Copa Mundial 2026', DATE '2026-06-11', DATE '2026-07-19');


-- ============================================================
-- 2. SEDE
-- ============================================================

INSERT INTO SEDE (id_sede, id_edicion, pais)
VALUES (1, 1, 'Estados Unidos');

INSERT INTO SEDE (id_sede, id_edicion, pais)
VALUES (2, 1, 'Mexico');


-- ============================================================
-- 3. CIUDAD
-- ============================================================

INSERT INTO CIUDAD (id_ciudad, id_sede, nombre)
VALUES (1, 1, 'Nueva York');

INSERT INTO CIUDAD (id_ciudad, id_sede, nombre)
VALUES (2, 1, 'Miami');

INSERT INTO CIUDAD (id_ciudad, id_sede, nombre)
VALUES (3, 2, 'Ciudad de Mexico');


-- ============================================================
-- 4. ESTADIO
-- ============================================================

INSERT INTO Estadio (id_estadio, id_ciudad, nombre, capacidad)
VALUES (1, 1, 'Estadio Metropolitano Norte', 82000);

INSERT INTO Estadio (id_estadio, id_ciudad, nombre, capacidad)
VALUES (2, 2, 'Estadio Internacional Sur', 65000);

INSERT INTO Estadio (id_estadio, id_ciudad, nombre, capacidad)
VALUES (3, 3, 'Estadio Capital', 87000);


-- ============================================================
-- 5. ETAPA_COMPETENCIA
-- Se insertan primero las etapas padre y luego sus etapas hijas.
-- ============================================================

INSERT INTO ETAPA_COMPETENCIA
    (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)
VALUES
    (1, 1, NULL, 'Fase de Grupos', 'FASE', 1);

INSERT INTO ETAPA_COMPETENCIA
    (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)
VALUES
    (2, 1, 1, 'Grupo A', 'GRUPO', 1);

INSERT INTO ETAPA_COMPETENCIA
    (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)
VALUES
    (3, 1, 1, 'Grupo B', 'GRUPO', 2);

INSERT INTO ETAPA_COMPETENCIA
    (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)
VALUES
    (4, 1, NULL, 'Fase Eliminatoria', 'FASE', 2);

INSERT INTO ETAPA_COMPETENCIA
    (id_etapa, id_edicion, id_etapa_padre, nombre, tipo_etapa, orden)
VALUES
    (5, 1, 4, 'Final', 'INSTANCIA_ELIMINATORIA', 1);


-- ============================================================
-- 6. ORGANIZACIONES_FUTBOL
-- Primero se insertan las confederaciones y luego las federaciones.
-- ============================================================

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (1, 'CONMEBOL', 'CONFEDERACION', 'Sudamerica', NULL);

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (2, 'UEFA', 'CONFEDERACION', 'Europa', NULL);

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (11, 'Federacion Colombiana de Futbol', 'FEDERACION_NACIONAL', 'Colombia', 1);

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (12, 'Asociacion del Futbol Argentino', 'FEDERACION_NACIONAL', 'Argentina', 1);

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (21, 'Real Federacion Espanola de Futbol', 'FEDERACION_NACIONAL', 'Espana', 2);

INSERT INTO ORGANIZACIONES_FUTBOL
    (id_organizacion, nombre, tipo, pais, id_organizacion_padre)
VALUES
    (22, 'Federacion Francesa de Futbol', 'FEDERACION_NACIONAL', 'Francia', 2);


-- ============================================================
-- 7. SELECCION
-- La edicion se obtiene mediante id_etapa_grupo -> ETAPA_COMPETENCIA.
-- ============================================================

INSERT INTO SELECCION
    (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa)
VALUES
    (1, 11, 2, 'COL');

INSERT INTO SELECCION
    (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa)
VALUES
    (2, 12, 2, 'ARG');

INSERT INTO SELECCION
    (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa)
VALUES
    (3, 21, 3, 'ESP');

INSERT INTO SELECCION
    (id_seleccion, id_organizacion, id_etapa_grupo, codigo_fifa)
VALUES
    (4, 22, 3, 'FRA');


-- ============================================================
-- 8. PERSONA
-- Personas ficticias para jugadores, tecnicos, arbitros y periodistas.
-- ============================================================

-- Colombia
INSERT INTO PERSONA VALUES (1001, 'Carlos Rojas', 'Colombiana', DATE '1998-03-12');
INSERT INTO PERSONA VALUES (1002, 'Mateo Silva', 'Colombiana', DATE '2000-07-21');
INSERT INTO PERSONA VALUES (1003, 'Andres Torres', 'Colombiana', DATE '1978-10-05');

-- Argentina
INSERT INTO PERSONA VALUES (1101, 'Tomas Perez', 'Argentina', DATE '1997-02-18');
INSERT INTO PERSONA VALUES (1102, 'Julian Vega', 'Argentina', DATE '1999-09-11');
INSERT INTO PERSONA VALUES (1103, 'Ricardo Luna', 'Argentina', DATE '1975-06-14');

-- Espana
INSERT INTO PERSONA VALUES (1201, 'Diego Martin', 'Espanola', DATE '1998-01-09');
INSERT INTO PERSONA VALUES (1202, 'Pablo Ruiz', 'Espanola', DATE '2001-04-27');
INSERT INTO PERSONA VALUES (1203, 'Sergio Alba', 'Espanola', DATE '1976-12-02');

-- Francia
INSERT INTO PERSONA VALUES (1301, 'Lucas Moreau', 'Francesa', DATE '1999-05-20');
INSERT INTO PERSONA VALUES (1302, 'Hugo Bernard', 'Francesa', DATE '2000-11-03');
INSERT INTO PERSONA VALUES (1303, 'Pierre Laurent', 'Francesa', DATE '1974-08-16');

-- Arbitros
INSERT INTO PERSONA VALUES (2001, 'Daniel Costa', 'Brasilena', DATE '1985-03-04');
INSERT INTO PERSONA VALUES (2002, 'Miguel Santos', 'Portuguesa', DATE '1984-06-23');
INSERT INTO PERSONA VALUES (2003, 'Marco Bianchi', 'Italiana', DATE '1983-01-17');
INSERT INTO PERSONA VALUES (2004, 'John Miller', 'Estadounidense', DATE '1986-09-08');
INSERT INTO PERSONA VALUES (2005, 'Erik Larsen', 'Danesa', DATE '1985-12-12');

-- Periodistas
INSERT INTO PERSONA VALUES (3001, 'Laura Mendoza', 'Mexicana', DATE '1992-04-15');
INSERT INTO PERSONA VALUES (3002, 'Sofia Herrera', 'Chilena', DATE '1990-08-30');


-- ============================================================
-- 9. VINCULACION_SELECCION
-- ============================================================

-- Colombia
INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (1, 1001, 1, 'S', 9, 'DELANTERO', 'JUGADOR', 'Club Andino');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (2, 1002, 1, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Deportivo Capital');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (3, 1003, 1, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);

-- Argentina
INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (4, 1101, 2, 'S', 9, 'DELANTERO', 'JUGADOR', 'Atletico del Plata');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (5, 1102, 2, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Buenos Aires FC');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (6, 1103, 2, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);

-- Espana
INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (7, 1201, 3, 'S', 9, 'DELANTERO', 'JUGADOR', 'Madrid Deportivo');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (8, 1202, 3, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Club Mediterraneo');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (9, 1203, 3, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);

-- Francia
INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (10, 1301, 4, 'S', 9, 'DELANTERO', 'JUGADOR', 'Paris Athletic');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (11, 1302, 4, 'N', 10, 'MEDIOCAMPISTA', 'JUGADOR', 'Lyon Sport');

INSERT INTO VINCULACION_SELECCION
    (id_vinculacion, id_persona, id_seleccion, capitan, dorsal, posicion, rol, club)
VALUES
    (12, 1303, 4, NULL, NULL, NULL, 'DIRECTOR_TECNICO', NULL);


-- ============================================================
-- 10. PARTIDO
-- Los partidos 1 y 2 son de grupos.
-- El partido 3 es la final y recibe a los ganadores de los partidos 1 y 2.
-- ============================================================

INSERT INTO PARTIDO
    (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2,
     fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2)
VALUES
    (1, 2, 1, NULL, NULL,
     TO_DATE('2026-06-15 18:00', 'YYYY-MM-DD HH24:MI'),
     76000, 'FINALIZADO', NULL, NULL);

INSERT INTO PARTIDO
    (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2,
     fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2)
VALUES
    (2, 3, 2, NULL, NULL,
     TO_DATE('2026-06-16 20:00', 'YYYY-MM-DD HH24:MI'),
     61000, 'FINALIZADO', NULL, NULL);

INSERT INTO PARTIDO
    (id_partido, id_etapa, id_estadio, id_partido_origen_1, id_partido_origen_2,
     fecha_hora, asistencia_registrada, estado, resultado_origen_1, resultado_origen_2)
VALUES
    (3, 5, 3, 1, 2,
     TO_DATE('2026-07-19 18:00', 'YYYY-MM-DD HH24:MI'),
     85000, 'FINALIZADO', 'GANADOR', 'GANADOR');


-- ============================================================
-- 11. PARTICIPACION_PARTIDO
-- ============================================================

-- Partido 1: Colombia 2 - 0 Argentina
INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (1, 1, 1, 'LOCAL', 2, 0, 'GANO');

INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (2, 1, 2, 'VISITANTE', 0, 0, 'PERDIO');

-- Partido 2: Espana 1 - 0 Francia
INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (3, 2, 3, 'LOCAL', 1, 0, 'GANO');

INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (4, 2, 4, 'VISITANTE', 0, 0, 'PERDIO');

-- Partido 3: Colombia 2 - 1 Espana
INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (5, 3, 1, 'LOCAL', 2, 0, 'GANO');

INSERT INTO PARTICIPACION_PARTIDO
    (id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado)
VALUES
    (6, 3, 3, 'VISITANTE', 1, 0, 'PERDIO');


-- ============================================================
-- 12. ASIGNACION_ARBITRAL
-- ============================================================

-- Partido 1
INSERT INTO ASIGNACION_ARBITRAL VALUES (1, 1, 2001, 'CENTRAL');
INSERT INTO ASIGNACION_ARBITRAL VALUES (2, 1, 2002, 'ASISTENTE_1');
INSERT INTO ASIGNACION_ARBITRAL VALUES (3, 1, 2003, 'VAR');

-- Partido 2
INSERT INTO ASIGNACION_ARBITRAL VALUES (4, 2, 2004, 'CENTRAL');
INSERT INTO ASIGNACION_ARBITRAL VALUES (5, 2, 2005, 'ASISTENTE_1');
INSERT INTO ASIGNACION_ARBITRAL VALUES (6, 2, 2001, 'VAR');

-- Partido 3
INSERT INTO ASIGNACION_ARBITRAL VALUES (7, 3, 2002, 'CENTRAL');
INSERT INTO ASIGNACION_ARBITRAL VALUES (8, 3, 2004, 'ASISTENTE_1');
INSERT INTO ASIGNACION_ARBITRAL VALUES (9, 3, 2005, 'VAR');


-- ============================================================
-- 13. EVENTO_PARTIDO
-- Los eventos de gol coinciden con los marcadores registrados.
-- ============================================================

-- Partido 1: dos goles de Colombia
INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (1, 1, 1001, NULL, 'GOL', 25, NULL, 'Primer gol de Colombia');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (2, 1, 1002, NULL, 'GOL', 67, NULL, 'Segundo gol de Colombia');

-- Partido 2: un gol de Espana
INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (3, 2, 1201, NULL, 'GOL', 54, NULL, 'Gol de Espana');

-- Partido 3: Colombia 2 - 1 Espana
INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (4, 3, 1001, NULL, 'GOL', 18, NULL, 'Gol de Colombia en la final');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (5, 3, 1201, NULL, 'GOL', 41, NULL, 'Gol del empate de Espana');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (6, 3, 1002, NULL, 'GOL', 78, NULL, 'Gol definitivo de Colombia');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (7, 3, 1202, NULL, 'TARJETA_AMARILLA', 63, NULL, 'Amonestacion por falta');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (8, 3, 1202, 1201, 'SUSTITUCION', 70, NULL, 'Cambio realizado por Espana');

INSERT INTO EVENTO_PARTIDO
    (id_evento, id_partido, id_persona, id_persona_relacionada, tipo_evento, minuto, valor_numerico, descripcion)
VALUES
    (9, 3, 1001, NULL, 'MINUTOS_JUGADOS', NULL, 90, 'Minutos disputados por el jugador');


-- ============================================================
-- 14. ENTRADA
-- ============================================================

INSERT INTO ENTRADA VALUES (1, 1, 'CATEGORIA_1', 'ORIENTAL', 150.00, 'VENDIDA');
INSERT INTO ENTRADA VALUES (2, 1, 'CATEGORIA_2', 'OCCIDENTAL', 95.50, 'DISPONIBLE');

INSERT INTO ENTRADA VALUES (3, 2, 'CATEGORIA_1', 'CENTRAL', 180.00, 'VENDIDA');
INSERT INTO ENTRADA VALUES (4, 2, 'CATEGORIA_2', 'NORTE', 110.00, 'DISPONIBLE');

INSERT INTO ENTRADA VALUES (5, 3, 'CATEGORIA_1', 'VIP', 1200.00, 'VENDIDA');
INSERT INTO ENTRADA VALUES (6, 3, 'CATEGORIA_2', 'GENERAL', 450.00, 'VENDIDA');


-- ============================================================
-- 15. ACREDITACION_PRENSA
-- Nota: se usa el nombre exacto de la columna del DDL: medio_comunicacio.
-- ============================================================

INSERT INTO ACREDITACION_PRENSA
    (id_acreditacion, id_persona, id_edicion, medio_comunicacio,
     fecha_emision, tipo_acreditacion, estado)
VALUES
    (1, 3001, 1, 'Noticias Globales',
     DATE '2026-06-01', 'PRENSA_ESCRITA', 'ACTIVA');

INSERT INTO ACREDITACION_PRENSA
    (id_acreditacion, id_persona, id_edicion, medio_comunicacio,
     fecha_emision, tipo_acreditacion, estado)
VALUES
    (2, 3002, 1, 'Deportes Internacional',
     DATE '2026-06-02', 'TELEVISION', 'ACTIVA');


-- ============================================================
-- 16. AUDITORIA
-- Registros ficticios para probar la tabla de trazabilidad.
-- ============================================================

INSERT INTO AUDITORIA
    (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado,
     operacion, fecha_hora, valor_anterior, valor_nuevo)
VALUES
    (1, 'USUARIO_PRUEBA_1', 'PARTIDO', 3,
     'INSERT', TIMESTAMP '2026-07-01 10:00:00',
     NULL, 'Creacion del partido final');

INSERT INTO AUDITORIA
    (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado,
     operacion, fecha_hora, valor_anterior, valor_nuevo)
VALUES
    (2, 'USUARIO_PRUEBA_2', 'PARTIDO', 3,
     'UPDATE', TIMESTAMP '2026-07-19 21:00:00',
     'estado=PROGRAMADO', 'estado=FINALIZADO');

INSERT INTO AUDITORIA
    (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado,
     operacion, fecha_hora, valor_anterior, valor_nuevo)
VALUES
    (3, 'USUARIO_PRUEBA_1', 'ENTRADA', 5,
     'UPDATE', TIMESTAMP '2026-07-10 12:30:00',
     'estado=DISPONIBLE', 'estado=VENDIDA');


COMMIT;

-- ============================================================
-- CONSULTAS DE VERIFICACION RAPIDA
-- ============================================================

SELECT COUNT(*) AS total_ediciones FROM EDICION_MUNDIAL;
SELECT COUNT(*) AS total_sedes FROM SEDE;
SELECT COUNT(*) AS total_ciudades FROM CIUDAD;
SELECT COUNT(*) AS total_estadios FROM Estadio;
SELECT COUNT(*) AS total_etapas FROM ETAPA_COMPETENCIA;
SELECT COUNT(*) AS total_organizaciones FROM ORGANIZACIONES_FUTBOL;
SELECT COUNT(*) AS total_selecciones FROM SELECCION;
SELECT COUNT(*) AS total_personas FROM PERSONA;
SELECT COUNT(*) AS total_vinculaciones FROM VINCULACION_SELECCION;
SELECT COUNT(*) AS total_partidos FROM PARTIDO;
SELECT COUNT(*) AS total_participaciones FROM PARTICIPACION_PARTIDO;
SELECT COUNT(*) AS total_asignaciones FROM ASIGNACION_ARBITRAL;
SELECT COUNT(*) AS total_eventos FROM EVENTO_PARTIDO;
SELECT COUNT(*) AS total_entradas FROM ENTRADA;
SELECT COUNT(*) AS total_acreditaciones FROM ACREDITACION_PRENSA;
SELECT COUNT(*) AS total_auditorias FROM AUDITORIA;
