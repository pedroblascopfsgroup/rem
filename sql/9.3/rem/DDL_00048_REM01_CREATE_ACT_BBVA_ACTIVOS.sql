--/*
--##########################################
--## AUTOR=Carlos Augusto
--## FECHA_CREACION=20200729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10762
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_BBVA_ACTIVOS
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
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_BBVA_ACTIVOS'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** ACT_BBVA_ACTIVOS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_BBVA_ACTIVOS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existe la tabla se borra
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE.');    
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';		
	  END IF;

    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    IF V_NUM_TABLAS = 1 THEN
      DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Secuencia BORRADA.');  
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
         DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'Se ha borrado la secuencia la volvemos a crear.');
      V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');
      
    ELSE
     
    	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');

    END IF; 
 
     
    	 --Creamos la tabla
      DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
    			  BBVA_ID                     	NUMBER(16,0)        NOT NULL
				 ,ACT_ID                     	NUMBER(16,0)        NOT NULL
				 ,BBVA_NUM_ACTIVO               NUMBER(16,0)      
				 ,BBVA_ID_DIVARIAN              NUMBER(16,0)
				 ,BBVA_LINEA_FACTURA            NUMBER(16,0) 
				 ,BBVA_ID_ORIGEN_HRE     	    NUMBER(16,0)
                 ,DD_TTR_ID                     NUMBER(16,0)
                 ,DD_TAL_ID                     NUMBER(16,0)
				 ,BBVA_UIC    		            VARCHAR2(50 CHAR)
				 ,BBVA_CEXPER                   VARCHAR2(50 CHAR)
				 ,BBVA_ID_PROCESO_ORIGEN		NUMBER(16,0)
				 ,BBVA_ACTIVO_EPA              	NUMBER(16,0)
				 ,BBVA_EMPRESA                  NUMBER(16,0)
				 ,BBVA_OFICINA                  NUMBER(16,0)
				 ,BBVA_CONTRAPARTIDA            NUMBER(16,0)
                 ,BBVA_FOLIO                    NUMBER(16,0)
                 ,BBVA_CDPEN                    NUMBER(16,0)
				 ,VERSION                       NUMBER(1,0)         DEFAULT 0
				 ,USUARIOCREAR                  VARCHAR2(50 CHAR) 
				 ,FECHACREAR                    TIMESTAMP(6)        DEFAULT SYSTIMESTAMP
				 ,USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
				 ,FECHAMODIFICAR                TIMESTAMP(6)
				 ,USUARIOBORRAR                 VARCHAR2(50 CHAR)
				 ,FECHABORRAR                   TIMESTAMP(6)
				 ,BORRADO                       NUMBER(1,0)         DEFAULT 0
				 ,CONSTRAINT PK_BBVA_ID PRIMARY KEY(BBVA_ID)
				 ,CONSTRAINT FK_BBVA_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID)
                 ,CONSTRAINT UK_BBVA_ACT_ID UNIQUE (ACT_ID)
                 ,CONSTRAINT UK_BBVA_NUM_ACTIVO UNIQUE (BBVA_NUM_ACTIVO)
				 ,CONSTRAINT FK_BBVA_DD_TTR_ID FOREIGN KEY (DD_TTR_ID) REFERENCES '||V_ESQUEMA||'.DD_TTR_TIPO_TRANSMISION (DD_TTR_ID)
				 ,CONSTRAINT FK_BBVA_DD_TAL_ID FOREIGN KEY (DD_TAL_ID) REFERENCES '||V_ESQUEMA||'.DD_TAL_TIPO_ALTA (DD_TAL_ID)
				 ,CONSTRAINT FK_BBVA_ACTIVO_EPA FOREIGN KEY (BBVA_ACTIVO_EPA) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID)				
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
				
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla suministros de los activos.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_ID IS ''Identificador de tabla''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_ID IS ''Id Activo FK a ACT_ACTIVO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_NUM_ACTIVO IS ''Nº de activo BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_ID_DIVARIAN IS ''ID App Divarian'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_LINEA_FACTURA IS ''Linea de Factura''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_ID_ORIGEN_HRE IS ''ID Origen Haya''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_TTR_ID IS ''Tipo de Transmision FK a DD_TTR_TIPO_TRANSMISION''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_TAL_ID IS ''Tipo de Alta FK a DD_TAL_TIPO_ALTA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_UIC IS ''UIC de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_CEXPER IS ''Cexper de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_ID_PROCESO_ORIGEN IS ''ID del proceso origen''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_ACTIVO_EPA IS ''Activo EPA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_EMPRESA IS ''Empresa de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_OFICINA IS ''Oficina de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_CONTRAPARTIDA IS ''Contrapartida de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_FOLIO IS ''Folio de BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BBVA_CDPEN IS ''CDPEN DE BBVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.VERSION IS ''Indica la versión del registro''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BORRADO IS ''Indicador de borrado''';
  
    DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.'||V_TABLA||'... OK');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    
    
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
