CREATE DEFINER=`root`@`localhost` PROCEDURE `TiempoPromedioVehiculosXLinea`(in id_linea_de_montaje_input int)
begin 

declare cantidad_autos int;

set cantidad_autos = (select count(ae.automovil_id) from automovil_estacion ae
	inner join estacion_trabajo e on ae.estacion_trabajo_id = e.id_estacion
    inner join linea_montaje lm on e.linea_id_linea = lm.id_linea_montaje
    where e.orden = 5 and ae.fecha_salida is not null and e.linea_id_linea = id_linea_de_montaje_input);
    
select sum(timestampdiff(SECOND,ae.fecha_entrada,fecha_salida)/60) / cantidad_autos as `promedio_construccion_vehiculos(minutos)` from automovil_estacion ae 
	inner join estacion_trabajo e on ae.estacion_trabajo_id = e.id_estacion
	inner join linea_montaje lm on e.linea_id_linea = lm.id_linea_montaje
	where e.linea_id_linea = id_linea_de_montaje_input and verificarSiEstaTerminadoElVehiculo(ae.automovil_id) = true order by ae.automovil_id,ae.estacion_trabajo_id; 

END