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


  -- ASIGNAMOS LOS USUARIOS AL DESPACHO SUPERVISOR EXPEDIENTES JUDICIALES

  FOR v_usuario_id IN (select distinct usu.usu_id, 
                           (select DES_ID from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = 'Supervisor expedientes judiciales') as des_id--, usd.usd_id, des.des_despacho
                      from HAYA02.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                      inner join HAYA02.DD_GHC_GEST_HAYA_CAJAMAR ghc   on ghc.dd_ghc_haya_codigo = rge.cod_gestor
                      inner join HAYAMASTER.usu_usuarios usu           on usu.usu_username = ghc.dd_ghc_bcc_codigo                  
                      inner join HAYA02.usd_usuarios_despachos usd     on usu.usu_id = usd.usu_id and usd.des_id not in (select DES_ID 
                                                                                                                         from HAYA02.DES_DESPACHO_EXTERNO des 
                                                                                                                         WHERE des.borrado = 0 and des_despacho = 'Supervisor expedientes judiciales'
                                                                                                                         )
                    ) 
                 LOOP
  
   V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS  
               (
                usd_id
              , usu_id
              , des_id
              , usd_gestor_defecto
              , usd_supervisor
              , usuariocrear
              , fechacrear
              )
        values (
                '||V_ESQUEMA||'.s_usd_usuarios_despachos.nextval
              , '''||v_usuario_id.USU_ID||'''
              , '''||v_usuario_id.DES_ID||'''
              , 0
              , 0 
              , '''||V_USUARIO||'''
              , sysdate 
               )';
    
  SELECT COUNT(*) INTO V_EXISTE
  FROM HAYA02.USD_USUARIOS_DESPACHOS
  WHERE USU_ID = v_usuario_id.USU_ID
    AND DES_ID = v_usuario_id.DES_ID;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando el despacho para el gestor '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El despacho para el usuario gestor '||v_usuario_id.USU_ID||' YA EXISTE!');
  END IF;

END LOOP;



   -- ASIGNAMOS LOS USUARIOS AL GRUPO DESPACHO SUPERVISOR EXPEDIENTES JUDICIALES    
     
FOR v_usuario_id IN (select distinct usu.usu_id, 
                                     usd.des_id as des_id--, usd.usd_id, des.des_despacho
                      from HAYA02.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                      inner join HAYA02.DD_GHC_GEST_HAYA_CAJAMAR ghc   on ghc.dd_ghc_haya_codigo = rge.cod_gestor
                      inner join HAYAMASTER.usu_usuarios usu           on usu.usu_username = ghc.dd_ghc_bcc_codigo                  
                      inner join HAYA02.usd_usuarios_despachos usd     on usu.usu_id = usd.usu_id and usd.des_id = (select DES_ID from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = 'Supervisor expedientes judiciales')
                     ) 
                 LOOP
                 
  V_MSQL:= 'insert into '||V_ESQUEMA_MASTER||'.GRU_GRUPOS_USUARIOS gru 
                  (  gru.GRU_ID
                   , gru.USU_ID_GRUPO
                   , gru.USU_ID_USUARIO
                   , gru.USUARIOCREAR
                   , gru.FECHACREAR) 
           VALUES ('||V_ESQUEMA_MASTER||'.s_GRU_GRUPOS_USUARIOS.nextval
                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_id = '''||v_usuario_id.usu_id||''')
                 , (select usu_id from '||V_ESQUEMA_MASTER||'.usu_usuarios where usu_id = (select usu_id from HAYAMASTER.usu_usuarios where usu_username = ''GRUPO-Supervisor expedientes judiciales''))
                 , '''||V_USUARIO||'''
                 , sysdate)';

  SELECT COUNT(*) INTO V_EXISTE
  FROM HAYAMASTER.GRU_GRUPOS_USUARIOS
  WHERE USU_ID_USUARIO = (select usu_id from HAYAMASTER.usu_usuarios where usu_id = v_usuario_id.usu_id)
    AND USU_ID_GRUPO = (select usu_id from HAYAMASTER.usu_usuarios where usu_username = 'GRUPO-Supervisor expedientes judiciales')
   ;
  
  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('Insertando grupos para el usuario Gestor Precontencioso '||v_usuario_id.USU_ID||'');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El el usuario Gestor Precontencioso '||v_usuario_id.USU_ID||' YA TIENE GRUPO!');
  END IF;
  
END LOOP;      
     

     -- GESTORES PRECONTENCIOSOS EN LA GAA
    ------------------------------

-- BORRAMOS los SUP_PCO
    
    EXECUTE IMMEDIATE('delete
                     from GAA_GESTOR_ADICIONAL_ASUNTO gaa1
                    where gaa1.gaa_id in (
                              select distinct gaa.gaa_id
                               from HAYA02.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                               inner join HAYA02.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
                               inner join HAYA02.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
                               inner join HAYA02.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
                               inner join HAYA02.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
                               inner join HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.asu_id = asu.asu_id 
                               where gaa.dd_tge_id = (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''))');
     
  
    
    --INSERTAMOS EN LA GAA
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
select distinct auxi.asu_id, auxi.usd_id
    from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usu.usu_id) as ranking
           from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
           inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
           inner join '||V_ESQUEMA||'.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
           inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
           inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
           inner join '||V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR ghc        on ghc.dd_ghc_haya_codigo = rge.cod_gestor
           inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu         on usu.usu_username = ghc.dd_ghc_bcc_codigo 
           inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd          on usu.usu_id = usd.usu_id 
                                            and usd.des_id = (select DES_ID from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = ''Supervisor expedientes judiciales'')
           where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                             --         inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on gaa.usd_id = usd.usd_id
                             --         inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu   on usu.usu_id = usd.usu_id 
                             where gaa.asu_id = asu.asu_id 
                               and gaa.dd_tge_id = (select dd_tge_id 
                                                    from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                     where dd_tge_codigo=''SUP_PCO''))
     ) auxi where auxi.ranking = 1
  ) aux');

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Gestores precontenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- GESTORES PRECONTENCIOSOS en GAH
    --------------------------
-- BORRAMOS los SUP_PCO
    
    EXECUTE IMMEDIATE('delete from GAH_GESTOR_ADICIONAL_historico gaa1
                      where gaa1.gah_id in (
                      select distinct gaa.gah_id
                       from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
                       inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
                       inner join '||V_ESQUEMA||'.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
                       inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
                       inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
                       inner join '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_historico gaa on gaa.gah_asu_id = asu.asu_id 
                       where gaa.gah_tipo_gestor_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''))');   
    
    
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP_PCO''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
           from '||V_ESQUEMA||'.MIG_RGE_REL_GESTOR_EXPEDIENTE rge
           inner join '||V_ESQUEMA||'.mig_expedientes_cabecera mig on rge.cd_expediente = mig.cd_expediente
           inner join '||V_ESQUEMA||'.asu_asuntos asu              on mig.cd_expediente = asu.asu_id_externo
           inner join '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS prc       on prc.asu_id = asu.asu_id 
           inner join '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS pco   on pco.prc_id = prc.prc_id
           inner join '||V_ESQUEMA||'.DD_GHC_GEST_HAYA_CAJAMAR ghc        on ghc.dd_ghc_haya_codigo = rge.cod_gestor
           inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu         on usu.usu_username = ghc.dd_ghc_bcc_codigo 
           inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd          on usu.usu_id = usd.usu_id
                                           and usd.des_id = (select DES_ID from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and des_despacho = ''Supervisor expedientes judiciales'')
         where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah 
                              --        inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on gah.gah_gestor_id = usd.usd_id
                              --        inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu   on usu.usu_id = usd.usu_id          
                                    where gah.gah_asu_id = asu.asu_id 
                                      and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                  where dd_tge_codigo=''SUP_PCO'')
                            )
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

