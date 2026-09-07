##### **Intento de 3 operaciones inválidas**



###### **1. Inserción en 'edicion\_mundial'**



```sql

INSERT INTO is101001.edicion\_mundial (id\_edicion, anio, pais\_sede, lema, fecha\_inicio, fecha\_fin)

VALUES (56, 1926, 'Colombia', 'Amor y paz', '11-JUN-1926','11-JUL-1926');

```



Error: No se permite porque la restricción CHECK min\_anio\_edicion exige que el año sea mayor o igual a 1930 (primer mundial).



###### **2. Inserción en 'seleccion'**



```sql

INSERT INTO is101001.seleccion (id\_seleccion, id\_edicion, pais, confederacion, grupo, convocados)

VALUES (90, null, 'RD Congo', 'AFC', 'H', 24);

```



Error: La columna id\_edicion tiene restricción NOT NULL. Al insertar null, la operación falla.



###### **3. Inserción en jugador**



```sql

INSERT INTO is101001.jugador (id\_jugador, nombre, fecha\_nacimiento, altura, peso, nacionalidad)

VALUES ('1001', 'Cristiano Ronaldo', '05-FEB-1985', 187, 83, 'Portugal');

```

Error: Violación de restricción PRIMARY KEY (único). El id\_jugador = 1001 ya existe.



##### **Demostración del comportamiento ON DELETE**



###### **1. Eliminación en cascada (CASCADE) en seleccion**



DDL de la relación selección

```sql

CREATE TABLE SELECCION (

&#x20;   ...

&#x09;

&#x20;   FOREIGN KEY (id\_edicion) REFERENCES EDICION\_MUNDIAL

&#x20;       ON DELETE CASCADE

);

```



Al borrar una edición, se eliminan automáticamente las selecciones asociadas.



Antes de eliminar:



id	edicion\_id	pais		confederacion	grupo	convocados

101	1		Argentina	CONMEBOL	C	26

102	1		Francia		UEFA		D	26

103	1		Croacia		UEFA		F	26

104	1		Marruecos	CAF		F	26

105	3		Belgica		UEFA		G	23

106	3		Inglaterra	UEFA		G	23

107	3		Brasil		CONMEBOL	E	23

108	3		Japon		AFC		H	23



Sentencia:

```sql

DELETE FROM is101001.edicion\_mundial

WHERE id\_edicion = 1;

```



Despúes de eliminar:



id	edicion\_id	pais		confederacion	grupo	convocados

105	3		Belgica		UEFA		G	23

106	3		Inglaterra	UEFA		G	23

107	3		Brasil		CONMEBOL	E	23

108	3		Japon		AFC		H	23



###### **2. Eliminación con restricción (RESTRICT) en participacion\_partido**



DDL de la relación participacion\_partido

```sql

FOREIGN KEY (id\\\_seleccion) REFERENCES SELECCION

ON DELETE RESTRICT;

```

Sentencia:

```sql

DELETE FROM is101001.seleccion

WHERE id\_seleccion = 101;

```

Resultado:

```code

ORA-02292: integrity constraint (IS101001.SYS\_C00925668) violated - child record found

```

No se puede eliminar la selección porque existen registros dependientes en participacion\_partido con on delete restrict.



