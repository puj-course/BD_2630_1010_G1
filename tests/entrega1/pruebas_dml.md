*intento de 3 operaciones invalidas* 
--1.
INSERT INTO is101001.edicion_mundial (id_edicion, anio, pais_sede, lema, fecha_inicio, chafing)
VALUES (56, 1926, 'Colombia', 'Amor y paz', '11-JUN-1926','11-JUL-1926');

-- Se trata de insertar una tupla en edicion_mundiañ y no deja por la restriccion check min_anio_edicion 
-- porque la que se inserta es menor a 1930 que fue el primer mundial

--2.
INSERT INTO is101001.seleccion (id_seleccion, id_edicion, pais, confederacion, grupo, convocados)
VALUES (90, null, 'RD Congo', 'AFC', 'H', 24);

-- Intento de insertar seleccion y aparece la restriccion de not null en edicion_mundial

--3.
INSERT INTO is101001.jugador (id_jugador, nombre, fecha_nacimiento, altura, peso, nacionalidad)
VALUES ('1001', 'Cristiano Ronaldo', '05-FEB-1985', 187, 83, 'Portugal');

-- Insercion fallida por Restriccion de primary key especificamente unique ya que el id ya fue insertado


*Demostración del comportamiento ON DELETE en al menos 2 relaciones distintas.*

--Prueba eliminacion cascade de seleccion
Este es el DDL
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

Antes de eliminar: 
id   edicion_id   pais
101	1	Argentina	CONMEBOL	C	26
102	1	Francia		UEFA		D	26
103	1	Croacia		UEFA		F	26
104	1	Marruecos	CAF		F	26
105	3	Belgica		UEFA		G	23
106	3	Inglaterra	UEFA		G	23
107	3	Brasil		CONMEBOL	E	23
108	3	Japon		AFC		H	23

sentencia: 
delete from is101001.edicion_mundial
where id_edicion = 1;

Después de eliminar:

105	3	Belgica		UEFA		G	23
106	3	Inglaterra	UEFA		G	23
107	3	Brasil		CONMEBOL	E	23
108	3	Japon		AFC		H	23


--Prueba eliminacion on restriction en participacion partido
DDL:

FOREIGN KEY (id_seleccion) REFERENCES SELECCION
       -- ON DELETE RESTRICT
    );

sentencia
delete from is101001.seleccion
where id_seleccion = 101;

mensaje de error:
Error starting at line : 57 in command -
delete from is101001.seleccion
where id_seleccion = 101
Error report -
ORA-02292: integrity constraint (IS101001.SYS_C00925668) violated - child record found


