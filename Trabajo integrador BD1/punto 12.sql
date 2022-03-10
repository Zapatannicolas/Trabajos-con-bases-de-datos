CREATE DEFINER=`root`@`localhost` PROCEDURE `listarCantidadInsumosPorPedido`(in nro_pedido int)
begin

	select i.descripcion,ei.insumo_id_insumo, sum(ei.cantidad) * sum(pd.cantidad)  as cantidad_total from pedido_detalle pd
	inner join modelo m on pd.modelo_id = m.id_modelo
	inner join linea_montaje lm on m.id_modelo = lm.modelo_id
	inner join estacion_trabajo e on e.linea_id_linea = lm.id_linea_montaje
	inner join estacion_insumo ei on ei.estacion_id_estacion = e.id_estacion
    inner join insumo i on ei.insumo_id_insumo = i.id_insumo
	where pd.pedido_id = nro_pedido
    group by ei.insumo_id_insumo;

END