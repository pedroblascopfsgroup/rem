--/*
--######################################### 
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7210
--## PRODUCTO=NO
--## 
--## Finalidad:
--##            
--## INSTRUCCIONES:  
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
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master 
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7210';
	
BEGIN
        DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO TABLA ACT_NOG_NOTIFICACION_GENCAT');

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_NOG_NOTIFICACION_GENCAT WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-7210''';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado  '||SQL%ROWCOUNT||' registros .');

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO TABLA ACT_VIG_VISITA_GENCAT');

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_VIG_VISITA_GENCAT WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-7210''';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado  '||SQL%ROWCOUNT||' registros .');

	DBMS_OUTPUT.PUT_LINE('[INICIO] BORRADO TABLA ACT_CMG_COMUNICACION_GENCAT');

	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT WHERE BORRADO = 1 AND USUARIOBORRAR = ''REMVIP-7210''';

	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado  '||SQL%ROWCOUNT||' registros .');

    	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
  
EXCEPTION
	WHEN OTHERS THEN 
	    DBMS_OUTPUT.PUT_LINE('KO!');
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    
	    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
	    DBMS_OUTPUT.PUT_LINE(err_msg);
	    
	    ROLLBACK;
	    RAISE;          

END;
/
EXIT;
