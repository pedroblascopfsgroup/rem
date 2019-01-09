--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20181210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4996
--## PRODUCTO=NO
--## Finalidad: Modificar columna HIC_INCREMENTO_RENTA y ALQ_FECHA_INC_RENTA
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA1 VARCHAR2(2400 CHAR) := 'HIC_HISTO_CON'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_COLUMN VARCHAR2(500 CHAR):= 'Indicador del tipo de comercialización del activo.'; -- Vble. para el comentario de la columna.

BEGIN

	-- Comprobamos si existe columna ALQ_FECHA_INC_RENTA
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ALQ_FECHA_INC_RENTA'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ALQ_FECHA_INC_RENTA... Ya existe');
	ELSE
	
		-- Vacíamos los registros de la columna para que podamos modificarla
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET ALQ_FECHA_INC_RENTA = NULL ';
		EXECUTE IMMEDIATE V_MSQL;
			
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' MODIFY (ALQ_FECHA_INC_RENTA NUMBER(16,2))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ALQ_FECHA_INC_RENTA... Modificado');
	END IF;
	
	
	-- Comprobamos si existe columna HIC_INCREMENTO_RENTA
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''HIC_INCREMENTO_RENTA'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA1||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA1||'.HIC_INCREMENTO_RENTA... Ya existe');
	ELSE
		-- Vacíamos los registros de la columna para que podamos modificarla
		V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA1||' ';
		EXECUTE IMMEDIATE V_MSQL;
		
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA1||' MODIFY (HIC_INCREMENTO_RENTA NUMBER(16,2))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA1||'.HIC_INCREMENTO_RENTA... Modificado');
	END IF;
	
	
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
