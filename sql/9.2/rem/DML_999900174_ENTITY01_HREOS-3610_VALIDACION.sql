--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.35
--## INCIDENCIA_LINK=HREOS-3610
--## PRODUCTO=SI
--## Finalidad: Poner a 'false' el campo TFI_VALIDACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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

	VN_COUNT NUMBER;
	V_TABLENAME VARCHAR2(35 CHAR):= 'TFI_TAREAS_FORM_ITEMS'; 
	V_COLNAME VARCHAR2(25 CHAR):= '"TFI_VALIDACION"';
	V_VALOR VARCHAR2(25 CHAR):= 'false';
	V_INCIDENCIALINK VARCHAR(35 CHAR):='HREOS-3610';
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
	V_TYPE_COL VARCHAR2(50 CHAR):= 'NUMBER(16)';
	V_DESCRIPCION_COL VARCHAR2(200 CHAR):='Perfil que debería completar la regla de elevación';

	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas');

	V_MSQL := 'SELECT COUNT(1) 
    FROM '||V_ESQUEMA||'.'||V_TABLENAME||' WHERE TFI_NOMBRE = ''comboRespuesta'' 
    AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_RespuestaOfertante'') 
    AND '||V_COLNAME||' = ''false''';

	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya tiene el valor que se pretende');
	ELSE
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLENAME||' SET USUARIOMODIFICAR = ''HREOS-3610'', FECHAMODIFICAR = SYSDATE, '||V_COLNAME||' = ''false'' WHERE TFI_NOMBRE = ''comboRespuesta''
	AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_RespuestaOfertante'')';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el valor del campo '||V_COLNAME||' de la tabla '||V_TABLENAME||' con el valor '||V_VALOR);

	END IF;

COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Terminadas las tareas del ticket '||V_INCIDENCIALINK);

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

	

	
