--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14760
--## PRODUCTO=NO
--## Finalidad:
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T017_RatificacionComiteCES''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
						 SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T017_RatificacionComiteCES''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_APRUEBA ? actualizarOfertaBoarding() : null''
						 , USUARIOMODIFICAR = ''HREOS-14760''
						 , FECHAMODIFICAR = SYSDATE
						 WHERE TAP_CODIGO = ''T017_RatificacionComiteCES''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
	COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');


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
