--==============================================================*/					    
--Crear nuevas funciones para permitir configurar plazos de tareas externas	*/
--																*/														
--==============================================================*/


insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_CONFPLAZOSEXT', 'Ver opciones de configuración de plazos de tareas externas',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_ADDPLAZOSEXT', 'Añadir nuevos plazos de tareas externas',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_BORRAPLAZOSEXT', 'Eliminar un plazo de una tarea externa',0,'AAS',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_EDITPLAZOSEXT', 'Editar un plazo de una tarea externa',0,'AAS',sysdate,0);


