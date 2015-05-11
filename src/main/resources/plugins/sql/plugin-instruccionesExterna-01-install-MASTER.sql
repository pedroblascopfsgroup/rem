--==============================================================*/					    
--Crear nuevas funciones para permitir configurar itinerarios	*/
--																*/														
--==============================================================*/


insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONF_INSTRUCC_EXT', 'Ver opciones de configuración de instrucciones de tareas externas',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDITINSTRUCCIONESEXT', 'Editar las instrucciones de una tarea externas',0,'AAS',sysdate,0);


