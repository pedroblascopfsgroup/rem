--/*
--##########################################
--## AUTOR=Juan Bautista alfonso
--## FECHA_CREACION=20210408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9412
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización principal sujeto lineas gasto
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
	V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
 	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
 	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9412'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
    V_NUM_GASTO VARCHAR2(50 CHAR):='13654089';
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE T1 USING (
					SELECT GLD.GLD_ID,BASE_SUJETA FROM(
                        SELECT GLD.GLD_ID,SUM(TBJ.TBJ_IMPORTE_TOTAL) AS BASE_SUJETA FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
                        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID=GPV.GPV_ID
                        JOIN '||V_ESQUEMA||'.GLD_TBJ GLTJ ON GLTJ.GLD_ID=GLD.GLD_ID
                        JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID=GLTJ.TBJ_ID
                        WHERE GPV.GPV_NUM_GASTO_HAYA='||V_NUM_GASTO||' 
                        GROUP BY (GLD.GLD_ID)
                    )AUX
                    JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID=AUX.GLD_ID
                    WHERE GLD.GLD_PRINCIPAL_SUJETO!=AUX.BASE_SUJETA
                    ) T2
				ON (T1.GLD_ID = T2.GLD_ID)
				WHEN MATCHED THEN UPDATE SET
				GLD_PRINCIPAL_SUJETO = T2.BASE_SUJETA,
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN GLD_GASTO_LINEA_DETALLE DEL GASTO '||V_NUM_GASTO||'');

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	EXCEPTION
	
	    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		ROLLBACK;
		RAISE;
END;
/
EXIT;