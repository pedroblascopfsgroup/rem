/*==============================================================*/					    
/*Crear nuevas funciones para permitir configurar arquetipos	*/
/*y modelos de arquetipos 										*/														
/*==============================================================*/


insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONFARQ', 'Ver opciones de configuraci�n de arquetipos',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONFMODELOS', 'Ver opciones de configuraci�n de modelos de arquetipos',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_MENUARQ', 'Ver menu de configuraci�n de arquetipos y modelos',0,'AAS',sysdate,0);