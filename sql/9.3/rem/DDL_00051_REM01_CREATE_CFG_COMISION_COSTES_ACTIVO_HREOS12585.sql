--/*
--##########################################
--## AUTOR=Jesus Jativa Martinez
--## FECHA_CREACION=20201226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9210
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla CFG_COMISION_COSTES_ACTIVO
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
    V_TABLA VARCHAR2(2400 CHAR):= 'CFG_COMISION_COSTES_ACTIVO'; -- Vble. con el nombre de la tabla.
    V_REF_TABLA_TIPO VARCHAR2(2400 CHAR):= 'DD_TPA_TIPO_ACTIVO'; --Vble. con el nombre de la tabla de referencia para la FK  
    V_REF_TABLA_SUBTIPO VARCHAR2(2400 CHAR):= 'DD_SAC_SUBTIPO_ACTIVO'; --Vble. con el nombre de la tabla de referencia para la FK
    V_REF_TABLA_COMISION VARCHAR2(2400 CHAR):= 'DD_TCM_TIPO_COMISION'; --Vble. con el nombre de la tabla de referencia para la FK
    V_REF_TABLA_COSTE VARCHAR2(2400 CHAR):= 'DD_TCT_TIPO_COSTES'; --Vble. con el nombre de la tabla de referencia para la FK     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** CFG_COMISION_COSTES_ACTIVO *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla CFG_COMISION_COSTES_ACTIVO
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
   -- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		
	END IF; 	
   
    -- Si existe la tabla no se crea y si no la creamos
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE.');    	
	       
    ELSE
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');
        V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
            (
                  CFG_CCA_ID                    NUMBER(16,0)        NOT NULL
                , DD_TPA_ID                     NUMBER(16,0)        
                , DD_SAC_ID                     NUMBER(16,0)
                , DD_TCM_ID                     NUMBER(16,0)
                , DD_TCT_ID                     NUMBER(16,0)                             
                , VERSION                       NUMBER(1,0)         DEFAULT 0   NOT NULL    ENABLE
                , USUARIOCREAR                  VARCHAR2(50 CHAR)   NOT NULL    ENABLE
                , FECHACREAR                    TIMESTAMP(6)        DEFAULT SYSTIMESTAMP    NOT NULL    ENABLE
                , USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
                , FECHAMODIFICAR                TIMESTAMP(6)
                , USUARIOBORRAR                 VARCHAR2(50 CHAR)
                , FECHABORRAR                   TIMESTAMP(6)
                , BORRADO                       NUMBER(1,0)         DEFAULT 0   NOT NULL    ENABLE       
            )';        	

        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');

        -- Creamos primary key
        V_MSQL := 'ALTER TABLE '||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (CFG_CCA_ID))';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');

        -- Creamos sequence
	    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||'... Secuencia creada');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT CFG_CCA_FK_DD_TPA FOREIGN KEY (DD_TPA_ID)
	    REFERENCES '||V_ESQUEMA||'.'||V_REF_TABLA_TIPO||' (DD_TPA_ID))';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] CFG_CCA_FK_DD_TPA ... FK creada.');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT CFG_CCA_FK_DD_SAC FOREIGN KEY (DD_SAC_ID)
	    REFERENCES '||V_ESQUEMA||'.'||V_REF_TABLA_SUBTIPO||' (DD_SAC_ID))';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] CFG_CCA_FK_DD_SAC ... FK creada.');
        
        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT CFG_CCA_FK_DD_TCM FOREIGN KEY (DD_TCM_ID)
	    REFERENCES '||V_ESQUEMA||'.'||V_REF_TABLA_COMISION||' (DD_TCM_ID))';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] CFG_CCA_FK_DD_TCM ... FK creada.');

        -- Creamos foreign key
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT CFG_CCA_FK_DD_TCT FOREIGN KEY (DD_TCT_ID)
	    REFERENCES '||V_ESQUEMA||'.'||V_REF_TABLA_COSTE||' (DD_TCT_ID))';
	    EXECUTE IMMEDIATE V_MSQL;
	    DBMS_OUTPUT.PUT_LINE('[INFO] CFG_CCA_FK_DD_TCT ... FK creada.');
            
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO IS ''CORRESPONDENCIA DE COMISION Y COSTE CON TIPOLOGÍAS DE ACTIVO ''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.CFG_CCA_ID IS ''ID único del tipo de activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.DD_TPA_ID IS ''ID único del diccionario DD_TPA_TIPO_ACTIVO''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.DD_SAC_ID IS ''ID único del diccionario DD_SAC_SUBTIPO_ACTIVO''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.DD_TCM_ID IS ''ID único del diccionario DD_TCM_ID''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.DD_TCT_ID IS ''ID único del diccionario DD_TCT_ID''';          
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.VERSION IS ''Indica la versión del registro''';  
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.CFG_COMISION_COSTES_ACTIVO.BORRADO IS ''Indicador de borrado''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.CFG_COMISION_COSTES_ACTIVO... OK');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    END IF; 
    
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
