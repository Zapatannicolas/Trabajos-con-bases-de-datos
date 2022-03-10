/*Parte 4 - ¿Qué medidas tomarán? 
Esta sección está para atender problemas de usuarios. Deben escribir qué medidas tomarán frente a  problemas que tengan usuarios y 
en algunos casos colocar la query SQL. 
Nota de real importancia: no a todos los usuarios les interesan los IDs. Si deben devolver algo, ver de  entregarlo lo más similar a un reporte, pero por salida de SQL. 


1. Como usuario 3, quiero ver un listado de todos los profesores y sus asignaturas.


Como primer medida se tendria que verificar si el usuario 3 existe, si no es asi crearle un login y un usuario
de la sieguiente forma

USE master 
GO
CREATE LOGIN Usuario_3 WITH PASSWORD = '123456';  utilizamos la contraseña que nosotros creamos conveniente
CREATE USER Usuario_3 FOR LOGIN Usuario_3;

Luego se le otorgaran los permisos para realizar las cosas que necesite en este caso como necesita consultar tablas
le prodriamos dar los permisos de lectura para dichas tablas

GRANT SELECT ON escuela.dbo.profesor TO usuario_3;
GRANT SELECT ON escuela.dbo.asignatura TO usuario_3;  En este caso se supone que las tablas se encuentran en la bd escuela y en el esquema dbo

El usuario debera hacer la siguente consulta

SELECT p.nombre AS profesor, a.nombre AS asignatura FROM dbo.profesores p
JOIN dbo.asignatura a ON p.id = a.id_profesor;              ---> esto devuelve el listado de profesosres y asignaturas




2. Como usuario 2, quiero poder crear una tabla en la base de datos actual que me tenga todos  los alumnos de la promoción 2010. 
   Este usuario solo sabe consultar a la base de datos, y su  conocimiento técnico de la misma, es mínimo. 

   Como pre condicion el usuario 2 tendra que tener los permisos necesarios para crear y seleccionar las tablas de las bases de datos correspondientes
   luego ya que dice que el usuario no cuenta con mucho conocimiento lo que podria hacer es lo siguiente:

   SELECT * INTO NuevaTabla FROM OtraTabla;  ------->Esta sentencia lo que hace es crear una nueva tabla a partir de una consulta a otra tabla, facil y sencillo

   en este caso podria ser algo asi:

   SELECT * INTO alumnos_2010 FROM alumnos WHERE alumnos.promocion=2010;



 3. Entra el usuario Pepito y necesita poder consular sobre la base de datos actual. 
 
 se le podria dar los permisos o darle un rol de solo lectura como el siguiente 

 ALTER ROLE db_datareader
	ADD MEMBER pepito;  
 GO



 4. El gerente de la empresa le da los privilegios a Pepito y ahora puede ejecutar store
procedures dentro de la base de datos.

La forma mas facil de hacer esto es la siguiente

use bd_actual
GO
GRANT EXECUTE TO pepito ------------>De esta forma pepito va apoder ejecutar todos los sp de la base de datos tanto a los actuales como a los nuevos
GO



5. Se le han denegado los permisos a Pepito y se necesita eliminar este usuario de la base de
datos. Ordenes directivas.

se le quita el rol de lectura

ALTER ROLE db_datareader
			DROP MEMBER pepito;


y luego se le denegan los permisos

GO
DENY EXECUTE TO pepito 
GO

se elimina de la base de datos

DROP USER IF EXISTS pepito;




6. Entra alguien del ministerio de educación y le tenemos que dar un usuario que pueda ver en
una sola consulta los alumnos aprobados, el año, y las asignaturas.


--Primero creamos el login y el usuario 

USE master 
GO
CREATE LOGIN usuario_ministerio WITH PASSWORD = '123456'; 
CREATE USER Usuario_ministerio FOR LOGIN Usuario_ministerio;

--En este caso para lo que necesita el usuario se podria crear una vista con dichos campos 
(suponiendo que la base de datos sea la creada anteriormente la vista quedaria algo asi, esto devolveria el alumno, la signatura y el año)

GO
CREATE VIEW vista_alumnos_aprobados
	WITH SchemaBinding
	AS SELECT a.nombre + ' ' + a.apellido1 + ' ' + a.apellido2 AS alumno, asi.nombre as asignatura, c.anyo_inicio + '-' + c.anyo_fin as anio FROM Esquema_01.alumno a
		JOIN Esquema_01.nota_final nf ON a.id = nf.id_alumno
		JOIN Esquema_01.asignatura asi ON nf.id_asignatura = asi.id
		JOIN Esquema_01.curso_escolar c ON nf.id_curso_escolar = c.id
		WHERE (nf.nota_1+nf.nota_2+nf.nota_3)/3 >= 7         ---> la nota promedio sea mayor igual a 7
GO

--Finalmente le damos permisos al usuario para que pueda acceder a la vista

GRANT SELECT ON Esquema_01.alumnos_aprobados TO usuario_ministerio;
GO






7. El usuario se queja porque las consultas sobre las tablas son lentas. 


--Para solucionar este problema se prodria crear indices a los campos de la vista creada, de esta forma lo haria mas rapido

GO
CREATE INDEX vista_alumnos_aprobados_idx ON
Esquema_01.vista_alumnos_aprobados (alumno)
INCLUDE (asignatura, anio)
GO





8. El usuario 4 (no está en la tabla de arriba), se queja porque no puede ver el resultado de la  consulta a los alumnos del modelo, y no hay problemas en la consulta SQL.

--Esto se debe a que no tiene los permisos para realizar la consulta

GRANT SELECT ON Esquema_01.alumnos_aprobados TO usuario_4;
GO

*/
