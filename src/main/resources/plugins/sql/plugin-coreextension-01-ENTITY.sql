-- SUBTIPOS DE TAREA PARA LOS DISTINTOS PLAZOS DE UN ACUERDO -- MASTER
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


-- NUEVOS PLAZOS PARA LOS ACUERDOS

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,521 ,31536000000,'ANY','Periodo anual',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,522 ,2592000000,'MES','Un mes',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,523 ,15552000000,'SEI','Seis meses',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,524 ,7776000000,'TRI','Tres meses',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,525 ,5184000000,'BI','Dos meses',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,526 ,604800000,'SEM','Una semana',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,527 ,604800000,'UNI','Plazo único',0,'AAS',sysdate,0);