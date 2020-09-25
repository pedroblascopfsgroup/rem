--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8046
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización porcentajes gastos-activo erroneos
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
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-8046';
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--ACTUALIZAMOS porcentaje erroneo por el correcto usando la vista, depende de los casos modificamos condiciones 
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_ACT T1 USING (
				SELECT AUX.PORCENTAJE_TOTAL, 
				GA.GPV_PARTICIPACION_GASTO AS PARTICIP_GASTO_ERRONEO,
				VI.GPV_ACT_ID,
				VI.GPV_ID,
				VI.ACT_ID,
				ROUND(VI.GPV_PARTICIPACION_GASTO,4) AS PARTICIP_GASTO_CORRECTO 
				FROM '||V_ESQUEMA||'.GPV_ACT GA
				INNER JOIN '||V_ESQUEMA||'.VI_BUSQUEDA_GASTOS_ACTIVOS VI ON VI.GPV_ID = GA.GPV_ID AND VI.ACT_ID = GA.ACT_ID
				INNER JOIN (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_TBJ GROUP BY GPV_ID) GT ON GT.GPV_ID = GA.GPV_ID
				INNER JOIN (SELECT GPV_ID, GPV_NUM_GASTO_HAYA NUM_GASTO,
					    SUMA AS PORCENTAJE_TOTAL,
					    FECHA_ENVIO AS FECHA_ENVIO_HISTORICO
					    FROM (
					    SELECT GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA,
					    SUM(GA.GPV_PARTICIPACION_GASTO) AS SUMA,
					    ENV.FECHA_ENVIO
					    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
					    INNER JOIN '||V_ESQUEMA||'.GPV_ACT GA ON GA.GPV_ID = GPV.GPV_ID
					    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GA.ACT_ID AND ACT.DD_CRA_ID <> 43
					    INNER JOIN '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE ON GPV.GPV_ID = GGE.GPV_ID
					    INNER JOIN '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA EAH ON GGE.DD_EAH_ID = EAH.DD_EAH_ID 
					    INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID 
					    LEFT JOIN '||V_ESQUEMA||'.VI_GASTOS_HISTORICO_ENVIO ENV ON GPV.GPV_NUM_GASTO_HAYA = ENV.GPV_NUM_GASTO_HAYA 
					    WHERE GPV.BORRADO = 0 
					    AND ACT.BORRADO = 0 
					    AND ENV.FECHA_ENVIO IS NULL 
					    GROUP BY 
					    GPV.GPV_ID, GPV.GPV_NUM_GASTO_HAYA,ENV.FECHA_ENVIO)
					    WHERE SUMA >= 101 ) AUX ON AUX.GPV_ID = GA.GPV_ID
				WHERE VI.GPV_PARTICIPACION_GASTO != 0 AND VI.DD_EGA_CODIGO NOT IN (''04'',''05'',''06'') 
				AND ROUND(GA.GPV_PARTICIPACION_GASTO,2) != ROUND(VI.GPV_PARTICIPACION_GASTO,2)) T2
			ON (T1.GPV_ACT_ID = T2.GPV_ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
				T1.GPV_PARTICIPACION_GASTO = T2.PARTICIP_GASTO_CORRECTO';

			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS');

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
