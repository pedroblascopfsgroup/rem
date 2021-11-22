--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16085
--## PRODUCTO=NO
--##
--## Finalidad: Crear diccionario DD_LES_LISTADO_ERRORES_CAIXA           
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16085] - Alejandra García
--##########################################
--*/

--Para permitir la visualización de texto  en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_LES_LISTADO_ERRORES_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 

	V_MSQL := 'SELECT COUNT(*) FROM ALL_TABLES where owner = '''||V_ESQUEMA||''' and table_name = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
		(
			DD_LES_ID 				NUMBER(16,0) NOT NULL , 
			DD_LES_CODIGO 			VARCHAR2(32 BYTE) NOT NULL , 
			DD_RETORNO_CAIXA 		VARCHAR2(50 CHAR) NOT NULL , 
			DD_TEXT_MENSAJE_CAIXA 	VARCHAR2(300 CHAR) NOT NULL , 
			DD_EGA_ID 				NUMBER(16,0), 
			DD_EAH_ID 				NUMBER(16,0), 
			DD_EAP_ID 				NUMBER(16,0), 
			VERSION 				NUMBER(16,0) DEFAULT 0 NOT NULL , 
			USUARIOCREAR 			VARCHAR2(50 CHAR) NOT NULL , 
			FECHACREAR 				TIMESTAMP (6) NOT NULL , 
			USUARIOMODIFICAR 		VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 			TIMESTAMP (6), 
			USUARIOBORRAR 			VARCHAR2(50 CHAR), 
			FECHABORRAR 			TIMESTAMP (6), 
			BORRADO 				NUMBER(1,0) DEFAULT 0 NOT NULL 
		)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');

		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DD_LES_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

		--Creamos FKs
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_DD_EGA_ID_CAIXA FOREIGN KEY (DD_EGA_ID) REFERENCES '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO(DD_EGA_ID) ON DELETE SET NULL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EGA_ID_CAIXA... Foreign key creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_DD_EAH_ID_CAIXA FOREIGN KEY (DD_EAH_ID) REFERENCES '||V_ESQUEMA||'.DD_EAH_ESTADOS_AUTORIZ_HAYA(DD_EAH_ID) ON DELETE SET NULL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EAH_ID_CAIXA... Foreign key creada.');

		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_DD_EAP_ID_CAIXA FOREIGN KEY (DD_EAP_ID) REFERENCES '||V_ESQUEMA||'.DD_EAP_ESTADOS_AUTORIZ_PROP(DD_EAP_ID) ON DELETE SET NULL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_EAP_ID_CAIXA... Foreign key creada.');

		-- Comprobamos si existe la secuencia
		V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and sequence_owner = '''||V_ESQUEMA||'''';
			
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			-- Creamos sequence
			V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
			EXECUTE IMMEDIATE V_MSQL;		
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
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
