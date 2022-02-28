--/*
--##########################################
--## AUTOR=Adrián Molina Garrido
--## FECHA_CREACION=20210901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14935
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar valores de diccionario para dejar hueco a un insert en DML_00670
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TABLA VARCHAR2(2400 CHAR) := 'DD_MTO_MOTIVOS_OCULTACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14935';
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(50 CHAR);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		--Modificamos con orden descendente para que no sobrescribir los ya modificados
		T_TIPO_DATA('19', '20'),
		T_TIPO_DATA('18', '19'),
		T_TIPO_DATA('17', '18'),
		T_TIPO_DATA('16', '17'),
		T_TIPO_DATA('15', '16'),
		T_TIPO_DATA('14', '15')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	DBMS_OUTPUT.PUT_LINE('	[INFO]: Actualización de registros en '''||V_TABLA||'''.');
	
	--Comprobar la existencia de la tabla.
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM;
		
	IF V_NUM = 1 THEN
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			
			V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
				DD_MTO_ORDEN = '''||V_TMP_TIPO_DATA(2)||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''',
				FECHAMODIFICAR = SYSDATE
			WHERE DD_MTO_ORDEN = '''||V_TMP_TIPO_DATA(1)||'''
			';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('	[OK]: Actualizado DD_MTO_ORDEN = '''||V_TMP_TIPO_DATA(1)||''' con valor '''||V_TMP_TIPO_DATA(2)||'''.');
		END LOOP;
	ELSE
		DBMS_OUTPUT.PUT_LINE('	[ERROR]: La tabla no existe.');
	END IF;
	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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