--/*
--##########################################
--## AUTOR=JAIME SANCHEZ-CUENCA
--## FECHA_CREACION=20151223
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1449
--## PRODUCTO=NO
--## 
--## Finalidad: Carga de datos (usuarios procuradores y letrados, y usuarios_despachos procuradores y letrados).
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 20151126 GMN Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

        v_procurador HAYA02.mig_procedims_cabecera_MIM.CD_PROCURADOR%TYPE;
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


/**************************************************************************************************/
/**********************************    PROCURADORES                    ****************************/
/**************************************************************************************************/



   -- Procuradores procedimientos  
    ------------------------------

    
insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='PROC'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from HAYA02.asu_asuntos asu                                                                inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo  inner join
               HAYA02.des_despacho_externo        des  on des.des_codigo = migp.CD_PROCURADOR inner join 
               HAYA02.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join
               HAYAMASTER.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = migp.CD_PROCURADOR      
         where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo='PROC')
                          )
      ) auxi where auxi.ranking = 1
     ) aux;

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- Procuradores
    --------------------------

    
insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='PROC'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from HAYA02.asu_asuntos asu                                                                inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo   inner join
               HAYA02.des_despacho_externo        des  on des.des_codigo = migp.CD_PROCURADOR inner join 
               HAYA02.usd_usuarios_despachos      usd on usd.des_id = des.des_id                     inner join
               HAYAMASTER.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 and usu_username = migp.CD_PROCURADOR    
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo='PROC')
                            )
      ) auxi where auxi.ranking = 1
     ) aux;    
     
        
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 


 
 
--/***************************************
--*     FIN PROCURADORES  *
--***************************************/

/**************************************************************************************************/
/**********************************    LETRADOS                        ****************************/
/**************************************************************************************************/


   -- LETRADOS EN LA GAA
    ------------------------------

insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='GEXT'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
--      select distinct auxi.asu_id, auxi.usd_id
--      from (
          select distinct asu.asu_id, usd.usd_id
--                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from HAYA02.asu_asuntos asu                                                                inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo inner join
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc  on  lhc.dd_lhc_bcc_codigo = migp.CD_DESPACHO   inner join              
   --               HAYA02.des_despacho_externo   des  on des.des_codigo = ''||v_letrado.CD_DESPACHO||'' inner join 
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id 
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo='GEXT')
                          )
  --  ) auxi where auxi.ranking = 1
     ) aux;

  --Insertamos carterizacion de grupos sin gestor particular
  
 insert into HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select HAYA02.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='GEXT'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
 select distinct asu.asu_id, usd.usd_id
       from HAYA02.asu_asuntos asu                                                                inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo   inner join
               HAYA02.des_despacho_externo   des  on des.des_codigo = migp.CD_DESPACHO inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id 			and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
          where not exists (select 1 from HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id 
                                                                                           and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                  from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                  where dd_tge_codigo='GEXT')
                          )
     ) aux;    
     
     
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Letrados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- letrados en GAH
    --------------------------
    
insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='GEXT'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
--      select distinct auxi.asu_id, auxi.usd_id
--      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from HAYA02.asu_asuntos asu                                                                  inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo  inner join
               HAYA02.DD_LHC_LETR_HAYA_CAJAMAR    lhc  on  lhc.dd_lhc_bcc_codigo = migp.CD_DESPACHO    inner join              
   --               HAYA02.des_despacho_externo   des  on des.des_codigo = ''||v_letrado.CD_DESPACHO||'' inner join 
               HAYAMASTER.usu_usuarios            usu  on usu.USU_EXTERNO = 1 and usu_username = lhc.dd_lhc_haya_codigo       inner join
               HAYAMASTER.GRU_GRUPOS_USUARIOS gru on gru.usu_id_usuario = usu.usu_id inner join
               HAYA02.usd_usuarios_despachos      usd  on gru.usu_id_grupo = usd.usu_id  
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo='GEXT')
                            )
--      ) auxi where auxi.ranking = 1
     ) aux;    
 
 --Insertamos carterizacion de grupos sin gestor particular
 
insert into HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select HAYA02.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF'), 
           (select dd_tge_id from HAYAMASTER.dd_tge_tipo_gestor where dd_tge_codigo='GEXT'), 
           'HR-2391', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,'DD/MM/RR HH24:MI:SS.FF'),'DD/MM/RR HH24:MI:SS.FF')
    from 
     (
          select distinct asu.asu_id, usd.usd_id
          from HAYA02.asu_asuntos asu                                                                inner join 
               HAYA02.mig_procedims_cabecera_MIM migp on migp.cd_expediente_nuse = asu.asu_id_externo   inner join           
               HAYA02.des_despacho_externo   des  on des.des_codigo = migp.CD_DESPACHO inner join 
               HAYA02.usd_usuarios_despachos      usd  on des.des_id= usd.des_id 			and usd.USD_GESTOR_DEFECTO = 1  inner join 
               HAYAMASTER.usu_usuarios            usu  on usd.usu_id = usu.usu_id and usu.USU_EXTERNO = 1  and usu.usu_grupo = 1
--Se añade el gestos por defecto para poner al grupo en la carterizacion				
				and usd.USD_GESTOR_DEFECTO = 1 
          where not exists (select 1 from HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO gah where gah.gah_asu_id = asu.asu_id 
                                                                                               and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                           from HAYAMASTER.dd_tge_tipo_gestor 
                                                                                                                          where dd_tge_codigo='GEXT')
                            )
     ) aux;    
     
     
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Letrados. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE HAYA02.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');
 


 
 
--/***************************************
--*     FIN LETRADOS  *
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

