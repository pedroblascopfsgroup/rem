--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20161012
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Cambiar columna 'DD_MNC_ID' por 'PAC_MOT_EXCL_COMERCIALIZAR'.
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si existe la tabla.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... No Existe. No se puede continuar...');
	ELSE
		-- Comprobar si existe foreign key 'FK_PAC_MNC' para eliminarla.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= ''FK_PAC_MNC'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' DISABLE CONSTRAINT FK_PAC_MNC';
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' DROP CONSTRAINT FK_PAC_MNC';
			DBMS_OUTPUT.PUT_LINE('[INFO] FK_PAC_MNC eliminada');
		END IF;
		
		-- Eliminar la columna 'DD_MNC_ID'.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''DD_MNC_ID'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS =1 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' DROP COLUMN DD_MNC_ID';
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'.DD_MNC_ID eliminada');
		END IF;
		
		-- Crear la columna 'PAC_MOT_EXCL_COMERCIALIZAR'.
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLS WHERE COLUMN_NAME = ''PAC_MOT_EXCL_COMERCIALIZAR'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 0 THEN
			EXECUTE IMMEDIATE 'ALTER TABLE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' ADD PAC_MOT_EXCL_COMERCIALIZAR VARCHAR2(256 CHAR)';
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PAC_MOT_EXCL_COMERCIALIZAR IS ''Motivo de exclusión de comercializar''';
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'.PAC_MOT_EXCL_COMERCIALIZAR creada');
		END IF;
		
		DBMS_OUTPUT.PUT_LINE('[FIN]');
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

EXIT