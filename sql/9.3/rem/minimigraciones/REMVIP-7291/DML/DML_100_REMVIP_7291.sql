--/*
--#########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200515
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7291
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-7291';
	V_SEQUENCE NUMBER(16);
	
BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO]');

		V_SQL := 'SELECT '||V_ESQUEMA||'.S_ACT_RPV_RECARGOS_PROVEEDOR.NEXTVAL FROM DUAL';
		EXECUTE IMMEDIATE V_SQL INTO V_SEQUENCE;
        
        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_RPV_RECARGOS_PROVEEDOR T1
					USING (
						SELECT  '||V_SEQUENCE||'+ROW_NUMBER() OVER(ORDER BY TBJ_ID ASC) AS RPV_ID,
							TCT.TBJ_ID, AUX.TBJ_NUM_TRABAJO, TCT.TCT_TOTAL
						FROM '||V_ESQUEMA||'.AUX_REMVIP_7291 AUX
						JOIN (
							SELECT TBJ_ID, TBJ_NUM_TRABAJO, SUM(TCT_TOTAL) AS TCT_TOTAL FROM (
								SELECT TBJ.TBJ_ID, TBJ.TBJ_NUM_TRABAJO, TCT_MEDICION*TCT_PRECIO_UNITARIO AS TCT_TOTAL 
								FROM '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA TCT
								JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TCT.TBJ_ID
							) GROUP BY TBJ_ID, TBJ_NUM_TRABAJO
						) TCT ON TCT.TBJ_NUM_TRABAJO = AUX.TBJ_NUM_TRABAJO
					) T2
					ON (T1.TBJ_ID = T2.TBJ_ID)
					WHEN NOT MATCHED THEN INSERT
						(RPV_ID, TBJ_ID, DD_TRP_ID, DD_TCC_ID, RPV_IMPORTE_CALCULO, RPV_IMPORTE_FINAL, USUARIOCREAR, FECHACREAR, BORRADO)
						VALUES (T2.RPV_ID, T2.TBJ_ID, 1, 2, 20, T2.TCT_TOTAL*0.2, ''REMVIP-7291'', SYSDATE, 0)';
        EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros.');

		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN]');

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
