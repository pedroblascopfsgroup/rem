--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20200414
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6834
--## PRODUCTO=SI
--##
--## Finalidad: Script que inserta una nueva tasación en ACT_TAS_TASACION y el correspondiente registro del bien en BIE_VALORACIONES. 
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
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
	V_NUM NUMBER(16); -- Vble. para validar la existencia de un registro.
	err_num NUMBER; -- Numero de errores
	err_msg VARCHAR2(2048); -- Mensaje de error
	V_USR VARCHAR2(30 CHAR) := 'REMVIP-6834'; -- USUARIOCREAR/USUARIOMODIFICAR.
	
	TYPE T_VAR IS TABLE OF VARCHAR2(50);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR; 
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(   
		T_VAR('6850005', '29/12/2017', '15273,96')
	); 
	V_TMP_VAR T_VAR;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] Creando nueva/s tasación/es:');

	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Tasación para el activo '||V_TMP_VAR(1)||'...');
		
		V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_VAR(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM;
		
		IF V_NUM = 1 THEN
			DBMS_OUTPUT.PUT_LINE('	[INFO] Insertando en BIE_VALORACIONES...');
			
			EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.BIE_VALORACIONES (
				BIE_VAL_ID,
				BIE_ID,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				BORRADO
			)
			WITH VALORACIONES AS(
				SELECT DISTINCT
					BIE_VAL.BIE_ID
				FROM '||V_ESQUEMA||'.BIE_VALORACIONES BIE_VAL
				JOIN '||V_ESQUEMA||'.ACT_TAS_TASACION TAS ON BIE_VAL.BIE_VAL_ID = TAS.BIE_VAL_ID
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TAS.ACT_ID AND ACT.ACT_NUM_ACTIVO = '||V_TMP_VAR(1)||'
			)
			SELECT
				'||V_ESQUEMA||'.S_BIE_VALORACIONES.NEXTVAL,
				VAL.BIE_ID,
				0,
				'''||V_USR||''',
				SYSDATE,
				0
			FROM VALORACIONES VAL
			WHERE NOT EXISTS (
				SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES
				WHERE USUARIOCREAR = '''||V_USR||'''
			)
			';
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Insertando en ACT_TAS_TASACION...');
			
			EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_TAS_TASACION (
				TAS_ID,
				ACT_ID,
				BIE_VAL_ID,
				TAS_FECHA_INI_TASACION,
				TAS_FECHA_RECEPCION_TASACION,
				TAS_IMPORTE_TAS_FIN,
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				BORRADO
			)
			VALUES(
				'||V_ESQUEMA||'.S_ACT_TAS_TASACION.NEXTVAL,
				(
					SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_VAR(1)||'
				),
				(
					SELECT BIE_VAL_ID FROM '||V_ESQUEMA||'.BIE_VALORACIONES WHERE USUARIOCREAR = '''||V_USR||'''
				),
				'''||V_TMP_VAR(2)||''',
				'''||V_TMP_VAR(2)||''',
				'''||V_TMP_VAR(3)||''',
				0,
				'''||V_USR||''',
				SYSDATE,
				0
			)';
			
			DBMS_OUTPUT.PUT_LINE('	[INFO] Tasación realizada para el activo '||V_TMP_VAR(1)||'.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[WRN] No existe el activo '||V_TMP_VAR(1)||'.');
		END IF;
	END LOOP;
	
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
