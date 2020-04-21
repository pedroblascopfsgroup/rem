--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6779
--## PRODUCTO=SI
--##
--## Finalidad: Script que modifica ciertos campos de los gastos de un activo.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(4000 CHAR);
	V_SQL VARCHAR2(4000 CHAR);
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM NUMBER(16); -- Vble. para validar la existencia de un registro.
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-6779'; -- USUARIOCREAR/USUARIOMODIFICAR.
	
	TYPE T_VAR IS TABLE OF VARCHAR2(50);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR; 
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
		T_VAR('9473252', '05', '01', ''),
		T_VAR('9473253', '05', '01', ''),
		T_VAR('9473254', '05', '01', ''),
		T_VAR('9473255', '05', '01', ''),
		T_VAR('9473256', '05', '01', ''),
		T_VAR('9473257', '05', '01', ''),
		T_VAR('9473258', '05', '01', ''),
		T_VAR('9473259', '05', '01', ''),
		T_VAR('9473260', '05', '01', ''),
		T_VAR('9473261', '05', '01', ''),
		T_VAR('9473262', '05', '01', ''),
		T_VAR('9473263', '05', '01', ''),
		T_VAR('9473264', '05', '01', ''),
		T_VAR('9473265', '05', '01', ''),
		T_VAR('9473266', '05', '01', ''),
		T_VAR('9473267', '05', '01', ''),
		T_VAR('9473268', '05', '01', ''),
		T_VAR('9473269', '05', '01', ''),
		T_VAR('9473270', '05', '01', ''),
		T_VAR('9473271', '05', '01', ''),
		T_VAR('9473272', '05', '01', ''),
		T_VAR('9473273', '05', '01', ''),
		T_VAR('9473274', '05', '01', ''),
		T_VAR('9473275', '05', '01', ''),
		T_VAR('9473276', '05', '01', ''),
		T_VAR('9473277', '05', '01', ''),
		T_VAR('9473278', '05', '01', ''),
		T_VAR('9473279', '05', '01', ''),
		T_VAR('9473280', '05', '01', ''),
		T_VAR('9473281', '05', '01', ''),
		T_VAR('9473282', '05', '01', ''),
		T_VAR('9473283', '05', '01', ''),
		T_VAR('9473284', '05', '01', ''),
		T_VAR('9473285', '05', '01', ''),
		T_VAR('9473286', '05', '01', '')
	); 
	V_TMP_VAR T_VAR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso:');
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');

	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Modificando datos para el gasto '||V_TMP_VAR(1)||'...');
		
		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||V_TMP_VAR(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM = 1 THEN
			
			-- Modificamos primero las fechas de pago:
			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE
				USING(
					SELECT GDE_ID FROM '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO T1
					JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = T1.GPV_ID AND GPV.GPV_NUM_GASTO_HAYA = '||V_TMP_VAR(1)||'
					LEFT JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = GPV.DD_EGA_ID AND EGA.DD_EGA_CODIGO = '''||V_TMP_VAR(2)||'''
				) T2
				ON (GDE.GDE_ID = T2.GDE_ID)
				WHEN MATCHED THEN UPDATE SET
					GDE.GDE_FECHA_PAGO = '''||V_TMP_VAR(4)||''',
					GDE.USUARIOMODIFICAR = '''||V_USR||''',
					GDE.FECHAMODIFICAR = SYSDATE
			';
			
			-- Aquí modificamos el estado del gasto a 'Pendiente autorizar':
			EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				USING(
					SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR T1
					JOIN '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO EGA ON EGA.DD_EGA_ID = T1.DD_EGA_ID AND EGA.DD_EGA_CODIGO = '''||V_TMP_VAR(2)||'''
					WHERE T1.GPV_NUM_GASTO_HAYA = '||V_TMP_VAR(1)||'
				) T2
				ON (GPV.GPV_ID = T2.GPV_ID)
				WHEN MATCHED THEN UPDATE SET
					GPV.DD_EGA_ID = (
						SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '''||V_TMP_VAR(3)||'''
					),
					GPV.USUARIOMODIFICAR = '''||V_USR||''',
					GPV.FECHAMODIFICAR = SYSDATE
			';
			
			DBMS_OUTPUT.PUT_LINE('[INFO] Modificaciones realizadas para el gasto '||V_TMP_VAR(1)||'.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[WRN] No existe el gasto '||V_TMP_VAR(1)||'.');
		END IF;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('---------------------------------------');
	DBMS_OUTPUT.PUT_LINE('[FIN] Fin del proceso. '||SQL%ROWCOUNT||' filas');
	
	--ROLLBACK;
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
