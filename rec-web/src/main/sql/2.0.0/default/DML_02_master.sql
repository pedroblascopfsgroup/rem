
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'MENU_BUSQUEDAS_GENERAL', 'Visualiza el menú padre de busquedas',0,'CPI',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'MENU-LIST-EXP-ALL-USERS', 'Muestra el menú de busqueda de expedientes aunque el usuario sea externo',0,'CPI',sysdate,0);

commit;