--/*
--##########################################
--## AUTOR=Ivan Repiso
--## FECHA_CREACION=20200902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8001
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización HIC_FECHA EN ACT_HIC_EST_INF_COMER_HIST
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
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-8001';
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--ACTUALIZAMOS HIC FECHA DE ACT_HIC_EST_INF_COMER_HIST
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST T1 
				USING (SELECT HIC_ID, ICO_FECHA_ACEPTACION, HIC_FECHA FROM (
						SELECT HIC_ID,ACT_ID,HIC_FECHA FROM '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST WHERE TO_CHAR(HIC_FECHA,''DD/MM/YY'') = ''18/11/17'' AND DD_AIC_ID = 2) HIC
						LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO
						ON ICO.ACT_ID = HIC.ACT_ID
						LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
						ON ACT.ACT_ID = HIC.ACT_ID
						WHERE DD_CRA_ID = 21 AND ICO.ICO_FECHA_ACEPTACION IS NOT NULL) T2 
				ON (T1.HIC_ID = T2.HIC_ID)
				WHEN MATCHED THEN UPDATE SET 
				T1.HIC_FECHA = T2.ICO_FECHA_ACEPTACION,
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USU||'''';
			
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