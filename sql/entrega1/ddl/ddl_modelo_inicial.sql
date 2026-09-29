CREATE TABLE EDICION_MUNDIAL
    (id_edicion VARCHAR(20),
    anio NUMERIC(4) NOT NULL,
    pais_sede VARCHAR(50) NOT NULL,
    lema VARCHAR(1000),
    fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (id_edicion),
    
    CONSTRAINT min_anio_edicion 
        CHECK (anio >= 1930 AND anio != 1942 AND anio != 1946),
        
    CONSTRAINT fecha_edicion CHECK (fecha_fin > fecha_inicio) 
    );
    
CREATE TABLE SELECCION
    (id_seleccion VARCHAR(20),
    id_edicion VARCHAR(20) NOT NULL,
    pais VARCHAR (50) NOT NULL, 
    confederacion VARCHAR(15),
    grupo CHAR(1),
    convocados NUMERIC(2),
    PRIMARY KEY (id_seleccion), 
    
    CONSTRAINT edicion_pais UNIQUE (id_edicion, pais),
    
    CONSTRAINT numero_convocados CHECK (convocados <= 26 AND convocados >=23),
    
    CONSTRAINT grupo_confederaciones CHECK (confederacion IN ('UEFA','CONMEBOL','CONCACAF','CAF','AFC','OFC')),
    
    -- JUSTIFICACION: 
    -- ON DELETE: Se deja en CASCADE porque al borrar una edicion no tiene sentido conservar las
    -- selecciones porque pierden su contexto (al dejar en null el id_edicion) así que es mejor borrarlas.
    -- ON UPDATE: Se deja RESTRICT, ya que al ser id_edicion la FK pero también la PK (subrogada) de EDICION_MUNDIAL
    -- esta debería ser inmutable. 
    FOREIGN KEY (id_edicion) REFERENCES EDICION_MUNDIAL
        ON DELETE CASCADE
    );

CREATE TABLE JUGADOR
    (id_jugador VARCHAR(20), 
    nombre VARCHAR(40) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    altura NUMERIC(4, 1),
    peso NUMERIC(3), 
    nacionalidad VARCHAR(20),
    PRIMARY KEY (id_jugador)
    );
    
CREATE TABLE CONVOCADOS_POR_EDICION
    (id_edicion VARCHAR(20),
    id_seleccion VARCHAR(20),
    id_jugador VARCHAR(20),
    dorsal NUMERIC(2), 
    posicion VARCHAR(15),
    PRIMARY KEY (id_edicion, id_jugador),
    
    CONSTRAINT numero_dorsal CHECK (dorsal <= 99 AND dorsal >= 1),
    
    CONSTRAINT seleccion_dorsal UNIQUE (id_edicion, id_seleccion, dorsal),
    
    CONSTRAINT pisicion_valida CHECK (posicion IN ('delantero','portero', 'defensa', 'mediocampista')),
    
    -- JUSTIFICACIÓN: 
    -- ON DELETE: CASCADE ya que si no hay edicion del mundial no hay convocados.
    -- ON UPDATE: restrict dado que es PK subrogada (lo mismo con las siguientes dos PK.
    FOREIGN KEY (id_edicion) REFERENCES EDICION_MUNDIAL 
        ON DELETE CASCADE,
        
    -- ON DELETE: RESTRICT, no se puede borrar un jugador registrado en una convocatoria historica.
    FOREIGN KEY (id_jugador) REFERENCES JUGADOR (id_jugador),
    
    -- ON DELETE: RESTRICT No permite borrar una seleccion que ya tiene un grupo convocado.
    FOREIGN KEY (id_seleccion) REFERENCES SELECCION
    );

CREATE TABLE ESTADIO 
    (id_estadio VARCHAR(20),
    id_edicion VARCHAR(20),
    nombre VARCHAR(50) NOT NULL,
    ciudad VARCHAR(10) NOT NULL,
    capacidad NUMERIC(10),
    PRIMARY KEY (id_estadio),
    
    CONSTRAINT capacidad_mínima CHECK (capacidad >= 75000),
    
    -- JUSTIFICACIÓN: 
    -- ON DELETE: Se pone CASCADE ya que si se borra el id_estadio, los estadios asignados ya no serían sedes 
    -- del evento, por tanto lo mejor sería que tambien se borraran. 
    -- ON UPDATE: Al igual que en en SELECCION lo mejor es dejar en RESTRICT, dado que id_edision es una PK 
    -- subrogada de EDICION_MUNDIAL, po rlo que debería ser inmutable 
    FOREIGN KEY (id_edicion) REFERENCES EDICION_MUNDIAL
        ON DELETE CASCADE
    );

CREATE TABLE PARTIDO
    (id_partido VARCHAR(20),
    id_edicion VARCHAR(20) NOT NULL,
    id_estadio VARCHAR(20),
    fecha_hora TIMESTAMP, 
    fase VARCHAR(15),
    asistencia_registrada NUMERIC(10),
    PRIMARY KEY (id_partido),
    
    CONSTRAINT asistencia_positiva CHECK (asistencia_registrada >= 0),
    
    CONSTRAINT unico_partido UNIQUE (id_estadio, fecha_hora),
    
    -- JUSTIFICACIÓN: 
    -- ON DELETE: CASCADE por lo mismo, no tiene snetido guardar un partido sin su contexto.
    -- ON UPDATE: RESTRICT id_edicion PK subrogada, debe ser inmutable. 
    FOREIGN KEY (id_edicion) REFERENCES EDICION_MUNDIAL
        ON DELETE CASCADE,
            
    -- JUSTIFICACIÓN: 
    -- ON DELETE: SET NULL, pensandolo como si por ejemplo demuelen en un futuro el estadio 
    -- y lo borran de la base de datos, por estadisticas y demás es mejor conservar los demás datos
    -- por ende es preferible dejar el valor en null a eliminar todo. 
    -- ON UPDATE: id_estadio es una PK subrogada, debe ser inmutable. 
    FOREIGN KEY (id_estadio) REFERENCES ESTADIO
        ON DELETE SET NULL
    );

CREATE TABLE PARTICIPACION_PARTIDO
    (id_participacion VARCHAR(20),
    id_partido VARCHAR(20) NOT NULL,
    id_seleccion VARCHAR(20) NOT NULL,
    condicion VARCHAR(10) NOT NULL, --CHECK ,
    goles_marcados NUMERIC(2) DEFAULT 0,
    resultado VARCHAR(10),
    PRIMARY KEY (id_participacion),
    
    CONSTRAINT partido_condicion UNIQUE (id_partido, condicion),
    
    CONSTRAINT goles_positivos CHECK (goles_marcados >= 0),
    
    CONSTRAINT condicion_valida CHECK (condicion in ('local','visitante')),
    
    CONSTRAINT unica_seleccion_condicion
        UNIQUE(id_partido, id_seleccion, condicion),
        
    CONSTRAINT resultado_valido CHECK (resultado IN ('GANO','PERDIO','EMPATO')),
    
    -- JUSTIFICACIÓN:
    -- ON DELETE: CASCADE, no tiene sentido guardar la participación de un partido si se borra el 
    -- partido. 
    -- ON UPDATE: Id_partido también es una llave subrogada, aso que RESTRICT (por inmutabilidad)
    FOREIGN KEY (id_partido) REFERENCES PARTIDO
        ON DELETE CASCADE,
    
    -- JUSTIFICACIÓN:
    -- ON DELETE: Se deja en RESTRICT porque si ya hay una selección que ha jugado 1 o mas partidos
    -- no debería ser borrada. 
    -- ON UPDATE: id_selección es llave subrogada, entonces RESTRICT. 
    FOREIGN KEY (id_seleccion) REFERENCES SELECCION
       -- ON DELETE RESTRICT
    );

-- ========================================================================
-- INDICES
-- ========================================================================

CREATE INDEX indice_seleccion_edicion 
ON SELECCION (id_edicion);

-- JUSTIFICACIÓN: 
-- Optimiza las consultas para listar los países participantes de un Mundial 
-- específico y acelera las eliminaciones en cascada (ON DELETE CASCADE) de esa edición.

CREATE INDEX indice_convocados_seleccion 
ON CONVOCADOS_POR_EDICION (id_seleccion);

-- JUSTIFICACIÓN: 
-- Acelera la obtención del equipo completo de una selección. Como id_seleccion 
-- no es la clave primaria de esta tabla, el índice evita escanear a todos los jugadores del torneo.
CREATE INDEX indice_partic_seleccion 
ON PARTICIPACION_PARTIDO (id_seleccion);

-- JUSTIFICACIÓN: 
-- Facilita la consulta del historial y desempeño de un equipo (partidos jugados, 
-- victorias o goles) sin tener que recorrer las participaciones de los demás países.

CREATE INDEX indice_partido_edicion 
ON PARTIDO (id_edicion);

-- JUSTIFICACIÓN: 
-- Permite cargar todos los partidos de una edición puntual de forma directa 
-- y hace eficiente la eliminación en cascada de los partidos si se borra el torneo.
----jj