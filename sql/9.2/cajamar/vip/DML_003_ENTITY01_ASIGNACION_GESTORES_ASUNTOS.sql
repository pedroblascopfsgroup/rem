/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-2054
--## PRODUCTO=NO
--##
--## Finalidad: Asignación de gestores de riesgos a asuntos 
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

-- Carterización

-- Gestor de riesgos

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR) select ' || V_ESQUEMA || '.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,        (select usd_id from ' || V_ESQUEMA || '.des_despacho_externo des inner join ' || V_ESQUEMA || '.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gesriesgo'' and des.des_despacho = ''Despacho Gestor de riesgos'') usd_id, (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''GESRIE''), ''CMREC-2054'', sysdate from (select asu.asu_id  from ' || V_ESQUEMA || '.asu_asuntos asu  where not exists (select 1 from ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''GESRIE''))  and asu.asu_id in (select asuu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asuu inner join ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id where asuu.DD_TAS_ID = 2)) aux ';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear) select ' || V_ESQUEMA || '.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, (select usd_id from ' || V_ESQUEMA || '.usd_usuarios_despachos usd inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.gesriesgo'') usd_id, sysdate, (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''GESRIE''), ''CMREC-2054'', sysdate from (select asu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asu where not exists (select 1 from ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''GESRIE'')) and asu.asu_id in (select asuu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asuu inner join ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id where asuu.DD_TAS_ID = 2 )) aux ';
EXECUTE IMMEDIATE V_MSQL;

-- Director territorial riesgos

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR) select ' || V_ESQUEMA || '.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,        (select usd_id from ' || V_ESQUEMA || '.usd_usuarios_despachos usd inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.dirterriegos'') usd_id, (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRTERRIE''), ''CMREC-2054'', sysdate from (select asu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asu where not exists (select 1 from ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRTERRIE'')) and asu.asu_id in (select asuu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asuu inner join ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id where asuu.DD_TAS_ID = 2)) aux ';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear) select ' || V_ESQUEMA || '.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id, (select usd_id from ' || V_ESQUEMA || '.usd_usuarios_despachos usd inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.dirterriegos'') usd_id, sysdate, (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRTERRIE''), ''CMREC-2054'', sysdate from (select asu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asu where not exists (select 1 from ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRTERRIE'')) and asu.asu_id in (select asuu.asu_id from ' || V_ESQUEMA || '.asu_asuntos asuu inner join ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id where asuu.DD_TAS_ID = 2)) aux';
EXECUTE IMMEDIATE V_MSQL;

-- Director riesgos territoriales GCC

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select ' || V_ESQUEMA || '.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from ' || V_ESQUEMA || '.usd_usuarios_despachos usd inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.dirrietergcc'') usd_id,
       (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRRIETERGCC''), ''CMREC-2054'', sysdate
from
 (select asu.asu_id
  from ' || V_ESQUEMA || '.asu_asuntos asu
  where not exists (select 1 from ' || V_ESQUEMA || '.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRRIETERGCC''))
  and asu.asu_id in (select asuu.asu_id
                    from ' || V_ESQUEMA || '.asu_asuntos asuu inner join
                         ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'insert into ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select ' || V_ESQUEMA || '.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from ' || V_ESQUEMA || '.usd_usuarios_despachos usd inner join ' || V_ESQUEMA_MASTER || '.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = ''val.dirrietergcc'') usd_id,
       sysdate, (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRRIETERGCC''), ''CMREC-2054'', sysdate
from
 (select asu.asu_id
  from ' || V_ESQUEMA || '.asu_asuntos asu
  where not exists (select 1 from ' || V_ESQUEMA || '.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from ' || V_ESQUEMA_MASTER || '.dd_tge_tipo_gestor where dd_tge_codigo = ''DIRRIETERGCC''))
  and asu.asu_id in (select asuu.asu_id
                    from ' || V_ESQUEMA || '.asu_asuntos asuu inner join
                         ' || V_ESQUEMA || '.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         ' || V_ESQUEMA || '.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux' ;
EXECUTE IMMEDIATE V_MSQL;

COMMIT;
     
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
