/*------------------------------INSERTS------------------------------------*/

insert into modelo values(1,"Renault","Clio");
insert into modelo values(2,"Peugeot","206");
insert into modelo values(3,"Fiat","Siena");
insert into modelo values(4,"Ford","Focus");

insert into concesionaria values(1,"Concesionaria MG");

insert into pedido(id_pedido,fecha_pedido,concesionaria_id) values (1,'2021-10-22',1);
insert into pedido_detalle values (1, 1, 2);
insert into pedido_detalle values(1, 4, 1);

insert into pedido(id_pedido,fecha_pedido,concesionaria_id) values (2,'2021-10-25',1);
insert into pedido_detalle values (2, 2, 2);
insert into pedido_detalle values(2, 3, 1);

insert into linea_montaje values (1,1);
insert into linea_montaje values (2,2);
insert into linea_montaje values (3,3);
insert into linea_montaje values (4,4);

insert into tarea values
	(1, "Chasis", "Armado de estructura, soldadura, colocacion de puertas, capot"),
    (2, "Pintura", "Proceso antioxidante, pintura y acabado final de brillo"),
    (3, "Tren delantero y trasero", "Armado y colocacion de sistema de traccion, frenos y direccion. Colocacion de llantas y cubiertas correspondientes"),
    (4, "Electricidad", "Cableado completo, instalacion de sistema de luces y electronicos, comprobacion y chequeo general"),
    (5, "Motorizacion y Banco De Prueba", "Instalacion y puesta a punto de motor. Sistema de embrague");

insert into estacion_trabajo values (1,"Estacion inicial chasis",1,1,0);
insert into estacion_trabajo values (2,"Estacion inicial chasis",2,1,0);
insert into estacion_trabajo values (3,"Estacion inicial chasis",3,1,0);
insert into estacion_trabajo values (4,"Estacion inicial chasis",4,1,0);

insert into estacion_trabajo values (5,"Estacion pintura",1,2,1);
insert into estacion_trabajo values (6,"Estacion pintura",2,2,1);
insert into estacion_trabajo values (7,"Estacion pintura",3,2,1);
insert into estacion_trabajo values (8,"Estacion pintura",4,2,1);

insert into estacion_trabajo values (9,"Estacion Tren delant y Traser",1,3,2);
insert into estacion_trabajo values (10,"Estacion Tren delant y Traser",2,3,2);
insert into estacion_trabajo values (11,"Estacion Tren delant y Traser",3,3,2);
insert into estacion_trabajo values (12,"Estacion Tren delant y Traser",4,3,2);

insert into estacion_trabajo values (13,"Estacion Electricidad",1,4,3);
insert into estacion_trabajo values (14,"Estacion Electricidad",2,4,3);
insert into estacion_trabajo values (15,"Estacion Electricidad",3,4,3);
insert into estacion_trabajo values (16,"Estacion Electricidad",4,4,3);

insert into estacion_trabajo values (17,"Estacion Motorizacion",1,5,4);
insert into estacion_trabajo values (18,"Estacion Motorizacion",2,5,4);
insert into estacion_trabajo values (19,"Estacion Motorizacion",3,5,4);
insert into estacion_trabajo values (20,"Estacion Motorizacion",4,5,4);


insert into estacion_trabajo values (1,"Estacion inicial chasis 1",1,1,0);
insert into estacion_trabajo values (2,"Estacion pintura 1",1,2,1);
insert into estacion_trabajo values (3,"Estacion Tren delant y Traser 1",1,3,2);
insert into estacion_trabajo values (4,"Estacion Electricidad 1",1,4,3);
insert into estacion_trabajo values (5,"Estacion Motorizacion 1",1,5,4);

insert into estacion_trabajo values (6,"Estacion inicial chasis 2",2,1,0);
insert into estacion_trabajo values (7,"Estacion pintura 2",2,2,1);
insert into estacion_trabajo values (8,"Estacion Tren delant y Traser 2",2,3,2);
insert into estacion_trabajo values (9,"Estacion Electricidad 2",2,4,3);
insert into estacion_trabajo values (10,"Estacion Motorizacion 2",2,5,4);


insert into estacion_trabajo values (11,"Estacion inicial chasis 3",3,1,0);
insert into estacion_trabajo values (12,"Estacion pintura 3",3,2,1);
insert into estacion_trabajo values (13,"Estacion Tren delant y Traser 3",3,3,2);
insert into estacion_trabajo values (14,"Estacion Electricidad 3",3,4,3);
insert into estacion_trabajo values (15,"Estacion Motorizacion 3",3,5,4);


insert into estacion_trabajo values (16,"Estacion inicial chasis 4",4,1,0);
insert into estacion_trabajo values (17,"Estacion pintura 4",4,2,1);
insert into estacion_trabajo values (18,"Estacion Tren delant y Traser 4",4,3,2);
insert into estacion_trabajo values (19,"Estacion Electricidad 4",4,4,3);
insert into estacion_trabajo values (20,"Estacion Motorizacion 4",4,5,4);

