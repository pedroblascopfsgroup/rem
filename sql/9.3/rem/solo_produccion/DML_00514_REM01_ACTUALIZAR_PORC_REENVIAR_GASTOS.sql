--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20201103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8256
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
	V_USU VARCHAR2(30 CHAR):= 'REMVIP-8256';
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);	
   	V_PAR VARCHAR( 3000 CHAR );
   	V_RET VARCHAR( 3000 CHAR );  
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	--ACTUALIZAMOS porcentaje erroneo por el correcto usando la vista, depende de los casos modificamos condiciones 
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_ACT T1 USING (
				SELECT 
				GA.GPV_PARTICIPACION_GASTO AS PARTICIP_GASTO_ERRONEO,
				VI.GPV_ACT_ID,
				VI.GPV_ID,
				VI.ACT_ID,
				ROUND(VI.GPV_PARTICIPACION_GASTO,4) AS PARTICIP_GASTO_CORRECTO 
				FROM '||V_ESQUEMA||'.GPV_ACT GA
				INNER JOIN '||V_ESQUEMA||'.VI_BUSQUEDA_GASTOS_ACTIVOS VI ON VI.GPV_ID = GA.GPV_ID AND VI.ACT_ID = GA.ACT_ID
				INNER JOIN (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_TBJ GROUP BY GPV_ID) GT ON GT.GPV_ID = GA.GPV_ID
				WHERE ga.gpv_id in (4262471,6852374,7155426)) T2
			ON (T1.GPV_ACT_ID = T2.GPV_ACT_ID)
				WHEN MATCHED THEN UPDATE SET 
				T1.GPV_PARTICIPACION_GASTO = T2.PARTICIP_GASTO_CORRECTO';

			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS  '|| SQL%ROWCOUNT ||' REGISTROS');
	
	COMMIT;
	
	DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

	 V_PAR := '9451610,10878701,11181953';	

   	REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USU, V_RET );

-----------------------------------------------------------------------------------------------------------------

   	DBMS_OUTPUT.PUT_LINE( V_RET );
   	DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');
   	DBMS_OUTPUT.PUT_LINE('[FIN] ');

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
