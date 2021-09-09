--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14860
--## PRODUCTO=NO
--## Finalidad: Creacion AUX_OFR_ENTIDAD_ORIGEN, modificacion de la OFR_OFERTAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
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
    V_TABLA VARCHAR2(2400 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_OFR_ENTIDAD_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla auxiliar.
    V_TABLA_DD VARCHAR2(2400 CHAR) := 'DD_SOR_SISTEMA_ORIGEN'; -- Vble. auxiliar para almacenar el nombre de la tabla diccionario.
    
    V_OFR_ID NUMBER(16); -- Vble. que almacena el id de la oferta.
    V_OFR_ENTIDAD VARCHAR(10 CHAR); -- Vble. que almacena el nombre de la entidad origen.
    
    CURSOR ENTIDAD_OFERTA IS SELECT OFR_ID, OFR_ORIGEN FROM #ESQUEMA#.OFR_OFERTAS WHERE OFR_ORIGEN in ('REM', 'WCOM');
    
BEGIN
    
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_AUX||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA_AUX||'... Ya existe. Procedemos a borrarla.');
		V_MSQL := 'DROP TABLE ' ||V_ESQUEMA||'.'||V_TABLA_AUX||'';
            	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA_AUX||'... Tabla borrada.');
    	END IF;
    	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA_AUX||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA_AUX||'
	    (
		OFR_ID                      NUMBER(16,0)
		,OFR_ENTIDAD_ORIGEN         VARCHAR2(10 CHAR)
	    )
	    LOGGING 
	    NOCOMPRESS 
	    NOCACHE
	    NOPARALLEL
	    NOMONITORING
	    ';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA_AUX||'... Tabla creada.');
	        
	-- Insertamos los valores en la tabla auxiliar mientras vamos dejando a null cada campo que ya hemos insertado
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA_AUX||'] ');
	FOR ENTOFR IN ENTIDAD_OFERTA LOOP
	
		V_OFR_ID:=ENTOFR.OFR_ID;   
		V_OFR_ENTIDAD:=ENTOFR.OFR_ORIGEN;
    		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_AUX||' (OFR_ID, OFR_ENTIDAD_ORIGEN) VALUES ('||V_OFR_ID||', '''||V_OFR_ENTIDAD||''')';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET OFR_ORIGEN = NULL WHERE OFR_ID = '||V_OFR_ID||'';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA_AUX||' insertados correctamente.');
	      
    	END LOOP;
    	
    	-- Cambiar el DATA_TYPE
    	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||''' and column_name = ''OFR_ORIGEN''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la columna OFR_ORIGEN en la tabla '||V_ESQUEMA||'.'||V_TABLA||'... no se modifica nada.');
	ELSE
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'' ||
			  ' MODIFY OFR_ORIGEN NUMBER(16,0)';
	    	
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
    	
    	-- Añadiendo FK
    	DBMS_OUTPUT.PUT_LINE('[ADD_CONSTRAINT FK_OFR_ORIGEN]');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TABLA||''' AND CONSTRAINT_NAME = ''FK_OFR_ORIGEN''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 0 THEN
	    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo FK FK_OFR_ORIGEN');  
	    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_OFR_ORIGEN FOREIGN KEY(OFR_ORIGEN) REFERENCES '||V_TABLA_DD||'(DD_SOR_ID)';
	ELSE
	    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción FK_OFR_ORIGEN ya existe.');
	END IF;  
	
	-- Añadiendo comentario en la columna
	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.OFR_ORIGEN IS ''Identificador único del diccionario de Sistema Origen''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna OFR_ORIGEN creado.'); 
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado correctamente');

    COMMIT;


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
EXIT;
