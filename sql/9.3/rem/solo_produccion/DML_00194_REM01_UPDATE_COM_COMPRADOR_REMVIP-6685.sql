--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200316
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6685
--## PRODUCTO=NO
--##
--## Finalidad: Update de registros en COM_COMPRADOR
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
	V_TABLA VARCHAR(50 CHAR):='TMP_COM_COMPRADOR_REMVIP_6685';
	V_FECHA VARCHAR(10) := '15/03/2020';
	V_USUARIO VARCHAR(50):='REMVIP-6685';
   
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.COM_COMPRADOR COMPRADOR 
		USING 
		(   
			SELECT COM_ID
			FROM '||V_ESQUEMA||'.'||V_TABLA||'
		) AUX
    	ON (COMPRADOR.COM_ID = AUX.COM_ID)
    	WHEN MATCHED THEN UPDATE 
			SET
            	COMPRADOR.COM_ENVIADO = TO_DATE('''||V_FECHA||''', ''dd/mm/yyyy''),
				COMPRADOR.USUARIOMODIFICAR = '''||V_USUARIO||''',
				COMPRADOR.FECHAMODIFICAR = SYSDATE';
				

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han mergeado '||SQL%ROWCOUNT||' registros');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

    
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;
/
EXIT
