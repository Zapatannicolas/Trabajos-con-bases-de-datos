DROP database terminal_automotriz;
/* Creacion y uso de la base de datos*/
create database terminal_automotriz;
use terminal_automotriz;

/*-------------------------------------------------------------------------------------------------------*/
/*Creacion de tablas*/
create table modelo
(
	id_modelo int not null primary key AUTO_INCREMENT,
    nombre varchar(45) not null,
    descripcion varchar(45)
);
create table linea_montaje
(
	id_linea_montaje int not null primary key AUTO_INCREMENT,
    modelo_id int not null,
    foreign key (modelo_id) references modelo(id_modelo)
);
create table tarea (
	id_tarea int not null primary key AUTO_INCREMENT,
    nombre char(50),
    descripcion char(150)
    );
create table estacion_trabajo (
	id_estacion int not null primary key AUTO_INCREMENT,
    nombre_estacion char(50),
    linea_id_linea int not null,
    tarea_id_tarea int not null,
    foreign key (linea_id_linea) references linea_montaje(id_linea_montaje),
    foreign key (tarea_id_tarea) references tarea(id_tarea)
    );
create table proveedor
(
	id_proveedor int not null primary key AUTO_INCREMENT,
    descripcion varchar(45) not null,
    contacto varchar(45) not null
);

create table insumo
(
	id_insumo int not null primary key AUTO_INCREMENT,
    nombre varchar(45) not null,
    descripcion varchar(45) not null
);	

create table estacion_insumo (
	estacion_id_estacion int not null,
    insumo_id_insumo int not null,
    primary key (estacion_id_estacion, insumo_id_insumo),
    foreign key (estacion_id_estacion) references estacion_trabajo(id_estacion),
    foreign key (insumo_id_insumo) references insumo(id_insumo),
    cantidad int
    );
create table concesionaria
(
	id_concesionaria int not null primary key,
    nombre varchar(45) not null
);

create table pedido
(
	id_pedido int not null primary key AUTO_INCREMENT,
    fecha_entrega date,
    fecha_pedido date,
    concesionaria_id int not null,
	foreign key (concesionaria_id) references concesionaria(id_concesionaria)
);

create table automovil
(
	id_automovil int not null primary key AUTO_INCREMENT,
    patente varchar(45),
    modelo_id int not null,
    pedido_id int not null,
    foreign key (modelo_id) references modelo(id_modelo),
    foreign key (pedido_id) references pedido(id_pedido)
);

create table pedido_detalle
(
    pedido_id int not null,
    modelo_id int not null,
    cantidad int,
    primary key(pedido_id, modelo_id),
    foreign key (modelo_id) references modelo(id_modelo)
);

create table automovil_estacion
(
	automovil_id int not null,
    estacion_trabajo_id int not null,
    fecha_entrada datetime default null,
    fecha_salida datetime default null,
    foreign key (automovil_id) references automovil(id_automovil),
    foreign key (estacion_trabajo_id) references estacion_trabajo(id_estacion)    
);

create table proveedor_detalle_insumo (
	proveedor_id int not null,
    insumo_id_insumo int not null,
    precio int,
    primary key (proveedor_id, insumo_id_insumo),
    foreign key (proveedor_id) references proveedor(id_proveedor),
    foreign key (insumo_id_insumo) references insumo(id_insumo)
);

/*---------------ABMS DE TABLAS----------------*/

DELIMITER $$
CREATE PROCEDURE abm_concesionaria(IN _id_concesionaria int, IN _nombre varchar(50), IN alta_baja_mod varchar(10)
,out _respuesta varchar(45))
BEGIN
	CASE alta_baja_mod
		WHEN "alta" THEN 
        set @repetido =0 ;
			Select count(*) into @repetido from concesionaria where nombre= _nombre or id_concesionaria = _id_concesionaria;
        if @repetido =0 then
			insert into concesionaria values (_id_concesionaria, _nombre);
            set _respuesta ='Concecionaria creado con exito!';
         else
         set _respuesta='Concesionaria  con ese nombre o id ya existe';
         end if;
		WHEN "baja" THEN
          set @repetido =0 ;
	Select count(*) into @repetido from concesionaria where id_concesionaria= _id_concesionaria;
        if @repetido =1 then
			delete from concesionaria WHERE id_concesionaria=_id_concesionaria;
            set _respuesta ='Concecionaria eliminado con exito!';
		else
           set _respuesta='No existe esa Concecionaria';
         end if;
		WHEN "mod" THEN 
        set @repetido =0 ;
	Select count(*) into @repetido from concesionaria where id_concesionaria= _id_concesionaria;
    if @repetido =1 then
			update concesionaria set
		nombre=_nombre where id_concesionaria=_id_concesionaria;
	 set _respuesta ='Concesinaria actualizado con exito!';
	else
	    set _respuesta='No existe esa Concesionaria';
	end if;
	END CASE;
	select * from concesionaria;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abm_insumo`(IN _id_insumo int, IN _nombre varchar(50), IN _descripcion varchar(150) , IN alta_baja_mod varchar(10),out _respuesta varchar(45))
BEGIN
	CASE alta_baja_mod
    WHEN "alta" THEN 
		set @repetido =0;
    Select count(*) into @repetido from insumo where  id_insumo = _id_insumo;
        if @repetido =0 then
			insert into insumo values (_id_insumo, _nombre, _descripcion);
            set _respuesta ='Insumo agregado con exito!';
		else
			set _respuesta='Insumo  con ese id ya existe';
         end if;
	WHEN "baja" THEN
          set @repetido =0 ;
	Select count(*) into @repetido from insumo where id_insumo= _id_insumo;
        if @repetido =1 then
			delete from insumo WHERE id_insumo=_id_insumo;
				set _respuesta ='Insumo eliminado con exito!';
		else
           set _respuesta='Insumo con ese id no existe';
		end if;   
	WHEN "mod" THEN 
        set @repetido =0 ;
	Select count(*) into @repetido from insumo where id_insumo= _id_insumo;
		if @repetido =1 then
			update insumo set
			nombre=_nombre, descripcion=_descripcion where id_insumo=_id_insumo;
				set _respuesta ='Insumo actualizado con exito!';
		else
			set _respuesta='Insumo con ese id no existe';
		end if;   
	END CASE;
	select * from insumo;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abm_modelo`(IN _id_modelo int, IN _nombre varchar(50), IN _descripcion varchar(100),
 IN alta_baja_mod varchar(10),out _respuesta varchar(45))
BEGIN

    CASE 	alta_baja_mod
      WHEN 'alta' THEN 
        set @repetido =0 ;
	Select count(*) into @repetido from modelo where nombre= _nombre or id_modelo = _id_modelo;
        if @repetido =0 then
           insert into modelo values (_id_modelo,_nombre,_descripcion);
           set _respuesta ='Modelo creado con exito!';
         else
         set _respuesta='Modelo o id  repetido ';
         end if;
         
      WHEN 'baja' THEN 
        set @repetido =0 ;
	Select count(*) into @repetido from modelo where id_modelo= _id_modelo;
        if @repetido =1 then
           delete from modelo where id_modelo=_id_modelo;
           set _respuesta ='Modelo eliminado con exito!';
		else
           set _respuesta='No existe ese modelo';
         end if;
	
	WHEN 'mod' THEN
      set @repetido =0 ;
	Select count(*) into @repetido from modelo where id_modelo= _id_modelo;
    if @repetido =1 then
      update modelo set
		nombre=_nombre, descripcion=_descripcion where id_modelo=_id_modelo;
        set _respuesta ='Modelo actualizado con exito!';
	else
	    set _respuesta='No existe ese modelo';
	end if;
        
    END CASE;
    select * from modelo;
  END$$
  DELIMITER ;
  
  DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abm_pedido`(IN _id_pedido int, IN _concesionaria_id_concesionaria int, IN _fecha_pedido date,
IN _fecha_entrega date, IN alta_baja_mod varchar(10),out _respuesta varchar (65))
BEGIN
	CASE alta_baja_mod
	WHEN "alta" THEN -- valida que no exista un pedido con el mismo id, y valida que exista la concesionaria
        set @repetido =0 ;
        set @existe_concesionaria=0;
			Select count(*) into @repetido from pedido where id_pedido=_id_pedido;
			Select count(*) into @existe_concesionaria from concesionaria where id_concesionaria= _concesionaria_id_concesionaria;
        if @repetido =0 and @existe_concesionaria=1 then
			insert into pedido (id_pedido,concesionaria_id, fecha_pedido, fecha_entrega) values (_id_pedido, _concesionaria_id_concesionaria, _fecha_pedido, _fecha_entrega);
				set _respuesta ='Pedido creado con exito!';
		else
				set _respuesta='Pedido  con ese id ya existe o concecionaria no existe';
		end if;  
	WHEN "baja" THEN
		set @repetido =0 ;
	Select count(*) into @repetido from pedido where id_pedido= _id_pedido;
        if @repetido =1 then
			delete from pedido WHERE id_pedido=_id_pedido;
				set _respuesta ='Pedido eliminado con exito!';
		else
           set _respuesta='Pedido no existe con ese id';
         end if;
            
		WHEN "mod" THEN -- En este caso solo se pueden modificar las columnas que no son clave (fecha_pedido y fecha_entrega)
			set @repetido =0 ;
	Select count(*) into @repetido from pedido where id_pedido= _id_pedido;
        if @repetido =1 then
            update pedido set
			fecha_pedido=_fecha_pedido, fecha_entrega=_fecha_entrega where id_pedido=_id_pedido ;
        set _respuesta ='Pedido actualizado con exito!';
	else
	    set _respuesta='Pedido no existe con ese id';
	end if;    
	END CASE;
	select * from pedido;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `abm_proveedor`(IN _id_proveedor int, IN _descripcion varchar(50), IN _contacto varchar(100), IN alta_baja_mod varchar(10)
,out _respuesta varchar (45))
BEGIN
	CASE alta_baja_mod
		WHEN "alta" THEN 
        set @repetido =0 ;
			Select count(*) into @repetido from proveedor where  id_proveedor = _id_proveedor;
        if @repetido =0 then
			insert into proveedor values (_id_proveedor, _descripcion, _contacto);
            set _respuesta ='proveedor agregado con exito!';
         else
         set _respuesta='Proovedor  con ese id ya existe';
         end if;
		WHEN "baja" THEN
        set @repetido =0 ;
	Select count(*) into @repetido from proveedor where proveedor_id= _id_proveedor;
        if @repetido =1 then
			delete from proveedor WHERE id_proveedor=_id_proveedor;
            set _respuesta ='Proveedor eliminado con exito!';
		else
           set _respuesta='Proveedor con ese id no existe';
         end if;
		WHEN "mod" THEN 
        set @repetido =0 ;
	Select count(*) into @repetido from proveedor where id_proveedor= _id_proveedor;
    if @repetido =1 then
			update proveedor set
		decripcion=_descripcion, contacto=_contacto where id_proveedor=_id_proveedor;
        set _respuesta ='Proveedor actualizado con exito!';
	else
	    set _respuesta='Proveedor con ese id no existe';
	end if;
        
	END CASE;
	select * from proveedor;
END$$
DELIMITER ; 

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `detalle_pedido_alta`(idPedido int, idModelo int, cantidad int, out resultado int,out mensaje varchar(45))
BEGIN

declare nCantidad int;
select count(*) into nCantidad from pedido_detalle where pedido_id=idPedido and modelo_id=idModelo;


IF (nCantidad > 0) then
select -1 INTO resultado;
select "Encontro" into mensaje;

ELSE
insert into pedido_detalle values(idPedido,idModelo,cantidad);
select 0 into resultado;
select "Detalle cargado correctamente" into mensaje;
END IF;

END$$
DELIMITER ;

/*-----------PUNTO 8 (GENERACION VEHICULO, PATENTE Y CANTIDAD DEL DET. PEDIDO-----------*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `asignar_pedido_auto`(in idPedido int)
BEGIN
	declare finished int default 0;
	declare nCantidad int;
	declare nInsertados int;
	declare nModelo int;

	declare curDetallePedido
		cursor for 
			select modelo_id, cantidad from pedido_detalle where pedido_id = idPedido;
	
    declare continue handler	
		for not found set finished = 1;
        
	open curDetallePedido;
    
    getDetalle: loop
		
        fetch curDetallePedido into nModelo, nCantidad;
        if finished = 1 then
			leave getDetalle;
		end if;
        set nInsertados = 0;
        
		while nInsertados < nCantidad do
		select @iPatente := upper(substring(md5(rand())from 1 for 6));
        insert into automovil(patente,modelo_id,pedido_id) values (@iPatente, nModelo, idPedido);
        set nInsertados = nInsertados + 1;
        end while;
		insert into linea_montaje (modelo_id) values (nModelo);
        
	end loop getDetalle;
    
    close curDetallePedido;
	
END$$
DELIMITER ;

/*------------------PRUEBA INSERCION DE DATOS------------------*/

call abm_concesionaria(1, 'concesionaria mg', 'alta', @_respuesta);

call abm_modelo(1, 'RENAULT', 'Clio', 'alta', @_respuesta);

call abm_pedido(1, 1, '2021-10-21', '2021-12-27', 'alta', @_respuesta);

call detalle_pedido_alta(1, 1, 5, @resultado, @mensaje);

call asignar_pedido_auto(1);

SELECT * FROM automovil;
