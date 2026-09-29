-- ==================================================
-- Rol Operativo a Jerónimo (GRANT ALL) 
-- ==================================================
CREATE ROLE consultor;
GRANT SELECT ON EDICION_MUNDIAL TO consultor;
GRANT SELECT ON SELECCION TO consultor;
GRANT SELECT ON JUGADOR TO consultor;
GRANT SELECT ON CONVOCADOS_POR_EDICION TO consultor;
GRANT SELECT ON ESTADIO TO consultor;
GRANT SELECT ON PARTIDO TO consultor;
GRANT SELECT ON PARTICIPACION_PARTIDO TO consultor;
GRANT consultor TO is101000;

REVOKE consultor TO id101000;
-- ==================================================
-- Rol Seleccion a Camilo (GRANT SELECT) 
-- ==================================================

CREATE ROLE operador;
GRANT SELECT, INSERT, UPDATE ON EDICION_MUNDIAL TO operador;
GRANT SELECT, INSERT, UPDATE ON SELECCION TO operador;
GRANT SELECT, INSERT, UPDATE ON JUGADOR TO operador;
GRANT SELECT, INSERT, UPDATE ON PARTIDO TO operador;
GRANT SELECT, INSERT, UPDATE ON CONVOCADOS_POR_EDICION TO operador;
GRANT SELECT, INSERT, UPDATE ON ESTADIO TO operador;
GRANT SELECT, INSERT, UPDATE ON PARTICIPACION_PARTIDO TO operador;
GRANT operador TO is101008;

REVOKE operador TO is101000;

COMMIT;
