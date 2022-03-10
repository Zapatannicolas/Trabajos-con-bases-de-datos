--CREACION DE TABLAS

create table Categoria(
    id_categoria numeric primary key,
    categoria varchar2(50),
    favorita_flag numeric
    )
create sequence cat_seq start with 1; ---Esto lo hago para que el ID sea autoincremental, se repite en las demas tablas
create or replace trigger cat_trig
before insert on Categoria
for each row
begin
    select cat_seq.nextval
    into :new.id_categoria
    from dual;
end;


create table Contactos(
    id_contacto numeric primary key,
    nombre varchar2(50),
    numero_cel1 varchar2(30),
    numero_cel2 varchar2(30),
    numero_cel3 varchar2(30),
    categoria_id numeric,
    foreign key(categoria_id) references Categoria(id_categoria)
    );
create sequence cont_seq start with 1;

create or replace trigger cont_trig
before insert on Contactos
for each row
begin
    select cont_seq.nextval
    into :new.id_contacto
    from dual;
end;


create table Llamadas(
    id_llamada numeric,
    fecha_hora_inicio date,
    fecha_hora_fin varchar2(500),
    borrado_flag numeric,
    contacto_id numeric,
    primary key(id_llamada,contacto_id),
    foreign key(contacto_id) references Contactos(id_contacto)
    );
create sequence llam_seq start with 1;

create or replace trigger llam_trig
before insert on Llamadas
for each row
begin
    select llam_seq.nextval
    into :new.id_llamada
    from dual;
end;


create table Archivos(
    id_archivo numeric primary key,
    tipo_archivo varchar2(50),
    archivo varchar2(100),
    descripcion varchar2(2000),
    borrado_flag numeric
    );
create sequence arch_seq start with 1;

create or replace trigger arch_trig
before insert on Archivos
for each row
begin
    select arch_seq.nextval
    into :new.id_archivo
    from dual;
end;


create table Mensajes(
    id_mensaje numeric,
    contacto_id numeric,
    fecha_hora date,
    mensaje varchar2(2000),
    borrado_flag numeric,
    archivo_id numeric,
    primary key(id_mensaje,contacto_id),
    foreign key(contacto_id) references Contactos(id_contacto),
    foreign key(archivo_id) references Archivos(id_archivo)
    );
create sequence mens_seq start with 1;

create or replace trigger mens_trig
before insert on Mensajes
for each row
begin
    select mens_seq.nextval
    into :new.id_mensaje
    from dual;
end;


create table Mensajes_palabras(
    indice numeric,
    contacto_id numeric,
    mensaje_id numeric,
    palabra varchar(50),
    primary key(indice,contacto_id,mensaje_id)
    );
alter table Mensajes_palabras add constraint fk_contac foreign key(contacto_id) references Contactos(id_contacto);
--alter table Mensajes_palabras add constraint fk_menj foreign key(mensaje_id) references Mensajes(id_mensaje); ESTA FK NO ME FUNCIONO, ME TIRA ERROR

create sequence palab_seq start with 1;

create or replace trigger palab_trig
before insert on Mensajes_palabras
for each row
begin
    select palab_seq.nextval
    into :new.indice
    from dual;
end;


--INSERTS DE DATOS ALEATORIOS A LAS TABAS 

create or replace procedure sp_llenar_categoria(nCategoria numeric) as

categoria_nombre Categoria.categoria %TYPE;
fav_flag Categoria.favorita_flag %TYPE;
i numeric;

begin

for i in 1..nCategoria loop
    categoria_nombre := dbms_random.string('a',10);
    fav_flag := round(dbms_random.value(0,1));

    insert into Categoria(categoria,favorita_flag) values(categoria_nombre,fav_flag);

end loop;
commit;

null;

end sp_llenar_categoria;
--PRUEBA
begin
    sp_llenar_categoria(10); --INSERTO 10 CATEGORIAS
end;

select *from categorias;



create or replace procedure sp_llenar_contacto(nContacto numeric) as

contacto_nombre Contactos.nombre %TYPE;
cel_num1 Contactos.numero_cel1 %TYPE;
cel_num2 Contactos.numero_cel2 %TYPE;
cel_num3 Contactos.numero_cel3 %TYPE;
id_cat Contactos.categoria_id %TYPE;
i numeric;
begin

for i in 1..nContacto loop
    contacto_nombre := dbms_random.string('a',10);
    cel_num1 := round(dbms_random.value(1000000000,1999999999));
    cel_num2 := round(dbms_random.value(1000000000,1999999999)); 
    cel_num3 := round(dbms_random.value(1000000000,1999999999));
    id_cat := round(dbms_random.value(1,10)); ---Aca pongo 10 porque supuestamente hay 10 categorias
    insert into Contactos(nombre,numero_cel1,numero_cel2,numero_cel3,categoria_id) values(contacto_nombre,cel_num1,cel_num2,cel_num3,id_cat);

end loop;
commit;
null;
end sp_llenar_contacto;
--PRUEBA
begin
    sp_llenar_contacto(25);--INSERTO 25 CONTACTOS 
end;
select *from contactos;

create or replace procedure sp_llenar_llamada(nLlamada numeric) as

f_h_inicio Llamadas.fecha_hora_inicio %TYPE;
f_h_fin Llamadas.fecha_hora_fin %TYPE;
borr_flag Llamadas.borrado_flag %TYPE;
id_contac Llamadas.contacto_id %TYPE;
i numeric;
segundos numeric;
begin

for i in 1..nLlamada loop

    f_h_inicio := (trunc(sysdate) - round(dbms_random.value(0,60),0)) - dbms_random.value(0,1440) / (60*24);  ---Genera una fecha aleatoria entre los ultimos 60 dias
    segundos := round(dbms_random.value(1,7200));
    f_h_fin := f_h_inicio + segundos /86400; ---Se le suma a la fecha-hora de inicio segundos aleatorios con un max de 2hs (ESTO NO ME FUNCIONO, NO SE GUARDA EL TIEMPO)
    borr_flag := 0; ---Se inicializa en 0 porque en un principio ninguna llamada esta borrada
    id_contac := round(dbms_random.value(1,25)); ---Lo mismo que antes pongo 25 porque supuestamente hay 25 contactos

    insert into Llamadas(fecha_hora_inicio,fecha_hora_fin,borrado_flag,contacto_id) values(f_h_inicio,f_h_fin,borr_flag,id_contac);

end loop;
commit;
null;
end sp_llenar_llamada;

alter session set nls_date_format = ‘DD/MM/YYYY HH24:MI:SS’;

--PRUEBA
begin
    sp_llenar_llamada(12); --INSERTO 12 LLAMADAS
end;
select *from llamadas;


create or replace procedure sp_llenar_archivo(nArchivo numeric) as

tipo_arch Archivos.tipo_archivo %TYPE;
arch Archivos.archivo %TYPE;
descrip Archivos.descripcion %TYPE;
borrad Archivos.borrado_flag %TYPE;
i numeric;

begin

for i in 1..nArchivo loop
    tipo_arch := dbms_random.string('a',10);
    arch := dbms_random.string('a',15);
    descrip := dbms_random.string('a',20);
    borrad := 0;

    insert into Archivos(tipo_archivo,archivo,descripcion,borrado_flag) values(tipo_arch,arch,descrip,borrad);

end loop;
commit;

null;

end sp_llenar_archivo;

--PRUEBA
begin
    sp_llenar_archivo(20); --INSEERTO 20 ARCHIVOS
end;
select *from archivos;

create or replace procedure sp_llenar_mensajes(nMensajes numeric) as

contacto Mensajes.contacto_id %TYPE;
f_h mensajes.fecha_hora %TYPE;
mensaj mensajes.mensaje %TYPE;
borrado mensajes.borrado_flag %TYPE;
archivo mensajes.archivo_id %TYPE;
i numeric;

begin

for i in 1..nMensajes loop
    contacto := dbms_random.value(1,25);
    f_h := (trunc(sysdate) - round(dbms_random.value(0,60),0)) - dbms_random.value(0,1440) / (60*24);  ---Genera una fecha aleatoria entre los ultimos 60 dias
    mensaj := dbms_random.string('a',25);
    borrado := 0;
    archivo := dbms_random.value(1,20);

    insert into Mensajes(contacto_id,fecha_hora,mensaje,borrado_flag,archivo_id) values(contacto,f_h,mensaj,borrado,archivo);

end loop;
commit;

null;

end sp_llenar_mensajes;

begin
    sp_llenar_mensajes(50);  --INSERTO 50 MENSAJES
end;
select *from mensajes;


create or replace procedure sp_llenar_mensajes_palabras(nMensajes_palabras numeric) as

contacto Mensajes_palabras.contacto_id %TYPE;
mensaje Mensajes_palabras.mensaje_id %TYPE;
palab mensajes_palabras.palabra %TYPE;
i numeric;

begin

for i in 1..nMensajes_palabras loop
    contacto := dbms_random.value(1,25);
    mensaje := dbms_random.value(1,50);
    palab := dbms_random.string('a',20);

    insert into Mensajes_palabras(contacto_id,mensaje_id,palabra) values(contacto,mensaje,palab);

end loop;
commit;

null;

end sp_llenar_mensajes_palabras;

--PRUEBA
begin
    sp_llenar_mensajes_palabras(100); --INSERTO 100
end;
select *from mensajes_palabras;


--PUNTO 1

create or replace procedure sp_eliminar_mensaje
(id_mens in numeric)
is---En este caso elegi borrar los mensajes por id porque no tiene nombre y mandar un mensaje por parametro seria muy largo
begin

    update Mensajes set borrado_flag = 1 where id_mensaje = id_mens; --UTILIZO BORRDADO_FLAG PARA ELIMINAR Y NO DELETE

end sp_eliminar_mensaje;
--PRUEBA
begin
    sp_eliminar_mensaje(2); --borramos el mensaje con id 2
    sp_eliminar_mensaje(20); --eliminamos el mensaje con id 20
end;
SELECT *FROM MENSAJES; --verificamos


create or replace PROCEDURE sp_eliminar_llamada (id_llam numeric) AS 
BEGIN
  update Llamadas set borrado_flag = 1 where id_llam = id_llamada;
END sp_eliminar_llamada;

--PRUEBA
begin
    sp_eliminar_llamada(2); --elimino la llamada con id 2
    sp_eliminar_llamada(8);
    sp_eliminar_llamada(15);
end;
select *from llamadas;

create or replace PROCEDURE sp_eliminar_contacto(nombre_contacto contactos.nombre%TYPE) AS 
BEGIN
    ---Aca si se hace un delete en cascada ya que no existe un campo de borrado_flag como en los demas
    DELETE FROM Llamadas WHERE contacto_id = (select id_contacto from contactos where nombre = nombre_contacto);
    DELETE FROM Mensajes_palabras WHERE contacto_id = (select id_contacto from contactos where nombre = nombre_contacto);
    DELETE FROM Mensajes WHERE  contacto_id = (select id_contacto from contactos where nombre = nombre_contacto);
    DELETE FROM Contactos WHERE nombre = nombre_contacto;
    
END sp_eleiminar_contacto;

--PRUEBA 
begin
    sp_eliminar_contacto('YgvCKTShSr'); --ELIMINO AL CONTACTO CON ESE NOMBRE ALEATORIO EN ESTE CASO EL CONTACTO CON ID 25
end;
select *from contactos;


--PUNTO 2

select count(m.id_mensaje) as cantidad_mensaje, c.nombre, c.id_contacto from Mensajes m
inner join Contactos c on m.contacto_id = c.id_contacto
inner join Categoria cat on c.categoria_id = cat.id_categoria
where(cat.categoria != 'Familia') and (m.fecha_hora > (select add_months(sysdate, -2) from dual))
group by c.nombre, c.id_contacto
order by cantidad_mensajes desc;

--PUNTO 3

--COMINEZO CREANDO LA TABLA
create table archivos_borrados(
id_borrado numeric primary key,
archivo_id numeric,
fecha_hora date, --le cree un date para que se guarde la fecha/hora que se elimino
foreign key(archivo_id) references Archivos(id_archivo)
);
create sequence arch_borr_seq start with 1; --El id es incremental como en las demas tablas

create or replace trigger arch_borr_trig
before insert on Archivos_borrados
for each row
begin
    select arch_borr_seq.nextval
    into :new.id_borrado
    from dual;
end;

create or replace trigger tr_archivo_borrado --Aca creo un trigger que cuando en el campo borrado_flag es modificado se agrega automaticamente a la tabala archivos_borrados
before update of borrado_flag on Archivos  --lo que me falto hacer es que valide que el borrado_flag este en 0(osea sin borrar), lo intente pero siempre me tiraba algun error
for each row
begin

        insert into Archivos_borrados(archivo_id,fecha_hora) values(:new.id_archivo,sysdate);

end tr_archivo_borrado;

update archivos set borrado_flag = 1 where id_archivo = 1; --Probamos modificando el archivo con id 1

select *from archivos; --verificamos que la flag este en 1
select *from archivos_borrados; --verificamos que el archivo se inserto

--PUNTO 4

select count(mp.palabra), c.id_contacto from Contactos c
inner join Mensajes m on c.id_contacto = m.contacto_id
inner join Mensajes_palabras mp on c.id_contacto = mp.contacto_id
where(mp.palabra like '%amor%' or
      mp.palabra like '%lindo%' or
      mp.palabra like '%jajaja%' or
      mp.palabra like '%salir%') and
      rownum <= 5
      group by c.id_contacto, mp.palabra
      having count(mp.palabra) > 2
      order by mp.palabra desc;
      
--PUNTO 5

create table llamadas_borradas(
contacto_id numeric,
cantidad_llamadas numeric,
cantidad_llamadas_borradas numeric,
foreign key(contacto_id) references contactos(id_contacto)
);

insert into llamadas_borradas(contacto_id,cantidad_llamadas,cantidad_llamadas_borradas)  (
select c.id_contacto, count(l.id_llamada) as cantidad, 
    case l.borrado_flag when 1 then count(l.id_llamada) end as cantidad_borr
                        from contactos c
                        inner join llamadas l on c.id_contacto = l.contacto_id
                        group by c.id_contacto, borrado_flag );
                        
select *from llamadas_borradas;


/* TAMBIEN HABIA PENSADO EN CREAR UN PROCEDIMIENTO CON UN CURSOR QUE RECORRA LA TABLA CONTACTOS
    VERIFICARIA SI ESE CONTACTO EXISTE EN LA TABLA LLAMADAS
    DE ESE SER EL CASO CONTARIA LA CANTIDAD DE LLAMAS Y LA CANTIDAD DE LLAMADAS BORRADAS (BORRADO_FLAG = 1) DE ESE CONTACTO
    INSERTARIA ESOS DATOS EN LA TABLA LLAMADAS_BORRADAS CREADA ANTERIORMENTE
    CUANDO SE TERMINEN LOS REGISTROS DE CONTACTO SE CIERRA EL CURSOR
    FIN DEL PROCEDIMIENTO*/



--PUNTO 6

alter table llamadas_borradas add duracion_llamada_seg varchar2(30); --ESTE PUNTO NO ME SALIO PORQUE EL TIEMPO NO ME APARECE EN EL FIN DE LA LLAMADA
                                                                     --LO QUE HARIA SERIA SACAR LA DIFERENCIA DE LA DOS FECHAS(INICIO/FIN) RESTANDOLOS PARA ASI OBTENER LA DURACION
                                                                     --CON UNA CLAUSULA QUE ME FILTRE A LOS QUE TIENEN >5 SEGUNDOS


--PUNTO 7
--HAY UN ERROR EN EL CALCULO DEL PORCENTAJE 
select c.id_contacto,count(m.id_mensaje) as cantidad,
(((case m.borrado_flag when 1 then count(m.id_mensaje) end)/ count(m.id_mensaje) )* 100) as porcentaje, 'mensajes' as tipo from contactos c
inner join mensajes m on c.id_contacto = m.contacto_id
group by c.id_contacto,m.borrado_flag
union all
select c.id_contacto, count(l.id_llamada) as cantidad,
(((case l.borrado_flag when 1 then count(l.id_llamada) end)/count(l.id_llamada) )/100) as porcentaje, 'llamadas' as tipo from contactos c
inner join llamadas l on c.id_contacto = l.contacto_id
group by c.id_contacto,l.borrado_flag
order by cantidad desc,tipo;
--

    