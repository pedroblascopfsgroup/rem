--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160209
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1645
--## PRODUCTO=NO
--## 
--## Finalidad: Carterizacion de gestores precontenciosos
--## INSTRUCCIONES:  
--## VERSIONES:
--##        1.0 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_procurador HAYA02.MIG_PROCEDIMIENTOS_CABECERA.CD_PROCURADOR%TYPE;
        v_usuario_id HAYAMASTER.USU_USUARIOS.USU_ID%TYPE;
	v_letrado    HAYA02.MIG_PROCEDIMIENTOS_ACTORES.CD_ACTOR%TYPE;

        V_MSQL  VARCHAR2(2500);
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        V_USUARIO VARCHAR2(25 CHAR):= 'MIGRAHAYA02';        

        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

  
BEGIN


     

     -- GESTORES PRECONTENCIOSOS EN LA GAA
    ------------------------------

-- BORRAMOS los SUP_PCO
    
/*    EXECUTE IMMEDIATE('delete
                     from GAA_GESTOR_ADICIONAL_ASUNTO gaa1
                    where gaa1.gaa_id in (
                              select distinct gaa.gaa_id
                               from HAYA02.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                               inner join HAYA02.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
                               inner join HAYA02.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
                               inner join HAYA02.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
                               inner join HAYA02.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
                               inner join HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.asu_id = asu.asu_id 
--                               where gaa.dd_tge_id = (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO'')
                               )');
*/     
  
    
    --INSERTAMOS EN LA GAA
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
--           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''), 
           aux.dd_tge_id,           
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
select distinct auxi.asu_id, auxi.usd_id, auxi.dd_tge_id
    from (
          select distinct asu.asu_id, usd.usd_id, tge.dd_tge_id,
                 rank() over (partition by asu.asu_id order by usu.usu_id) as ranking
           from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
           inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig    on rge.cd_expediente = mig.cd_expediente
           inner join '||V_ESQUEMA||'.asu_asuntos asu                 on mig.cd_expediente = asu.asu_id_externo
           inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc          on prc.asu_id = asu.asu_id 
           inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco      on pco.prc_id = prc.prc_id
           inner join '||V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR ghc    on ghc.dd_ghc_haya_codigo = rge.cod_gestor
           inner join '||V_ESQUEMA_MASTER||'.USU_USUARIOS usu         on usu.usu_username = ghc.dd_ghc_bcc_codigo 
           inner join '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd      on usu.usu_id = usd.usu_id and usd.borrado = 0
           inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des        on usd.des_id = des.des_id and des.borrado = 0
           inner join '||V_ESQUEMA_MASTER||'.dd_tde_tipo_despacho tde on  des.dd_tde_id = tde.dd_tde_id and tde.borrado = 0
           inner join '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD tgp   on tde.DD_TDE_CODIGO = tgp.TGP_VALOR and tgp.borrado = 0        
           inner join '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR  tge  on tgp.DD_TGE_ID = tge.DD_TGE_ID and tge.borrado = 0 and tge.dd_tge_codigo not in (''GESPROC'',''OFICINA'')
           WHERE  tge.dd_tge_id not in    (select distinct gaa.dd_tge_id from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                                            where gaa.asu_id = asu.asu_id                              
                                              and gaa.dd_tge_id in (select dd_tge_id 
                                                                     from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR 
                                                                      where dd_tge_codigo in ( ''APOD''
                                                                                              ,''CM_GD_PCO''
                                                                                              ,''CM_GL_PCO''
                                                                                              ,''GCONGE''
                                                                                              ,''GCONPR''
                                                                                              ,''GESPROC''   
                                                                                              ,''OFICINA''  
                                                                                              ,''SAEST''
                                                                                              ,''SUCONPR''
                                                                                              ,''SUP''
                                                                                              ,''SUP_PCO''
                                                                                             )                                                                
                                                                       )
                                                )                                                                       
--                                            and usd.des_id = (select DES_ID from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = ''Supervisor expedientes judiciales'')
--           where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                             --         inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on gaa.usd_id = usd.usd_id
                             --         inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu   on usu.usu_id = usd.usu_id 
--                             where gaa.asu_id = asu.asu_id 
--                               and gaa.dd_tge_id = (select dd_tge_id 
--                                                    from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
--                                                     where dd_tge_codigo=''SUP_PCO''))
     ) auxi where auxi.ranking = 1
  ) aux');

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Gestores precontenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- GESTORES PRECONTENCIOSOS en GAH
    --------------------------
-- BORRAMOS 
/*    
    EXECUTE IMMEDIATE('delete from GAH_GESTOR_ADICIONAL_historico gaa1
                      where gaa1.gah_id in (
                      select distinct gaa.gah_id
                       from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                       inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
                       inner join '||V_ESQUEMA||'.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
                       inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
                       inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
                       inner join '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_historico gaa on gaa.gah_asu_id = asu.asu_id 
--                       where gaa.gah_tipo_gestor_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO'')
                     )');   
    
*/    
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           --(select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''), 
           aux.dd_tge_id,
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id, auxi.dd_tge_id
      from (
          select distinct asu.asu_id, usd.usd_id, tge.dd_tge_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
           from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
           inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
           inner join '||V_ESQUEMA||'.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
           inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
           inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
           inner join '||V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR ghc on ghc.dd_ghc_haya_codigo = rge.cod_gestor
           inner join '||V_ESQUEMA_MASTER||'.USU_USUARIOS usu      on usu.usu_username = ghc.dd_ghc_bcc_codigo 
           inner join '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd   on usu.usu_id = usd.usu_id
           inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des     on usd.des_id = des.des_id and des.borrado = 0
           inner join '||V_ESQUEMA_MASTER||'.dd_tde_tipo_despacho tde on  des.dd_tde_id = tde.dd_tde_id and tde.borrado = 0
           inner join '||V_ESQUEMA||'.TGP_TIPO_GESTOR_PROPIEDAD tgp   on tde.DD_TDE_CODIGO = tgp.TGP_VALOR and tgp.borrado = 0        
           inner join '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR  tge  on tgp.DD_TGE_ID = tge.DD_TGE_ID and tge.borrado = 0  and tge.dd_tge_codigo not in (''GESPROC'',''OFICINA'')     
           WHERE  tge.dd_tge_id not in    (select distinct gah.GAH_TIPO_GESTOR_ID from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah
                                            where gah.gah_asu_id = asu.asu_id                         
                                              and gah.GAH_TIPO_GESTOR_ID in (select dd_tge_id 
                                                                               from '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR 
                                                                               where dd_tge_codigo in ( ''APOD''
                                                                                                       ,''CM_GD_PCO''
                                                                                                       ,''CM_GL_PCO''
                                                                                                       ,''GCONGE''
                                                                                                       ,''GCONPR''
                                                                                                       ,''GESPROC''
                                                                                                       ,''OFICINA''
                                                                                                       ,''SAEST''
                                                                                                       ,''SUCONPR''
                                                                                                       ,''SUP''
                                                                                                       ,''SUP_PCO''
                                                                                                      )                                                                
                                                                                )
             )           
--                                           and usd.des_id = (select DES_ID from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = ''Supervisor expedientes judiciales'')
--         where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah 
                              --        inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on gah.gah_gestor_id = usd.usd_id
                              --        inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu   on usu.usu_id = usd.usu_id          
--                                    where gah.gah_asu_id = asu.asu_id 
--                                      and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
--                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
--                                                                  where dd_tge_codigo=''SUP_PCO'')
--                            )
      ) auxi where auxi.ranking = 1
     ) aux');    
     

     
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Gestores precontenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 


 
 
--/***************************************
--*     FIN GESTORES                     *
--***************************************/




  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO');

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_MSQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;

