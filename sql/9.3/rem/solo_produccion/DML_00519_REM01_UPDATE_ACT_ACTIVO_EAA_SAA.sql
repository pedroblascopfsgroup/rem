--/*
--######################################### 
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201106
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8269
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  ACTUALIZAR ESTADO Y SUBESTADO ADMISION
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(100 CHAR):='REMVIP-8269V2'; --Vble. auxiliar para almacenar el usuario
    V_TABLA VARCHAR2(100 CHAR) :='ACT_ACTIVO'; --Vble. auxiliar para almacenar la tabla a insertar	
    V_ID NUMBER(16); --Vble. Para almacenar el id del tramite a actualizar   
    V_COUNT NUMBER(16):=0; --Vble. Para contar cuantos registros se han actualizado correctamente

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAMOS A SANEADO REGISTRALMENTE');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1 USING 
			(SELECT DISTINCT ACT.ACT_ID
			FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
			INNER JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON ACT.ACT_ID = TIT.ACT_ID
			INNER JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_ID = TIT.DD_ETI_ID
			INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
			WHERE PAC.PAC_CHECK_ADMISION = 1 
			AND ETI.DD_ETI_CODIGO = ''02'' 
			AND ACT.ACT_CON_CARGAS = 0 and act.dd_eaa_id is null
             		and act.borrado = 0 
             		and (act.act_id not in 
		    (
		    SELECT DISTINCT ACT.ACT_ID
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
				INNER JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.ACT_ADA_ADJUNTO_ACTIVO ADA ON ACT.ACT_ID = ADA.ACT_ID
				INNER JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = ADA.DD_TPD_ID
				WHERE PAC.PAC_CHECK_ADMISION = 1 
				AND DD_TPD_MATRICULA_GD NOT IN (''AI-01-CNCV-17'',''AI-01-CNCV-83'',''AI-01-ESCR-06'',''AI-18-ESCR-06'',''AI-01-ESCR-10'',''AI-18-ESCR-10'',
				''AI-01-ESCR-59'',''AI-01-ESCR-14'',''AI-01-CNCV-84'',''AI-01-SERE-24'',''AI-18-SERE-24'',''AI-01-SERE-26'',''AI-18-SERE-26'',''AI-01-DOCN-14'',
				''AI-01-ESCR-26'',''AI-14-IPLS-54'')))
			) T2 ON (T1.ACT_ID = T2.ACT_ID)
		WHEN MATCHED THEN UPDATE SET 
		T1.DD_EAA_ID = 4,
		T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
		T1.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN ACT_ACTIVO: ' ||sql%rowcount);

        
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    
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
EXIT
