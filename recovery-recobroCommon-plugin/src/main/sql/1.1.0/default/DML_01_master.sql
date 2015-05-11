-- nuevas funciones para visibilidad de expedientes y acciones
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'ROLE_VISIB_COMPLETA_RECOBRO_EXT', 'Permite ver todos las expedientes de recobro a un externo',0,'CPI',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'TODAS_LAS_ACCIONES_SIN_AGENCIA', 'Permite ver todos las acciones de recobro a un externo',0,'CPI',sysdate,0);

commit;
