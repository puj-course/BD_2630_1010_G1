CREATE TABLE EDICION_MUNDIAL ( 
     id_edicion   INTEGER  NOT NULL , 
     anio         NUMBER  NOT NULL , 
     nombre       VARCHAR2 (100 CHAR)  NOT NULL , 
     fecha_inicio DATE  NOT NULL , 
     fecha_fin    DATE  NOT NULL,
    
    CONSTRAINT edicion_fechas CHECK (fecha_fin > fecha_inicio)
    
    );

ALTER TABLE EDICION_MUNDIAL 
    ADD CONSTRAINT EDICION_MUNDIAL_PK PRIMARY KEY ( id_edicion ) ;

ALTER TABLE EDICION_MUNDIAL 
    ADD CONSTRAINT anio UNIQUE ( anio ) ;

CREATE TABLE Estadio ( 
     id_estadio INTEGER  NOT NULL , 
     id_ciudad  INTEGER  NOT NULL , 
     nombre     VARCHAR2 (100 CHAR)  NOT NULL , 
     capacidad  INTEGER  NOT NULL,
    
    CONSTRAINT estadio_capacidad CHECK (capacidad > 0)
    );

ALTER TABLE Estadio 
    ADD CONSTRAINT Estadio_PK PRIMARY KEY ( id_estadio ) ;

ALTER TABLE Estadio 
    ADD CONSTRAINT Unique_Keyv4 UNIQUE ( nombre , id_ciudad ) ;

CREATE TABLE ACREDITACION_PRENSA ( 
     id_acreditacion   INTEGER  NOT NULL , 
     id_persona        INTEGER  NOT NULL , 
     id_edicion        INTEGER  NOT NULL , 
     medio_comunicacio VARCHAR2 (120 CHAR)  NOT NULL , 
     fecha_emision     DATE  NOT NULL , 
     tipo_acreditacion VARCHAR2 (40 CHAR)  NOT NULL , 
     estado            VARCHAR2 (20 CHAR)  NOT NULL    
    );

ALTER TABLE ACREDITACION_PRENSA 
    ADD CONSTRAINT ACREDITACION_PRENSA_PK PRIMARY KEY ( id_acreditacion ) ;

CREATE TABLE ASIGNACION_ARBITRAL ( 
     id_asignacion INTEGER  NOT NULL , 
     id_partido    INTEGER  NOT NULL , 
     id_persona    INTEGER  NOT NULL , 
     rol_arbitral  VARCHAR2 (40 CHAR)  NOT NULL,

     CONSTRAINT asignacion_rol CHECK (rol_arbitral IN ('CENTRAL', 'ASISTENTE_1', 'ASISTENTE_2', 'CUARTO_ARBITRO', 'VAR', 'AVAR'))
    );

ALTER TABLE ASIGNACION_ARBITRAL 
    ADD CONSTRAINT ASIGNACION_ARBITRAL_PK PRIMARY KEY ( id_asignacion ) ;

ALTER TABLE ASIGNACION_ARBITRAL 
    ADD CONSTRAINT Unique_Key_1 UNIQUE (rol_arbitral , id_partido) ;

ALTER TABLE ASIGNACION_ARBITRAL 
    ADD CONSTRAINT Unique_Key_2 UNIQUE (id_partido , id_persona) ;

CREATE TABLE AUDITORIA ( 
     id_auditoria         INTEGER  NOT NULL , 
     usuario_bd           VARCHAR2 (100 CHAR)  NOT NULL , 
     tabla_afectada       VARCHAR2 (50 CHAR)  NOT NULL , 
     id_registro_afectado INTEGER  NOT NULL , 
     operacion            VARCHAR2 (10 CHAR)  NOT NULL , 
     fecha_hora           TIMESTAMP  NOT NULL , 
     valor_anterior       CLOB , 
     valor_nuevo          CLOB,
    
    CONSTRAINT auditoria_operacion CHECK (operacion IN ('INSERT', 'UPDATE', 'DELETE'))
    );

ALTER TABLE AUDITORIA 
    ADD CONSTRAINT AUDITORIA_PK PRIMARY KEY ( id_auditoria ) ;

CREATE TABLE CIUDAD ( 
     id_ciudad INTEGER  NOT NULL , 
     id_sede   INTEGER  NOT NULL , 
     nombre    VARCHAR2 (80 CHAR)  NOT NULL 
    );

ALTER TABLE CIUDAD 
    ADD CONSTRAINT CIUDAD_PK PRIMARY KEY ( id_ciudad ) ;

ALTER TABLE CIUDAD 
    ADD CONSTRAINT Unique_Key UNIQUE ( id_sede , nombre ) ;

CREATE TABLE ENTRADA ( 
     id_entrada INTEGER  NOT NULL , 
     id_partido INTEGER  NOT NULL , 
     categoria  VARCHAR2 (30 CHAR)  NOT NULL , 
     zona       VARCHAR2 (50 CHAR)  NOT NULL , 
     precio     NUMBER (10,2)  NOT NULL , 
     estado     VARCHAR2 (20)  NOT NULL,

     CONSTRAINT entrada_precio CHECK (precio >= 0)
    );

ALTER TABLE ENTRADA 
    ADD CONSTRAINT ENTRADA_PK PRIMARY KEY ( id_entrada ) ;

CREATE TABLE ETAPA_COMPETENCIA ( 
     id_etapa       INTEGER  NOT NULL , 
     id_edicion     INTEGER  NOT NULL , 
     id_etapa_padre INTEGER , 
     nombre         VARCHAR2 (80 CHAR)  NOT NULL , 
     tipo_etapa     VARCHAR2 (40)  NOT NULL , 
     orden          INTEGER  NOT NULL,

     CONSTRAINT etapa_tipo CHECK (tipo_etapa IN ('FASE', 'GRUPO', 'INSTANCIA_ELIMINATORIA'))
    );

ALTER TABLE ETAPA_COMPETENCIA 
    ADD CONSTRAINT ETAPA_COMPETENCIA_PK PRIMARY KEY ( id_etapa ) ;

CREATE TABLE EVENTO_PARTIDO ( 
     id_evento              INTEGER  NOT NULL , 
     id_partido             INTEGER  NOT NULL , 
     id_persona             INTEGER , 
     id_persona_relacionada INTEGER , 
     tipo_evento            VARCHAR2 (40 CHAR)  NOT NULL , 
     minuto                 SMALLINT , 
     valor_numerico         SMALLINT , 
     descripcion            VARCHAR2 (400 CHAR),

     CONSTRAINT evento_tipo CHECK (tipo_evento IN ('GOL', 'ASISTENCIA', 'TARJETA_AMARILLA', 'TARJETA_ROJA', 'SUSTITUCION', 'MINUTOS_JUGADOS'))
    );

ALTER TABLE EVENTO_PARTIDO 
    ADD CONSTRAINT EVENTO_PARTIDO_PK PRIMARY KEY ( id_evento ) ;

CREATE TABLE ORGANIZACIONES_FUTBOL ( 
     id_organizacion       INTEGER  NOT NULL , 
     nombre                VARCHAR2 (100 CHAR)  NOT NULL , 
     tipo                  VARCHAR2 (30 CHAR)  NOT NULL , 
     pais                  VARCHAR2 (80 CHAR)  NOT NULL , 
     id_organizacion_padre INTEGER,
    
    CONSTRAINT organizacion_tipo CHECK (tipo IN ('CONFEDERACION', 'FEDERACION_NACIONAL'))
    );

ALTER TABLE ORGANIZACIONES_FUTBOL 
    ADD CONSTRAINT ORGANIZACIONES_FUTBOL_PK PRIMARY KEY ( id_organizacion ) ;

CREATE TABLE PARTICIPACION_PARTIDO( 
     id_participacion_partido INTEGER  NOT NULL , 
     id_partido               INTEGER  NOT NULL , 
     id_seleccion             INTEGER  NOT NULL , 
     condicion                VARCHAR2 (10 CHAR)  NOT NULL , 
     goles                    INTEGER  NOT NULL , 
     goles_penales            INTEGER  NOT NULL , 
     resultado                VARCHAR2 (10),
    
    CONSTRAINT partido_condicion CHECK (condicion IN ('LOCAL', 'VISITANTE')),
    CONSTRAINT part_goles CHECK (goles >= 0 AND goles_penales >= 0),
    CONSTRAINT part_resultado CHECK (resultado IN ('GANO', 'PERDIO', 'EMPATO'))
    );

ALTER TABLE PARTICIPACION_PARTIDO 
    ADD CONSTRAINT PARTICIPACION_PARTIDO_PK PRIMARY KEY ( id_participacion_partido ) ;

ALTER TABLE PARTICIPACION_PARTIDO 
    ADD CONSTRAINT Unique_Key_1v2 UNIQUE ( id_seleccion , id_partido ) ;

ALTER TABLE PARTICIPACION_PARTIDO 
    ADD CONSTRAINT Unique_Key_2v2 UNIQUE ( id_partido , condicion ) ;

CREATE TABLE PARTIDO( 
     id_partido            INTEGER  NOT NULL , 
     id_etapa              INTEGER  NOT NULL , 
     id_estadio            INTEGER  NOT NULL , 
     id_partido_origen_1   INTEGER , 
     id_partido_origen_2   INTEGER , 
     fecha_hora            DATE  NOT NULL , 
     asistencia_registrada INTEGER  NOT NULL , 
     estado                VARCHAR2 (30 CHAR)  NOT NULL , 
     resultado_origen_1    VARCHAR2 (20 CHAR) , 
     resultado_origen_2    VARCHAR2 (20 CHAR),
    
    CONSTRAINT partido_asistencia CHECK (asistencia_registrada >= 0)
    );

ALTER TABLE PARTIDO 
    ADD CONSTRAINT PARTIDO_PK PRIMARY KEY ( id_partido ) ;

CREATE TABLE PERSONA ( 
     id_persona          INTEGER  NOT NULL , 
     nombre_completo     VARCHAR2 (120 CHAR)  NOT NULL , 
     nacionalidad        VARCHAR2 (80 CHAR) , 
     fecha_de_nacimiento DATE 
    );

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE SEDE ( 
     id_sede    INTEGER  NOT NULL , 
     id_edicion INTEGER  NOT NULL , 
     pais       VARCHAR2 (80 CHAR)  NOT NULL 
    );

ALTER TABLE SEDE 
    ADD CONSTRAINT SEDE_PK PRIMARY KEY ( id_sede ) ;

ALTER TABLE SEDE 
    ADD CONSTRAINT Unique_Keyv1 UNIQUE ( pais , id_edicion ) ;

CREATE TABLE SELECCION ( 
     id_seleccion    INTEGER  NOT NULL , 
     id_organizacion INTEGER  NOT NULL , 
     id_etapa_grupo  INTEGER  NOT NULL , 
     codigo_fifa     VARCHAR2 (3 CHAR)  NOT NULL 
    );

ALTER TABLE SELECCION 
    ADD CONSTRAINT SELECCION_PK PRIMARY KEY ( id_seleccion ) ;

CREATE TABLE VINCULACION_SELECCION ( 
     id_vinculacion INTEGER  NOT NULL , 
     id_persona     INTEGER  NOT NULL , 
     id_seleccion   INTEGER  NOT NULL , 
     capitan        CHAR (1 CHAR) , 
     dorsal         SMALLINT , 
     posicion       VARCHAR2 (30) , 
     rol            VARCHAR2 (30 CHAR)  NOT NULL , 
     club           VARCHAR2 (120 CHAR),

     CONSTRAINT vinculacion_rol CHECK (rol IN ('JUGADOR', 'DIRECTOR_TECNICO', 'ASISTENTE', 'PREPARADOR_FISICO'))
    );

ALTER TABLE VINCULACION_SELECCION 
    ADD CONSTRAINT VINCULACION_SELECCION_PK PRIMARY KEY ( id_vinculacion ) ;

ALTER TABLE VINCULACION_SELECCION 
    ADD CONSTRAINT Unique_Keyv2 UNIQUE ( id_seleccion , id_persona ) ;

ALTER TABLE ACREDITACION_PRENSA 
    ADD CONSTRAINT acredita FOREIGN KEY 
    (id_edicion) 
    REFERENCES EDICION_MUNDIAL 
    (id_edicion) 

    -- ON UPDATE RESTRICT 
    /*
    ON DELETE RESTRICT: Permite evitar eliminar una edicion si ya tiene historial de 
    acreditaciones, protegiendo los datos históricos 
    ON UPDATE RESTRICT: al ser un id subrogado, no debería tener cambios y por tanto 
    tampoco ser actualizado.  
    */
;

ALTER TABLE SELECCION 
    ADD CONSTRAINT agrupa FOREIGN KEY 
    (id_etapa_grupo) 
    REFERENCES ETAPA_COMPETENCIA 
    (id_etapa) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: Proteje la integridad del dataset, haciendo que no se puedan 
    borrar estapas que tengan selecciones asociadas.
    ON UPDATE RESTRICT: id subrogado, no debe por qué tener cambios. 
    */
;

ALTER TABLE PARTIDO 
    ADD CONSTRAINT alberga FOREIGN KEY 
    (id_estadio) 
    REFERENCES Estadio 
    (id_estadio) 

    -- ON UPDATE RESTRICT 

    /*
    ON DELETE RESTRICT: Un estadio que tengapartidos programados o que ya se jugaron 
    no debería borrarse por historial. 
    ON UPDATE RESTRICT: identificador subrogado, no debe tener cambios. 
    */
;

ALTER TABLE PARTIDO 
    ADD CONSTRAINT contiene FOREIGN KEY 
    (id_etapa) 
    REFERENCES ETAPA_COMPETENCIA 
    (id_etapa) 

    -- ON UPDATE RESTRICT

    /*
    ON DELETE RESTRICT: al igual que con Partido-Estadio, por protección de los datos 
    historicos, no se debe borrar ninguna etapa de la competencia que ya tenga registado algún partido 
    ON UPDATE RESTRICT: id subrogado, no tiene que tenegr cambios. 
    */
;

ALTER TABLE VINCULACION_SELECCION 
    ADD CONSTRAINT crea FOREIGN KEY 
    (id_persona) 
    REFERENCES PERSONA 
    (id_persona) 

    -- ON UPDATE RESTRICT

    /*
    ON DELETE RESTRICT: no permite borrar a una persona (ya sea jugador o dt) si mantiene un vículo
    con alguna seleccion. 
    ON UPDATE RESTRICT: id subrogado, no tendía porque actualizarse
    */
;

ALTER TABLE ETAPA_COMPETENCIA 
    ADD CONSTRAINT cuenta_con FOREIGN KEY 
    (id_edicion) 
    REFERENCES EDICION_MUNDIAL 
    (id_edicion)

    --ON UPDATE RESTRICT 

    /*
    ON DETELE RESTRICT: No se pueden borar edisiones si ya tienen etapas 
    registradas.
    ON UPDATE RESTRICT: id subrogado, no cambios. 
    */ 
;

ALTER TABLE Estadio 
    ADD CONSTRAINT dispone FOREIGN KEY 
    (id_ciudad) 
    REFERENCES CIUDAD 
    (id_ciudad) 
    
    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: No se puede eliminar una ciudad si tiene estadios construidos o registrados en ella.
    ON UPDATE RESTRICT: id subrogado, sin cambios esperados.
    */
;

ALTER TABLE ASIGNACION_ARBITRAL 
    ADD CONSTRAINT es FOREIGN KEY 
    (id_persona) 
    REFERENCES PERSONA 
    (id_persona) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: Protege la historia arbitral impidiendo borrar una persona si tiene asignaciones arbitrales.
    ON UPDATE RESTRICT: id subrogado, no debe modificarse.
    */
;

ALTER TABLE EVENTO_PARTIDO 
    ADD CONSTRAINT genera FOREIGN KEY 
    (id_partido) 
    REFERENCES PARTIDO 
    (id_partido)

    ON DELETE CASCADE
    -- ON UPDATE RESTRICT
    /*
    ON DELETE CASCADE: Si se elimina un partido, sus eventos asociados (goles, tarjetas) 
    deben eliminarse automáticamente para evitar registros huérfanos.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE EVENTO_PARTIDO 
    ADD CONSTRAINT involucra FOREIGN KEY 
    (id_persona_relacionada) 
    REFERENCES PERSONA 
    (id_persona)

    ON DELETE SET NULL
    -- ON UPDATE RESTRICT
    /*
    ON DELETE SET NULL: Si se elimina una persona relacionada a un evento,
    el campo queda nulo conservando el evento principal sin corromperse.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */ 
;

ALTER TABLE PARTIDO 
    ADD CONSTRAINT P2precede FOREIGN KEY 
    (id_partido_origen_1) 
    REFERENCES PARTIDO 
    (id_partido) 

    ON DELETE SET NULL
    -- ON UPDATE RESTRICT
    /*
    ON DELETE SET NULL: Si un partido previo se descarta o reestructura, el partido siguiente queda sin la referencia del origen 1 en lugar de borrarse toda la llave.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE CIUDAD 
    ADD CONSTRAINT posee FOREIGN KEY 
    (id_sede) 
    REFERENCES SEDE 
    (id_sede) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: No se puede eliminar una sede si contiene ciudades registradas en la organización.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE PARTIDO 
    ADD CONSTRAINT precede FOREIGN KEY 
    (id_partido_origen_2) 
    REFERENCES PARTIDO 
    (id_partido) 

    ON DELETE SET NULL
    -- ON UPDATE RESTRICT
    /*
    ON DELETE SET NULL: Si un partido previo se descarta o reestructura, el partido siguiente queda sin la referencia del origen 1 en lugar de borrarse toda la llave.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE ACREDITACION_PRENSA 
    ADD CONSTRAINT recibe FOREIGN KEY 
    (id_persona) 
    REFERENCES PERSONA 
    (id_persona) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: Preserva el registro histórico de los periodistas y su acreditación, impidiendo la eliminación de la persona.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE PARTICIPACION_PARTIDO 
    ADD CONSTRAINT registra FOREIGN KEY 
    (id_seleccion) 
    REFERENCES SELECCION 
    (id_seleccion) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: Impide eliminar una selección si cuenta con historial de participaciones registradas en partidos del torneo.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE EVENTO_PARTIDO 
    ADD CONSTRAINT relaciona FOREIGN KEY 
    (id_persona) 
    REFERENCES PERSONA 
    (id_persona) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: Garantiza el historial de los protagonistas principales evitando que la persona sea borrada si está en los eventos del partido.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE PARTICIPACION_PARTIDO 
    ADD CONSTRAINT rellena FOREIGN KEY 
    (id_partido) 
    REFERENCES PARTIDO 
    (id_partido) 
    
    ON DELETE CASCADE 
    -- ON UPDATE RESTRICT
    /*
    ON DELETE CASCADE: Si se elimina un partido, sus estadísticas de participación de las selecciones se limpian automáticamente.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE SELECCION 
    ADD CONSTRAINT representa FOREIGN KEY 
    (id_organizacion) 
    REFERENCES ORGANIZACIONES_FUTBOL 
    (id_organizacion) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: No permiten borrar organizaciones que tengan asociadas a selecciones. 
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE ETAPA_COMPETENCIA 
    ADD CONSTRAINT se_conforma FOREIGN KEY 
    (id_etapa_padre) 
    REFERENCES ETAPA_COMPETENCIA 
    (id_etapa) 

    ON DELETE SET NULL
    -- ON UPDATE RESTRICT
    /*
    ON DELETE SET NULL: Si se elimina una etapa, las subetapas dependientes quedan sin padre en lugar de perderse en cascada.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE ORGANIZACIONES_FUTBOL 
    ADD CONSTRAINT se_forma_de FOREIGN KEY 
    (id_organizacion_padre) 
    REFERENCES ORGANIZACIONES_FUTBOL 
    (id_organizacion) 

    ON DELETE SET NULL
    -- ON UPDATE RESTRICT
    /*
    ON DELETE SET NULL: Si se disuelve una organización, las suborganizaciones quedan independientes en lugar de eliminarse por completo.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE SEDE 
    ADD CONSTRAINT tiene FOREIGN KEY 
    (id_edicion) 
    REFERENCES EDICION_MUNDIAL 
    (id_edicion) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: No se permite eliminar una edición mundial si tiene sedes asignadas.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE ENTRADA 
    ADD CONSTRAINT tienev1 FOREIGN KEY 
    (id_partido) 
    REFERENCES PARTIDO 
    (id_partido) 

    ON DELETE CASCADE
    -- ON UPDATE RESTRICT
    /*
    ON DELETE CASCADE: Si un partido se cancela de forma definitiva, las entradas asociadas se eliminan automáticamente.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE ASIGNACION_ARBITRAL 
    ADD CONSTRAINT tienev2 FOREIGN KEY 
    (id_partido) 
    REFERENCES PARTIDO 
    (id_partido) 

    ON DELETE CASCADE
    -- ON UPDATE RESTRICT
    /*
    ON DELETE CASCADE: Si el partido se elimina, las asignaciones de los arbitros no sirven, 
    por tanto se eliminan.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

ALTER TABLE VINCULACION_SELECCION 
    ADD CONSTRAINT vincula FOREIGN KEY 
    (id_seleccion) 
    REFERENCES SELECCION 
    (id_seleccion) 

    -- ON UPDATE RESTRICT
    /*
    ON DELETE RESTRICT: No se puede eliminar una selección si mantiene a personas vinculadas.
    ON UPDATE RESTRICT: id subrogado, sin cambios.
    */
;

--- ===============================================================
--  INDICES Y JUSTIFICACIONES
--- ===============================================================

CREATE INDEX idx_partido_fecha ON PARTIDO (fecha_hora);
/*
Justificación: Es común que las personas busquen frecuentememnte por fechas o de 
manera ordenada cronológicamente. 
*/

CREATE INDEX idx_evento_partido ON EVENTO_PARTIDO (id_partido);
/*
Justificación: Optimiza la busqueda respecto a los resultados de los partidos, incluyendo
todo lo relacionados a goles, tarjetas y tiempos, tambien es una busqueda frecuente. 
*/

CREATE INDEX idx_entrada_partido_estado ON ENTRADA (id_partido, estado);
/*
Justificación: otra busqueda compun es la disponibilidad respecto a las entradas de partidos,
este indice permite buscar tanto entradas disponibles como vendidas. 
*/
