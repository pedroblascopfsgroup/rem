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
        V_SQL1        VARCHAR2(12000 CHAR);        
        
        V_ESQUEMA    VARCHAR2(25 CHAR):= 'HAYA02';
        V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'HAYAMASTER';
        USUARIO      VARCHAR2(50 CHAR):= 'MIG_CARACTERIZA';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

 TYPE T_GAA IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_GAA IS TABLE OF T_GAA;
  
  
V_GAA T_ARRAY_GAA := T_ARRAY_GAA(
         T_GAA('val.DRECU','DRECU','Despacho Dirección recuperaciones')
       , T_GAA('val.GAREO','CJ-GAREO','Despacho Gestor admisión')
       , T_GAA('val.GAEST','GAEST','Despacho Gestor análisis estudio')
       , T_GAA('val.GAFIS','GAFIS','Despacho Gestor Aseoría Fiscal')
       , T_GAA('val.GAJUR','GAJUR','Despacho Gestor Asesoría jurídica')
       , T_GAA('val.GCON','GCON','Despacho Gestor contabilidad')       
       , T_GAA('val.GCONGE','GCONGE','Despacho Gestor contencioso gestión')
       , T_GAA('val.GCONPR','GCONPR','Despacho Gestor contencioso procesal')       
       , T_GAA('val.GGESDOC','GGESDOC','Despacho Gestor de gestión documentario')      
       , T_GAA('val.GESTILL','CJ-GESTLLA','Despacho Gestor HRE gestión llaves')
       , T_GAA('val.LETRADO','CJ-LETR','Despacho Letrado')
       , T_GAA('val.SAREO','CJ-SAREO','Despacho Supervisor admisión')
       , T_GAA('val.SAEST','SAEST','Despacho Supervisor análisis estudio')
       , T_GAA('val.SFIS','CJ-SFIS','Despacho Supervisor Asesoría Fiscal')
       , T_GAA('val.SAJUR','SAJUR','Despacho Supervisor Asesoría jurídica')
       , T_GAA('val.SCON','CJ-SCON','Despacho Supervisor contabilidad')
       , T_GAA('val.SUCONT','SUCONT','Despacho Supervisor contencioso')
       , T_GAA('val.SUCONGE','SUCONGE','Despacho Supervisor contencioso gestión')
       , T_GAA('val.SUCONPR','SUCONPR','Despacho Supervisor contencioso procesal')       
       , T_GAA('val.SGESDOC','SGESDOC','Despacho Supervisor de gestión documentario')
       , T_GAA('val.SPGL','SPGL','Despacho Supervisor HRE gestión llaves')
       , T_GAA('val.SUCONGEN2','SUCONGEN2','Despacho Supervisor contencioso gestión nivel 2')
       , T_GAA('val.GCTRGE','GCTRGE','Despacho Gestor control gestión HRE')
       , T_GAA('val.SCTRGE','SCTRGE','Despacho Supervisor control gestión HRE')                 
 );
   
   V_TMP_GAA T_GAA;
  
BEGIN


 FOR I IN V_GAA.FIRST .. V_GAA.LAST
 LOOP
   V_TMP_GAA := V_GAA(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Insertando en GAA_GESTOR_ADICIONAL_ASUNTO el gestor: '||V_TMP_GAA(1));   
   
   
   V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
            select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
                   (select usd_id from '||V_ESQUEMA||'.des_despacho_externo des inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
                    '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = '''||V_TMP_GAA(1)||''' and des.des_despacho = '''||V_TMP_GAA(3)||''') usd_id,
                   (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''), '''||USUARIO||''', sysdate
            from
             (select asu.asu_id
              from '||V_ESQUEMA||'.asu_asuntos asu
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
                   (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = '''||V_TMP_GAA(1)||''') usd_id,
                   sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''), ''SAG'', sysdate
            from
             (select asu.asu_id
              from '||V_ESQUEMA||'.asu_asuntos asu
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
 



  
   -- Procuradores procedimientos  
    ------------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
    select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval uk,
           aux.asu_id, 
           aux.usd_id,
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''PROC''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo        des  on des.des_despacho = migp.cd_procurador        inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd  on usd.des_id = des.des_id                    inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu  on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1
         where not exists (select 1 from '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id 
                                                                                                                                            from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                            where dd_tge_codigo=''PROC'')
                          )
      ) auxi where auxi.ranking = 1
     ) aux');
     
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;
    
    
    -- Procuradores
    --------------------------
    EXECUTE IMMEDIATE('insert into '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
    select '||V_ESQUEMA||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, 
           aux.asu_id, 
           aux.usd_id,
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF''), 
           (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo=''PROC''), 
           '''||USUARIO||''', 
           TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP,''DD/MM/RR HH24:MI:SS.FF''),''DD/MM/RR HH24:MI:SS.FF'')
    from 
     (
      select distinct auxi.asu_id, auxi.usd_id
      from (
          select distinct asu.asu_id, usd.usd_id,
                 rank() over (partition by asu.asu_id order by usd.usu_id) as ranking
          from '||V_ESQUEMA||'.asu_asuntos asu                                                                inner join 
               '||V_ESQUEMA||'.mig_procedimientos_cabecera migp on migp.cd_procedimiento = asu.asu_id_externo inner join
               '||V_ESQUEMA||'.des_despacho_externo        des on des.des_despacho = migp.cd_procurador         inner join 
               '||V_ESQUEMA||'.usd_usuarios_despachos      usd on usd.des_id = des.des_id                     inner join
               '||V_ESQUEMA_MASTER||'.usu_usuarios         usu on usu.usu_id = usd.usu_id and usu.USU_EXTERNO = 1 
          where not exists (select 1 from '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa where gaa.gah_asu_id = asu.asu_id and GAH_TIPO_GESTOR_ID = (select dd_tge_id 
                                                                                                                                                         from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor 
                                                                                                                                                         where dd_tge_codigo=''PROC''))
      ) auxi where auxi.ranking = 1
     ) aux');    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO cargada. Procuradores. '||SQL%ROWCOUNT||' Filas.');
    COMMIT;

    

    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAA_GESTOR_ADICIONAL_ASUNTO Analizada');



    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO COMPUTE STATISTICS');
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' - GAH_GESTOR_ADICIONAL_HISTORICO Analizada');

 
 
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





