CREATE DEFINER=`root`@`localhost` PROCEDURE `iniciarMontajeV2`(patente_auto varchar(45), out resultado int, out mensaje varchar(45))
BEGIN

-- MODELO DEL AUTO SEGUN SU PATENTE

SET @modeloProcedure:=(SELECT modelo_id from Automovil where patente=patente_auto);

-- PATENTE DEL VEHICULO

SET @idVehiculoProcedure:=(SELECT id_automovil from automovil where patente=patente_auto);

-- PRIMERA ESTACION EN LA CUAL PONDREMOS EL VEHICULO A CONSTRUIR

SET @idEstacionProcedure:=(select e.id_estacion from estacion_trabajo e inner join linea_montaje m on e.linea_id_linea=m.id_linea_montaje where m.modelo_id=@modeloProcedure and orden=1);

-- BUSCA LA CANTIDAD DE VEHICULOS DEL MISMO MODELO QUE TODAVIA SIGAN EN LA PRIMER ESTACION

SET @cantidad:=(select count(*) from automovil_estacion ea inner join estacion_trabajo e on ea.estacion_trabajo_id=e.id_estacion 
inner join automovil a on ea.automovil_id=a.id_automovil where e.orden=1 and ea.fecha_salida IS NULL 
and a.modelo_id=(SELECT modelo_id from automovil where patente=patente_auto limit 1));

-- CONDICIONAL PARA VER SI SE PUEDE INGRESAR EL VEHICULO

IF @cantidad=0 THEN
update automovil_estacion set fecha_salida=now() where automovil_id = (SELECT id_automovil from automovil where patente=patente_auto);
			INSERT INTO automovil_estacion (fecha_entrada,estacion_trabajo_id,automovil_id) 
			values (now(),@idEstacionProcedure,@idVehiculoProcedure);
            select 0 into resultado;
            select "-" into mensaje;
            select @resultado,@mensaje;
            
            ELSE 
            select -1 into resultado;
			select "NO SE PUEDE AVANZAR" into mensaje;
            select @resultado,@mensaje,@idVehiculoProcedure as Patente;
				END IF;


END