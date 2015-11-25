--/*
--##########################################
--## AUTOR=CARLOS GIL
--## FECHA_CREACION=20151103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (Asuntos, procedimientos, tareas ..) a partir de tabla intermedia de migración
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial (Carlos Gil)
--##        0.2 GMN Adaptación script a lanzador
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        TABLE_COUNT  NUMBER(3);
        EXISTE       NUMBER;
        V_SQL        VARCHAR2(12000 CHAR);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'CM01';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIG_CARACTERIZA';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
  
        
BEGIN




-- Gestor concursal

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
         select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
                (select usd_id from '||V_ESQUEMA||'.des_despacho_externo des inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
                 '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESCON'' and des.des_despacho = ''Despacho Gestor concursal'') usd_id,
                (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCON''), '''||USUARIO||''', sysdate
         from
          (select asu.asu_id
           from '||V_ESQUEMA||'.asu_asuntos asu
           where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                             where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCON''))
           and asu.asu_id in (select asuu.asu_id
                             from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                  '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                  '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                             where asuu.DD_TAS_ID = 2
                            )
           ) aux' ;

EXECUTE IMMEDIATE V_SQL;          

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESCON'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCON''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2 )
) aux';

EXECUTE IMMEDIATE V_SQL; 

-- Gestor control de gestión HRE

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESCHRE'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCHRE''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESCHRE'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCHRE''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESCHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
  
EXECUTE IMMEDIATE V_SQL; 

-- Supervisor control gestión HRE

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUCHRE'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCHRE''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUCHRE'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCHRE''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';

EXECUTE IMMEDIATE V_SQL; 

-- Dirección recuperaciones

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRREC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRREC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 
 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRREC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRREC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 
 
 -- Gestor de incumplimiento

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESINC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESINC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESINC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 
 
V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESINC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESINC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESINC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';

EXECUTE IMMEDIATE V_SQL; 

  -- Gerente de recuperaciones

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GERREC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GERREC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GERREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GERREC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GERREC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GERREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';

EXECUTE IMMEDIATE V_SQL; 

 
   -- Gestor análisis de recuperaciones

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GEANREC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GEANREC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GEANREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GEANREC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GEANREC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GEANREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
  
EXECUTE IMMEDIATE V_SQL; 

   -- Gestor concursal HRE

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESHRE'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHRE''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESHRE'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHRE''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

    -- Gestor administración contable

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GADMCON'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GADMCON''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GADMCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GADMCON'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GADMCON''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GADMCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
  
EXECUTE IMMEDIATE V_SQL; 

    -- Gestor oficina

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESOF'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESOF''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESOF''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 
 
V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GESOF'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESOF''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESOF''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

     -- Supervisor concursal

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUCON'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCON''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUCON'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCON''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

      -- Supervisor de incumplimiento

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUINC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUINC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUINC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUINC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUINC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUINC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

-- Supervisor análisis de recuperaciones

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUANREC'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUANREC''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUANREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 
 
V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUANREC'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUANREC''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUANREC''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

 -- Supervisor concursal HRE

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUHRE'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUHRE''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 
 
V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUHRE'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUHRE''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
EXECUTE IMMEDIATE V_SQL; 

  -- Supervisor administración contable

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUADCON'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUADMCON''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUADMCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.SUADCON'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUADMCON''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''SUADMCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
   -- Director concursal

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRCON'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRCON''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 
 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRCON'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRCON''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRCON''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
    -- Director control gestión HRE

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRHRE'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRHRE''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 
 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.DIRHRE'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRHRE''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRHRE''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
-- Gestor concursal HRE insinuación

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GEHREIN'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHREIN''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHREIN''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 
 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.GEHREIN'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHREIN''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''GESHREIN''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
 -- Gestor documentación

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gestdocumentacion'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GD_PCO''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GD_PCO''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

 EXECUTE IMMEDIATE V_SQL; 
 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gestdocumentacion'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GD_PCO''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GD_PCO''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
-- Gestor liquidaciones

V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gestliquidaciones'') usd_id,
       (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GL_PCO''), '''||USUARIO||''', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GL_PCO''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux';

EXECUTE IMMEDIATE V_SQL; 

V_SQL:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gestliquidaciones'') usd_id,
       sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GL_PCO''), ''SAG'', sysdate
from
 (select asu.asu_id
  from '||V_ESQUEMA||'.asu_asuntos asu
  where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = ''CM_GL_PCO''))
  and asu.asu_id in (select asuu.asu_id
                    from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                         '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
) aux';
 
 EXECUTE IMMEDIATE V_SQL; 
 
 
 commit;
 
--/***************************************
--*     FIN CARACTERIZACION VALIDADORES  *
--***************************************/

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;





