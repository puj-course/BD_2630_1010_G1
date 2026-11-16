
-- ===================================================
-- TRIGGERS SOBRE AUDITORIA
-- ===================================================
CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1; 

-- Trigger de auditoria para PARTIDO
CREATE OR REPLACE TRIGGER trg_auditar_partido 
AFTER INSERT OR DELETE OR UPDATE ON PARTIDO
FOR EACH ROW 
DECLARE 
    v_operacion VARCHAR(10); 
    v_id_registro INTEGER; 
    v_viejo CLOB;
    v_nuevo CLOB; 
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_id_registro := :new.id_partido;
        v_nuevo := 'id_partido: ' || :new.id_partido || 
                   ', id_etapa: ' || :new.id_etapa || 
                   ', id_estadio: ' || :new.id_estadio || 
                   ', id_partido_origen_1: ' || :new.id_partido_origen_1 || 
                   ', id_partido_origen_2: ' || :new.id_partido_origen_2 || 
                   ', fecha_hora: ' || TO_CHAR(:new.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                   ', asistencia: ' || :new.asistencia_registrada || 
                   ', estado: ' || :new.estado || 
                   ', res_origen_1: ' || :new.resultado_origen_1 || 
                   ', res_origen_2: ' || :new.resultado_origen_2;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_id_registro := :new.id_partido;
        v_viejo := 'id_partido: ' || :old.id_partido || 
                   ', id_etapa: ' || :old.id_etapa || 
                   ', id_estadio: ' || :old.id_estadio || 
                   ', id_partido_origen_1: ' || :old.id_partido_origen_1 || 
                   ', id_partido_origen_2: ' || :old.id_partido_origen_2 || 
                   ', fecha_hora: ' || TO_CHAR(:old.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                   ', asistencia: ' || :old.asistencia_registrada || 
                   ', estado: ' || :old.estado || 
                   ', res_origen_1: ' || :old.resultado_origen_1 || 
                   ', res_origen_2: ' || :old.resultado_origen_2;
                   
        v_nuevo := 'id_partido: ' || :new.id_partido || 
                   ', id_etapa: ' || :new.id_etapa || 
                   ', id_estadio: ' || :new.id_estadio || 
                   ', id_partido_origen_1: ' || :new.id_partido_origen_1 || 
                   ', id_partido_origen_2: ' || :new.id_partido_origen_2 || 
                   ', fecha_hora: ' || TO_CHAR(:new.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                   ', asistencia: ' || :new.asistencia_registrada || 
                   ', estado: ' || :new.estado || 
                   ', res_origen_1: ' || :new.resultado_origen_1 || 
                   ', res_origen_2: ' || :new.resultado_origen_2;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_id_registro := :old.id_partido;
        v_viejo := 'id_partido: ' || :old.id_partido || 
                   ', id_etapa: ' || :old.id_etapa || 
                   ', id_estadio: ' || :old.id_estadio || 
                   ', id_partido_origen_1: ' || :old.id_partido_origen_1 || 
                   ', id_partido_origen_2: ' || :old.id_partido_origen_2 || 
                   ', fecha_hora: ' || TO_CHAR(:old.fecha_hora, 'YYYY-MM-DD HH24:MI:SS') || 
                   ', asistencia: ' || :old.asistencia_registrada || 
                   ', estado: ' || :old.estado || 
                   ', res_origen_1: ' || :old.resultado_origen_1 || 
                   ', res_origen_2: ' || :old.resultado_origen_2;
    END IF;

    INSERT INTO AUDITORIA (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) 
    VALUES (seq_auditoria.NEXTVAL, USER, 'PARTIDO', v_id_registro, v_operacion, SYSTIMESTAMP, v_viejo, v_nuevo);
END;

-- Trigger de auditoria para PARTICIPACION PARTIDO 
CREATE OR REPLACE TRIGGER trg_auditar_participacion
AFTER INSERT OR UPDATE OR DELETE ON PARTICIPACION_PARTIDO
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_id_registro INTEGER;
    v_viejo CLOB;
    v_nuevo CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_id_registro := :new.id_participacion_partido;
        v_nuevo := 'id_participacion: ' || :new.id_participacion_partido || 
                   ', id_partido: ' || :new.id_partido || 
                   ', id_seleccion: ' || :new.id_seleccion || 
                   ', condicion: ' || :new.condicion || 
                   ', goles: ' || :new.goles || 
                   ', goles_penales: ' || :new.goles_penales || 
                   ', resultado: ' || :new.resultado;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_id_registro := :new.id_participacion_partido;
        v_viejo := 'id_participacion: ' || :old.id_participacion_partido || 
                   ', id_partido: ' || :old.id_partido || 
                   ', id_seleccion: ' || :old.id_seleccion || 
                   ', condicion: ' || :old.condicion || 
                   ', goles: ' || :old.goles || 
                   ', goles_penales: ' || :old.goles_penales || 
                   ', resultado: ' || :old.resultado;
                   
        v_nuevo := 'id_participacion: ' || :new.id_participacion_partido || 
                   ', id_partido: ' || :new.id_partido || 
                   ', id_seleccion: ' || :new.id_seleccion || 
                   ', condicion: ' || :new.condicion || 
                   ', goles: ' || :new.goles || 
                   ', goles_penales: ' || :new.goles_penales || 
                   ', resultado: ' || :new.resultado;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_id_registro := :old.id_participacion_partido;
        v_viejo := 'id_participacion: ' || :old.id_participacion_partido || 
                   ', id_partido: ' || :old.id_partido || 
                   ', id_seleccion: ' || :old.id_seleccion || 
                   ', condicion: ' || :old.condicion || 
                   ', goles: ' || :old.goles || 
                   ', goles_penales: ' || :old.goles_penales || 
                   ', resultado: ' || :old.resultado;
    END IF;

    INSERT INTO AUDITORIA (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) 
    VALUES (seq_auditoria.NEXTVAL, USER, 'PARTICIPACION_PARTIDO', v_id_registro, v_operacion, SYSTIMESTAMP, v_viejo, v_nuevo);
END;
/

-- Trigger de auditoria para EVENTO PARTIDO
CREATE OR REPLACE TRIGGER trg_auditar_evento
AFTER INSERT OR UPDATE OR DELETE ON EVENTO_PARTIDO
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_id_registro INTEGER;
    v_viejo CLOB;
    v_nuevo CLOB;
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_id_registro := :new.id_evento;
        v_nuevo := 'id_evento: ' || :new.id_evento || 
                   ', id_partido: ' || :new.id_partido || 
                   ', id_persona: ' || :new.id_persona || 
                   ', id_persona_relacionada: ' || :new.id_persona_relacionada || 
                   ', tipo_evento: ' || :new.tipo_evento || 
                   ', minuto: ' || :new.minuto || 
                   ', valor_numerico: ' || :new.valor_numerico || 
                   ', descripcion: ' || :new.descripcion;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_id_registro := :new.id_evento;
        v_viejo := 'id_evento: ' || :old.id_evento || 
                   ', id_partido: ' || :old.id_partido || 
                   ', id_persona: ' || :old.id_persona || 
                   ', id_persona_relacionada: ' || :old.id_persona_relacionada || 
                   ', tipo_evento: ' || :old.tipo_evento || 
                   ', minuto: ' || :old.minuto || 
                   ', valor_numerico: ' || :old.valor_numerico || 
                   ', descripcion: ' || :old.descripcion;
                   
        v_nuevo := 'id_evento: ' || :new.id_evento || 
                   ', id_partido: ' || :new.id_partido || 
                   ', id_persona: ' || :new.id_persona || 
                   ', id_persona_relacionada: ' || :new.id_persona_relacionada || 
                   ', tipo_evento: ' || :new.tipo_evento || 
                   ', minuto: ' || :new.minuto || 
                   ', valor_numerico: ' || :new.valor_numerico || 
                   ', descripcion: ' || :new.descripcion;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_id_registro := :old.id_evento;
        v_viejo := 'id_evento: ' || :old.id_evento || 
                   ', id_partido: ' || :old.id_partido || 
                   ', id_persona: ' || :old.id_persona || 
                   ', id_persona_relacionada: ' || :old.id_persona_relacionada || 
                   ', tipo_evento: ' || :old.tipo_evento || 
                   ', minuto: ' || :old.minuto || 
                   ', valor_numerico: ' || :old.valor_numerico || 
                   ', descripcion: ' || :old.descripcion;
    END IF;

    INSERT INTO AUDITORIA (id_auditoria, usuario_bd, tabla_afectada, id_registro_afectado, operacion, fecha_hora, valor_anterior, valor_nuevo) 
    VALUES (seq_auditoria.NEXTVAL, USER, 'EVENTO_PARTIDO', v_id_registro, v_operacion, SYSTIMESTAMP, v_viejo, v_nuevo);
END;
/

-- ===================================================
-- TRIGGERS PARA VAIDAR GOLES Y ASISTENCIA POSITIVAS
-- ===================================================

CREATE OR REPLACE TRIGGER trg_valida_eventos_positivos
BEFORE INSERT OR UPDATE ON EVENTO_PARTIDO
FOR EACH ROW
BEGIN
    -- Valida que si el evento es un GOL o ASISTENCIA el valor no sea negativo.
    IF :NEW.tipo_evento IN ('GOL', 'ASISTENCIA', 'MINUTOS_JUGADOS') THEN
        IF :NEW.valor_numerico < 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error: El valor para goles o asistencias no puede ser negativo.');
        END IF;
    END IF;
    
    -- Valida que el minuto de juego no sea negativo
    IF :NEW.minuto < 0 THEN
         RAISE_APPLICATION_ERROR(-20002, 'Error: El minuto del evento no puede ser negativo.');
    END IF;
END;
/

-- Trigger para asistencia
CREATE OR REPLACE TRIGGER trg_valida_asistencia_estadio
BEFORE INSERT OR UPDATE ON PARTIDO
FOR EACH ROW
BEGIN
    IF :new.asistencia_registrada < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: La asistencia de público no puede ser negativa.');
    END IF;
END;
/
-- ===================================================
-- TRIGGER SOBRE PARTICIPANTES DUPLICADOS EN UN PARTIDO 
-- ===================================================
CREATE OR REPLACE TRIGGER trg_anti_duplicidad_participacion
BEFORE INSERT OR UPDATE ON PARTICIPACION_PARTIDO
FOR EACH ROW
DECLARE
    v_conteo INTEGER;
BEGIN
    -- Validamos si la misma selección ya está registrada en el mismo partido
    SELECT COUNT(*)
    INTO v_conteo
    FROM PARTICIPACION_PARTIDO
    WHERE id_partido = :NEW.id_partido
      AND id_seleccion = :NEW.id_seleccion
      AND id_participacion_partido != NVL(:NEW.id_participacion_partido, -1); 

    IF v_conteo > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No duplicados: La selección ya se encuentra registrada participando en este partido.');
    END IF;
    
    -- Validamos que no se repitan condiciones.
    SELECT COUNT(*)
    INTO v_conteo
    FROM PARTICIPACION_PARTIDO
    WHERE id_partido = :NEW.id_partido
      AND condicion = :NEW.condicion
      AND id_participacion_partido != NVL(:NEW.id_participacion_partido, -1);

    IF v_conteo > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'No duplicados: Ya existe un equipo con la condición ' || :NEW.condicion || ' en este partido.');
    END IF;
END;
/   

-- ===================================================
-- MARCADOR OFICIAL VS. SUMA DE GOLES INDIVIDUALES
-- ===================================================

CREATE OR REPLACE TRIGGER trg_verifica_consistencia
BEFORE INSERT OR UPDATE OF goles ON PARTICIPACION_PARTIDO
FOR EACH ROW
DECLARE
    v_goles_individuales INTEGER;
BEGIN
    -- Contar los goles registrados individualmente a favor de esta selección en este partido específico
    SELECT COUNT(*)
    INTO v_goles_individuales
    FROM EVENTO_PARTIDO ep
    JOIN VINCULACION_SELECCION vs ON ep.id_persona = vs.id_persona
    JOIN ETAPA_COMPETENCIA ec ON vs.id_edicion = ec.id_edicion
    JOIN PARTIDO p ON p.id_etapa = ec.id_etapa AND p.id_partido = ep.id_partido
    WHERE ep.id_partido = :NEW.id_partido
      AND ep.tipo_evento = 'GOL'
      AND vs.id_seleccion = :NEW.id_seleccion;

    -- Verificar si el marcador que intentan guardar coincide con el conteo de eventos
    IF :NEW.goles != v_goles_individuales THEN
        RAISE_APPLICATION_ERROR(
            -20004, 
            'Inconsistencia: Los goles del marcador oficial (' || :NEW.goles || 
            ') no coinciden con la suma de goles individuales (' || v_goles_individuales || ').'
        );
    END IF;
END;
/






