--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160808
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columnas con marcas para Preciar/Repreciar y Descuento
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
   
    
    
BEGIN
	
	-- Comprobamos si existe columna ACT_FECHA_IND_PRECIADO (si es así, no hacemos nada)
	-- Es un indicador de activo PRECIADO (por primera vez). El indicador es una fecha del momento en que pasa a ser activo PRECIADO
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_FECHA_IND_PRECIADO'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	V_TEXT1 := 'Indicador de activo preciado por primera vez';
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_PRECIADO... Ya existe. No se hace nada.');
	ELSE
		-- Se crea la columna y se le agrega un comentario 
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (ACT_FECHA_IND_PRECIADO DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_PRECIADO IS '''||V_TEXT1||'''  ';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_PRECIADO... Creado');
		DBMS_OUTPUT.PUT_LINE('[INFO] ACT_FECHA_IND_PRECIADO: Es un indicador de activo listo para PRECIAR (por primera vez). El indicador es una fecha del momento en que es marcado porque reune las condiciones para ser preciado x 1a vez');
	END IF;
	

	-- Comprobamos si existe columna ACT_FECHA_IND_REPRECIAR (si es así, no hacemos nada)
	-- Indicador de activo repreciado.  El indicador se sobreescribe cada vez que el activo se REPRECIA. 
	-- El indicador es una fecha del momento en que pasa a ser activo REPRECIADO
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_FECHA_IND_REPRECIAR'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	V_TEXT1 := 'Indicador de activo repreciado';
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_REPRECIAR... Ya existe. No se hace nada.');
	ELSE
		-- Se crea la columna y se le agrega un comentario 
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (ACT_FECHA_IND_REPRECIAR DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_REPRECIAR IS '''||V_TEXT1||'''  ';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_REPRECIAR... Creado');
		DBMS_OUTPUT.PUT_LINE('[INFO] ACT_FECHA_IND_REPRECIAR: Es un indicador de activo listo para REPRECIAR. El indicador es una fecha del momento en que es marcado porque reune las condiciones para ser repreciado otra vez');
	END IF;


	-- Comprobamos si existe columna ACT_FECHA_IND_DESCUENTO (si es así, no hacemos nada)
	-- Indicador de activo con descuento vigente.  El indicador se sobreescribe cuando el descuento pasa a no vigente o aparece un nuevo descuento.
	-- El indicador es una fecha del momento en que aparece un nuevo precio DESCUENTO VIGENTE
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''ACT_FECHA_IND_DESCUENTO'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	V_TEXT1 := 'Indicador de activo con precio de descuento vigente';
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_DESCUENTO... Ya existe. No se hace nada.');
	ELSE
		-- Se crea la columna y se le agrega un comentario 
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (ACT_FECHA_IND_DESCUENTO DATE)';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_DESCUENTO IS '''||V_TEXT1||'''  ';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.ACT_FECHA_IND_DESCUENTO... Creado');
		DBMS_OUTPUT.PUT_LINE('[INFO] ACT_FECHA_IND_DESCUENTO: Es un indicador de activo con DESCUENTO VIGENTE. El indicador es una fecha del momento en que es marcado porque tiene uno o mas precios de descuento en periodo vigente');
	END IF;	
	


	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');


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