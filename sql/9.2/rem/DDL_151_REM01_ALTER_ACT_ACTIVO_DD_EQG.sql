--/*
--##########################################
--## AUTOR=MIGUEL LOPEZ
--## FECHA_CREACION=20190821
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7397
--## PRODUCTO=NO
--## Finalidad: Añadir columnas DD_EQG_ID en tabla ACT_ACTIVO.
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
    V_COMMENT_COLUMN VARCHAR2(500 CHAR):= 'Codigo identificador de la tabla DD_EQG_EQUIPO_GESTION.'; -- Vble. para los comentarios de las tablas
    V_COLUMN VARCHAR2(500 CHAR) := 'DD_EQG_ID'; --Nombre de la columna
    V_FK VARCHAR2(500 CHAR) := 'FK_ACTIVO_EQG'; --Nombre de la FK
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_EQG_EQUIPO_GESTION'; --Nombre de la tabla

    
BEGIN

  	-- Comprobamos si existe columna DD_EQG_ID
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_COLUMN||''' and DATA_TYPE = ''NUMBER'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  	
  	IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN||'... Ya existe');
  	ELSE
	  	--  Creamos la columna
	    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD ('||V_COLUMN||' NUMBER(16))'; 
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN||'... Creado');
	  	
	  	-- Creamos comentario	
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_COLUMN||' IS '''||V_COMMENT_COLUMN||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario en columna creado.');

  	END IF;
  
  
  	--Comprobamos si existe foreign key FK_ACTIVO_EQUIPO_GESTION
  	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME= '''||V_FK||''' and TABLE_NAME='''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
  	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
  
  	IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_FK||'... Ya existe. No hacemos nada.');    
  	ELSE
   	 -- Creamos foreign key FK_ACTIVO_EQUIPO_GESTION
    	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_FK||' FOREIGN KEY ('||V_COLUMN||') REFERENCES '||V_ESQUEMA||'.'||V_TABLA||' ('||V_COLUMN||') ON DELETE SET NULL)';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_FK||'... Foreign key creada.');
  	END IF;
  
  	EXCEPTION
       	WHEN OTHERS THEN
        	err_num := SQLCODE;
            err_msg := SQLERRM;
  
            DBMS_OUTPUT.PUT_LINE('KO!');
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
            DBMS_OUTPUT.put_line(err_msg);
  
            ROLLBACK;
            RAISE;          

END;

/

EXIT