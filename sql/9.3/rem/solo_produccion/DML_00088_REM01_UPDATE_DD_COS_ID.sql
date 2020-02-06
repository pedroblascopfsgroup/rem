--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6305
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
	V_USUARIOBORRAR VARCHAR2(50 CHAR) := 'REMVIP-6305';
	
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1
				USING (
				    SELECT DISTINCT ECO.ECO_ID, COS.DD_COS_ID
				    FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
				    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = ECO.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
				    LEFT JOIN '||V_ESQUEMA||'.DD_COS_COMITES_SANCION COS ON COS.DD_COS_CODIGO = ''10''
				    WHERE ACT.DD_CRA_ID = 1
				    AND ECO.DD_COS_ID IS NULL
				) T2
				ON (T1.ECO_ID = T2.ECO_ID)
				WHEN MATCHED THEN UPDATE SET
				    T1.DD_COS_ID = T2.DD_COS_ID
				    ,T1.USUARIOMODIFICAR = '''||V_USUARIOBORRAR||'''
				    ,FECHAMODIFICAR = SYSDATE
				';
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' expedientes');

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