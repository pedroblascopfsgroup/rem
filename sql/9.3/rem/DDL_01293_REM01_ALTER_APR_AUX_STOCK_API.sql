--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18817
--## PRODUCTO=NO
--## Finalidad: Añadir nueva columna EMAIL en la tabla APR_AUX_STOCK_API.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_API'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref
    V_COLUMN_NAME VARCHAR2(50):= 'EMAIL'; -- Vble. para el nombre de las columnas.
    
BEGIN
	-- Comprobar si existe la columna TAS_ILOCALIZABLE.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN_NAME||''' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Ya existe. Se continua.');
	ELSE
		-- Se crea la columna y se le agrega un comentario.
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN_NAME||' VARCHAR2(50 CHAR))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN_NAME||'... Creada');
	END IF;
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin');

	EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;          

END;

/

EXIT
