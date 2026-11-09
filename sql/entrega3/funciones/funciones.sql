-- Función diferencia de gol
select *
from seleccion;
select *
from participacion_partido;



CREATE OR REPLACE FUNCTION fn_diferencia_gol (
    p_id_seleccion IN NUMBER
) RETURN NUMBER IS
    v_existe NUMBER;
    v_dif    NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM seleccion
    WHERE id_seleccion = p_id_seleccion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La selección no existe');
    END IF;

    SELECT NVL(SUM(pp.goles - rival.goles), 0)
    INTO v_dif
    FROM participacion_partido pp
    JOIN participacion_partido rival ON rival.id_partido = pp.id_partido
                                    AND rival.id_seleccion <> pp.id_seleccion
    JOIN partido p ON p.id_partido = pp.id_partido
    WHERE pp.id_seleccion = p_id_seleccion
      AND p.estado = 'FINALIZADO';

    RETURN v_dif;
END fn_diferencia_gol;
/

--prueba
SELECT s.codigo_fifa, fn_diferencia_gol(s.id_seleccion) dif_gol
FROM seleccion s
ORDER BY dif_gol DESC;

-- función ranking goleadores

CREATE OR REPLACE FUNCTION fn_ranking_goleadores (p_id_edicion IN NUMBER, p_top IN NUMBER DEFAULT 3) RETURN VARCHAR2 IS
    v_existe    NUMBER;
    v_resultado VARCHAR2(4000) := '';
    v_posicion  NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM edicion_mundial
    WHERE id_edicion = p_id_edicion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'La edición no existe');
    END IF;

    IF p_top IS NULL OR p_top < 1 THEN
        RAISE_APPLICATION_ERROR(-20003, 'p_top debe ser mayor o igual a 1');
    END IF;

    FOR r IN (
        SELECT *
        FROM (
            SELECT pers.nombre_completo,
                   s.codigo_fifa pais,
                   COUNT(*) goles
            FROM etapa_competencia ec
            JOIN partido p            ON p.id_etapa = ec.id_etapa
            JOIN evento_partido ep    ON ep.id_partido = p.id_partido
            JOIN persona pers         ON pers.id_persona = ep.id_persona
            JOIN vinculacion_seleccion vs ON vs.id_persona = pers.id_persona
            JOIN seleccion s          ON s.id_seleccion = vs.id_seleccion
            JOIN etapa_competencia eg ON eg.id_etapa = s.id_etapa_grupo
                                     AND eg.id_edicion = ec.id_edicion
            WHERE ec.id_edicion = p_id_edicion
              AND ep.tipo_evento = 'GOL'
            GROUP BY pers.id_persona, pers.nombre_completo, s.codigo_fifa
            ORDER BY goles DESC, pers.nombre_completo
        )
        WHERE ROWNUM <= p_top
    ) LOOP
        v_posicion  := v_posicion + 1;
        v_resultado := v_resultado || v_posicion || '. ' || r.nombre_completo
                       || ' (' || r.pais || ') - ' || r.goles || ' goles ' || CHR(10);
    END LOOP;

    IF v_posicion = 0 THEN
        RETURN 'Sin goles registrados';
    END IF;

    RETURN RTRIM(v_resultado, CHR(10));
END fn_ranking_goleadores;
/
SELECT em.nombre mundial,
       fn_ranking_goleadores(em.id_edicion, 3) top_goleadores
FROM edicion_mundial em;



-- validación convocatoria

CREATE OR REPLACE FUNCTION fn_validar_cupo_convocatoria (
    p_id_seleccion IN NUMBER,
    p_cupo_maximo  IN NUMBER DEFAULT 26
) RETURN NUMBER IS
    v_existe     NUMBER;
    v_convocados NUMBER;
BEGIN
    IF p_cupo_maximo IS NULL OR p_cupo_maximo < 1 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El cupo máximo debe ser mayor o igual a 1');
    END IF;

    SELECT COUNT(*) INTO v_existe
    FROM seleccion
    WHERE id_seleccion = p_id_seleccion;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'La selección no existe');
    END IF;

    SELECT COUNT(*) INTO v_convocados
    FROM vinculacion_seleccion
    WHERE id_seleccion = p_id_seleccion
      AND rol = 'JUGADOR';

    IF v_convocados <= p_cupo_maximo THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END fn_validar_cupo_convocatoria;
/

--Selecciones con convocatoria que excede
SELECT s.codigo_fifa
FROM seleccion s
WHERE fn_validar_cupo_convocatoria(s.id_seleccion, 26) = 0;

