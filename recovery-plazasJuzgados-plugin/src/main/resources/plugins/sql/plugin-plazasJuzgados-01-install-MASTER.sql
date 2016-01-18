--==============================================================*/					    
--Crear nuevas funciones para permitir configurar plazas de juzgados	*/
--																*/														
--==============================================================*/


insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONFPLAZASYJUZ', 'Ver opciones de configuración de plazas y juzgados',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_ADDJUZGADO', 'Añadir nuevos juzgados',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDITPLAZA', 'Editar los atributos de una plaza de juzgado',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDITJUZGADO', 'Editar los atributos de un juzgado',0,'AAS',sysdate,0);


