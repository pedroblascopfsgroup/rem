--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20160104
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1645
--## PRODUCTO=NO
--## 
--## Finalidad: Asignar a los asuntos precontencioso de haya por defecto los mismos gestores/supervisores que actualmente 
--##            se añaden para los asuntos 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA02'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER; -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER;  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER;
    V_DDNAME VARCHAR2(25 CHAR) := '';
    V_DD_TPA_CODIGO VARCHAR2(50):= '';
    V_DD_TPA_DESCRIPCIONO VARCHAR2(50):= '';

    --Valores a insertar
	/* ejemplo 
		T_TIPO_TGE(
		1.- codigo tge....... 'DRECU',
		2.- username......... 'val.DRECU',
		3.- que hacemos..... 'Despacho Dirección recuperaciones'
	*/
    TYPE T_TIPO_TGE IS TABLE OF VARCHAR2(350);
    TYPE T_ARRAY_TGE IS TABLE OF T_TIPO_TGE;
    V_TIPO_TFA T_ARRAY_TGE := T_ARRAY_TGE(  
                                  T_TIPO_TGE('DRECU'     ,'val.DRECU'    ,'Despacho Dirección recuperaciones')
                                , T_TIPO_TGE('CJ-GAREO'  ,'val.GAREO'    ,'Despacho Gestor admisión')
                                , T_TIPO_TGE('GAEST'     ,'val.GAEST'    ,'Despacho Gestor análisis estudio')
                                , T_TIPO_TGE('GAFIS'     ,'val.GAFIS'    ,'Despacho Gestor Aseoría Fiscal')
                                , T_TIPO_TGE('GAJUR'     ,'val.GAJUR'    ,'Despacho Gestor Asesoría jurídica')
                                , T_TIPO_TGE('GCON'      ,'val.GCON'     ,'Despacho Gestor contabilidad')       
                                , T_TIPO_TGE('GCONGE'    ,'val.GCONGE'   ,'Despacho Gestor contencioso gestión')
                                , T_TIPO_TGE('GCONPR'    ,'val.GCONPR'   ,'Despacho Gestor contencioso procesal')       
                                , T_TIPO_TGE('GGESDOC'   ,'val.GGESDOC'  ,'Despacho Gestor de gestión documentario')      
                                , T_TIPO_TGE('CJ-GESTLLA','val.GESTILL'  ,'Despacho Gestor HRE gestión llaves')
                                , T_TIPO_TGE('GEXT'      ,'val.LETRADO'  ,'Despacho Letrado')
                                , T_TIPO_TGE('CJ-SAREO'  ,'val.SAREO'    ,'Despacho Supervisor admisión')
                                , T_TIPO_TGE('SAEST'     ,'val.SAEST'    ,'Despacho Supervisor análisis estudio')
                                , T_TIPO_TGE('CJ-SFIS'   ,'val.SFIS'     ,'Despacho Supervisor Asesoría Fiscal')
                                , T_TIPO_TGE('SAJUR'     ,'val.SAJUR'    ,'Despacho Supervisor Asesoría jurídica')
                                , T_TIPO_TGE('CJ-SCON'   ,'val.SCON'     ,'Despacho Supervisor contabilidad')
                                , T_TIPO_TGE('SUCONT'    ,'val.SUCONT'   ,'Despacho Supervisor contencioso')
                                , T_TIPO_TGE('SUP'       ,'val.SUCONGE'  ,'Despacho Supervisor contencioso gestión')
                                , T_TIPO_TGE('SUCONPR'   ,'val.SUCONPR'  ,'Despacho Supervisor contencioso procesal')       
                                , T_TIPO_TGE('SGESDOC'   ,'val.SGESDOC'  ,'Despacho Supervisor de gestión documentario')
                                , T_TIPO_TGE('SPGL'      ,'val.SPGL'     ,'Despacho Supervisor HRE gestión llaves')
                                , T_TIPO_TGE('SUCONGEN2' ,'val.SUCONGEN2','Despacho Supervisor contencioso gestión nivel 2')
                                , T_TIPO_TGE('GCTRGE'    ,'val.GCTRGE'   ,'Despacho Gestor control gestión HRE')
                                , T_TIPO_TGE('SCTRGE'    ,'val.SCTRGE'   ,'Despacho Supervisor control gestión HRE')     
                         );
                         
      V_TMP_TIPO_TGE T_TIPO_TGE;

BEGIN

DBMS_OUTPUT.PUT_LINE('[INICIO]');
 
	FOR I IN V_TIPO_TFA.FIRST .. V_TIPO_TFA.LAST 
	LOOP              
    V_TMP_TIPO_TGE := V_TIPO_TFA(I);
		DBMS_OUTPUT.PUT_LINE('INICIO--'||V_TMP_TIPO_TGE(3));		

		V_MSQL := 'insert into '|| V_ESQUEMA ||'.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)'
			|| 'select '|| V_ESQUEMA ||'.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,'
			|| '       (select max(usd_id) from '|| V_ESQUEMA ||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_TIPO_TGE(2)||'''))) usd_id,'
			|| '       (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_TIPO_TGE(1)||'''), ''JSV'', sysdate'
			|| ' from'
			|| ' (select asu.asu_id'
			|| '  from '|| V_ESQUEMA ||'.asu_asuntos asu'
			|| '  where not exists (select 1 from '|| V_ESQUEMA ||'.GAA_GESTOR_ADICIONAL_ASUNTO gaa '
			|| '                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_TIPO_TGE(1)||'''))'
			|| '  and asu.asu_id in (select asuu.asu_id'
			|| '                    from '|| V_ESQUEMA ||'.asu_asuntos asuu inner join'
			|| '                         '|| V_ESQUEMA ||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join'
			|| '                         '|| V_ESQUEMA ||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner join '
			|| '						 '|| V_ESQUEMA ||'.PRC_PROCEDIMIENTOS prc on prc.asu_id = asuu.asu_id inner join '
			|| '                         '|| V_ESQUEMA ||'.PCO_PRC_PROCEDIMIENTOS pco on pco.prc_id = prc.prc_id'
			|| '                    where asuu.DD_TAS_ID = 1)'
			|| '  ) aux '
--|| ' where asu_id = 101247287'
			;

		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;	
		DBMS_OUTPUT.PUT_LINE('Asignamos los gestores en la GAA' || I);	
		
		V_MSQL := 'insert into '|| V_ESQUEMA ||'.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)'
			|| 'select '|| V_ESQUEMA ||'.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,'
			|| '       (select max(usd_id) from '|| V_ESQUEMA ||'.usd_usuarios_despachos usd inner join '||V_ESQUEMA_M||'.usu_usuarios usu on usu.usu_id = usd.usu_id where TRIM(UPPER(usu.usu_username)) = TRIM(UPPER('''||V_TMP_TIPO_TGE(2)||'''))) usd_id,'
			|| '       sysdate, (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_TIPO_TGE(1)||'''), ''JSV'', sysdate'
			|| ' from'
			|| ' (select asu.asu_id'
			|| '  from '|| V_ESQUEMA ||'.asu_asuntos asu'
			|| '  where not exists (select 1 from '|| V_ESQUEMA ||'.GAH_GESTOR_ADICIONAL_HISTORICO gaa '
			|| '                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from '||V_ESQUEMA_M||'.dd_tge_tipo_gestor where dd_tge_codigo = '''||V_TMP_TIPO_TGE(1)||'''))'
			|| '  and asu.asu_id in (select asuu.asu_id'
			|| '                    from '|| V_ESQUEMA ||'.asu_asuntos asuu inner join'
			|| '                         '|| V_ESQUEMA ||'.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join'
			|| '                         '|| V_ESQUEMA ||'.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id inner join '
			|| '						 '|| V_ESQUEMA ||'.PRC_PROCEDIMIENTOS prc on prc.asu_id = asuu.asu_id inner join '
			|| '                         '|| V_ESQUEMA ||'.PCO_PRC_PROCEDIMIENTOS pco on pco.prc_id = prc.prc_id'
			|| '                    where asuu.DD_TAS_ID =1)'
			|| ' ) aux'
--|| ' where asu_id = 101247287'
			;
			
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;		
		
		DBMS_OUTPUT.PUT_LINE('Asignamos los gestores en la GAH'|| I);

	    COMMIT;		
		
		DBMS_OUTPUT.PUT_LINE('FIN--'||V_TMP_TIPO_TGE(3));	 
	END LOOP;   
 
DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          ROLLBACK;
          RAISE;          
END;

/

EXIT
