CREATE DEFINER=`root`@`localhost` FUNCTION `verificarSiEstaTerminadoElVehiculo`(id_automovil_input varchar(45)) RETURNS tinyint(1)
    DETERMINISTIC
begin
	declare finalizado bool;
    
    if exists(select ae.fecha_salida from automovil_estacion ae inner join estacion_trabajo e on ae.estacion_trabajo_id = e.id_estacion where ae.automovil_id = id_automovil_input and ae.fecha_salida is not null and e.orden = 5) then -- Suponiendo que todas las lineas de montaje tienen 5 estaciones
		set finalizado = true;
	else
		set finalizado = false;
    end if;
    
    return finalizado;
END