-- esto se ejecutará en el master--
-- fijarse en el valor de la secuencia, puede que no esté sincronizada con los id's
insert into dd_sta_subtipo_tarea_base (dd_sta_id,dd_tar_id,dd_sta_codigo,dd_sta_descripcion,version,usuariocrear,fechacrear,borrado)
values(s_dd_sta_subtipo_tarea_base.nextval,1,s_dd_sta_subtipo_tarea_base.nextval,'cambiar umbral',0,'AAS',sysdate,0);

-- esto se ejecutará en la entidad--
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pla_plazos_default.nextval,502 ,15552000000,s_pla_plazos_default.nextval,'Plazo maximo umbral',0,'AAS',sysdate,0);

insert into pen_param_entidad (pen_id,pen_param,pen_valor,pen_descripcion,version,usuariocrear,fechacrear,borrado) values 
(s_pen_param_entidad.nextval,'LimiteImporteUmbral','99999999999999999999999999999','Límite importe umbral',0,'AAS',sysdate,0);
