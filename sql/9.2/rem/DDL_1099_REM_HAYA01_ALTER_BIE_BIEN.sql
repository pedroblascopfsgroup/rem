--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20151210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columna BIE_CODIGO_BIEN a tabla BIE_BIEN
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
 	table_count number(3); -- Vble. para validar la existencia de las Tablas.
 	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN
	
	-- Comprobamos si existe columna BIE_CODIGO_BIEN
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''BIE_CODIGO_BIEN'' and DATA_TYPE = ''VARCHAR2'' and TABLE_NAME=''BIE_BIEN'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN.BIE_CODIGO_BIEN... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD (BIE_CODIGO_BIEN VARCHAR2(50 CHAR))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN.BIE_CODIGO_BIEN... Creado');
	END IF;
	
	
	-- Comprobamos si existe columna BIE_NUMERO_ACTIVO
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''BIE_NUMERO_ACTIVO'' and DATA_TYPE = ''VARCHAR2'' and TABLE_NAME=''BIE_BIEN'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN.BIE_NUMERO_ACTIVO... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD (BIE_NUMERO_ACTIVO VARCHAR2(50 CHAR))';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN.BIE_NUMERO_ACTIVO... Creado');
	END IF;
	
	
	-- Comprobamos si existe el indice sobre BIE_NUMERO_ACTIVO
	--V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME= ''BIE_NUMERO_ACTIVO_IDX'' and TABLE_NAME=''BIE_BIEN'' and owner = '''||V_ESQUEMA||'''';
	--EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	--IF table_count = 1 THEN
		--DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN.BIE_NUMERO_ACTIVO_IDX... Ya existe');
	--ELSE
		--V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.BIE_NUMERO_ACTIVO_IDX ON '||V_ESQUEMA|| '.BIE_BIEN(BIE_NUMERO_ACTIVO) TABLESPACE '||V_TABLESPACE_IDX;			
		--EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.BIE_NUMERO_ACTIVO_IDX... Indice creado.');
	--END IF;
	
	
	
	
	-- Creamos indice	
	
	
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

EXIT