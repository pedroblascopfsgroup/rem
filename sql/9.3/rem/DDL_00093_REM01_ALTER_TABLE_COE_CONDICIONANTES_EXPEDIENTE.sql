--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20201016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11719
--## PRODUCTO=NO
--## Finalidad: Editar tipo de campos en tablas
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(50 CHAR):= 'COE_CONDICIONANTES_EXPEDIENTE'; -- Nombre de la tabla

    --Tipos de campo
    V_TIPO_VARCHAR VARCHAR2(250 CHAR):= 'NUMBER(16, 0)';

    --Nombre de las columnas
    V_CAMPO VARCHAR2(50 CHAR):= 'ID_FINANCIACION_BOARDING';



BEGIN


	DBMS_OUTPUT.PUT_LINE('[INICIO ADD CAMPOS]');

	--Comprobacion de la tabla
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN

		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_CAMPO||'''';
    	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS < 1 THEN
			DBMS_OUTPUT.PUT_LINE('  [INFO] AÑADIMOS EL CAMPO '|| V_ESQUEMA ||'.'||V_TABLA||'.'||V_CAMPO||'');

			--Añadimos el campo
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_CAMPO||' '||V_TIPO_VARCHAR||'';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.'||V_CAMPO||' IS ''número identificador de la financiación boarding''';

 		ELSE
			DBMS_OUTPUT.PUT_LINE('  [INFO] EL CAMPO '|| V_ESQUEMA ||'.'||V_TABLA||'.'||V_CAMPO||' YA EXISTE!');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE(' [INFO] '''||V_TABLA||'''... No existe.');
	END IF;


  DBMS_OUTPUT.PUT_LINE('[FIN ADD CAMPOS]');

  COMMIT;


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------');
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;
END;

/

EXIT;
