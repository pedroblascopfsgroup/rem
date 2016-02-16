
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
        USUARIO      VARCHAR2(50 CHAR):= 'MIGRAHAYA02';
        
        ERR_NUM      NUMBER(25);
        ERR_MSG      VARCHAR2(1024 CHAR);
                    
        V_NUMBER     NUMBER;
        V_COUNT      NUMBER;    
   
        V_EXISTE NUMBER (1):=null;

 TYPE T_GAA IS TABLE OF VARCHAR2(2000 CHAR);
 TYPE T_ARRAY_GAA IS TABLE OF T_GAA;
  
  
V_GAA T_ARRAY_GAA := T_ARRAY_GAA(
         T_GAA('GRUPO-Despacho Dirección recuperaciones','DRECU','Despacho Dirección recuperaciones')
       , T_GAA('GRUPO-Despacho Gestor admisión','CJ-GAREO','Despacho Gestor admisión')
       , T_GAA('GRUPO-Despacho Gestor análisis estudio','GAEST','Despacho Gestor análisis estudio')
       , T_GAA('GRUPO-Despacho Gestor Asesoría Fiscal','GAFIS','Despacho Gestor Asesoría Fiscal')
       , T_GAA('GRUPO-Despacho Gestor Asesoría jurídica','GAJUR','Despacho Gestor Asesoría jurídica')
       , T_GAA('GRUPO-Despacho Gestor contabilidad','GCON','Despacho Gestor contabilidad')       
       , T_GAA('GRUPO-Despacho Gestor contencioso gestión','GCONGE','Despacho Gestor contencioso gestión')
       , T_GAA('GRUPO-Despacho Gestor contencioso procesal','GCONPR','Despacho Gestor contencioso procesal')       
       , T_GAA('GRUPO-Despacho Gestor de gestión documentario','GGESDOC','Despacho Gestor de gestión documentario')      
       , T_GAA('GRUPO-Despacho Gestor HRE gestión llaves','CJ-GESTLLA','Despacho Gestor HRE gestión llaves')
       , T_GAA('GRUPO-Despacho Supervisor admisión','CJ-SAREO','Despacho Supervisor admisión')
       , T_GAA('GRUPO-Despacho Supervisor análisis estudio','SAEST','Despacho Supervisor análisis estudio')
       , T_GAA('GRUPO-Despacho Supervisor Asesoría Fiscal','CJ-SFIS','Despacho Supervisor Asesoría Fiscal')
       , T_GAA('GRUPO-Despacho Supervisor Asesoría jurídica','SAJUR','Despacho Supervisor Asesoría jurídica')
       , T_GAA('GRUPO-Despacho Supervisor contabilidad','CJ-SCON','Despacho Supervisor contabilidad')
       , T_GAA('GRUPO-Despacho Supervisor contencioso','SUCONT','Despacho Supervisor contencioso')
       , T_GAA('GRUPO-Despacho Supervisor contencioso gestión','SUP','Despacho Supervisor contencioso gestión')
       , T_GAA('GRUPO-Despacho Supervisor contencioso procesal','SUCONPR','Despacho Supervisor contencioso procesal')       
       , T_GAA('GRUPO-Despacho Supervisor de gestión documentario','SGESDOC','Despacho Supervisor de gestión documentario')
       , T_GAA('GRUPO-Despacho Supervisor HRE gestión llaves','SPGL','Despacho Supervisor HRE gestión llaves')
       , T_GAA('GRUPO-Despacho Supervisor contenciosoGestNiv2','SUCONGEN2','Despacho Supervisor contencioso gestión nivel 2')
       , T_GAA('GRUPO-Despacho Gestor control gestión HRE','GCTRGE','Despacho Gestor control gestión HRE')
       , T_GAA('GRUPO-Despacho Supervisor control gestión HRE','SCTRGE','Despacho Supervisor control gestión HRE')  
       , T_GAA('GRUPO-Supervisor expedientes judiciales','SUP_PCO','Supervisor expedientes judiciales')  
       , T_GAA('GRUPO-Precontencioso - Gestor de liquidación','CM_GL_PCO','Precontencioso - Gestor de liquidación')  
       , T_GAA('GRUPO-Precontencioso - Gestor de documentación','CM_GD_PCO','Precontencioso - Gestor de documentación')  
       , T_GAA('GRUPO-Precontencioso - Gestor de estudio','CM_GE_PCO','Precontencioso - Gestor de estudio')  
 );
   
   V_TMP_GAA T_GAA;
  
BEGIN

EXECUTE IMMEDIATE 'delete from  '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO where dd_tge_id in (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo in (''DRECU'',''CJ-GAREO'',''GAEST'',''GAFIS'',''GAJUR'',''GCON'',''GCONGE'',''GCONPR'',''GGESDOC'',''CJ-GESTLLA'',''CJ-SAREO'',''SAEST'',''CJ-SFIS'',''SAJUR'',''CJ-SCON'',''SUCONT'',''SUP'',''SUCONPR'',''SGESDOC'',''SPGL'',''SUCONGEN2'',''GCTRGE'',''SCTRGE'',''CM_GE_PCO'',''CM_GD_PCO'',''CM_GL_PCO'',''SUP_PCO''))'; 
EXECUTE IMMEDIATE 'delete from  '||V_ESQUEMA||'.GAH_GESTOR_ADICIONAL_HISTORICO where GAH_TIPO_GESTOR_ID in (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo in (''DRECU'',''CJ-GAREO'',''GAEST'',''GAFIS'',''GAJUR'',''GCON'',''GCONGE'',''GCONPR'',''GGESDOC'',''CJ-GESTLLA'',''CJ-SAREO'',''SAEST'',''CJ-SFIS'',''SAJUR'',''CJ-SCON'',''SUCONT'',''SUP'',''SUCONPR'',''SGESDOC'',''SPGL'',''SUCONGEN2'',''GCTRGE'',''SCTRGE'',''CM_GE_PCO'',''CM_GD_PCO'',''CM_GL_PCO'',''SUP_PCO''))'; 

 FOR I IN V_GAA.FIRST .. V_GAA.LAST
 LOOP
   V_TMP_GAA := V_GAA(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Insertando en GAA_GESTOR_ADICIONAL_ASUNTO el gestor: '||V_TMP_GAA(1));   
   
   
   V_SQL:= 'insert into '||V_ESQUEMA||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
            select '||V_ESQUEMA||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
                   (select usd_id from '||V_ESQUEMA||'.des_despacho_externo des inner join '||V_ESQUEMA||'.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
                    '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_GAA(1)||''')) and des.des_despacho = '''||V_TMP_GAA(3)||''') usd_id,
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
                   (select usd_id from '||V_ESQUEMA||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_MASTER||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_GAA(1)||'''))) usd_id,
                   sysdate, (select dd_tge_id from '||V_ESQUEMA_MASTER||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_GAA(2)||'''), '''||USUARIO||''', sysdate
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
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
