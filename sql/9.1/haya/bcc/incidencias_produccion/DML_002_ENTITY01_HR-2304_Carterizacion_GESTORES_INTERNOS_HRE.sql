--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160419
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HR-2304
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

        V_SQL  VARCHAR2(2500);
        V_SQL1 VARCHAR2(12000 CHAR);            
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= '#ESQUEMA#';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
        V_USUARIO VARCHAR2(25 CHAR):= 'MIGRAHAYA02';        


        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;


 TYPE T_GAA IS TABLE OF VARCHAR2(2000 CHAR);
 TYPE T_ARRAY_GAA IS TABLE OF T_GAA;
        
V_GAA T_ARRAY_GAA := T_ARRAY_GAA(
					 T_GAA('GRUPO-D-DRECU','DRECU','D-DRECU')
					,T_GAA('GRUPO-D-CJ-GAREO','CJ-GAREO','D-CJ-GAREO')
-- BORRADO					,T_GAA('GRUPO-D-GAEST','GAEST','D-GAEST')
					,T_GAA('GRUPO-D-GAFIS','GAFIS','D-GAFIS')
					,T_GAA('GRUPO-D-GAJUR','GAJUR','D-GAJUR')
					,T_GAA('GRUPO-D-GCON','GCON','D-GCON')
					,T_GAA('GRUPO-D-GCONGE','GCONGE','D-GCONGE')
					,T_GAA('GRUPO-D-GCONPR','GCONPR','D-GCONPR')
					,T_GAA('GRUPO-D-GGESDOC','GGESDOC','D-GGESDOC')
					,T_GAA('GRUPO-D-CJ-GESTLLA','CJ-GESTLLA','D-CJ-GESTLLA')
					,T_GAA('GRUPO-D-CJ-SAREO','CJ-SAREO','D-CJ-SAREO')
					,T_GAA('GRUPO-D-SAEST','SAEST','D-SAEST')
					,T_GAA('GRUPO-D-CJ-SFIS','CJ-SFIS','D-CJ-SFIS')
					,T_GAA('GRUPO-D-SAJUR','SAJUR','D-SAJUR')
					,T_GAA('GRUPO-D-CJ-SCON','CJ-SCON','D-CJ-SCON')
					,T_GAA('GRUPO-D-SUCONT','SUCONT','D-SUCONT')
-- BORRADO					,T_GAA('GRUPO-D-SUCONGE','SUP','D-SUCONGE')
					,T_GAA('GRUPO-D-SUCONPR','SUCONPR','D-SUCONPR')
					,T_GAA('GRUPO-D-SGESDOC','SGESDOC','D-SGESDOC')
					,T_GAA('GRUPO-D-SPGL','SPGL','D-SPGL')
					,T_GAA('GRUPO-D-SUCONGEN2','SUCONGEN2','D-SUCONGEN2')
					,T_GAA('GRUPO-D-GCTRGE','GCTRGE','D-GCTRGE')
					,T_GAA('GRUPO-D-SCTRGE','SCTRGE','D-SCTRGE')
					,T_GAA('GRUPO-SUP_PCO','SUP_PCO','SUP_PCO')
					,T_GAA('GRUPO-CM_GL_PCO','CM_GL_PCO','CM_GL_PCO')
					,T_GAA('GRUPO-CM_GD_PCO','CM_GD_PCO','CM_GD_PCO')
					,T_GAA('GRUPO-CM_GE_PCO','CM_GE_PCO','CM_GE_PCO')
					,T_GAA('GRU_SUPASU','SUP','DES-SUPASU')					
 );
   
   V_TMP_GAA T_GAA;
   
  
BEGIN


   -- BORRADO GESTORES ASIGNADOS A ASUNTOS A RECARTERIZAR EN LA GAA_GESTOR_ADICIONAL_ASUNTO
   
    EXECUTE IMMEDIATE('DELETE
                       FROM '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa1
                       WHERE gaa1.gaa_id in (
                              select distinct gaa.gaa_id
                               from '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
                               inner join '||V_ESQUEMA||'.ASU_ASUNTOS asu                 on tmp.asu_id = asu.asu_id
                               inner join '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.asu_id = asu.asu_id 
                               where gaa.dd_tge_id in (select dd_tge_id 
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
                               )');
        
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO BORRADA. Gestores asuntos a recarterizar '||SQL%ROWCOUNT||' Filas.');        
    COMMIT;
    
   -- BORRADO GESTORES ASIGNADOS A ASUNTOS A RECARTERIZAR EN LA GAH_GESTOR_ADICIONAL_historico
    
    EXECUTE IMMEDIATE('delete from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa1
                      where gaa1.gah_id in (
                      select distinct gaa.gah_id
                       from  '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
                       inner join '||V_ESQUEMA||'.asu_asuntos asu              on tmp.asu_id = asu.asu_id
                       inner join '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa on gaa.gah_asu_id = asu.asu_id 
                       where gaa.gah_tipo_gestor_id in (select dd_tge_id 
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
                     )');   
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO BORRADA. Gestores asuntos a recarterizar '||SQL%ROWCOUNT||' Filas.');        
    COMMIT;    

     -- GESTORES CONTENCIOSOS/PRECONTENCIOSOS EN LA GAA
    ------------------------------

    
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
           from '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
           inner join '||V_ESQUEMA||'.ASU_ASUNTOS asu              on tmp.asu_id = asu.asu_id
           inner join '||V_ESQUEMA_MASTER||'.USU_USUARIOS usu      on usu.usu_username = tmp.usu_username
           inner join '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd   on usu.usu_id = usd.usu_id and usd.borrado = 0
           inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des     on usd.des_id = des.des_id and des.borrado = 0
           inner join '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO tde on  des.dd_tde_id = tde.dd_tde_id and tde.borrado = 0
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
     ) auxi where auxi.ranking = 1
  ) aux');

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Gestores contenciosos-precontenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- GESTORES CONTENCIOSOS/PRECONTENCIOSOS en GAH
    --------------------------
   
    
    
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
           from '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
           inner join '||V_ESQUEMA||'.ASU_ASUNTOS asu              on tmp.asu_id = asu.asu_id
           inner join '||V_ESQUEMA_MASTER||'.USU_USUARIOS usu      on usu.usu_username = tmp.usu_username
           inner join '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd   on usu.usu_id = usd.usu_id
           inner join '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des     on usd.des_id = des.des_id and des.borrado = 0
           inner join '||V_ESQUEMA_MASTER||'.DD_TDE_TIPO_DESPACHO tde on  des.dd_tde_id = tde.dd_tde_id and tde.borrado = 0
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
      ) auxi where auxi.ranking = 1
     ) aux');    
     
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Gestores contenciosos-precontenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    

    
-- RECARTERIZAMOS SUPERVISORES

    --INSERTAMOS EN LA GAA
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
select distinct auxi.asu_id, auxi.usd_id
    from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usu.usu_id) as ranking
           from '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
           inner join '||V_ESQUEMA||'.asu_asuntos asu              on tmp.asu_id = asu.asu_id
           inner join '||V_ESQUEMA||'.DD_GHS_GEST_HAYA_SUPERVISOR  ghs on ghs.DD_GHS_HAYA_CODIGO = tmp.usu_username
           inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu      on usu.usu_username = ghs.DD_GHS_HAYA_SUP_CODIGO 
           inner join '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS usd   on usu.usu_id = usd.usu_id and usd.borrado = 0 
                                           and usd.des_id = (select DES_ID from '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and upper(trim(des_despacho)) = ''DESPACHO SUPERVISOR DEL ASUNTO'')
           where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                             where gaa.asu_id = asu.asu_id 
                               and gaa.dd_tge_id = (select dd_tge_id 
                                                    from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                     where dd_tge_codigo=''SUP''))
     ) auxi where auxi.ranking = 1
  ) aux');

     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Supervisores contenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- SUPERVISORES CONTENCIOSOS en GAH
    --------------------------
-- BORRAMOS los SUP
    
    
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''SUP''), 
           '''||V_USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id, 
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
           from '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp
           inner join '||V_ESQUEMA||'.ASU_ASUNTOS asu                   on tmp.asu_id = asu.asu_id
           inner join '||V_ESQUEMA||'.DD_GHS_GEST_HAYA_SUPERVISOR ghs   on ghs.DD_GHS_HAYA_CODIGO = tmp.usu_username        
           inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu           on usu.usu_username = ghs.DD_GHS_HAYA_SUP_CODIGO 
           inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd        on usu.usu_id = usd.usu_id
                                           and usd.des_id = (select DES_ID from HAYA02.DES_DESPACHO_EXTERNO des WHERE des.borrado = 0 and upper(trim(des_despacho)) = ''DESPACHO SUPERVISOR DEL ASUNTO'')           
           where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah 
                                    where gah.gah_asu_id = asu.asu_id 
                                      and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                  from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                  where dd_tge_codigo=''SUP'')
                            )      
      ) auxi where auxi.ranking = 1
     ) aux');    
     

     
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Supervisores contenciosos '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    
    
 FOR I IN V_GAA.FIRST .. V_GAA.LAST
 LOOP
   V_TMP_GAA := V_GAA(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Insertando en GAA_GESTOR_ADICIONAL_ASUNTO el gestor: '||V_TMP_GAA(1));   
   
   
   V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
            select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
                   (select usd_id from '||V_ESQUEMA||'.des_despacho_externo des inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
                    '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_GAA(1)||''')) and des.DES_CODIGO = '''||V_TMP_GAA(3)||''') usd_id,
                   (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''), '''||V_USUARIO||''', sysdate
            from
             (select asu.asu_id
              from '||V_ESQUEMA||'.asu_asuntos asu
              inner join '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp on asu.asu_id = tmp.asu_id 
              where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                                where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''))
              and asu.asu_id in (select asuu.asu_id
                                from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                     '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                     '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                                where asuu.DD_TAS_ID = 1
                               )
              ) aux' ;
   
   EXECUTE IMMEDIATE V_SQL;          
   
   DBMS_OUTPUT.PUT_LINE('Insertando en GAH_GESTOR_ADICIONAL_HISTORICO el gestor: '||V_TMP_GAA(1));           
           
   V_SQL1:= 'insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
            select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
                   (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_GAA(1)||'''))) usd_id,
                   sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''), '''||V_USUARIO||''', sysdate
            from
             (select asu.asu_id
              from '||V_ESQUEMA||'.asu_asuntos asu
              inner join '||V_ESQUEMA||'.TMP_HR_2304_RECART tmp on asu.asu_id = tmp.asu_id               
              where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                                where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''))
              and asu.asu_id in (select asuu.asu_id
                                from '||V_ESQUEMA||'.asu_asuntos asuu inner join
                                     '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                                     '||V_ESQUEMA||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                                where asuu.DD_TAS_ID = 1 )
            ) aux';
   
    EXECUTE IMMEDIATE V_SQL1; 
   
    COMMIT;

 END LOOP;     
    
    
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
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;

