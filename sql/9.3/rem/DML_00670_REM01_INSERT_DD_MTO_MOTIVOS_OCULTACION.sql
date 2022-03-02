--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20210901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14935
--## PRODUCTO=NO
--##
--## Finalidad: Insertar registro de diccionario en DD_MTO_MOTIVOS_OCULTACION
--## INSTRUCCIONES: 
--## VERSIONES:
--## 		0.1 HREOS-10108 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para ejecutar sentencias.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TABLA VARCHAR2(100 CHAR) := 'DD_MTO_MOTIVOS_OCULTACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14935';
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(100 CHAR);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('20', 'Reservado alquiler', 'Reservado alquiler', '3', '0', '14')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('	[INFO]: Inserción de registro en '''||V_TABLA||'''.');
	
	--Comprobar la existencia de la tabla.
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
	
	IF V_NUM = 1 THEN
		V_TMP_TIPO_DATA := V_TIPO_DATA(1);
		
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			DD_MTO_ID,
			DD_MTO_CODIGO,
			DD_MTO_DESCRIPCION,
			DD_MTO_DESCRIPCION_LARGA,
			DD_TCO_ID,
			DD_MTO_MANUAL,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO,
			DD_MTO_ORDEN
		) 
		VALUES (
			'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
			'''||V_TMP_TIPO_DATA(1)||''',
			'''||V_TMP_TIPO_DATA(2)||''',
			'''||V_TMP_TIPO_DATA(3)||''',
			TO_NUMBER('''||V_TMP_TIPO_DATA(4)||'''),
			TO_NUMBER('''||V_TMP_TIPO_DATA(5)||'''),
			0,
			'''||V_USUARIO||''',
			SYSDATE,
			0,
			TO_NUMBER('''||V_TMP_TIPO_DATA(6)||''')
		)';
		--DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('	[OK]: Registro insertado.');
	END IF;

	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN]');

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