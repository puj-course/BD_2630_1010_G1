-- Procedimiento carga masiva de resultados partidos
 /**CREATE TABLE carga_resultados (
    id_carga            NUMBER        PRIMARY KEY,
    id_partido          NUMBER        NOT NULL,
    goles_local         NUMBER,
    goles_visitante     NUMBER,
    penales_local       NUMBER        DEFAULT 0 NOT NULL,
    penales_visitante   NUMBER        DEFAULT 0 NOT NULL,
    estado_carga        VARCHAR2(10)  DEFAULT 'PENDIENTE' NOT NULL,
    mensaje_error       VARCHAR2(300)
);
*/
-- drop table carga_resultados;

CREATE OR REPLACE PROCEDURE sp_carga_masiva_resultados (
    p_commit_cada      IN  NUMBER DEFAULT 100,
    p_detener_en_error IN  NUMBER DEFAULT 0,
    p_procesados       OUT NUMBER,
    p_cargados         OUT NUMBER,
    p_errores          OUT NUMBER
) IS
    v_existe     NUMBER;
    v_estado     VARCHAR2(30);
    v_locales    NUMBER;
    v_visitantes NUMBER;
    v_res_local  VARCHAR2(10);
    v_res_visit  VARCHAR2(10);
    v_en_lote    NUMBER := 0;
    v_msg        VARCHAR2(300);
BEGIN
    IF p_commit_cada IS NULL OR p_commit_cada < 1 THEN
        RAISE_APPLICATION_ERROR(-20010, 'p_commit_cada debe ser mayor o igual a 1');
    END IF;

    IF p_detener_en_error IS NULL OR p_detener_en_error NOT IN (0, 1) THEN
        RAISE_APPLICATION_ERROR(-20016, 'p_detener_en_error debe ser 0 o 1');
    END IF;

    p_procesados := 0;
    p_cargados   := 0;
    p_errores    := 0;

    FOR r IN (
        SELECT id_carga, id_partido, goles_local, goles_visitante,
               penales_local, penales_visitante
        FROM carga_resultados
        WHERE estado_carga = 'PENDIENTE'
        ORDER BY id_carga
    ) LOOP
        p_procesados := p_procesados + 1;
        SAVEPOINT sp_fila;

        BEGIN
            -- Validaciones
            SELECT COUNT(*) INTO v_existe
            FROM partido
            WHERE id_partido = r.id_partido;

            IF v_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20011, 'El partido no existe');
            END IF;

            SELECT estado INTO v_estado
            FROM partido
            WHERE id_partido = r.id_partido;

            IF v_estado = 'FINALIZADO' THEN
                RAISE_APPLICATION_ERROR(-20012, 'El partido ya tiene resultado cargado');
            END IF;

            IF r.goles_local IS NULL OR r.goles_visitante IS NULL
               OR r.goles_local < 0 OR r.goles_visitante < 0 THEN
                RAISE_APPLICATION_ERROR(-20013, 'Goles nulos o negativos');
            END IF;

            IF r.penales_local < 0 OR r.penales_visitante < 0
               OR (r.goles_local <> r.goles_visitante
                   AND (r.penales_local > 0 OR r.penales_visitante > 0)) THEN
                RAISE_APPLICATION_ERROR(-20014, 'Penales inválidos para este marcador');
            END IF;

            SELECT COUNT(*) INTO v_locales
            FROM participacion_partido
            WHERE id_partido = r.id_partido AND condicion = 'LOCAL';

            SELECT COUNT(*) INTO v_visitantes
            FROM participacion_partido
            WHERE id_partido = r.id_partido AND condicion = 'VISITANTE';

            IF v_locales <> 1 OR v_visitantes <> 1 THEN
                RAISE_APPLICATION_ERROR(-20015, 'El partido no tiene un local y un visitante');
            END IF;

            -- Resultado de cada equipo
            IF r.goles_local > r.goles_visitante THEN
                v_res_local := 'GANO';    v_res_visit := 'PERDIO';
            ELSIF r.goles_local < r.goles_visitante THEN
                v_res_local := 'PERDIO';  v_res_visit := 'GANO';
            ELSIF r.penales_local > r.penales_visitante THEN
                v_res_local := 'GANO';    v_res_visit := 'PERDIO';
            ELSIF r.penales_local < r.penales_visitante THEN
                v_res_local := 'PERDIO';  v_res_visit := 'GANO';
            ELSE
                v_res_local := 'EMPATO';  v_res_visit := 'EMPATO';
            END IF;

            -- Aplicar cambios
            UPDATE participacion_partido
            SET goles = r.goles_local,
                goles_penales = r.penales_local,
                resultado = v_res_local
            WHERE id_partido = r.id_partido AND condicion = 'LOCAL';

            UPDATE participacion_partido
            SET goles = r.goles_visitante,
                goles_penales = r.penales_visitante,
                resultado = v_res_visit
            WHERE id_partido = r.id_partido AND condicion = 'VISITANTE';

            UPDATE partido
            SET estado = 'FINALIZADO'
            WHERE id_partido = r.id_partido;

            UPDATE carga_resultados
            SET estado_carga = 'CARGADO', mensaje_error = NULL
            WHERE id_carga = r.id_carga;

            p_cargados := p_cargados + 1;
            v_en_lote  := v_en_lote + 1;

            IF v_en_lote >= p_commit_cada THEN
                COMMIT;
                v_en_lote := 0;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                v_msg := SUBSTR(SQLERRM, 1, 300);
                ROLLBACK TO sp_fila;

                UPDATE carga_resultados
                SET estado_carga = 'ERROR', mensaje_error = v_msg
                WHERE id_carga = r.id_carga;

                p_errores := p_errores + 1;
        END;

        EXIT WHEN p_errores > 0 AND p_detener_en_error = 1;
    END LOOP;

    COMMIT;
END sp_carga_masiva_resultados;
/

select *
from participacion_partido;

-- cargar los resultados en la tabla de paso
INSERT INTO carga_resultados (id_carga, id_partido, goles_local, goles_visitante)
VALUES (1, 1, 2, 1);

INSERT INTO carga_resultados (id_carga, id_partido, goles_local, goles_visitante,
                              penales_local, penales_visitante)
VALUES (2, 2, 1, 1, 4, 3);

INSERT INTO carga_resultados (id_carga, id_partido, goles_local, goles_visitante)
VALUES (3, 13, 0, 0);   -- partido inexistente: será rechazado

COMMIT;

-- ejecutar el procedimiento
SET SERVEROUTPUT ON
DECLARE
    v_proc NUMBER;
    v_ok   NUMBER;
    v_err  NUMBER;
BEGIN
    sp_carga_masiva_resultados(50, 0, v_proc, v_ok, v_err);
    DBMS_OUTPUT.PUT_LINE('Procesados: ' || v_proc ||
                         ' | Cargados: ' || v_ok ||
                         ' | Errores: '   || v_err);
END;
/

-- revisar las filas rechazadas
SELECT id_carga, id_partido, mensaje_error
FROM carga_resultados
WHERE estado_carga = 'ERROR';

-- reintentar una fila corregida
UPDATE carga_resultados
SET id_partido = 3, estado_carga = 'PENDIENTE', mensaje_error = NULL
WHERE id_carga = 3;
COMMIT;


---==================================================================
--- Procedimeinto para Actualización Automatica de la tabla de posiciones por grupo
---==================================================================

CREATE OR REPLACE PROCEDURE prc_actualizar_tabla_posiciones (
    p_id_etapa_grupo IN ETAPA_COMPETENCIA.id_etapa%TYPE
) IS
    v_tipo_etapa ETAPA_COMPETENCIA.tipo_etapa%TYPE;
BEGIN
    
    SELECT tipo_etapa INTO v_tipo_etapa
    FROM ETAPA_COMPETENCIA
    WHERE id_etapa = p_id_etapa_grupo;

    IF v_tipo_etapa != 'GRUPO' THEN
        RAISE_APPLICATION_ERROR(-20010, 'Error: La etapa indicada (' || p_id_etapa_grupo || ') no es de tipo GRUPO.');
    END IF;

    FOR r_partido IN (
        SELECT id_partido 
        FROM PARTIDO 
        WHERE id_etapa = p_id_etapa_grupo 
          AND estado = 'FINALIZADO'
    ) LOOP
        UPDATE PARTICIPACION_PARTIDO pp1
        SET resultado = (
            SELECT CASE 
                WHEN pp1.goles > pp2.goles THEN 'GANO'
                WHEN pp1.goles < pp2.goles THEN 'PERDIO'
                ELSE 'EMPATO'
            END
            FROM PARTICIPACION_PARTIDO pp2
            WHERE pp2.id_partido = pp1.id_partido
              AND pp2.id_seleccion != pp1.id_seleccion
        )
        WHERE pp1.id_partido = r_partido.id_partido;
    END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('=========================================================================');
    DBMS_OUTPUT.PUT_LINE('TABLA DE POSICIONES - GRUPO ID: ' || p_id_etapa_grupo);
    DBMS_OUTPUT.PUT_LINE('=========================================================================');
    DBMS_OUTPUT.PUT_LINE('POS | SELECCION | PJ | PG | PE | PP | GF | GC | DG | PTS');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');

    FOR r_pos IN (
        SELECT 
            ROW_NUMBER() OVER (
                ORDER BY 
                    SUM(CASE WHEN p.estado = 'FINALIZADO' THEN 
                        CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END 
                    ELSE 0 END) DESC,
                    SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles - pp_rival.goles ELSE 0 END) DESC,
                    SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles ELSE 0 END) DESC
            ) AS pos,
            s.codigo_fifa,
            COUNT(CASE WHEN p.estado = 'FINALIZADO' THEN 1 END) AS pj,
            SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'GANO' THEN 1 ELSE 0 END) AS pg,
            SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'EMPATO' THEN 1 ELSE 0 END) AS pe,
            SUM(CASE WHEN p.estado = 'FINALIZADO' AND pp.resultado = 'PERDIO' THEN 1 ELSE 0 END) AS pp_perdidos,
            SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles ELSE 0 END) AS gf,
            SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp_rival.goles ELSE 0 END) AS gc,
            SUM(CASE WHEN p.estado = 'FINALIZADO' THEN pp.goles - pp_rival.goles ELSE 0 END) AS dg,
            SUM(CASE WHEN p.estado = 'FINALIZADO' THEN 
                CASE pp.resultado WHEN 'GANO' THEN 3 WHEN 'EMPATO' THEN 1 ELSE 0 END 
            ELSE 0 END) AS pts
        FROM SELECCION s
        LEFT JOIN PARTICIPACION_PARTIDO pp ON s.id_seleccion = pp.id_seleccion
        LEFT JOIN PARTIDO p ON pp.id_partido = p.id_partido AND p.id_etapa = p_id_etapa_grupo
        LEFT JOIN PARTICIPACION_PARTIDO pp_rival ON p.id_partido = pp_rival.id_partido 
                                                AND pp_rival.id_seleccion != s.id_seleccion
        WHERE s.id_etapa_grupo = p_id_etapa_grupo
        GROUP BY s.id_seleccion, s.codigo_fifa
        ORDER BY pos
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            r_pos.pos || ' | ' || 
            r_pos.codigo_fifa || ' | ' || 
            r_pos.pj || ' | ' || 
            r_pos.pg || ' | ' || 
            r_pos.pe || ' | ' || 
            r_pos.pp_perdidos || ' | ' || 
            r_pos.gf || ' | ' || 
            r_pos.gc || ' | ' || 
            r_pos.dg || ' | ' || 
            r_pos.pts
        );
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=========================================================================');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'Error: No existe una etapa registrada con el ID ' || p_id_etapa_grupo || '.');
END;
/

---==================================================================
--- Cierre de fase (avance automático de selecciones clasificadas).
---==================================================================

CREATE OR REPLACE PROCEDURE prc_cerrar_fase_y_avanzar (
    p_id_etapa_actual IN ETAPA_COMPETENCIA.id_etapa%TYPE
) IS
    v_partidos_pendientes INTEGER;
    v_total_partidos      INTEGER;
    v_id_seleccion_1      SELECCION.id_seleccion%TYPE;
    v_id_seleccion_2      SELECCION.id_seleccion%TYPE;
    v_nuevo_id_part       PARTICIPACION_PARTIDO.id_participacion_partido%TYPE;
    v_existe              INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_total_partidos
    FROM PARTIDO
    WHERE id_etapa = p_id_etapa_actual;

    IF v_total_partidos = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Error: La etapa indicada no tiene partidos registrados.');
    END IF;

    SELECT COUNT(*) INTO v_partidos_pendientes
    FROM PARTIDO
    WHERE id_etapa = p_id_etapa_actual
      AND estado != 'FINALIZADO';

    IF v_partidos_pendientes > 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error: No se puede cerrar la fase. Aún existen ' || v_partidos_pendientes || ' partidos sin finalizar.');
    END IF;

    UPDATE PARTICIPACION_PARTIDO pp1
    SET resultado = (
        SELECT CASE 
            WHEN pp1.goles > pp2.goles THEN 'GANO'
            WHEN pp1.goles < pp2.goles THEN 'PERDIO'
            WHEN pp1.goles = pp2.goles AND pp1.goles_penales > pp2.goles_penales THEN 'GANO'
            WHEN pp1.goles = pp2.goles AND pp1.goles_penales < pp2.goles_penales THEN 'PERDIO'
            ELSE 'EMPATO'
        END
        FROM PARTICIPACION_PARTIDO pp2
        WHERE pp2.id_partido = pp1.id_partido
          AND pp2.id_seleccion != pp1.id_seleccion
    )
    WHERE pp1.id_partido IN (SELECT id_partido FROM PARTIDO WHERE id_etapa = p_id_etapa_actual);

    FOR r_sig IN (
        SELECT id_partido, id_partido_origen_1, resultado_origen_1, id_partido_origen_2, resultado_origen_2
        FROM PARTIDO
        WHERE id_partido_origen_1 IN (SELECT id_partido FROM PARTIDO WHERE id_etapa = p_id_etapa_actual)
           OR id_partido_origen_2 IN (SELECT id_partido FROM PARTIDO WHERE id_etapa = p_id_etapa_actual)
    ) LOOP
        
        IF r_sig.id_partido_origen_1 IS NOT NULL THEN
            BEGIN
                SELECT id_seleccion INTO v_id_seleccion_1
                FROM PARTICIPACION_PARTIDO
                WHERE id_partido = r_sig.id_partido_origen_1
                  AND resultado = DECODE(r_sig.resultado_origen_1, 'GANADOR', 'GANO', 'PERDEDOR', 'PERDIO');

                -- Verificar que no se haya insertado previamente el LOCAL en el partido destino
                SELECT COUNT(*) INTO v_existe
                FROM PARTICIPACION_PARTIDO
                WHERE id_partido = r_sig.id_partido AND condicion = 'LOCAL';

                IF v_existe = 0 THEN
                    SELECT NVL(MAX(id_participacion_partido), 0) + 1 INTO v_nuevo_id_part FROM PARTICIPACION_PARTIDO;
                    
                    INSERT INTO PARTICIPACION_PARTIDO (
                        id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado
                    ) VALUES (
                        v_nuevo_id_part, r_sig.id_partido, v_id_seleccion_1, 'LOCAL', 0, 0, NULL
                    );
                    DBMS_OUTPUT.PUT_LINE('Avance exitoso: Selección ' || v_id_seleccion_1 || ' clasifica como LOCAL al partido ' || r_sig.id_partido);
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Aviso: No se encontró ' || r_sig.resultado_origen_1 || ' definido en el partido origen ' || r_sig.id_partido_origen_1);
            END;
        END IF;

        IF r_sig.id_partido_origen_2 IS NOT NULL THEN
            BEGIN
                SELECT id_seleccion INTO v_id_seleccion_2
                FROM PARTICIPACION_PARTIDO
                WHERE id_partido = r_sig.id_partido_origen_2
                  AND resultado = DECODE(r_sig.resultado_origen_2, 'GANADOR', 'GANO', 'PERDEDOR', 'PERDIO');

                -- Verificar que no se haya insertado previamente el VISITANTE en el partido destino
                SELECT COUNT(*) INTO v_existe
                FROM PARTICIPACION_PARTIDO
                WHERE id_partido = r_sig.id_partido AND condicion = 'VISITANTE';

                IF v_existe = 0 THEN
                    SELECT NVL(MAX(id_participacion_partido), 0) + 1 INTO v_nuevo_id_part FROM PARTICIPACION_PARTIDO;
                    
                    INSERT INTO PARTICIPACION_PARTIDO (
                        id_participacion_partido, id_partido, id_seleccion, condicion, goles, goles_penales, resultado
                    ) VALUES (
                        v_nuevo_id_part, r_sig.id_partido, v_id_seleccion_2, 'VISITANTE', 0, 0, NULL
                    );
                    DBMS_OUTPUT.PUT_LINE('Avance exitoso: Selección ' || v_id_seleccion_2 || ' clasifica como VISITANTE al partido ' || r_sig.id_partido);
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('Aviso: No se encontró ' || r_sig.resultado_origen_2 || ' definido en el partido origen ' || r_sig.id_partido_origen_2);
            END;
        END IF;

    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Cierre de la etapa ' || p_id_etapa_actual || ' completado exitosamente.');
END;
/