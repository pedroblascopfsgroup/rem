--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-2659
--## PRODUCTO=NO
--## 
--## Finalidad: Actualiza importes erroneos de la tabla GEX_GASTOS_EXPEDIENTE
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2659';

BEGIN


	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE T1
				USING (
					    SELECT DISTINCT ECO.ECO_NUM_EXPEDIENTE, GEX.GEX_ID, GEX.GEX_IMPORTE_CALCULO, GEX.GEX_IMPORTE_FINAL, GEX.ACT_ID, 
					    ROUND(AFR.ACT_OFR_IMPORTE*(GEX.GEX_IMPORTE_CALCULO/100),2) AS CALCULO 
					    FROM '||V_ESQUEMA||'.GEX_GASTOS_EXPEDIENTE GEX
					    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = GEX.ECO_ID 
					    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID 
					    JOIN '||V_ESQUEMA||'.ACT_OFR AFR ON AFR.ACT_ID = GEX.ACT_ID AND  AFR.OFR_ID = ECO.OFR_ID 
					    WHERE GEX.USUARIOMODIFICAR = ''REMVIP-2659'' 
					    AND GEX.GEX_IMPORTE_CALCULO = ''0.25''              
				) T2 
				ON (T1.GEX_ID = T2.GEX_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.GEX_IMPORTE_FINAL = T2.CALCULO,
					T1.USUARIOMODIFICAR = ''REMVIP-2659_2'',
					T1.FECHAMODIFICAR = SYSDATE';



	EXECUTE IMMEDIATE V_SQL;
		

	COMMIT;

      DBMS_OUTPUT.put_line('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registro en la tabla GEX_GASTOS_EXPEDIENTE');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
