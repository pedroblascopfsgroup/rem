/*
--##########################################
--## AUTOR=Sergio Belenguer Gadea
--## FECHA_CREACION=20171204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.32
--## INCIDENCIA_LINK=HREOS-3341
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master

    V_SQL VARCHAR2(6000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REG NUMBER;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
          
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ... UPDATE CONFIG TARIFA');
	DBMS_OUTPUT.PUT_LINE('UPDATE TARIFA SAB-CER');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT 
		SET DD_STR_ID = 21,
		USUARIOMODIFICAR =  ''HREOS-3341'',
		FECHAMODIFICAR = SYSDATE
        WHERE DD_ttr_id=3 and dd_cra_id=2 and DD_TTF_ID IN (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO IN (''SAB-CER8'',''SAB-CER9'',''SAB-CER10'',''SAB-CER11''))';

        EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('Tarifas actualizadas: ' || sql%rowcount);
    DBMS_OUTPUT.PUT_LINE('FIN TARIFA SAB-CER');

	DBMS_OUTPUT.PUT_LINE('UPDATE TARIFA TAP3');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT 
		SET DD_STR_ID = 22,
		USUARIOMODIFICAR =  ''HREOS-3341'',
		FECHAMODIFICAR = SYSDATE
        WHERE DD_ttr_id=3 and dd_cra_id=2 and DD_TTF_ID IN (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO =''TAP3'')';
        
        EXECUTE IMMEDIATE V_SQL; 
	DBMS_OUTPUT.PUT_LINE('Tarifas actualizadas: ' || sql%rowcount);
	DBMS_OUTPUT.PUT_LINE('UPDATE TARIFA SS3');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT 
		SET DD_STR_ID = 28,
		USUARIOMODIFICAR =  ''HREOS-3341'',
		FECHAMODIFICAR = SYSDATE
        WHERE DD_ttr_id=3 and dd_cra_id=2 and DD_TTF_ID IN (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO =''SS3'')';
        
        EXECUTE IMMEDIATE V_SQL;	
	DBMS_OUTPUT.PUT_LINE('Tarifas actualizadas: ' || sql%rowcount);
	DBMS_OUTPUT.PUT_LINE('UPDATE TARIFA ALR5');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT 
		SET DD_STR_ID = 30,
		USUARIOMODIFICAR =  ''HREOS-3341'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_ttr_id=3 and dd_cra_id=2 and DD_TTF_ID IN (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO =''ALR5'')';
        
        EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Tarifas actualizadas: ' || sql%rowcount);
	DBMS_OUTPUT.PUT_LINE('UPDATE TARIFA SOL12');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT 
		SET DD_STR_ID = 27,
		USUARIOMODIFICAR =  ''HREOS-3341'',
		FECHAMODIFICAR = SYSDATE
		WHERE DD_ttr_id=3 and dd_cra_id=2 and DD_TTF_ID IN (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO =''SOL12'')';
        
        EXECUTE IMMEDIATE V_SQL;
	
    	DBMS_OUTPUT.PUT_LINE('Tarifas actualizadas: ' || sql%rowcount);
        DBMS_OUTPUT.PUT_LINE('[FIN] ... UPDATE CONF TARIFAS');
    
    --ROLLBACK;
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
