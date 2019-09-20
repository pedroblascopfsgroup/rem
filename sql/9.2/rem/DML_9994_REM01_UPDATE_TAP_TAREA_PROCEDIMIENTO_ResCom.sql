--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190920
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7708
--## PRODUCTO=NO
--##
--## Finalidad: update TAP_TAREA_PROCEDIMIENTO 'T013_ResolucionComite' TAP_SCRIPT_VALIDACION
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_COUNT NUMBER(3); -- Vble. para validar la existencia de las Tablas.

	V_ITEM VARCHAR2(50 CHAR) := 'HREOS-7708';
	V_TABLA VARCHAR(100 CHAR) := 'TAP_TAREA_PROCEDIMIENTO';
	V_TAP_CODIGO VARCHAR(100 CHAR) := 'T013_ResolucionComite';

	V_TAP_SCRIPT_VALIDACION VARCHAR(1000 CHAR) := 'checkImporteParticipacion() ? (checkCompradores() ? (!checkVendido() ? (checkComercializable() ? (checkPoliticaCorporativa() ? (checkLiberbank() ? (!isOfertaDependiente() ? null : ''''La sanci&oacute;n de las ofertas agrupadas se realiza desde su oferta agrupada principal.'''' ) : null) : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') :  ''''El activo est&aacute; vendido'''') : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''';

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO');
	DBMS_OUTPUT.PUT_LINE('[INFO] 	Comprobando registro para actualizar...');

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = '''||V_TAP_CODIGO||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

	IF V_COUNT = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] 	Actualizando registro...');
		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
			TAP_SCRIPT_VALIDACION = '''||V_TAP_SCRIPT_VALIDACION||''', 
			USUARIOMODIFICAR = '''||V_ITEM||''',
			FECHAMODIFICAR = SYSDATE 
			WHERE TAP_CODIGO = '''||V_TAP_CODIGO||'''';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] 	No existe el registro solicitado.');
	END IF;

	COMMIT;
	--ROLLBACK;

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
