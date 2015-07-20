
-- crear nuevo tipo de gestor 

insert into bankmaster.DD_TGE_TIPO_GESTOR tge (tge.DD_TGE_ID, tge.DD_TGE_CODIGO, tge.DD_TGE_DESCRIPCION, tge.DD_TGE_DESCRIPCION_LARGA, tge.DD_TGE_EDITABLE_WEB, tge.FECHACREAR, tge.USUARIOCREAR)
values (bankmaster.s_DD_TGE_TIPO_GESTOR.nextval, 'GESTCDD', 'Gestor cierre de deuda', 'Gestor cierre de deuda', 1, sysdate, 'SAG');

insert into bank01.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values 
(bank01.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from bankmaster.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'GESTCDD'),
 'DES_VALIDOS', 'GESTESP',
 'SAG', sysdate);
 
insert into bankmaster.dd_sta_subtipo_tarea_base
  (dd_sta_id, dd_tar_id, dd_sta_codigo, dd_sta_descripcion, dd_sta_descripcion_larga, fechacrear, usuariocrear, dd_tge_id)
values
  (bankmaster.s_dd_sta_subtipo_tarea_base.nextval, 1, '120', 'Tarea gestor cierre de deuda', 'Tarea gestor cierre de deuda', sysdate, 'SAG', 
   (select dd_tge_id from bankmaster.DD_TGE_TIPO_GESTOR tge where tge.dd_tge_codigo = 'GESTCDD'));
   
update bank01.tap_tarea_procedimiento set 
    dd_tsup_id = null,
    dd_sta_id = (select dd_sta_id from bankmaster.dd_sta_subtipo_tarea_base where dd_sta_codigo = '120')
where tap_codigo in ('P401_ContabilizarCierreDeuda','P413_ContabilizarCierreDeuda');

-- actualizar las tareas ya creadas

update bank01.tar_tareas_notificaciones tar set tar.dd_sta_id = (select dd_sta_id from bankmaster.dd_sta_subtipo_tarea_base where dd_sta_codigo = '120')
where tar.tar_id in (
  select tar.tar_id
  from bank01.tar_tareas_notificaciones tar inner join
       bank01.tex_tarea_externa tex on tex.tar_id = tar.tar_id inner join
       bank01.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id
  where tap.tap_codigo in ('P401_ContabilizarCierreDeuda','P413_ContabilizarCierreDeuda')
);    

-- insertar nueva carterización

-- BANKIA

insert into bank01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select bank01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from bank01.usd_usuarios_despachos usd inner join bankmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'SAG', sysdate
from 
 (
  select asu.asu_id
  from bank01.asu_asuntos asu where not exists (select 1 from bank01.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu_id in (select asuu.asu_id
                    from bank01.asu_asuntos asuu inner join
                         bank01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         bank01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where /*asuu.dd_eas_id = 3
                      and*/ pas.dd_pas_codigo = 'BANKIA')                    
  ) aux ;
  
 insert into bank01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select bank01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from bank01.usd_usuarios_despachos usd inner join bankmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       sysdate, (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'SAG', sysdate
from 
 (select asu_id
  from bank01.asu_asuntos asu where not exists (select 1 from bank01.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
                        (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu.asu_id in (select asuu.asu_id
                    from bank01.asu_asuntos asuu inner join
                         bank01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         bank01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where /*asuu.dd_eas_id = 3
                      and*/ pas.dd_pas_codigo = 'BANKIA')
  --and asu_id = 100000837  
 ) aux ;

-- HAYA


insert into bank01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select bank01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id, 
       (select usd_id from bank01.usd_usuarios_despachos usd inner join bankmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'SAG', sysdate
from 
 (
  select asu.asu_id
  from bank01.asu_asuntos asu where not exists (select 1 from bank01.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu_id in (select asuu.asu_id
                    from bank01.asu_asuntos asuu inner join
                         bank01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         bank01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where pas.dd_pas_codigo = 'SAREB')                    
  ) aux ;
  
 insert into bank01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select bank01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, 
       (select usd_id from bank01.usd_usuarios_despachos usd inner join bankmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       sysdate, (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'SAG', sysdate
from 
 (select asu_id
  from bank01.asu_asuntos asu where not exists (select 1 from bank01.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 
                        (select dd_tge_id from bankmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu.asu_id in (select asuu.asu_id
                    from bank01.asu_asuntos asuu inner join
                         bank01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         bank01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id 
                    where  pas.dd_pas_codigo = 'SAREB')  
 ) aux ;
 
update  bankmaster.dd_sta_subtipo_tarea_base set dd_sta_codigo = '600' where dd_sta_codigo = '6001';

update  bankmaster.dd_sta_subtipo_tarea_base set dd_sta_codigo = '601' where dd_sta_codigo = '6011';

update  bankmaster.dd_sta_subtipo_tarea_base set dd_sta_codigo = '600' where dd_sta_codigo = '120';

update  bankmaster.dd_sta_subtipo_tarea_base set dd_sta_codigo = '601' where dd_sta_codigo = '110';
