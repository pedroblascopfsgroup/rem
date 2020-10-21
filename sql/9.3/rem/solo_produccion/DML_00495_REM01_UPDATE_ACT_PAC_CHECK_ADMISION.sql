--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8261
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_USUARIO VARCHAR(100 CHAR):= 'REMVIP_8261';
   
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    DBMS_OUTPUT.PUT_LINE('[ACTUALIZAMOS CHECK ADMISION A 1]');

          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1 
    	       USING (SELECT PAC.PAC_ID
		    FROM '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
		    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = PAC.ACT_ID 
		    WHERE ACT.BORRADO = 0 AND PAC.BORRADO = 0
		    AND ( ACT.DD_CRA_ID IN (1,2,21,43) OR ACT.DD_SCR_ID IN (101))) T2
                ON (T1.PAC_ID = T2.PAC_ID)
           WHEN MATCHED THEN UPDATE SET 
		T1.PAC_CHECK_ADMISION = 1, 
		T1.PAC_FECHA_ADMISION = SYSDATE, 
		USUARIOMODIFICAR = ''REMVIP_8261'', 
		FECHAMODIFICAR = SYSDATE';

 EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros ');

COMMIT;

 DBMS_OUTPUT.PUT_LINE('[FIN]' );

			 
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
EXIT;
