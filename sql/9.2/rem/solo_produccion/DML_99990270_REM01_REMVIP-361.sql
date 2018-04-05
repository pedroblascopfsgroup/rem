--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180321
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-361
--## PRODUCTO=NO
--## Finalidad:
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	 
    EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ T1
		USING (SELECT 100 - SUM(ACT_TBJ_PARTICIPACION) OVER(PARTITION BY ATB.TBJ_ID ORDER BY 1) DIFERENCIA
		        , ROW_NUMBER() OVER(PARTITION BY ATB.TBJ_ID ORDER BY 1) RN
		        , ATB.ACT_ID, ATB.TBJ_ID
		    FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
		    JOIN '||V_ESQUEMA||'.ACT_TBJ ATB ON TBJ.TBJ_ID = ATB.TBJ_ID
		    WHERE TBJ.TBJ_NUM_TRABAJO = ''9000059117'') T2
		ON (T1.ACT_ID = T2.ACT_ID AND T1.TBJ_ID = T2.TBJ_ID AND T2.RN = 1)
		WHEN MATCHED THEN UPDATE SET
		    T1.ACT_TBJ_PARTICIPACION = ACT_TBJ_PARTICIPACION + T2.DIFERENCIA
		WHERE T2.DIFERENCIA <> 0';    
    DBMS_OUTPUT.PUT_LINE('  [INFO] Se ha actualizado el ACT_TBJ_PARTICIPACION de '||SQL%ROWCOUNT||' activo.');
    
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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