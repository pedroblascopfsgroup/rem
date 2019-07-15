--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20190715
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.13.0
--## INCIDENCIA_LINK=HREOS-6668
--## PRODUCTO=NO
--## 
--## Finalidad: Alteración de auditorías tablas.
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

	V_CHAR_LENGTH NUMBER(5,0);
	V_MSQL VARCHAR2(4000 CHAR);
	V_ESQUEMA_1 VARCHAR2(20 CHAR) := '#ESQUEMA#';
	V_ESQUEMA_2 VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
	V_LENGTH NUMBER(2,0) := 50;
	TYPE T_NOMBRES IS TABLE OF VARCHAR2(30 CHAR);
	TYPE T_ARRAY IS TABLE OF T_NOMBRES;
	V_NOMBRES T_ARRAY := 
		T_ARRAY (
			T_NOMBRES('REM01','ADC_ADJUNTO_COMUNICACION','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','ADC_ADJUNTO_COMUNICACION','USUARIOCREAR'),
			T_NOMBRES('REM01','ADC_ADJUNTO_COMUNICACION','USUARIOBORRAR'),
			T_NOMBRES('REM01','GPL_GASTOS_PRINEX_LBK','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','GPL_GASTOS_PRINEX_LBK','USUARIOBORRAR'),
			T_NOMBRES('REM01','GPL_GASTOS_PRINEX_LBK','USUARIOCREAR'),
			T_NOMBRES('REM01','ACT_CPR_COPROPIETARIO','USUARIOCREAR'),
			T_NOMBRES('REM01','ACT_CPR_COPROPIETARIO','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','ACT_CPR_COPROPIETARIO','USUARIOBORRAR'),
			T_NOMBRES('REM01','ACT_CAC_COPROP_ACTIVO','USUARIOBORRAR'),
			T_NOMBRES('REM01','ACT_CAC_COPROP_ACTIVO','USUARIOCREAR'),
			T_NOMBRES('REM01','ACT_CAC_COPROP_ACTIVO','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','EPV_ECO_PLUSVALIAVENTA','USUARIOCREAR'),
			T_NOMBRES('REM01','EPV_ECO_PLUSVALIAVENTA','USUARIOBORRAR'),
			T_NOMBRES('REM01','EPV_ECO_PLUSVALIAVENTA','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','AIA_ADMIN_IMPUESTOS_ACTIVO','USUARIOMODIFICAR'),
			T_NOMBRES('REM01','AIA_ADMIN_IMPUESTOS_ACTIVO','USUARIOBORRAR'),
			T_NOMBRES('REM01','AIA_ADMIN_IMPUESTOS_ACTIVO','USUARIOCREAR')
			);
	V_TMP_NOMBRES T_NOMBRES;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Ampliación campos auditoría.');

	FOR I IN V_NOMBRES.FIRST .. V_NOMBRES.LAST
		LOOP
			V_TMP_NOMBRES := V_NOMBRES(I);

			--Comprobamos que campo sea de menor tamaño que la longitud definida
			V_MSQL := 'SELECT CHAR_LENGTH
				FROM ALL_TAB_COLUMNS 
				WHERE OWNER = '''||V_TMP_NOMBRES(1)||''' 
					AND TABLE_NAME = '''||V_TMP_NOMBRES(2)||''' 
					AND COLUMN_NAME = '''||V_TMP_NOMBRES(3)||'''';
			EXECUTE IMMEDIATE V_MSQL INTO V_CHAR_LENGTH;

			IF V_CHAR_LENGTH < V_LENGTH THEN
				V_MSQL := 'ALTER TABLE '||V_TMP_NOMBRES(1)||'.'||V_TMP_NOMBRES(2)||'
					MODIFY '||V_TMP_NOMBRES(3)||' VARCHAR2('||V_LENGTH||' CHAR)';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('	[INFO] Campo '||V_TMP_NOMBRES(3)||' de la tabla '||V_TMP_NOMBRES(2)||' ampliado de '||V_CHAR_LENGTH||' a '||V_LENGTH||' CHAR.');
			ELSE
				DBMS_OUTPUT.PUT_LINE('	[INFO] Campo '||V_TMP_NOMBRES(3)||' de la tabla '||V_TMP_NOMBRES(2)||', ya es mayor/igual de '||V_LENGTH||' CHAR, ('||V_CHAR_LENGTH||').');
			END IF;
		END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Todos los campos ampliados o sin necesidad de ello.');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/
EXIT;
