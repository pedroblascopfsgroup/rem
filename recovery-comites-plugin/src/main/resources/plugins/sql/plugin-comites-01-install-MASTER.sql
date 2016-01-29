--==============================================================*/					    
--Crear nuevas funciones para permitir configurar itinerarios	*/
--																*/														
--==============================================================*/


insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONFCOMITE', 'Ver opciones de configuración de comités',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_ADDCOMITE', 'Dar de alta nuevos comités',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDITCOMITE', 'Editar las opciones de un  comité',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDIT_COM_ITI', 'Editar los itinerarios compatibles con el comité',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_COMITE_BORRAPUESTO', 'Borrar puestos de comité de un comité',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_COMITE_ALTAPUESTO', 'Dar de alta nuevos puestos de comité de un comité',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_COMITE_EDITPUESTO', 'Editar un puesto de comité de un comité',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_BORRACOMITE', 'Eliminar un comité',0,'AAS',sysdate,0);


