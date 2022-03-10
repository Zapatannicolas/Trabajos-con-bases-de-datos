GO
USE escuela;
GO

--1. Crear una vista para que un usuario X (no es necesario crearlo) pueda obtener una lista de  
--todos los alumnos que cursaron la asignatura “Álgegra lineal y matemática discreta”. 
GO
CREATE VIEW alumn_lista_alg_mat  -->Creamos la vista
	AS SELECT a.nombre + ' ' + a.apellido1 + ' ' + a.apellido2 AS alumno FROM Esquema_01.alumno a
	JOIN alumno_se_matricula_asignatura ama ON a.id = ama.id_alumno
	JOIN asignatura asi ON ama.id_asignatura = asi.id
	WHERE asi.nombre = 'Álgegra lineal y matemática discreta'
	GROUP BY a.nombre + ' ' + a.apellido1 + ' ' + a.apellido2;
GO

SELECT *FROM alumn_lista_alg_mat; -->Verificamos que se haya creado con exito

GRANT SELECT 
ON alumn_lista_alg_mat -->Le damos los permisos de la vista a un usuario
TO User_02;






--2. Crear una tabla en el esquema de dbo que sea idéntica a la tabla alumno (sin FKs), e insertar  los datos de Data_SQLServer.sql.

CREATE TABLE dbo.alumno(
	id NUMERIC(10) PRIMARY KEY,
	nif VARCHAR(9),
	nombre VARCHAR(25) NOT NULL,
	apellido1 VARCHAR(50) NOT NULL,
	apellido2 VARCHAR(50),
	ciudad VARCHAR(25) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(9),
	fecha_nacimiento DATE NOT NULL,
	sexo CHAR NOT NULL CHECK(sexo IN('h','m'))
);

ALTER USER User_01 WITH DEFAULT_SCHEMA = dbo; -->Cambio al esquema dbo para hacer los inserts

INSERT INTO alumno VALUES (1, '89542419S', 'Juan', 'Saez', 'Vega', 'Almería', 'C/ Mercurio', '618253876', '1992/08/08', 'H');
INSERT INTO alumno VALUES (2, '26902806M', 'Salvador', 'Sánchez', 'Pérez', 'Almería', 'C/ Real del barrio alto', '950254837', '1991/03/28', 'H');
INSERT INTO alumno VALUES (4, '17105885A', 'Pedro', 'Heller', 'Pagac', 'Almería', 'C/ Estrella fugaz', NULL, '2000/10/05', 'H');
INSERT INTO alumno VALUES (6, '04233869Y', 'José', 'Koss', 'Bayer', 'Almería', 'C/ Júpiter', '628349590', '1998/01/28', 'H');
INSERT INTO alumno VALUES (7, '97258166K', 'Ismael', 'Strosin', 'Turcotte', 'Almería', 'C/ Neptuno', NULL, '1999/05/24', 'H');
INSERT INTO alumno VALUES (9, '82842571K', 'Ramón', 'Herzog', 'Tremblay', 'Almería', 'C/ Urano', '626351429', '1996/11/21', 'H');
INSERT INTO alumno VALUES (11, '46900725E', 'Daniel', 'Herman', 'Pacocha', 'Almería', 'C/ Andarax', '679837625', '1997/04/26', 'H');
INSERT INTO alumno VALUES (19, '11578526G', 'Inma', 'Lakin', 'Yundt', 'Almería', 'C/ Picos de Europa', '678652431', '1998/09/01', 'M');
INSERT INTO alumno VALUES (21, '79089577Y', 'Juan', 'Gutiérrez', 'López', 'Almería', 'C/ Los pinos', '678652431', '1998/01/01', 'H');
INSERT INTO alumno VALUES (22, '41491230N', 'Antonio', 'Domínguez', 'Guerrero', 'Almería', 'C/ Cabo de Gata', '626652498', '1999/02/11', 'H');
INSERT INTO alumno VALUES (23, '64753215G', 'Irene', 'Hernández', 'Martínez', 'Almería', 'C/ Zapillo', '628452384', '1996/03/12', 'M');
INSERT INTO alumno VALUES (24, '85135690V', 'Sonia', 'Gea', 'Ruiz', 'Almería', 'C/ Mercurio', '678812017', '1995/04/13', 'M');





/*3. Aplicar un método que, actualice esta “nueva tabla” cuando el nombre, los apellidos, la  
ciudad hayan cambiado, inserte cuando el registro sea nuevo, y borre aquellos que no estén  
en la tabla alumno (original). 
*/

MERGE dbo.alumno AS TARGET
USING Esquema_01.alumno AS SOURCE
	ON (TARGET.id = SOURCE.id)
--Se actulizan los registros cuando son diferentes
WHEN MATCHED AND TARGET.nombre <> SOURCE.nombre
	OR TARGET.apellido1 <> SOURCE.apellido1
	OR TARGET.apellido2 <> SOURCE.apellido2
	OR TARGET.ciudad <> SOURCE.ciudad THEN
	UPDATE SET TARGET.nombre  = SOURCE.nombre,
			   TARGET.apellido1 = SOURCE.apellido1,
			   TARGET.apellido2 = SOURCE.apellido2,
			   TARGET.ciudad = SOURCE.ciudad
--Cuando hay un dato nuevo se inserta el registro en  target
WHEN NOT MATCHED BY TARGET THEN
	INSERT(id,nombre,nif, apellido1, apellido2, ciudad,direccion, telefono, fecha_nacimiento, sexo) 
	VALUES(SOURCE.id, SOURCE.nif, SOURCE.nombre, SOURCE.apellido1, SOURCE.apellido2, SOURCE.ciudad,SOURCE.direccion, SOURCE.telefono, SOURCE.fecha_nacimiento, SOURCE.sexo)
--Se borra registro en target cuando no existe en source
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;

SELECT *FROM dbo.alumno --Compruebo los registros 
SELECT *FROM Esquema_01.alumno	






--4. Colocar índices (index/statistics) de todas las columnas a las tablas: alumno, profesor y asignatura.

IF EXISTS (SELECT name FROM sys.indexes   ------>Primero compruebo que existan los indices y luego lo creo
            WHERE name = N'idx_alumno')   
    DROP INDEX idx_alumno ON Esquema_01.alumno;
	CREATE INDEX idx_alumno ON Esquema_01.alumno(id,nif,nombre,apellido1,apellido2,ciudad,direccion,telefono,fecha_nacimiento,sexo);


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'idx_profesor')   
    DROP INDEX idx_profesor ON Esquema_01.profesor;
	CREATE INDEX idx_profesor ON Esquema_01.profesor(id,nif,nombre,apellido1,apellido2,ciudad,direccion,telefono,fecha_nacimineto,sexo,id_departamento);


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'idx_asignatura')   
    DROP INDEX idx_asignatura ON Esquema_01.asignatura;
	CREATE INDEX idx_asignatura ON Esquema_01.asignatura(id,nombre,creditos,tipo,curso,cuatrimestre,id_profesor,id_grado);

SELECT *FROM sys.indexes WHERE NAME IN ('idx_alumno', 'idx_profesor', 'idx_asignatura'); ----->Verifico que se hayan creado correctamente






--5. Colocar los índices que crea necesario al resto de tablas. También pueden colocar otros índices a las tablas alumno, profesor y asignatura.

CREATE NONCLUSTERED INDEX idx_alumnos_matriculados ON Esquema_01.alumno_se_matricula_asignatura(id_alumno,id_asignatura,id_curso_escolar);

CREATE NONCLUSTERED INDEX idx_alumno_contacto ON Esquema_01.alumno(nombre,apellido1,apellido2,telefono);

CREATE NONCLUSTERED INDEX idx_profesor_departamento ON Esquema_01.profesor(id_departamento);

CREATE NONCLUSTERED INDEX idx_curso_año ON Esquema_01.curso_escolar(anyo_inicio, anyo_fin);






/*6.Crear una tabla donde se encontrarán las notas finales. Debe contener: 3 notas principales  (pueden ser aleatorias), 
	el id de los alumnos, la asignatura para la cual fue tomada y el año  escolar. 
*/


CREATE TABLE Esquema_01.nota_final(
	nota_1  FLOAT,
	nota_2 FLOAT,
	nota_3 FLOAT,
	id_alumno NUMERIC(10),
	id_asignatura NUMERIC(10),
	id_curso_escolar NUMERIC(10),
	FOREIGN KEY(id_alumno) REFERENCES Esquema_01.alumno(id),
	FOREIGN KEY(id_asignatura) REFERENCES Esquema_01.asignatura(id),
	FOREIGN KEY(id_curso_escolar) REFERENCES Esquema_01.curso_escolar(id)
	);





--7. Crear un proceso que cargue la tabla anterior con cada alumno, cada asignatura, y cada año  escolar. Se puede usar cursores. 

DECLARE @id_alumno NUMERIC(10),
		@id_asignatura NUMERIC(10),
		@id_curso_escolar NUMERIC(10), ------->Defino variables para el cursor
		@nota_1 FLOAT,
		@nota_2 FLOAT,
		@nota_3 FLOAT;

DECLARE cur_alumno_matriculado CURSOR FOR SELECT  *FROM Esquema_01.alumno_se_matricula_asignatura; ----->Defino el cursor

OPEN cur_alumno_matriculado; ----->lo abro

FETCH NEXT FROM cur_alumno_matriculado INTO @id_alumno,
											@id_asignatura, ------->Lectura de los registros
											@id_curso_escolar;

WHILE (@@FETCH_Status = 0 ) --La función @@FETCH_STATUS reporta CERO (0) cuando la instrucción Fetch lee un registro. Al finalizar @@FETCH_STATUS toma el valor de -1.
BEGIN
	SET @nota_1 = ROUND(((10 - 1) * RAND() + 1), 2);
	SET @nota_2 = ROUND(((10 - 1) * RAND() + 1), 2);
	SET @nota_3 = ROUND(((10 - 1) * RAND() + 1), 2);
	INSERT INTO Esquema_01.nota_final VALUES(@nota_1, @nota_2, @nota_3, @id_alumno, @id_asignatura, @id_curso_escolar);

FETCH NEXT FROM cur_alumno_matriculado INTO @id_alumno,
											@id_asignatura, ------->Lectura de los siguientes registros
											@id_curso_escolar;

END; -->FIN DEL WHILE

CLOSE cur_alumno_matriculado; ---> Cierro el cursor

DEALLOCATE cur_alumno_matriculado; -- Libero el espacio de memoria ocupado por el cursor

							

SELECT *FROM Esquema_01.nota_final; ---> Verificamos que los regitros se hayan insertado correctamente






--8. Crear un proceso que actualice la nota final de un alumno.

GO
CREATE PROCEDURE sp_modificacion_nota_alumno ------->Creo el procedimiento con esos parametros
	@nota_nombre varchar(10),
	@id_alumno numeric(10), 
	@id_asignatura numeric(10),
	@id_curso_escolar numeric(10),
	@nota_numero float
AS 
	 -----Aca elijo que nota es la que quiero modificar (intente hacerlo con un case pero me daba un error de sintaxis)
	IF @nota_nombre = 'nota_1' BEGIN
	UPDATE Esquema_01.nota_final SET nota_1 = @nota_numero WHERE id_alumno = @id_alumno AND id_asignatura = @id_asignatura AND id_curso_escolar = @id_curso_escolar
	END
	ELSE IF @nota_nombre = 'nota_2' BEGIN
	UPDATE Esquema_01.nota_final SET nota_2 = @nota_numero WHERE id_alumno = @id_alumno AND id_asignatura = @id_asignatura AND id_curso_escolar = @id_curso_escolar
	END
	ELSE IF @nota_nombre = 'nota_3' BEGIN 
	UPDATE Esquema_01.nota_final SET nota_3 = @nota_numero WHERE id_alumno = @id_alumno AND id_asignatura = @id_asignatura AND id_curso_escolar = @id_curso_escolar
	END 
	ELSE 
		PRINT('La nota elegida es invalida')
GO

EXECUTE sp_modificacion_nota_alumno N'nota_1',1,1,1,5 ; --Probamos que funcione el procedimiento

SELECT *FROM Esquema_01.nota_final; --Verificamos que se haya actualizado






/*9. Agregar a la tabla en donde se encontrarán las notas finales, una columna de nota del  coloquio.
Esta columna puede ser nula. Esto último dependerá del criterio de quien haga la  columna. 
*/

ALTER TABLE nota_final ADD nota_coloquio FLOAT;



--10. Crear una vista de alumnos desaprobados. 
GO
CREATE VIEW alumnos_desaprobados 
	AS SELECT a.nombre + ' ' + a.apellido1 + ' ' + a.apellido2 AS alumno, asi.nombre as asignatura, nf.id_curso_escolar as curso_escolar, CONVERT(DECIMAL(2,1),(nf.nota_1+nf.nota_2+nf.nota_3)/3 )AS nota_final_promedio FROM Esquema_01.alumno a
		JOIN Esquema_01.nota_final nf ON a.id = nf.id_alumno
		JOIN Esquema_01.asignatura asi ON nf.id_asignatura = asi.id
		WHERE (nf.nota_1+nf.nota_2+nf.nota_3)/3 < 7
GO

SELECT *FROM alumnos_desaprobados;



--11. Realizar un proceso que reciba por parámetro la nota de coloquio y el alumno, y que sea  insertado sobre la misma tabla. 

--Entiendo que en este punto se inserte la nota de coloquio al alumno por paramentro pero hay alumnos que se repiten osea tienen mas asignaturas 
--y otros cursos entonces se insetaria en todos lo campos del alumno sin importar la asignatura ni el curso (??


GO
CREATE PROCEDURE sp_insertar_ncoloquio(
	@coloquio_nota FLOAT,
	@id_alumno NUMERIC(10)
	)
AS
BEGIN TRY
	IF @coloquio_nota <= 1 AND @coloquio_nota >=10 
		UPDATE Esquema_01.nota_final SET [nota_coloquio] = @coloquio_nota WHERE id_alumno = @id_alumno;
	ELSE
		PRINT 'Nota incorrecta'
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER(), ERROR_MESSAGE()
END CATCH
GO

EXEC sp_insertar_ncoloquio 10.5, 1;

SELECT *FROM Esquema_01.nota_final;


