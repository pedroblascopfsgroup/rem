
-- carterizar migracion

delete from  cm01.GAA_GESTOR_ADICIONAL_ASUNTO where dd_tge_id in (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo in ('GESCON','GESCHRE','SUCHRE','DIRREC','GESINC','GERREC','GEANREC','GESHRE','GADMCON','GESOF','SUCON','SUINC','SUANREC','SUHRE','SUADMCON','DIRCON','DIRHRE','GESHREIN','CM_GD_PCO','CM_GL_PCO','CM_GE_PCO','SUP_PCO')) ;

delete from  cm01.GAH_GESTOR_ADICIONAL_HISTORICO where GAH_TIPO_GESTOR_ID in (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo in ('GESCON','GESCHRE','SUCHRE','DIRREC','GESINC','GERREC','GEANREC','GESHRE','GADMCON','GESOF','SUCON','SUINC','SUANREC','SUHRE','SUADMCON','DIRCON','DIRHRE','GESHREIN','CM_GD_PCO','CM_GL_PCO','CM_GE_PCO','SUP_PCO')) ;

-- Gestor concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.des_despacho_externo des inner join cm01.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
        cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTC' and des.DES_CODIGO = 'D-GESCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                   )
  ) aux ;
  
  
insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2 )
 ) aux ;

-- Gestor control de gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GCGHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GCGHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
 ) aux ;
  
-- Supervisor control gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SCGHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SCGHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    )
 ) aux ;
 
-- Direccion recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRECU') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRECU') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 

 -- Gestor de incumplimiento

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTI') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTI') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
  -- Gerente de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTR') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTR') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
   -- Gestor analisis de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTA') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTA') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
   -- Gestor concursal HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTCHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTCHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
    -- Gestor administracion contable

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select max(usd_id) from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GACON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select max(usd_id) from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GACON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
    -- Gestor oficina
/*
insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GOFI') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GOFI') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 */
     -- Supervisor concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPCO') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPCO') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
      -- Supervisor de incumplimiento

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPIN') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPIN') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
-- Supervisor analisis de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPANAREC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPANAREC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 -- Supervisor concursal HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPCHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPCHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
  -- Supervisor administracion contable

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPADMC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'SUPADMC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
   -- Director concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
    -- Director control gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRCGHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'DIRCGHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
-- Gestor concursal HRE insinuacion

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTCOHREI') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GESTCOHREI') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 
 -- Gestor documentacion

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGD') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGD') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 
-- Gestor liquidaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGL') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGL') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 -- Gestor estudio

/* NO APLICA EN CAJAMAR
 
insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GE_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GE_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GGE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GE_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GE_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;

 */
 
 -- Supervisor PCO

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSEJ') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GSEJ') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUP_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
  
  
insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GPFS') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'LETR'), 'MIG_CARTERIZA', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'LETR'))
  and asu.asu_id in ( select assu.asu_id
                      from cm01.mig_procedimientos_actores migp inner join  
                           cm01.asu_asuntos assu on assu.asu_id_externo = migp.cd_procedimiento
                      where migp.cd_actor = 'PROYFORMS')
  ) aux ;

                   
insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'GPFS') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'LETR'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'LETR'))
  and asu.asu_id in (select assu.asu_id
                      from cm01.mig_procedimientos_actores migp inner join  
                           cm01.asu_asuntos assu on assu.asu_id_externo = migp.cd_procedimiento
                      where migp.cd_actor = 'PROYFORMS')
 ) aux ;
 
commit; 


EXIT;
/