--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220310
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17301
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas AUX_INFORME_GASTOS_CAIXA_CORREO
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-17217] - PIER GOTTA
--##        0.2 Añadir campos de auditoría e Id - [HREOS-17301] - Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'AUX_INFORME_GASTOS_CAIXA_CORREO';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices

BEGIN
	


	/***** H_AUX_I_RU_LFACT_SIN_PROV_BFA *****/

	V_TABLA := 'AUX_INFORME_GASTOS_CAIXA_CORREO';
	
	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

    -- Verificar si la tabla ya existe
	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
	END IF;

    --Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		
	END IF; 

	EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                            ( 
                                INF_ID	 	          		NUMBER(16)                  NOT NULL,
                                CORREO						VARCHAR2(150 CHAR)			NOT NULL,
                                CORREO_EN_COPIA				NUMBER(1,0)			        NOT NULL,
                                VERSION 					NUMBER(38,0) 		    	DEFAULT 0 NOT NULL ENABLE, 
                                USUARIOCREAR 				VARCHAR2(50 CHAR) 	    	NOT NULL ENABLE, 
                                FECHACREAR 					TIMESTAMP (6) 		    	NOT NULL ENABLE, 
                                USUARIOMODIFICAR 			VARCHAR2(50 CHAR), 
                                FECHAMODIFICAR 				TIMESTAMP (6), 
                                USUARIOBORRAR 				VARCHAR2(50 CHAR), 
                                FECHABORRAR 				TIMESTAMP (6), 
                                BORRADO 					NUMBER(1,0) 		    	DEFAULT 0 NOT NULL ENABLE
                              
                           )';


                           

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  
	
    -- Creamos indice	
	V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(INF_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (INF_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');


	-- Creamos sequence
	V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	EXECUTE IMMEDIATE V_SQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.INF_ID IS ''Identificador único ''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna INF_ID creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.CORREO IS ''Correo al que se envia''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CORREO creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.CORREO_EN_COPIA IS ''Correo en copia al que se envia''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna CORREO_EN_COPIA creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión del registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna VERSION creado.');
    
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOCREAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHACREAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOMODIFICAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHAMODIFICAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna USUARIOBORRAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna FECHABORRAR creado.');

    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna BORRADO creado.');

    COMMIT;

	
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
