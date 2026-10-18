-- ====================================
-- Rol Administrador del torneo 
-- ====================================
CREATE ROLE administrador_torneo; 
GRANT SELECT, INSERT, UPDATE ON EDICION_MUNDIAL to administrador_torneo;  
GRANT SELECT, INSERT, UPDATE ON ETAPA_COMPETENCIA to administrador_torneo; 
GRANT SELECT, INSERT, UPDATE ON SEDE to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON CIUDAD to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON ESTADIO to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON ORGANIZACIONES_FUTBOL to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON SELECCION to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON PERSONA to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON VINCULACION_SELECCION to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON PARTIDO to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON PARTICIPACION_PARTIDO to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON EVENTO_PARTIDO to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON ASIGNACION_ARBITRAL to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON ENTRADA to administrador_torneo;
GRANT SELECT, INSERT, UPDATE ON ACREDITACION_PRENSA to administrador_torneo;
GRANT SELECT ON AUDITORIA to administrador_torneo;

-- ====================================
-- Rol Analista deportivo 
-- ====================================
CREATE ROLE analista_deportivo; 
GRANT SELECT ON EDICION_MUNDIAL TO analista_deportivo; 
GRANT SELECT ON ETAPA_COMPETENCIA TO analista_deportivo; 
GRANT SELECT ON SEDE TO analista_deportivo; 
GRANT SELECT ON CIUDAD TO analista_deportivo; 
GRANT SELECT ON ESTADIO TO analista_deportivo; 
GRANT SELECT ON ORGANIZACIONES_FUTBOL TO analista_deportivo; 
GRANT SELECT ON SELECCION TO analista_deportivo; 
GRANT SELECT ON PERSONA TO analista_deportivo; 
GRANT SELECT ON VINCULACION_SELECCION TO analista_deportivo; 
GRANT SELECT ON PARTIDO TO analista_deportivo; 
GRANT SELECT ON PARTICIPACION_PARTIDO TO analista_deportivo; 
GRANT SELECT ON EVENTO_PARTIDO TO analista_deportivo; 
GRANT SELECT ON ASIGNACION_ARBITRAL TO analista_deportivo; 
GRANT SELECT ON ENTRADA TO analista_deportivo; 
GRANT SELECT ON ACREDITACION_PRENSA TO analista_deportivo; 

-- ====================================
-- Rol Auditor 
-- ====================================
CREATE ROLE auditor; 
GRANT SELECT ON EDICION_MUNDIAL TO auditor; 
GRANT SELECT ON ETAPA_COMPETENCIA TO auditor; 
GRANT SELECT ON SEDE TO auditor; 
GRANT SELECT ON CIUDAD TO auditor; 
GRANT SELECT ON ESTADIO TO auditor; 
GRANT SELECT ON ORGANIZACIONES_FUTBOL TO auditor; 
GRANT SELECT ON SELECCION TO auditor; 
GRANT SELECT ON PERSONA TO auditor; 
GRANT SELECT ON VINCULACION_SELECCION TO auditor; 
GRANT SELECT ON PARTIDO TO auditor; 
GRANT SELECT ON PARTICIPACION_PARTIDO TO auditor; 
GRANT SELECT ON EVENTO_PARTIDO TO auditor; 
GRANT SELECT ON ASIGNACION_ARBITRAL TO auditor; 
GRANT SELECT ON ENTRADA TO auditor; 
GRANT SELECT ON ACREDITACION_PRENSA TO auditor; 
GRANT SELECT ON AUDITORIA TO auditor; 

COMMIT; 