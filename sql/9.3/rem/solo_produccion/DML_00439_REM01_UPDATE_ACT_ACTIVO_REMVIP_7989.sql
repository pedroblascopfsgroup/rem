--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200827
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7989
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
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.    
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7989'; -- USUARIOCREAR/USUARIOMODIFICAR

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR RATING ACTIVOS');
	
	
	V_MSQL :=   'SELECT DD_AIC_ID FROM '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''02''';        
    EXECUTE IMMEDIATE V_MSQL INTO V_ID;    
	

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1 
			     USING(	
			 		SELECT 
						AUX.ACT_ID
			        FROM '||V_ESQUEMA||'.ACT_ACTIVO AUX
			        LEFT JOIN '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC ON HIC.ACT_ID = AUX.ACT_ID
			            AND HIC.DD_AIC_ID = '||V_ID||'
			        WHERE AUX.DD_RTG_ID IS NOT NULL        
			        AND HIC.ACT_ID IS NULL				
			     ) T2
			     ON (T1.ACT_ID = T2.ACT_ID)
			     WHEN MATCHED THEN UPDATE SET		 
			     T1.DD_RTG_ID = NULL,		   		     
			     T1.FECHAMODIFICAR = SYSDATE,
			     T1.USUARIOMODIFICAR = '''||V_USR||'''';

        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros '); 
        DBMS_OUTPUT.PUT_LINE('[FIN] '); 

        COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT
