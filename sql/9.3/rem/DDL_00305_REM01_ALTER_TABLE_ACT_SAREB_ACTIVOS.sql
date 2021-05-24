--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13560
--## PRODUCTO=NO
--## Finalidad: Añadir DEFAULT AL CAMPOS
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_SAREB_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_COLUMNA VARCHAR2(2400 CHAR) := 'GGAA';
	V_TEXT_TIPO_COLUMNA VARCHAR2(2400 CHAR) := 'NUMBER(16,0)';
	V_ID_SINO NUMBER:= 0;

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');

-- Verificar si la tabla ya existe
V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' AND COLUMN_NAME = '''||V_TEXT_COLUMNA||''' AND DATA_DEFAULT IS NULL';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
IF V_NUM_TABLAS = 1 THEN
    V_MSQL := 'SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02''';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_SINO;
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'.'||V_TEXT_COLUMNA||'...');
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY '||V_TEXT_COLUMNA||' '||V_TEXT_TIPO_COLUMNA||' DEFAULT '||V_ID_SINO||'';  
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_COLUMNA||'... Columna creada.');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET '||V_TEXT_COLUMNA||' = '||V_ID_SINO||' WHERE '||V_TEXT_COLUMNA||' IS NULL';  
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TEXT_COLUMNA||'... Columna actualizada.');
ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'.'||V_TEXT_COLUMNA||'... Ya existe.');
END IF;

COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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

