--/*
--##########################################
--## AUTOR=Alberto Flores
--## FECHA_CREACION=20191216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8735
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade un registro para el diccionario DD_UPO_UNID_POBLACIONAL
--## VERSIONES:
--## 	0.1 Versión inicial
--## 	0.2 HREOS-8735 Script que añade un registro para el diccionario DD_UPO_UNID_POBLACIONAL
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

	V_TABLA VARCHAR2(30 CHAR) := 'DD_UPO_UNID_POBLACIONAL';
	V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-8735';
	V_NUM NUMBER(16,0);
	V_CODIGO VARCHAR (50 CHAR) := '00000'; -- Código de la unidad poblacional
	V_LOC NUMBER(16,0) := '8121'; -- Código de la localidad 'No disponible'
	V_DESC VARCHAR2(100 CHAR) := 'No definido'; -- Descripción de la unidad poblacional

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE DD_UPO_CODIGO = '''||V_CODIGO||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

	IF V_NUM > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||' SET 
			DD_LOC_ID = '||V_LOC||',
			DD_UPO_CODIGO = '''||V_CODIGO||''',
			DD_UPO_DESCRIPCION = '''||V_DESC||''',
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE
			WHERE DD_UPO_CODIGO = '''||V_CODIGO||'''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] REGISTRO MODIFICADO CORRECTAMENTE');
		COMMIT;
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (
			DD_UPO_ID,
			DD_LOC_ID,
			DD_UPO_CODIGO,
			DD_UPO_DESCRIPCION,
			DD_UPO_DESCRIPCION_LARGA,
			USUARIOCREAR,
			FECHACREAR
		)
		SELECT
			'||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL,
			'||V_LOC||',
			'''||V_CODIGO||''',
			'''||V_DESC||''',
			'''||V_DESC||''',
			'''||V_USUARIO||''',
			SYSDATE
		FROM DUAL
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('	[INFO] REGISTRO INSERTADO CORRECTAMENTE');
		COMMIT;
	END IF;
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
