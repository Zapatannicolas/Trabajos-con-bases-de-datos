/*Parte 1 
1. Crear una base de datos para poder alojar la siguiente estructura. El nombre será a elección 
de cada uno en base a la interpretación del modelo. NO CREAR TABLAS AÚN.
*/

--Me desconecto para borrar la base de datos si existe
ALTER DATABASE escuela
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

--Elimino la base de datos si existe
DROP DATABASE IF EXISTS escuela;

--Creo la base de datos
CREATE DATABASE escuela;

--Pongo en uso la bd
GO
USE escuela
GO




--2. Crear 3 usuarios/logins con las siguientes características: 

--Creo los login
USE master 
GO
CREATE LOGIN User_01 WITH PASSWORD = '123456';
CREATE LOGIN User_02 WITH PASSWORD = '123456';
CREATE LOGIN User_03 WITH PASSWORD = '123456';

--Creo lo usuarios pedidos

USE escuela
GO
CREATE USER User_01 FOR LOGIN User_01 WITH DEFAULT_SCHEMA = Esquema_01; --Utiliza por defecto el esquema dbo
CREATE USER User_02 FOR LOGIN User_02 WITH DEFAULT_SCHEMA = Esquema_02; --le asigno por default el esquema 
CREATE USER User_03 FOR LOGIN User_03 WITH DEFAULT_SCHEMA = Esquema_03;

--Creo los esquemas

CREATE SCHEMA Esquema_01 AUTHORIZATION User_01
GO

CREATE SCHEMA Esquema_02 AUTHORIZATION User_02
GO

CREATE SCHEMA Esquema_03 AUTHORIZATION User_03
GO

--Otorgamos roles y permisos a los usuarios

--En esta parte me confundi un poco ya que dice heredar rol, no sabia si tenia que crear un rol nuevo con 'CREATE ROLE Administrador;' o 
--darle un rol ya establecido en la base de datos, finalmente opte por esta opcion


ALTER ROLE db_owner ADD MEMBER User_01; --Le damos el rol de administrador 

ALTER ROLE db_datareader ADD MEMBER User_02;
ALTER ROLE db_datawriter ADD MEMBER User_02; --Heredamos los roles de lectura y escritura para el user02

 --Le damos los permisos al User_03
GRANT SELECT ON SCHEMA::Esquema_01 TO User_03;
GRANT SELECT ON SCHEMA::Esquema_03 TO User_03;
--GRANT CREATE VIEW ON SCHEMA::Esquema_01 TO User_03; 
--GRANT CREATE VIEW ON SCHEMA::Esquema_03 TO User_03;       De esta forma no me lo permitio hacer me decia que el habia un error de sintaxis
GRANT CREATE VIEW TO User_03; 





--3. Crear todas las tablas en el esquema Esquema_01. Tener en cuenta qué usuario se usará. 
--Ahora me desconecto de la bd y me vuelvo a conectar con el usuario creado User_01 para la creacion de tablas

CREATE TABLE Esquema_01.departamento(  --Creo las tablas en el Esquema_01
	id NUMERIC(10) PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL
);

CREATE TABLE Esquema_01.profesor(
	id NUMERIC(10) PRIMARY KEY,
	nif VARCHAR(9),
	nombre VARCHAR(25) NOT NULL,
	apellido1 VARCHAR(50) NOT NULL,
	apellido2 VARCHAR(50),
	ciudad VARCHAR(25) NOT NULL,
	direccion VARCHAR(50) NOT NULL,
	telefono VARCHAR(9),
	fecha_nacimineto DATE NOT NULL,
	sexo CHAR NOT NULL CHECK(sexo IN('h','m')),
	id_departamento NUMERIC(10)
	FOREIGN KEY(id_departamento) REFERENCES Esquema_01.departamento(id)
	);

CREATE TABLE Esquema_01.grado(
	id NUMERIC(10) PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL
	);

CREATE TABLE Esquema_01.asignatura(
	id NUMERIC(10) PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	creditos FLOAT NOT NULL,
	tipo VARCHAR(20) NOT NULL CHECK(tipo IN('básica','obligatoria','optativa')),
	curso NUMERIC(3) NOT NULL,
	cuatrimestre NUMERIC(3) NOT NULL,
	id_profesor NUMERIC(10),
	id_grado NUMERIC(10),
	FOREIGN KEY(id_profesor) REFERENCES Esquema_01.profesor(id),
	FOREIGN KEY(id_grado) REFERENCES Esquema_01.grado(id)
	);

CREATE TABLE Esquema_01.alumno(
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

CREATE TABLE Esquema_01.curso_escolar(
	id NUMERIC(10) PRIMARY KEY,
	anyo_inicio NUMERIC(4) NOT NULL,
	anyo_fin NUMERIC(4) NOT NULL
);

CREATE TABLE Esquema_01.alumno_se_matricula_asignatura(
	id_alumno NUMERIC(10),
	id_asignatura NUMERIC(10),
	id_curso_escolar NUMERIC(10),
	PRIMARY KEY(id_alumno, id_asignatura, id_curso_escolar),
	FOREIGN KEY(id_alumno) REFERENCES Esquema_01.alumno(id),
	FOREIGN KEY(id_asignatura) REFERENCES Esquema_01.asignatura(id),
	FOREIGN KEY(id_curso_escolar) REFERENCES Esquema_01.curso_escolar(id)
);






--4. Insertar los datos desde el archivo Data_SQLServer.sql en la carpeta Parte 1.  

-- INSERTADO CON EXITO :)




--5. Insertar al menos 10 alumnos a la tabla alumno. 

BEGIN TRANSACTION
	INSERT INTO alumno VALUES (25, '69545419S', 'Martin', 'Sanaz', 'Valle', 'Almería', 'C/ Mercurio', '458253876', '1992/09/10', 'H');
	INSERT INTO alumno VALUES (26, '58942806M', 'Julieta', 'Sánchez', 'Martins', 'Almería', 'C/ Real del barrio alto', '846254837', '1991/08/21', 'M');
	INSERT INTO alumno VALUES (27, '16905885A', 'Eduardo', 'Bureu', 'Pignataro', 'Almería', 'C/ Estrella fugaz', NULL, '2001/10/05', 'H');
	INSERT INTO alumno VALUES (28, '89403869Y', 'Franco', 'Alonso', 'Alvarez', 'Almería', 'C/ Júpiter', '589449590', '1999/05/28', 'H');
	INSERT INTO alumno VALUES (29, '97258166K', 'Bruno', 'Diaz', 'Turco', 'Almería', 'C/ Neptuno', NULL, '1998/05/02', 'H');
	INSERT INTO alumno VALUES (30, '41542571K', 'Marcos', 'Ramirez', 'Tremblo', 'Almería', 'C/ Urano', '567151429', '1996/01/21', 'H');
	INSERT INTO alumno VALUES (31, '46900725E', 'Maximiliano', 'Guillin', 'Paco', 'Almería', 'C/ Andarax', '789837625', '1997/08/15', 'H');
	INSERT INTO alumno VALUES (32, '11578526G', 'Facundo', 'Salas', 'Yundtez', 'Almería', 'C/ Picos de Europa', '710652431', '1999/09/01', 'H');
	INSERT INTO alumno VALUES (33, '79089577Y', 'Melany', 'Kolek', 'López', 'Almería', 'C/ Los pinos', '595524381', '1998/06/30', 'M');
	INSERT INTO alumno VALUES (34, '14791230N', 'Nicolas', 'Rolfo', 'Guerra', 'Almería', 'C/ Cabo de Gata', '582652498', '1999/12/12', 'H');
COMMIT TRANSACTION





--6. Actualizar los campos Varchar en la tabla alumno, quitando los acentos. Ejemplo: Nicolás debería de ser Nicolas.


CREATE FUNCTION Esquema_01.fc_eliminar_acento(@String VARCHAR(MAX)) --Para este punto decidi crear una funcion que reemplace las vocales que tienen acento por una que no
RETURNS VARCHAR(MAX)
AS
BEGIN
    
    SET @String = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@String,'á','a'),'à','a'),'â','a'),'ã','a'),'ä','a')
    SET @String = REPLACE(REPLACE(REPLACE(REPLACE(@String,'é','e'),'è','e'),'ê','e'),'ë','e')
    SET @String = REPLACE(REPLACE(REPLACE(REPLACE(@String,'í','i'),'ì','i'),'î','i'),'ï','i')
    SET @String = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@String,'ó','o'),'ò','o'),'ô','o'),'õ','o'),'ö','o')
    SET @String = REPLACE(REPLACE(REPLACE(REPLACE(@String,'ú','u'),'ù','u'),'û','u'),'ü','u')
   
    RETURN (@String)
END


UPDATE Esquema_01.alumno SET nombre = Esquema_01.fc_eliminar_acento(nombre); --Actulizo la tabla nombre y llamo a la funcion

SELECT nombre FROM Esquema_01.alumno; --Pruebo que se haya modificado correctamente