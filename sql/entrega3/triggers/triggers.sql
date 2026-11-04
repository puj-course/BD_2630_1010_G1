
-- ===================================================
-- TRIGGERS SOBRE AUDITORIA
-- ===================================================
CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1; 

-- Trigger de Auditoria para PARTIDO
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

-- Trigger de auditoria para participación partido 
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

-- Trigger de auditoria para evento partido
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

-- Trigger para goles en Participacion partido 
CREATE OR REPLACE TRIGGER trg_valida_goles_participacion
BEFORE INSERT OR UPDATE ON PARTICIPACION_PARTIDO
FOR EACH ROW
BEGIN
    IF :new.goles < 0 OR :new.goles_penales < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: La cantidad de goles o goles por penales no puede ser negativa.');
    END IF;
END;
/

-- Trigger para asistencia
CREATE OR REPLACE TRIGGER trg_valida_asistencia_estadio
BEFORE INSERT OR UPDATE ON PARTIDO
FOR EACH ROW
BEGIN
    IF :new.asistencia_registrada < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: La asistencia de público al estadio no puede ser negativa.');
    END IF;
END;
/


-- ===================================================
-- TRIGGER SOBRE PARTICIPANTES DUPLICADOS EN UN PARTIDO 
-- ===================================================