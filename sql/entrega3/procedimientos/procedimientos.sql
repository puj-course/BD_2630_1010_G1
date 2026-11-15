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
