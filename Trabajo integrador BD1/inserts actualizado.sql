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



insert into estacion_trabajo values (1,"Estacion inicial chasis",1,1,1);
insert into estacion_trabajo values (2,"Estacion inicial chasis",2,1,1);
insert into estacion_trabajo values (3,"Estacion inicial chasis",3,1,1);
insert into estacion_trabajo values (4,"Estacion inicial chasis",4,1,1);

insert into estacion_trabajo values (5,"Estacion pintura",1,2,2);
insert into estacion_trabajo values (6,"Estacion pintura",2,2,2);
insert into estacion_trabajo values (7,"Estacion pintura",3,2,2);
insert into estacion_trabajo values (8,"Estacion pintura",4,2,2);

insert into estacion_trabajo values (9,"Estacion Tren delant y Traser",1,3,3);
insert into estacion_trabajo values (10,"Estacion Tren delant y Traser",2,3,3);
insert into estacion_trabajo values (11,"Estacion Tren delant y Traser",3,3,3);
insert into estacion_trabajo values (12,"Estacion Tren delant y Traser",4,3,3);

insert into estacion_trabajo values (13,"Estacion Electricidad",1,4,4);
insert into estacion_trabajo values (14,"Estacion Electricidad",2,4,4);
insert into estacion_trabajo values (15,"Estacion Electricidad",3,4,4);
insert into estacion_trabajo values (16,"Estacion Electricidad",4,4,4);

insert into estacion_trabajo values (17,"Estacion Motorizacion",1,5,5);
insert into estacion_trabajo values (18,"Estacion Motorizacion",2,5,5);
insert into estacion_trabajo values (19,"Estacion Motorizacion",3,5,5);
insert into estacion_trabajo values (20,"Estacion Motorizacion",4,5,5);

insert into insumo values
	(1,"CH47","parabrisas(chico)"),
    (2,"CH48","parabrisas(grande)"),
    (3,"CH49","puerta izq(chica)"),
    (4,"CH50","puerta der(chica)"),
    (5,"CH51","puerta izq(grande)"),
    (6,"CH52","puerta der(grande)"),
    (7,"CH53","optica izq(chica)"),
    (8,"CH54","optica der(grande)"),
    (9,"XZ30","antioxidante"), 
    (10,"XZ31","rojo"),
    (11,"XZ32","verde"),
    (12,"XZ33","azul"),
    (13,"XZ34","amarillo"),
    (14,"XZ35","purpura"),
    (15,"XZ36","gris"),
    (16,"ZZ10","freno chico"),
    (17,"ZZ11","freno grande"),
    (18,"ZZ12","llanta 13"),
    (19,"ZZ13","llanta 15"),
    (20,"ZZ14","cubierta 13"),
    (21,"ZZ15","cubierta 15"),
    (22,"ZZ16","trasmision grande"),
    (23,"ZZ17","trasmision chica"),
    (24,"EE1","luz trasera stop"), 
    (25,"EE2","bateria grande"),
    (26,"EE3","bateria chica"),
    (27,"EE4","bombilla grande"),
    (28,"EE5","bombilla chica"),
    (29,"EE6","stereo standar"),
    (30,"EE7","stereo premium"),
    (31,"MO8","motor chico "),
    (32,"MO9","motor grande"),
    (33,"MO10","embrague chico"),
    (34,"MO11","embrague grande"),
    (35,"MO12","correa chica"),
    (36,"MO13","correa grande"),
    (37,"MO14","bomba de nafta chica"),
    (38,"MO15","bomba de nafta grande");
    
insert into estacion_insumo values
	(1,1,2),
    (1,16,1),
	(1,3,2),
    (2,1,2),
    (2,3,2),
    (3,2,3),
    (3,3,1),
    (3,4,1),
    (4,18,1), 
    (4,8,3),
    (5,10,5),
    (5,11,8),
    (5,12,4),
    (6,15,12),
    (7,11,7),
    (7,15,2),
    (8,15,12),
    (8,10,1),
    (9,18,12),
    (9,19,12),
    (9,20,8),
    (10,22,4),
    (10,19,5),
    (11,24,5),
    (12,19,2), 
    (12,24,9),
    (13,25,2),
    (13,29,15),
    (14,27,12),
    (14,28,12),
    (14,29,12),
    (15,30,10),
    (15,25,7),
    (16,28,8),
    (16,25,3),
    (17,31,1),
    (17,33,2),
    (17,35,12),
    (18,37,4),
    (18,38,2), 
    (19,31,4),
    (19,38,5),
    (19,33,1),
    (20,31,2),
    (20,38,4);
    

