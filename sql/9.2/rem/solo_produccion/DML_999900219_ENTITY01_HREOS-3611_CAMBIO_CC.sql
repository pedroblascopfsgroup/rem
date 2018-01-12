--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.35
--## INCIDENCIA_LINK=HREOS-3564
--## PRODUCTO=SI
--## Finalidad: Setear el campo GIC_CUENTA_CONTABLE a 14121 y el campo GGE_FECHA_ENVIO_PRPTRIO a NULL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE

	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	VN_COUNT NUMBER;
	V_TABLENAME VARCHAR2(35 CHAR):= 'GIC_GASTOS_INFO_CONTABILIDAD'; 
	V_COLNAME VARCHAR2(25 CHAR):= 'GIC_CUENTA_CONTABLE';
	V_VALOR VARCHAR2(25 CHAR):= '14121';
	V_INCIDENCIALINK VARCHAR(35 CHAR):='HREOS-3564';
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas');

	V_MSQL := 'SELECT COUNT(1)
		FROM '||V_ESQUEMA||'.'||V_TABLENAME||'
		WHERE GPV_ID = (
		SELECT GPV.GPV_ID
		FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
		JOIN REM01.GGE_GASTOS_GESTION GGE ON GGE.GPV_ID = GPV.GPV_ID
		WHERE GPV_NUM_GASTO_HAYA = 9423575
		AND GGE.GGE_FECHA_ENVIO_PRPTRIO IS NULL		
		)
		AND '''||V_COLNAME||''' = ''14121''';
	
	EXECUTE IMMEDIATE V_MSQL INTO VN_COUNT;

	IF VN_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya tiene el valor que se pretende');
	ELSE
		
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME||' SET USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', FECHAMODIFICAR = SYSDATE, '||V_COLNAME||' = '||V_VALOR||' WHERE GPV_ID =(
			SELECT GPV_ID
			FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
			WHERE GPV_NUM_GASTO_HAYA = 9423575
		)';

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el valor del campo '||V_COLNAME||' de la tabla '||V_TABLENAME||' con el valor '||V_VALOR||' para el gasto 9423575');

		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION SET USUARIOMODIFICAR = '''||V_INCIDENCIALINK||''', FECHAMODIFICAR = SYSDATE, GGE_FECHA_ENVIO_PRPTRIO = NULL WHERE GPV_ID =(
			SELECT GPV_ID
			FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
			WHERE GPV_NUM_GASTO_HAYA = 9423575
		)';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el valor del campo GGE_FECHA_ENVIO_PRPTRIO de la tabla GPV_GASTOS_PROVEEDOR con el valor NULL para el gasto 9423575');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Modificados: '||SQL%ROWCOUNT||' registros.');


COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Terminadas las tareas del ticket '||V_INCIDENCIALINK);

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
