--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20160627
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.5
--## INCIDENCIA_LINK=RECOVERY-2204
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
	DBMS_OUTPUT.PUT_LINE('[INFO] Borramos el campo Cargas Posteriores de la Dacion');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACU_CAMPOS_TIPO_ACUERDO SET BORRADO = 1, USUARIOBORRAR = ''RECOVERY-2204'', FECHABORRAR = SYSDATE
			WHERE CMP_NOMBRE_CAMPO=''cargasPosteriores'' AND DD_TPA_ID = (SELECT DD_TPA_ID FROM '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO WHERE DD_TPA_CODIGO = ''01'')';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Campo Cargas Posteriores de la Dacion borrado OK');

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
