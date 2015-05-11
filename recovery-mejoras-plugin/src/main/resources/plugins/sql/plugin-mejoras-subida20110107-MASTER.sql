-- SUBTIPOS DE TAREA PARA LOS DISTINTOS PLAZOS DE UN ACUERDO --

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo anual',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo mensual',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo semestral',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo trimestral',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo bimestral',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo semanal',0,'AAS',sysdate,0);

insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'acuerdo unico',0,'AAS',sysdate,0);

-- PLAZO MÁXIMO AUTOPRORROGA
insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'plazo máximo autoprorroga',0,'AAS',sysdate,0);


-- FUNCIONES DE EXPORTAR
insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'EXPORTAR_COMUNICACIONES', 'Exportar comunicaciones del asunto',0,'MEJ',sysdate,0);

insert into fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(s_fun_funciones.nextval, 'EXPORTAR_HISTORICO', 'Exportar histórico del asunto',0,'MEJ',sysdate,0);
