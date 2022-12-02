--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=202209121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18630
--## PRODUCTO=NO
--## 
--## Finalidad: INSERTAR PROVEEDOR DIRECCION 
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
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18630'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR T1 USING (
		   SELECT 
		   PVE.PVE_ID, 
		   AUX.CODIGOBC
		   FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
		   JOIN '||V_ESQUEMA||'.APR_AUX_HREOS_18630_2 AUX ON AUX.CIF = PVE.PVE_DOCIDENTIF
		   WHERE PVE.BORRADO = 0 
		   AND PVE.PVE_COD_UVEM IS NULL
		   ) T2 ON (T1.PVE_ID = T2.PVE_ID)
		   WHEN MATCHED THEN UPDATE SET 							      
		   T1.PVE_COD_UVEM = T2.CODIGOBC,
		   T1.USUARIOMODIFICAR = ''HREOS-18630'', 
		   T1.FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_PVC_PROVEEDOR_CONTACTO');

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
