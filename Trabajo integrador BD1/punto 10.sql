CREATE DEFINER=`root`@`localhost` PROCEDURE `AvanzarEstacion`(id_auto int, out resultado int, out mensaje varchar(45))
BEGIN

-- MODELO DEL AUTO SEGUN SU PATENTE

SET @modeloProcedure:=(SELECT modelo_id from automovil where id_automovil=id_auto limit 1);

-- EL ORDEN ACTUAL DE LA ESTACION DEL AUTO

SET @ordenProcedure:=(select e.orden from automovil_estacion ea inner join estacion_trabajo e
 on ea.estacion_trabajo_id=e.id_estacion inner join linea_montaje m on e.linea_id_linea=m.id_linea_montaje
 where m.modelo_id=@modeloProcedure and ea.automovil_id= id_auto and ea.fecha_entrada IS NOT NULL AND ea.fecha_salida IS NULL limit 1);

-- ID DE LA PROXIMA ESTACION EN LA CUAL TENDRIA QUE INGRESAR

SET @idEstacionProcedure:=(select e.id_estacion from estacion_trabajo e inner join linea_montaje m on e.linea_id_linea=m.id_linea_montaje
 where m.modelo_id=@modeloProcedure and orden=@ordenProcedure+1 limit 1);

-- PATENTE DEL VEHICULO

SET @idVehiculoProcedure:=(SELECT id_automovil from automovil where id_automovil=id_auto limit 1);

-- BUSCA LA CANTIDAD DE VEHICULOS QUE SE ENCUENTRAN EN LA PROXIMA ESTACION

SET @cantidad:=(select count(*) from automovil_estacion ea inner join estacion_trabajo e on ea.estacion_trabajo_id=e.id_estacion 
inner join automovil a on ea.automovil_id=a.id_automovil where e.orden=@ordenProcedure+1 and ea.fecha_salida IS NULL 
and a.modelo_id=(SELECT modelo_id from automovil where id_automovil=id_auto));

-- CONDICIONAL PARA VER SI INGRESA EL VEHICULO

IF @cantidad=0 and @idEstacionProcedure IS NOT NULL THEN
update automovil_estacion ea inner join estacion_trabajo e on ea.estacion_trabajo_id=e.id_estacion set fecha_salida=now() where automovil_id=id_auto and e.orden=@ordenProcedure;
			INSERT INTO automovil_estacion (fecha_entrada,estacion_trabajo_id,automovil_id) 
			values (now(),@idEstacionProcedure,@idVehiculoProcedure);
            select 0 into resultado;
            select "-" into mensaje;
            select @resultado,@mensaje,@idVehiculoProcedure as Patente;
            
            ELSE IF @idEstacionProcedure IS NULL THEN
            update automovil_estacion ea inner join estacion_trabajo e on ea.estacion_trabajo_id=e.id_estacion set fecha_salida=now() where automovil_id = id_auto and e.orden=@ordenProcedure;
            
            select "AUTOMOVIL FINALIZADO" into mensaje;
            select @mensaje;
            ELSE
            select -1 into resultado;
			select "NO SE PUEDE AVANZAR" into mensaje;
            select @resultado,@mensaje,@idVehiculoProcedure as Patente;
				END IF;
                END IF;
                
END