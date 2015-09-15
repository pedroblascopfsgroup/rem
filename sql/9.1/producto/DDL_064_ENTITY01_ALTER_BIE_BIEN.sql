--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20150911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=CMREC-695
--## PRODUCTO=SI
--## Finalidad: DDL
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
  	V_MSQL       VARCHAR2(32000 CHAR);                     -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
  	V_SQL        VARCHAR2(4000 CHAR);                      -- Vble. para consulta que valida la existencia de una tabla.
  	V_NUM_TABLAS NUMBER(16);                               -- Vble. para validar la existencia de una tabla.
  	ERR_NUM      NUMBER(25);                               -- Vble. auxiliar para registrar errores en el script.
  	ERR_MSG      VARCHAR2(1024 CHAR);                      -- Vble. auxiliar para registrar errores en el script.
  	V_TEXT1      VARCHAR2(2400 CHAR);                      -- Vble. auxiliar
BEGIN
  -- ******** BIE_BIEN - Añadir campos *******
  DBMS_OUTPUT.PUT_LINE('******** BIE_BIEN - Añadir campos *******');
  V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and column_name = ''NUM_DOMICILIO''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  -- Si existe el campo lo indicamos sino lo creamos
  IF V_NUM_TABLAS = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... El campo ya existe en la tabla');
  ELSE
    V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_BIEN add(NUM_DOMICILIO VARCHAR2(10))';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Añadido el campo NUM_DOMICILIO');
  END IF;
  V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and column_name = ''CHAR_EXTRA2''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  -- Si existe el campo lo indicamos sino lo creamos
  IF V_NUM_TABLAS = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... El campo ya existe en la tabla');
  ELSE
    V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_BIEN add(CHAR_EXTRA2 VARCHAR2(50))';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Añadido el campo CHAR_EXTRA2');
  END IF;
  V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and column_name = ''CHAR_EXTRA3''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  -- Si existe el campo lo indicamos sino lo creamos
  IF V_NUM_TABLAS = 1 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... El campo ya existe en la tabla');
  ELSE
    V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_BIEN add(CHAR_EXTRA3 VARCHAR2(50))';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Añadido el campo CHAR_EXTRA3');
  END IF;
  DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');
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