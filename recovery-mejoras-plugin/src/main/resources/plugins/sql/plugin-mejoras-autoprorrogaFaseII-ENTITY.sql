
-- NUMERO MÁXIMO DE AUTOPRORROGAS

ALTER TABLE TAP_TAREA_PROCEDIMIENTO ADD (TAP_MAX_AUTOP NUMBER(2) DEFAULT 3 NOT NULL);
ALTER TABLE TAP_TAREA_PROCEDIMIENTO ADD (TAP_NUM_AUTOP NUMBER(2)DEFAULT 0 NOT NULL);


-- PLAZO MÁXIMO AUTOPRORROGA
insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'plazo máximo autoprorroga',0,'AAS',sysdate,0);

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,561 ,2592000000,'MAXAUTOP','Plazo maximo autoprorroga',0,'AAS',sysdate,0);






