--/*
--##########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20190824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7358
--## PRODUCTO=NO
--## Finalidad: Añadir la columna de la matrícula.
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TDT_TIPO_DOC_TRIBUTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.  
    
BEGIN

	-- Comprobamos si existe columna DD_TDT_MATRICULA_GD 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TDT_VINCULABLE'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDT_VINCULABLE... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD(DD_TDT_VINCULABLE NUMBER(1,0) DEFAULT 0 NOT NULL)';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDT_VINCULABLE... Creado');
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DD_TDT_TIPO_DOC_TRIBUTOS.DD_TDT_VINCULABLE  is ''Documento vinculable al activo''  ';
	END IF;
	
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TDT_TPD_ID'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDT_TPD_ID... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD(DD_TDT_TPD_ID NUMBER(16,0))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDT_TPD_ID... Creado');
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DD_TDT_TIPO_DOC_TRIBUTOS.DD_TDT_TPD_ID  is ''Relación con documento vinculable''  ';
		EXECUTE IMMEDIATE ('ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_TDT_TPD_ID FOREIGN KEY (DD_TDT_TPD_ID) REFERENCES '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO (DD_TPD_ID)) ');
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

EXIT;
