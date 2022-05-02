--/*
--###########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17551
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TABLA VARCHAR2(50 CHAR) := 'USU_USUARIOS';
	
	V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
	V_ENTIDAD_ID NUMBER(16);
	V_COUNT NUMBER(16);
	
	V_USUARIOCREAR VARCHAR2(50 CHAR) := 'HREOS-17551';

	TYPE T_PWD IS TABLE OF VARCHAR2(50 CHAR);
	V_PWD T_PWD := T_PWD('1234');
	
	-- Arrays de usuarios:
	TYPE T_USU IS TABLE OF VARCHAR2(50 CHAR);
	TYPE T_USUARIOS IS TABLE OF T_USU;
	-- USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_APELLIDO1, USU_APELLIDO2, USU_GRUPO
	V_USER T_USUARIOS := T_USUARIOS(
		T_USU('gestformcajamar', ''||V_PWD(1)||'', 'Gestoría de formalización Cajamar','','','1')
		
	);
	V_TMP_USU T_USU;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	FOR I IN V_USER.FIRST .. V_USER.LAST
	LOOP
		V_TMP_USU := V_USER(I);
		
		DBMS_OUTPUT.PUT_LINE('');
		DBMS_OUTPUT.PUT_LINE('[INFO]: Inserción del usuario '''||V_TMP_USU(1)||'''');
		DBMS_OUTPUT.PUT_LINE('[INFO]:		Comprobando si el registro ya existe...');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE USU_USERNAME = '''||V_TMP_USU(1)||'''';		
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[ WRN ]: El usuario '''||V_TMP_USU(1)||''' ya se encontraba insertado. Actualizando datos...');
			V_SQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' SET 
				USU_PASSWORD = '''||V_TMP_USU(2)||''', 
				USU_NOMBRE = '''||V_TMP_USU(3)||''',
				USU_APELLIDO1 = '''||V_TMP_USU(4)||''', 
				USU_APELLIDO2 = '''||V_TMP_USU(5)||''', 
				USUARIOMODIFICAR = '''||V_USUARIOCREAR||''', 
				FECHAMODIFICAR = SYSDATE, 
				USU_GRUPO = '''||V_TMP_USU(6)||''', 
				BORRADO = 0, 
				USU_FECHA_VIGENCIA_PASS = TO_DATE(''23/12/23'',''DD/MM/YYYY'')
				WHERE USU_USERNAME = '''||V_TMP_USU(1)||'''';			
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Usuario '''||V_TMP_USU(1)||''' modificado correctamente');
		ELSE
			V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' 
			(USU_ID,ENTIDAD_ID,USU_USERNAME,USU_PASSWORD,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USUARIOCREAR,FECHACREAR,USU_FECHA_VIGENCIA_PASS,USU_GRUPO,BORRADO)
	
			SELECT '||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL,
			1,
			'''||V_TMP_USU(1)||''',
			'''||V_TMP_USU(2)||''',
			'''||V_TMP_USU(3)||''',
			'''||V_TMP_USU(4)||''',
			'''||V_TMP_USU(5)||''',
			'''||V_USUARIOCREAR||''',
			SYSDATE,
			TO_DATE(''23/12/23'',''DD/MM/YYYY''),
			'''||V_TMP_USU(6)||''',
			0
			FROM DUAL			
			';			
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Usuario '''||V_TMP_USU(1)||''' insertado correctamente');		
		END IF;
	END LOOP;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: Los usuarios se han insertado correctamente en la tabla '||V_TABLA||'.');

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
EXIT
