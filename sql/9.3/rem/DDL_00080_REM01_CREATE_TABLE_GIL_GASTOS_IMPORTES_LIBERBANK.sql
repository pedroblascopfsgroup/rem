--/*
--#########################################
--## AUTOR=Joaquin Bahamonde
--## FECHA_CREACION=20200916
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11053
--## PRODUCTO=NO
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'GIL_GASTOS_IMPORTES_LIBERBANK';
V_NUM_TABLAS NUMBER(16);

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT = 0 THEN

    V_MSQL := '
    CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
    (
        GIL_ID                          NUMBER(16,0) NOT NULL,
        GPV_ID                     	 	NUMBER(16,0) NOT NULL,
        ENT_ID                          NUMBER(16), 
        DD_ENT_ID                  	    NUMBER(16),
        IMPORTE_ACTIVO                  NUMBER(16,2),
       
        USUARIOCREAR    	            VARCHAR2(10),
        FECHACREAR          	        DATE NOT NULL,
        USUARIOMODIFICAR    	        VARCHAR2(10),
        FECHAMODIFICAR      	        DATE,	 
        VERSION                   	    NUMBER(38,0) DEFAULT 0 NOT NULL,
        USUARIOBORRAR             	    VARCHAR2(50),
        FECHABORRAR               	    DATE,
        BORRADO                  	    NUMBER(1, 0) DEFAULT 0 NOT NULL
    )';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');

    V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
        EXECUTE IMMEDIATE V_MSQL;		
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');
    END IF;

    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (GIL_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_PK creada.');

    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT CK_GIL_GASTOS_IMPORTES_LIBERBANK CHECK ((BORRADO = 0 AND FECHABORRAR IS NULL) OR BORRADO = 1)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_CK creada.');

    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT FK_GIL_GPV_ID FOREIGN KEY (GPV_ID) REFERENCES '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] FK_GPV_GASTOS_TPV_ID creada.');

    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT UK_GIL_GASTOS_IMPORTES_LIBERBANK unique(GPV_ID, ENT_ID, DD_ENT_ID, BORRADO, FECHABORRAR)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] UK_GIL_GASTOS_IMPORTES_LIBERBANK  creada.');


    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GIL_ID IS ''Indica el código identificador único de la tabla.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_ID IS ''Indica el código identificador único del registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ENT_ID IS ''ID de la tabla de ENTIDAD.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_ENT_ID IS ''ID de la tabla DD_ENT_ENTIDAD_GASTO.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.IMPORTE_ACTIVO IS ''Columna con el valor del importe activo.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión de la modificación del registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que ha creado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se ha creado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que ha modificado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se ha modificado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que ha borrado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se ha borrado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indica la fecha en la que se ha borrado el registro.''';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] COMENTARIOS CREADOS');

END IF;

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




