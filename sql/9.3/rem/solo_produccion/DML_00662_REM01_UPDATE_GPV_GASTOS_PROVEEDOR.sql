--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8871
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización PVE_ID_GESTORIA
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8871'; -- USUARIO CREAR/MODIFICAR
	V_COUNT NUMBER(16); -- Vble. para comprobar
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error

	V_PVE_ID_ANTERIOR NUMBER(16):= 20732;
	V_PVE_ID_NUEVO NUMBER(16):= 171072;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1 USING (
					SELECT DISTINCT GPV.GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
					INNER JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO IN (''01'',''02'',''07'',''08'',''10'',''12'')
					WHERE GPV.BORRADO = 0 AND GPV.PVE_ID_GESTORIA = '||V_PVE_ID_ANTERIOR||') T2
				ON (T1.GPV_ID = T2.GPV_ID)
				WHEN MATCHED THEN UPDATE SET
				PVE_ID_GESTORIA = '||V_PVE_ID_NUEVO||',
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN GPV_GASTOS_PROVEEDOR');

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