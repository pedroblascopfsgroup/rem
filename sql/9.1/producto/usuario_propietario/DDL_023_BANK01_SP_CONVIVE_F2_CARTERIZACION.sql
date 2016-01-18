--/*
--##########################################
--## AUTOR=Rubén Rovira
--## FECHA_CREACION=20151027
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.2
--## INCIDENCIA_LINK=BKREC-58
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

create or replace PROCEDURE CONVIVE_F2_CARTERIZACION AUTHID CURRENT_USER AS
BEGIN
insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where ges.dd_ges_codigo = 'BANKIA')
  ) aux ;

 insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where  ges.dd_ges_codigo = 'BANKIA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2DELOIT') usd_id,
       3, 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'BANKIA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2DELOIT') usd_id,
       sysdate, 3, 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'BANKIA')
 ) aux ;



insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2LV2DEL') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                    (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'BANKIA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2LV2DEL') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'BANKIA')
 ) aux ;



insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'))
  and asu.asu_id in (
                    select distinct asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id  inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where ges.dd_ges_codigo = 'BANKIA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id  inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where ges.dd_ges_codigo = 'BANKIA')
 ) aux ;


insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA'))
  and asu.asu_id in (
                    select distinct asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA2'), 'SAG', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu where not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA2'))
  and asu_id in (select asuu.asu_id
                 from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id  inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                )
  ) aux ;

 insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA2'), 'SAG', sysdate
from
 (select asu_id
  from #ESQUEMA#.asu_asuntos asu where not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTLLA2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.prc_procedimientos prc on prc.asu_id = asuu.asu_id inner join
                         #ESQUEMA#.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = prc.dd_tpo_id  inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id)
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'), 'SAG', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu where not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'))
  and asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where ges.dd_ges_codigo = 'HAYA')
  ) aux ;

 insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'), 'SAG', sysdate
from
 (select asu_id
  from #ESQUEMA#.asu_asuntos asu where not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTESP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where ges.dd_ges_codigo = 'HAYA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYA') usd_id,
       3, 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYA') usd_id,
       sysdate, 3, 'CONVIVE_F2', sysdate
from
 (select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
 ) aux ;



insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYALV2') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                    (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYALV2') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
 ) aux ;



insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGPIS') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGPIS') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTPROP'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 1
                      and ges.dd_ges_codigo = 'HAYA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       aux.usd_id,
       3, 'CONVIVE_F2', sysdate
from
 (
  select distinct aux.asu_id, usd_supervisor usd_id
  from (
        select asuu.asu_id, asuu.asu_nombre, mic.gestor_proc,
               CASE WHEN usd.usd_id IS NOT NULL THEN usd.usd_id ELSE usds.usd_id END usd_supervisor
        from #ESQUEMA#.asu_asuntos asuu inner join
             #ESQUEMA#.cnv_aux_alta_prc on asuu.ASU_ID_EXTERNO=cnv_aux_alta_prc.CODIGO_PROCEDIMIENTO_NUSE inner join
             #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
             #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner JOIN
             #ESQUEMA#.mig_concursos_cabecera mic on mic.cd_concurso = asuu.asu_id_externo inner join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccg on bccg.BCC_USUARIO = mic.gestor_proc left join
             #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_username = bccg.BCC_USUARIO left join
             #ESQUEMA#.usd_usuarios_despachos usd on usd.usu_id = usu.usu_id left join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccs on bccs.BCC_RESPONSABLE = mic.gestor_proc left join
             #ESQUEMA_MASTER#.usu_usuarios usus on usus.usu_username = bccs.BCC_RESPONSABLE left join
             #ESQUEMA#.usd_usuarios_despachos usds on usds.usu_id = usus.usu_id
        where asuu.DD_TAS_ID = 2
          and (select max(prc.PRC_SALDO_RECUPERACION ) from #ESQUEMA#.prc_procedimientos prc
              where prc.asu_id = asuu.asu_id) >= 2000000
     ) aux
  where aux.usd_supervisor is not null
    and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = aux.asu_id and gaa.dd_tge_id = 3)
 ) aux ;

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       usd_id,
       sysdate, 3, 'CONVIVE_F2', sysdate
from
 (select distinct asu_id, usd_supervisor usd_id
  from (
        select asuu.asu_id, asuu.asu_nombre, mic.gestor_proc,
               CASE WHEN usd.usd_id IS NOT NULL THEN usd.usd_id ELSE usds.usd_id END usd_supervisor
        from #ESQUEMA#.asu_asuntos asuu inner join
             #ESQUEMA#.cnv_aux_alta_prc on asuu.ASU_ID_EXTERNO=cnv_aux_alta_prc.CODIGO_PROCEDIMIENTO_NUSE inner join
             #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
             #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner JOIN
             #ESQUEMA#.mig_concursos_cabecera mic on mic.cd_concurso = asuu.asu_id_externo inner join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccg on bccg.BCC_USUARIO = mic.gestor_proc left join
             #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_username = bccg.BCC_USUARIO left join
             #ESQUEMA#.usd_usuarios_despachos usd on usd.usu_id = usu.usu_id left join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccs on bccs.BCC_RESPONSABLE = mic.gestor_proc left join
             #ESQUEMA_MASTER#.usu_usuarios usus on usus.usu_username = bccs.BCC_RESPONSABLE left join
             #ESQUEMA#.usd_usuarios_despachos usds on usds.usu_id = usus.usu_id
        where asuu.DD_TAS_ID = 2
          and (select max(prc.PRC_SALDO_RECUPERACION ) from #ESQUEMA#.prc_procedimientos prc
              where prc.asu_id = asuu.asu_id) >= 2000000
     ) aux
  where aux.usd_supervisor is not null
  and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = aux.asu_id and gaa.GAH_TIPO_GESTOR_ID = 3)
 ) aux ;



insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       aux.usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (
  select distinct asu_id, usd_supervisor usd_id
  from (
        select asuu.asu_id, asuu.asu_nombre, mic.gestor_proc,
               usd.usd_id usd_supervisor
        from #ESQUEMA#.asu_asuntos asuu inner join
             #ESQUEMA#.cnv_aux_alta_prc on asuu.ASU_ID_EXTERNO=cnv_aux_alta_prc.CODIGO_PROCEDIMIENTO_NUSE inner join
             #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
             #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner JOIN
             #ESQUEMA#.mig_concursos_cabecera mic on mic.cd_concurso = asuu.asu_id_externo inner join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccg on bccg.BCC_USUARIO = mic.gestor_proc inner join
             #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_username = bccg.BCC_RESPONSABLE inner join
             #ESQUEMA#.usd_usuarios_despachos usd on usd.usu_id = usu.usu_id inner join
             #ESQUEMA#.des_despacho_externo des on des.des_id = usd.des_id and des_despacho = 'DIRECCION BANKIA'
        where asuu.DD_TAS_ID = 2
          and (select max(prc.PRC_SALDO_RECUPERACION ) from #ESQUEMA#.prc_procedimientos prc
              where prc.asu_id = asuu.asu_id) >= 2000000
    ) aux
  where aux.usd_supervisor is not null
    and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = aux.asu_id
    and gaa.dd_tge_id = (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
 ) aux ;

insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       usd_id,
       sysdate,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'),
       'SAG', sysdate
from
 (select distinct asu_id, usd_supervisor usd_id
  from (
        select asuu.asu_id, asuu.asu_nombre, mic.gestor_proc,
               usd.usd_id usd_supervisor
        from #ESQUEMA#.asu_asuntos asuu inner join
             #ESQUEMA#.cnv_aux_alta_prc on asuu.ASU_ID_EXTERNO=cnv_aux_alta_prc.CODIGO_PROCEDIMIENTO_NUSE inner join
             #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
             #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner JOIN
             #ESQUEMA#.mig_concursos_cabecera mic on mic.cd_concurso = asuu.asu_id_externo inner join
             #ESQUEMA#.BCC_BANKIA_CARTERIZA_CONCURSOS bccg on bccg.BCC_USUARIO = mic.gestor_proc inner join
             #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_username = bccg.BCC_RESPONSABLE inner join
             #ESQUEMA#.usd_usuarios_despachos usd on usd.usu_id = usu.usu_id inner join
             #ESQUEMA#.des_despacho_externo des on des.des_id = usd.des_id and des_despacho = 'DIRECCION BANKIA'
        where asuu.DD_TAS_ID = 2
          and (select max(prc.PRC_SALDO_RECUPERACION ) from #ESQUEMA#.prc_procedimientos prc
              where prc.asu_id = asuu.asu_id) >= 2000000
    ) aux
  where aux.usd_supervisor is not null
    and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = aux.asu_id
                     and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2')
    )
  )aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2DELOIT') usd_id,
       3, 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv
  where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'BANKIA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2DELOIT') usd_id,
       sysdate, 3, 'SAG', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'BANKIA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2LV2DEL') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                    (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'BANKIA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO2LV2DEL') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'BANKIA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYA') usd_id,
       3, 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'HAYA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYA') usd_id,
       sysdate, 3, 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = 3)
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'HAYA')
 ) aux ;

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYALV2') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists(select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                    (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'HAYA')
  ) aux ;


insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYALV2') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu , #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'SUPNVL2'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                      and ges.dd_ges_codigo = 'HAYA')
 ) aux;


 -- GESTCCDD

 insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where pas.dd_pas_codigo = 'BANKIA')
  ) aux ;

 insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'BPO1ACCEN') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'CONVIVE_F2', sysdate
from
 (select asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where pas.dd_pas_codigo = 'BANKIA')
 ) aux ;

-- HAYA

insert into #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select #ESQUEMA#.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'CONVIVE_F2', sysdate
from
 (
  select asu.asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where pas.dd_pas_codigo = 'SAREB')
  ) aux ;

 insert into #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select #ESQUEMA#.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from #ESQUEMA#.usd_usuarios_despachos usd inner join #ESQUEMA_MASTER#.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'HAYAGESP') usd_id,
       sysdate, (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'), 'CONVIVE_F2', sysdate
from
 (select asu_id
  from #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.CNV_AUX_ALTA_PRC cnv where asu.asu_id_externo=cnv.codigo_procedimiento_nuse and not exists (select 1 from #ESQUEMA#.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID =
                        (select dd_tge_id from #ESQUEMA_MASTER#.dd_tge_tipo_gestor where dd_tge_codigo = 'GESTCDD'))
  and asu.asu_id in (select asuu.asu_id
                    from #ESQUEMA#.asu_asuntos asuu inner join
                         #ESQUEMA#.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         #ESQUEMA#.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where pas.dd_pas_codigo = 'SAREB')
 ) aux ;






COMMIT;
END CONVIVE_F2_CARTERIZACION;
/

EXIT;
