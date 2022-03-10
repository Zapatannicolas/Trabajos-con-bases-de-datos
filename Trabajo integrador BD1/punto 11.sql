CREATE DEFINER=`root`@`localhost` PROCEDURE `listarAutomovilesConEstado`(in nro_pedido int)
begin

	select ae.automovil_id, 'Finalizado' as Estado, ae.estacion_trabajo_id  from automovil_estacion ae
		inner join automovil a on ae.automovil_id = a.id_automovil
        inner join estacion_trabajo e on ae.estacion_trabajo_id = e.id_estacion
        inner join pedido p on a.pedido_id = p.id_pedido
        where p.id_pedido = nro_pedido and e.orden=5 and ae.fecha_salida is not null
        
	UNION
    
    select ae.automovil_id, 'No finalizado' as Estado, ae.estacion_trabajo_id  from automovil_estacion ae
		inner join automovil a on ae.automovil_id = a.id_automovil
        inner join pedido p on a.pedido_id = p.id_pedido
        where p.id_pedido = nro_pedido and ae.fecha_salida is null;

END