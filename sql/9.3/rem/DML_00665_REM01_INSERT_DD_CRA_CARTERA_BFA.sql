--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14884
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_CRA_CARTERA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--## 		0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USU VARCHAR2(50 CHAR) := 'HREOS-14884';
	TYPE T_VAR IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_VAR IS TABLE OF T_VAR;
	V_VAR T_ARRAY_VAR := T_ARRAY_VAR(
	-- 			TABLA 					DESCRIPCION 		DESCRIPCION_LARGA 		CAMPOS AFECTADOS        CODIGO_CARTERA
		T_VAR('DD_CRA_CARTERA', 		'BFA', 			'BFA', 				'DD_CRA_ID', 'DD_CRA_CODIGO', 'DD_CRA_DESCRIPCION', 'DD_CRA_DESCRIPCION_LARGA','17')
	); 
	V_TMP_VAR T_VAR;
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	-- LOOP para insertar los nuevos registros
	FOR I IN V_VAR.FIRST .. V_VAR.LAST LOOP
		V_TMP_VAR := V_VAR(I);
		
		DBMS_OUTPUT.PUT_LINE('	[INFO]: Inserción de un nuevo registro en la tabla '''||V_TMP_VAR(1)||'''.');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' WHERE DD_CRA_DESCRIPCION = '''||V_TMP_VAR(2)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		
		-- Si no existe 
		IF V_NUM = 0 THEN
			
			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TMP_VAR(1)||' (
				'||V_TMP_VAR(4)||',
				'||V_TMP_VAR(5)||', 
				'||V_TMP_VAR(6)||', 
				'||V_TMP_VAR(7)||', 
				VERSION,
				USUARIOCREAR,
				FECHACREAR,
				BORRADO
			)
			SELECT 
				'||V_ESQUEMA||'.S_'||V_TMP_VAR(1)||'.NEXTVAL, 
				'''||V_TMP_VAR(8)||''',
				'''||V_TMP_VAR(2)||''',
				'''||V_TMP_VAR(3)||''',
				0,
				'''||V_USU||''',
				SYSDATE,
				0
			FROM DUAL
			';
			EXECUTE IMMEDIATE V_SQL;
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[ERROR] El registro '''||V_TMP_VAR(2)||''' ya existe.');
		END IF;
	END LOOP;
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	

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
EXIT;
