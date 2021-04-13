--/*
--##########################################
--## AUTOR= Lara Pablo FLores
--## FECHA_CREACION=20210327
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11552
--## PRODUCTO=NO
--## Finalidad: Creación tabla ACT_DDQ_DATOS_DQ
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_DDQ_DATOS_DQ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla de Datos DQ'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		
	   V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_DQ_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
		-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_DQ_DATOS_DQ FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO(ACT_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_DQ_DATOS_DQ... FK creada.');
		END IF;
			
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_TPA_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
		-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_TPA_DATOS_DQ FOREIGN KEY (DD_TPA_ID) REFERENCES '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO(DD_TPA_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_TPA_DATOS_DQ... FK creada.');
		END IF;

		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_STA_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
		-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_STA_DATOS_DQ FOREIGN KEY (DD_STA_ID) REFERENCES '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO(DD_STA_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_STA_DATOS_DQ... FK creada.');
		END IF;
		
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_TUD_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
		-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_TUD_DATOS_DQ FOREIGN KEY (DD_TUD_ID) REFERENCES '||V_ESQUEMA||'.DD_TUD_TIPO_USO_DESTINO(DD_TUD_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_TUD_DATOS_DQ... FK creada.');
		END IF;
		
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_LOC_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
			-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_LOC_DATOS_DQ FOREIGN KEY (DD_LOC_ID) REFERENCES '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD(DD_LOC_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_LOC_DATOS_DQ... FK creada.');
		END IF;

		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_LOC_REG_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
		-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_LOC_REG_DATOS_DQ FOREIGN KEY (DD_LOC_ID_REG) REFERENCES '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD(DD_LOC_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_LOC_REG_DATOS_DQ... FK creada.');
		END IF;
		
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_PRV_REG_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
        	-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_PRV_REG_DATOS_DQ FOREIGN KEY (DD_PRV_ID_REG) REFERENCES '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA(DD_PRV_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_PRV_REG_DATOS_DQ... FK creada.');
		END IF;
		
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_TVI_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
        	-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_TVI_DATOS_DQ FOREIGN KEY (DD_TVI_ID) REFERENCES '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA(DD_TVI_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_TVI_DATOS_DQ... FK creada.');
		END IF;
		
		V_MSQL := 'select count(1) from all_constraints where OWNER = '''||V_ESQUEMA||''' and table_name = '''||V_TEXT_TABLA||''' and constraint_name = ''FK_PRV_DATOS_DQ''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
		IF V_NUM_TABLAS = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[NO Hacemos nada Existe FK]');
        ELSE
			-- Creamos FK constraint
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT FK_PRV_DATOS_DQ FOREIGN KEY (DD_PRV_ID) REFERENCES '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA(DD_PRV_ID)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]  FK_PRV_DATOS_DQ... FK creada.');
		END IF;
		

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

EXIT;