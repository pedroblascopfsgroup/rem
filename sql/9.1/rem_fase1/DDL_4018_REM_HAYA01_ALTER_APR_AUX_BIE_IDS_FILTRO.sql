--/*
--##########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Modificar el nombre de la columna BIE_NUMERO_ACTIVO a NUMERO_ACTIVO en la tabla APR_AUX_BIE_IDS_FILTRO.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_BIE_IDS_FILTRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
BEGIN
	
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
  
  	-- Comprobamos si existe la columna BIE_NUMERO_ACTIVO
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''BIE_NUMERO_ACTIVO'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BIE_NUMERO_ACTIVO... Existe');
		
		-- Eliminamos la PK e índice correspondientes a BIE_NUMERO_ACTIVO
	    DBMS_OUTPUT.PUT_LINE('[INFO] Se va a eliminar la PK y su correspondiente índice de '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BIE_NUMERO_ACTIVO');    
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' DROP PRIMARY KEY DROP INDEX';
	    DBMS_OUTPUT.PUT_LINE('[INFO] PK e índice de '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Eliminados'); 
	    
	    -- Cambiamos el campo BIE_NUMERO_ACTIVO a NUMERO_ACTIVO
	    DBMS_OUTPUT.PUT_LINE('[INFO] Modificamos el nombre de  '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BIE_NUMERO_ACTIVO a NUMERO_ACTIVO');  
	    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' RENAME COLUMN BIE_NUMERO_ACTIVO TO NUMERO_ACTIVO';
	    
    
	   	-- Creamos indice	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(NUMERO_ACTIVO) TABLESPACE '||V_TABLESPACE_IDX;			
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_IDX... Indice creado.');
	
	
		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (NUMERO_ACTIVO) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');

	ELSE
  
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BIE_NUMERO_ACTIVO... Ya no existe. Ahora la PK es NUMERO_ACTIVO');
    
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
