--/*
--##########################################
--## AUTOR=Javier Urban
--## FECHA_CREACION=20200918
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11059
--## PRODUCTO=NO
--## Finalidad: Añadir la columna GAA_NUM_GASTO_ASOCIADO
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
	V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_NUM_TABLAS NUMBER(25);
	
	V_TABLA VARCHAR2(50 CHAR) := 'GAA_GASTO_ASOCIADO_ADQ';
	V_COLUMN VARCHAR2(50 CHAR) := 'GAA_NUM_GASTO_ASOCIADO';
	V_COLUMN2 VARCHAR2(50 CHAR) := 'GAA_FACTURA';
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
  	IF V_NUM_TABLAS > 0 THEN
  		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
            
       	IF V_NUM_TABLAS = 0 THEN
       		-- Añadimos la columna
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_COLUMN||' NUMBER(16,0) UNIQUE';
            
	  		-- Añadimos el comentario
            EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_COLUMN||' IS ''Identificador unico gasto asociado''';
            
            DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '||V_TABLA||'.'||V_COLUMN||' creada.');
            
		ELSE
			DBMS_OUTPUT.PUT_LINE('	[INFO] La columna '||V_TABLA||'.'||V_COLUMN||' ya existe.');
			
		END IF;
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('	[INFO] La tabla '||V_TABLA||' no existe.');
		
	END IF;

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||V_COLUMN2||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS <> 0 THEN
			DBMS_OUTPUT.PUT_LINE('HE ENTRADO 1-----');
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA|| ' DROP COLUMN ' ||V_COLUMN2||'';
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');
		ELSE
			DBMS_OUTPUT.PUT_LINE('	HE ENTRADO 1-----');
		END IF;

	-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 0 THEN
				
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
		    EXECUTE IMMEDIATE V_MSQL;		
		    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');

		END IF;
	
	COMMIT;
  	DBMS_OUTPUT.PUT_LINE('[FIN]');
  	
EXCEPTION
	WHEN OTHERS THEN
		ERR_NUM := SQLCODE;
		ERR_MSG := SQLERRM;
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(ERR_NUM));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(ERR_MSG);
		ROLLBACK;
		RAISE;   
END;
/
EXIT;