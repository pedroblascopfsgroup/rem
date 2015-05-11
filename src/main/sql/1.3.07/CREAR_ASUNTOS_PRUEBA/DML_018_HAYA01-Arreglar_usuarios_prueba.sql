/*
--CONSULTA PARA COMPROBAR CÓMO ESTÁN LOS USUARIOS
select u.usu_id, u.usu_username usuario
  , de.des_despacho despacho_externo
  , td.dd_tde_descripcion tipo_despacho
  , tg.dd_tge_descripcion tipo_gestor
from HAYAMASTER.usu_usuarios u
inner join usd_usuarios_despachos ud on ud.usu_id=u.usu_id
inner join des_despacho_externo de on de.des_id=ud.des_id
inner join HAYAMASTER.dd_tde_tipo_despacho td on td.dd_tde_id=de.dd_tde_id
inner join tgp_tipo_gestor_propiedad tgp on tgp.tgp_valor=td.dd_tde_codigo
inner join HAYAMASTER.dd_tge_tipo_gestor tg on tg.dd_tge_id=tgp.dd_tge_id

where u.usu_username in (
'GESTORIA_V','LETRADO_V','G_ADJ_V','G_SAN_V','S_ADM_V','G_ADM_V','S_FISC_V','G_FISC_V','S_CONT_V','G_CONT_V','S_SOP_V','G_SOP_V','S_DEUDA_V','G_DEUDA_V','S_SUB_V','G_SUB_V','G_UCL_V','S_UCL_V','D_UCL_V','GESTORIA_H','LETRADO_H','G_ADJ_H','G_SAN_H','S_ADM_H','G_ADM_H','S_FISC_H','G_FISC_H','S_CONT_H','G_CONT_H','S_SOP_H','G_SOP_H','S_DEUDA_H','G_DEUDA_H','S_SUB_H','G_SUB_H','G_UCL_H','S_UCL_H','D_UCL_H','GESTORIA','LETRADO','SUPER_UCL','GEST_ADJ','GEST_SAN','SUPER_ADM','GEST_ADM','SUPER_FISC','GEST_FISC','SUPER_CONT','GEST_CONT','SUPER_SOP','GEST_SOP','SUP_DEUDA','GEST_DEUDA','SUPER_SUB','GEST_SUB','GEST_UCL','DTOR_UCL'
)
    and u.borrado=0
    and de.borrado=0
    and td.borrado=0
    and tgp.borrado=0
    and tg.borrado=0
order by tg.dd_tge_id;
*/

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Letrado')
where des_id=(select max(des_id) 
              from des_despacho_externo 
              where des_despacho='Gestoría Letrado'
                  and des_id not in (
                      select min(des_id) from des_despacho_externo where des_despacho='Gestoría Letrado'
                  )
              );


delete from des_despacho_externo 
where des_despacho='Gestoría Letrado' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update usd_usuarios_despachos 
set des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Letrado')
where usu_id in (select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('LETRADO_H','LETRADO_V'));


update usd_usuarios_despachos
set des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Letrado')
where usu_id=(select usu_id from HAYAMASTER.usu_usuarios where usu_username='LETRADO')
  and usd_id=(select max(usd_id) from usd_usuarios_despachos where usu_id=(select usu_id from HAYAMASTER.usu_usuarios where usu_username='LETRADO'));


delete from gaa_gestor_adicional_asunto 
where usd_id in (
    select usd_id
    from usd_usuarios_despachos
    where usu_id=(select usu_id from HAYAMASTER.usu_usuarios where usu_username='LETRADO')
        and des_id not in (select des_id from des_despacho_externo where des_despacho='Gestoría Letrado')
);


delete from usd_usuarios_despachos
where usu_id=(select usu_id from HAYAMASTER.usu_usuarios where usu_username='LETRADO')
    and des_id not in (select des_id from des_despacho_externo where des_despacho='Gestoría Letrado');



update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DLETR')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Letrado');


--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestor Unidad Concursos y Litigios')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_UCL','G_UCL_V','G_UCL_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestor Unidad Concursos y Litigios' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DGUCL')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestor Unidad Concursos y Litigios');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor Unidad Concursos y Litigios')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_UCL','S_UCL_V','S_UCL_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor Unidad Concursos y Litigios' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSUCL')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor Unidad Concursos y Litigios');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Director Unidad Concursos y Litigios')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('DTOR_UCL','D_UCL_V','D_UCL_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Director Unidad Concursos y Litigios' 
    and des_id not in (select des_id from usd_usuarios_despachos);

update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DDUCL')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Director Unidad Concursos y Litigios');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GESTORIA','GESTORIA_V','GESTORIA_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='GESTORIA')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestoría para saneamiento')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_SAN','G_SAN_V','G_SAN_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestoría para saneamiento' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='GPS')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestoría para saneamiento');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestor subastas')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_SUB','G_SUB_V','G_SUB_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestor subastas' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DGSUB')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestor subastas');

--**************************************************************************************


update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor subastas')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_SUB','S_SUB_V','S_SUB_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor subastas' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSSUB')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor subastas');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestor deuda')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_DEUDA','G_DEUDA_H','G_DEUDA_V')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestor deuda' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DGDEU')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestor deuda');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestor soporte deuda')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_SOP','G_SOP_V','G_SOP_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestor soporte deuda' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DGSDE')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestor soporte deuda');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor soporte deuda')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_SOP','S_SOP_V','S_SOP_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor soporte deuda' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSSDE')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor soporte deuda');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Usuario contabilidad')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_CONT','G_CONT_H','G_CONT_V')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Usuario contabilidad' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DUCON')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Usuario contabilidad');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor contabilidad')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_CONT','S_CONT_H','S_CONT_V')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor contabilidad' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSCON')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor contabilidad');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Usuario fiscal')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_FISC','G_FISC_V','G_FISC_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Usuario fiscal' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DUFIS')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Usuario fiscal');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor fiscal')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_FISC','S_FISC_V','S_FISC_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor fiscal' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSFIS')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor fiscal');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestor admisión REO')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_ADM','G_ADM_V','G_ADM_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestor admisión REO' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DGAREO')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestor admisión REO');

--**************************************************************************************

update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor admisión REO')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUPER_ADM','S_ADM_V','S_ADM_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor admisión REO' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSAREO')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor admisión REO');

--******************************************************************************************************************************
--SUPER_SUB
update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSSUB')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor subastas');


--*******************************************************************************************************************************
--SUPER GESTIÓN DEUDA
update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Supervisor gestión deuda')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('SUP_DEUDA','S_DEUDA_V','S_DEUDA_H')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Supervisor gestión deuda' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='DSDEU')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Supervisor gestión deuda');


--***************************************************************************************************************************
--GESTORÍA ADJUDICACIÓN
update usd_usuarios_despachos
set des_id=(select min(des_id) from des_despacho_externo where des_despacho='Gestoría Gestoría para adjudicación')
where usu_id in (
    select usu_id from HAYAMASTER.usu_usuarios where usu_username in ('GEST_ADJ','G_ADJ_H','G_ADJ_V')
);


delete from des_despacho_externo 
where des_despacho='Gestoría Gestoría para adjudicación' 
    and des_id not in (select des_id from usd_usuarios_despachos);


update des_despacho_externo
set dd_tde_id=(select dd_tde_id from HAYAMASTER.dd_tde_tipo_despacho where dd_tde_codigo='GPA')
where des_id=(select des_id from des_despacho_externo where des_despacho='Gestoría Gestoría para adjudicación');

--***************************************************************************************************************************

commit;