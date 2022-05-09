--/*
--##########################################
--## AUTOR=JJM
--## FECHA_CREACION=20210504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11577
--## PRODUCTO=NO
--##
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-11577'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16);

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMNA ECO_NUM_CONTRATO_ANT');

	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''ECO_NUM_CONTRATO_ANT''
				AND TABLE_NAME = ''ECO_EXPEDIENTE_COMERCIAL''';

	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;

	IF V_NUM_FILAS = 0 THEN

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ADD ECO_NUM_CONTRATO_ANT VARCHAR2(20 CHAR)';

		EXECUTE IMMEDIATE V_MSQL;

		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL.ECO_NUM_CONTRATO_ANT IS ''Numero contrato anterior para renovacion.''';


		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');

	END IF;

    	DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMNA ECO_FECHA_FIN_CONTRATO_ANT');

    	V_SQL := 'SELECT COUNT(*)
    				FROM USER_TAB_COLS
    				WHERE COLUMN_NAME = ''ECO_FECHA_FIN_CONTRATO_ANT''
    				AND TABLE_NAME = ''ECO_EXPEDIENTE_COMERCIAL''';

    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;

    	IF V_NUM_FILAS = 0 THEN

    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ADD ECO_FECHA_FIN_CONTRATO_ANT DATE';

    		EXECUTE IMMEDIATE V_MSQL;

    		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL.ECO_FECHA_FIN_CONTRATO_ANT IS ''Fecha fin de contrato anterior''';

    		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');

    	ELSE

    		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');

    	END IF;

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