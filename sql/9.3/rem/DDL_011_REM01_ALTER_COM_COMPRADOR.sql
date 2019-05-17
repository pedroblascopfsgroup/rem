--/*
--##########################################
--## AUTOR=Sergio Beleña
--## FECHA_CREACION=20190418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columnas Estado civil,Reg. Económico matrimonial,Nº URSUS cónyuge,Problemas para la venta
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'COM_COMPRADOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.  
    
BEGIN

	-- Comprobamos si existe columna DD_ECV_ID_URSUS 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_ECV_ID_URSUS'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ECV_ID_URSUS... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (DD_ECV_ID_URSUS NUMBER(16))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_ECV_ID_URSUS... Creado');
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COM_COMPRADOR.DD_ECV_ID_URSUS  is ''Estado civil''  ';
	END IF;
	
	
	--Comprobamos si existe foreign key FK_COMPRADOR_DDECV_URSUS
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_COMPRADOR_DDECV_URSUS'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FK_COMPRADOR_DDECV_URSUS... Ya existe. No hacemos nada.');		
	ELSE
		-- Creamos foreign key FK_COMPRADOR_DDECV_URSUS
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COMPRADOR_DDECV_URSUS FOREIGN KEY (DD_ECV_ID_URSUS) REFERENCES '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES (DD_ECV_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COMPRADOR_DDECV_URSUS... Foreign key creada.');
	END IF;
	
	
		-- Comprobamos si existe columna DD_REM_ID_URSUS
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_REM_ID_URSUS'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_REM_ID_URSUS... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (DD_REM_ID_URSUS NUMBER(16))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_REM_ID_URSUS... Creado');
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COM_COMPRADOR.DD_REM_ID_URSUS  is ''Reg. Económico matrimonial''  ';
	END IF;
	
	
	--Comprobamos si existe foreign key FK_COMPRADOR_REMURSUS
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_COMPRADOR_REMURSUS'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FK_COMPRADOR_REMURSUS... Ya existe. No hacemos nada.');		
	ELSE
		-- Creamos foreign key FK_COMPRADOR_DDREM
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COMPRADOR_REMURSUS FOREIGN KEY (DD_REM_ID_URSUS) REFERENCES '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES (DD_REM_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COMPRADOR_REMURSUS... Foreign key creada.');
	END IF;


		-- Comprobamos si existe columna PROBLEMAS_URSUS
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''PROBLEMAS_URSUS'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PROBLEMAS_URSUS... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (PROBLEMAS_URSUS NUMBER(1,0))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PROBLEMAS_URSUS... Creado');
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COM_COMPRADOR.PROBLEMAS_URSUS  is ''Problemas para la venta''  ';
	END IF;

		-- Comprobamos si existe columna N_URSUS_CONYUGE

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''N_URSUS_CONYUGE'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.N_URSUS_CONYUGE... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (N_URSUS_CONYUGE NUMBER(16))';	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.N_URSUS_CONYUGE... Creado');

	EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.COM_COMPRADOR.N_URSUS_CONYUGE  is ''Nº URSUS cónyuge''  ';

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
