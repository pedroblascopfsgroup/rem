--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201024
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11745
--## PRODUCTO=NO
--## Finalidad: Creación diccionario ACT_CONFIG_CTAS_CONTABLES
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla en la que se almacenaran las configuraciones de las cuentas contables que corresponden a los importes de tasas, recargas e intereses de un gasto'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PURGE';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;

	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
	    "CCC_CTAS_ID"             NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "CCC_CUENTA_CONTABLE"     VARCHAR2(50 CHAR)
	        NOT NULL ENABLE
	    , "DD_TGA_ID"               NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DD_STG_ID"               NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DD_TIM_ID"               NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DD_CRA_ID"               NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "DD_SCR_ID"               NUMBER(16, 0)
	    , "PRO_ID"                  NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "EJE_ID"                  NUMBER(16, 0)
	        NOT NULL ENABLE
	    , "CCC_ARRENDAMIENTO"       NUMBER(1, 0) DEFAULT 0
	    , "CCC_REFACTURABLE"        NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "VERSION"                 NUMBER(38, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "USUARIOCREAR"            VARCHAR2(50 CHAR)
	        NOT NULL ENABLE
	    , "FECHACREAR"              TIMESTAMP(6)
	        NOT NULL ENABLE
	    , "USUARIOMODIFICAR"        VARCHAR2(50 CHAR)
	    , "FECHAMODIFICAR"          TIMESTAMP(6)
	    , "USUARIOBORRAR"           VARCHAR2(50 CHAR)
	    , "FECHABORRAR"             TIMESTAMP(6)
	    , "BORRADO"                 NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "DD_TBE_ID"               NUMBER(16, 0)
	    , "CCC_SUBCUENTA_CONTABLE"  VARCHAR2(50 CHAR)
	    , "CCC_ACTIVABLE"           NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "CCC_PLAN_VISITAS"        NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "DD_TCH_ID"               NUMBER(16, 0)
	    , "CCC_PRINCIPAL"           NUMBER(1, 0) DEFAULT 0
	        NOT NULL ENABLE
	    , "DD_TRT_ID"               NUMBER(16, 0)
	    , "CCC_VENDIDO"             NUMBER(1, 0) DEFAULT 0
	    , CONSTRAINT "PK_ACT_CONFIG_CTAS_CONTABLES" PRIMARY KEY ( "CCC_CTAS_ID" )
	        USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
	            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
	            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
	        TABLESPACE '||V_TABLESPACE_IDX||'
	    ENABLE
	    , CONSTRAINT "UK_CCC_CTAS_CONTABLES" UNIQUE ( "DD_TGA_ID"
	    , "DD_STG_ID"
	    , "DD_TIM_ID"
	    , "DD_CRA_ID"
	    , "DD_SCR_ID"
	    , "PRO_ID"
	    , "EJE_ID"
	    , "CCC_ARRENDAMIENTO"
	    , "CCC_REFACTURABLE"
	    , "DD_TBE_ID"
	    , "CCC_ACTIVABLE"
	    , "CCC_PLAN_VISITAS"
	    , "DD_TCH_ID"
	    , "CCC_PRINCIPAL"
	    , "DD_TRT_ID"
	    , "CCC_VENDIDO"
	    , "BORRADO" )
	        USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
	            STORAGE ( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL
	            DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT )
	        TABLESPACE '||V_TABLESPACE_IDX||'
	    ENABLE
	    , CONSTRAINT "CK_CCC_CAMPOS_LBK" CHECK ( ( DD_CRA_ID = 43
	       AND CCC_PLAN_VISITAS IN ( 0, 1 ) )
	        OR ( DD_CRA_ID <> 43
	       AND DD_TBE_ID IS NULL
	       AND DD_TCH_ID IS NULL
	       AND CCC_PLAN_VISITAS = 0 ) ) ENABLE
	    , CONSTRAINT "CK_CCC_ACTIVABLE" CHECK ( ( DD_CRA_ID IN ( 43, 162 )
	       AND CCC_ACTIVABLE IN ( 0, 1 ) )
	        OR ( DD_CRA_ID NOT IN ( 43, 162 )
	       AND CCC_ACTIVABLE = 0 ) ) ENABLE
	    , CONSTRAINT "CK_CCC_CON_ACTIVOS" CHECK ( ( DD_SCR_ID IS NOT NULL
	       AND CCC_ARRENDAMIENTO IS NOT NULL
	       AND CCC_VENDIDO IS NOT NULL )
	        OR ( DD_SCR_ID IS NULL
	       AND CCC_ARRENDAMIENTO IS NULL
	       AND CCC_VENDIDO IS NULL ) ) ENABLE
	    , CONSTRAINT "FK_CCC_DD_STG_ID" FOREIGN KEY ( "DD_STG_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_STG_SUBTIPOS_GASTO" ( "DD_STG_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_TGA_ID" FOREIGN KEY ( "DD_TGA_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_TGA_TIPOS_GASTO" ( "DD_TGA_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_TIM_ID" FOREIGN KEY ( "DD_TIM_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_TIM_TIPO_IMPORTE" ( "DD_TIM_ID" )
	            ON DELETE SET NULL
	    ENABLE
	    , CONSTRAINT "FK_CCC_PRO_ID" FOREIGN KEY ( "PRO_ID" )
	        REFERENCES '||V_ESQUEMA||'."ACT_PRO_PROPIETARIO" ( "PRO_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_CRA_ID" FOREIGN KEY ( "DD_CRA_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_CRA_CARTERA" ( "DD_CRA_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_SCR_ID" FOREIGN KEY ( "DD_SCR_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_SCR_SUBCARTERA" ( "DD_SCR_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_EJE_ID" FOREIGN KEY ( "EJE_ID" )
	        REFERENCES '||V_ESQUEMA||'."ACT_EJE_EJERCICIO" ( "EJE_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_TBE" FOREIGN KEY ( "DD_TBE_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_TBE_TIPO_ACTIVO_BDE" ( "DD_TBE_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_TCH" FOREIGN KEY ( "DD_TCH_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_TCH_TIPO_COMISIONADO_HRE" ( "DD_TCH_ID" )
	    ENABLE
	    , CONSTRAINT "FK_CCC_DD_TRT_ID" FOREIGN KEY ( "DD_TRT_ID" )
	        REFERENCES '||V_ESQUEMA||'."DD_TRT_TRIBUTOS_A_TERCEROS" ( "DD_TRT_ID" )
	    ENABLE
	)
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');		

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CCC_CTAS_ID IS ''Identificador único''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CCC_CTAS_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CCC_CUENTA_CONTABLE IS ''Cuenta contable''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CCC_CUENTA_CONTABLE creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TGA_ID IS ''Identificador único del tipo de gasto''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TGA_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_STG_ID IS ''Identificador único del subtipo de gasto''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_STG_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TIM_ID IS ''Identificador único del tipo de importe al que pertenece la configuración''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_TIM_ID creado.');	

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_CRA_ID IS ''Identificador único de la cartera a la que pertenece la configuración''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_CRA_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_SCR_ID IS ''Identificador único de la subcartera a la que pertenece la configuración''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna DD_SCR_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.PRO_ID IS ''Identificador único del propietario''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna PRO_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.EJE_ID IS ''Identificador único del ejercicio al que pertenece la configuració''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna EJE_ID creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CCC_ARRENDAMIENTO IS ''Marca si la cuenta contable es de arrendamiento''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CCC_ARRENDAMIENTO creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.CCC_REFACTURABLE IS ''Marca si la cuenta contable es refacturable''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CCC_REFACTURABLE creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.VERSION IS ''Indica la versión del registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
	
	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.BORRADO IS ''Indicador de borrado.''';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe.');  
	ELSE
		-- Creamos sequence
		V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
	END IF;

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_'||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' PURGE';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;

	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA|| '.TMP_'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
	(
	    "CCC_CTAS_ID"             NUMBER(16, 0)
	    , "CCC_CUENTA_CONTABLE"     VARCHAR2(50 CHAR)
	    , "DD_TGA_ID"               NUMBER(16, 0)
	    , "DD_STG_ID"               NUMBER(16, 0)
	    , "DD_TIM_ID"               NUMBER(16, 0)
	    , "DD_CRA_ID"               NUMBER(16, 0)
	    , "DD_SCR_ID"               NUMBER(16, 0)
	    , "PRO_ID"                  NUMBER(16, 0)
	    , "EJE_ID"                  NUMBER(16, 0)
	    , "CCC_ARRENDAMIENTO"       NUMBER(1, 0)
	    , "CCC_REFACTURABLE"        NUMBER(1, 0)
	    , "FECHACREAR"              TIMESTAMP(6)
	    , "BORRADO"                 NUMBER(1, 0)
	    , "DD_TBE_ID"               NUMBER(16, 0)
	    , "CCC_SUBCUENTA_CONTABLE"  VARCHAR2(50 CHAR)
	    , "CCC_ACTIVABLE"           NUMBER(1, 0)
	    , "CCC_PLAN_VISITAS"        NUMBER(1, 0)
	    , "DD_TCH_ID"               NUMBER(16, 0)
	    , "CCC_PRINCIPAL"           NUMBER(1, 0)
	    , "DD_TRT_ID"               NUMBER(16, 0)
	    , "CCC_VENDIDO"             NUMBER(1, 0)
	)
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'... Tabla creada.');

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
