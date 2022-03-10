--Parte 2 

--1. Devuelve todos los datos del alumno más joven. 

USE escuela;

SELECT TOP 1 *FROM Esquema_01.alumno a
ORDER BY a.fecha_nacimiento DESC;

--2. Devuelve un listado con los profesores que no están asociados a un departamento. 

SELECT *FROM Esquema_01.profesor p 
WHERE p.id_departamento IS NULL;

--3. Devuelve un listado con los departamentos que no tienen profesores asociados.

SELECT p.* FROM Esquema_01.departamento d 
LEFT JOIN Esquema_01.profesor p ON d.id = p.id_departamento
WHERE p.id_departamento IS NULL;

--4. Devuelve un listado con los profesores que tienen un departamento asociado y que no imparten ninguna asignatura. 

SELECT p.* FROM Esquema_01.profesor p 
LEFT JOIN Esquema_01.asignatura a ON p.id = a.id_profesor
WHERE p.id_departamento IS NOT NULL AND a.id_profesor IS NULL;

--5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.

SELECT a.* FROM Esquema_01.asignatura a
WHERE NOT EXISTS (SELECT * FROM Esquema_01.profesor p WHERE a.id_profesor=p.id);

--6. Devuelve un listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.

SELECT * FROM Esquema_01.departamento d
WHERE  EXISTS(SELECT * FROM Esquema_01.asignatura a 
			WHERE NOT EXISTS(SELECT *FROM Esquema_01.curso_escolar c 
								JOIN Esquema_01.alumno_se_matricula_asignatura ama ON c.id = ama.id_curso_escolar ------------>VERIFICAR LUEGO
								WHERE ama.id_asignatura = a.id)
								);

/*7. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen  vinculados. El listado también debe mostrar aquellos profesores que no tienen ningún  
departamento asociado. El listado debe devolver cuatro columnas, nombre del  
departamento, primer apellido, segundo apellido y nombre del profesor. El resultado estará  
ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el  
nombre. 
 */
 SELECT d.nombre AS departamento, p.apellido1 AS apellido_profesor_1, p.apellido2 AS apellido_profesor_2, p.nombre AS nombre_profesor FROM Esquema_01.departamento d
RIGHT JOIN Esquema_01.profesor p ON d.id = p.id_departamento
ORDER BY d.nombre, p.apellido1, p.apellido2, p.nombre DESC;

/*8. Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se  
haya impartido en ningún curso escolar. El resultado debe mostrar el nombre del  
departamento y el nombre de la asignatura que no se haya impartido nunca. 
*/

SELECT d.nombre AS departamento, a.nombre AS asignatura FROM Esquema_01.departamento d
JOIN Esquema_01.profesor p ON d.id = p.id_departamento
JOIN Esquema_01.asignatura a ON p.id = a.id_profesor
WHERE NOT EXISTS(SELECT *FROM Esquema_01.alumno_se_matricula_asignatura ama WHERE ama.id_asignatura = a.id)

--9. Eliminar aquellos profesores que hayan nacido en 1979. Tener en cuenta las relaciones.

UPDATE a SET a.id_profesor = NULL 
FROM Esquema_01.asignatura a
JOIN Esquema_01.profesor p ON a.id_profesor = p.id -------------> Primero actualizo la tabla asignatura poniendo en null a los profesores
WHERE YEAR(p.fecha_nacimineto) = '1979'

DELETE FROM Esquema_01.profesor  WHERE YEAR(fecha_nacimineto) = '1979'; ----->Elimino a los profesores

--10. Eliminar a la alumna “Sonia Gea Ruiz”. Tener en cuenta las relaciones. 

ALTER TABLE Esquema_01.alumno_se_matricula_asignatura ADD CONSTRAINT fk_id_alumno FOREIGN KEY(id_alumno) REFERENCES Esquema_01.alumno(id) ON DELETE CASCADE; -->Con esta sentencia me permite eliminar registros en cascada de la tabla alumnos
DELETE FROM Esquema_01.alumno WHERE nombre = 'Sonia' AND apellido1 = 'Gea' AND apellido2 = 'Ruiz'; 