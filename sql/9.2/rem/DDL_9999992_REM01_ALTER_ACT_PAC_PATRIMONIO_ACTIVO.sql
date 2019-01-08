--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20181217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2850
--## PRODUCTO=NO
--## Finalidad: Añadir columna DD_ADA_ID_ANTERIOR en tabla ACT_PTA_PATRIMONIO_ACTIVO.
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
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_PTA_PATRIMONIO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_COLUMN VARCHAR2(500 CHAR):= 'Código identificador único del diccionario de adecuación alquiler anterior.'; -- Vble. para el comentario de la columna.

BEGIN

	-- Comprobamos si existe columna DD_ADA_ID_ANTERIOR
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_ADA_ID_ANTERIOR'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.DD_ADA_ID_ANTERIOR... Ya existe');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (DD_ADA_ID_ANTERIOR NUMBER(16))';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.DD_ADA_ID_ANTERIOR... Creado');
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_ADA_ID_ANTERIOR IS '''||V_COMMENT_COLUMN||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario en columna creado.');
	END IF;
	
	
	--Comprobamos si existe foreign key FK_PTA_DD_ADA_ANTERIOR
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_PTA_DD_ADA_ANTERIOR'' and TABLE_NAME='''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.FK_PTA_DD_ADA_ANTERIOR... Ya existe.');		
	ELSE
		-- Creamos foreign key FK_PTA_DD_ADA_ANTERIOR
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_PTA_DD_ADA_ANTERIOR FOREIGN KEY (DD_ADA_ID_ANTERIOR) REFERENCES '||V_ESQUEMA||'.DD_ADA_ADECUACION_ALQUILER (DD_ADA_ID) ON DELETE SET NULL)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PTA_DD_ADA_ANTERIOR... Foreign key creada.');
	END IF;

	
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

EXIT