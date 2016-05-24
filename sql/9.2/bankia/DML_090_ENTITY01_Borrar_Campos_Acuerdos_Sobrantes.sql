--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20160524
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1271
--## PRODUCTO=NO
--##
--## Finalidad: Campos y tipos de termino acuerdo para Asuntos (corregir el funcional con los comentarios de Ramon Carbajo)
--## INSTRUCCIONES:
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


	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos los campos Solicitante informe');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''informeSolicitante''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campos Solicitante informe borrados OK');

	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos los campos Valoracion para las Cargas Posteriores/Anteriores');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''valoracionCargas''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campos Valoración para las Cargas Posteriores/Anteriores borrados OK.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos los campos Descripción para las Cargas Posteriores/Anteriores');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''descripcionCargas''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campos Descripción para las Cargas Posteriores/Anteriores borrados OK.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos los campos Valoración para Otros Bienes/Solvencia');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''valoracionBienesSolvencia''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campos Valoración para Otros Bienes/Solvencia borrados OK.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos los campos Descripción para Otros Bienes/Solvencia');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''descripcionBienesSolvencia''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campos Descripción para Otros Bienes/Solvencia borrados OK.');

	COMMIT;


	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');
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
