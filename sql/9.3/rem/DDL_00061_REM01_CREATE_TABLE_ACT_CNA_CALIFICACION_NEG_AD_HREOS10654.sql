--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20200803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10654
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_CNA_CALIFICACION_NEG_AD
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
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_CNA_CALIFICACION_NEG_AD'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ********  ACT_CNA_CALIFICACION_NEG_AD *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_CNA_CALIFICACION_NEG_AD
    
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
                ACT_CNA_ID                  NUMBER(16,0)        NOT NULL,
                ACT_ID                     	NUMBER(16,0)        NOT NULL,
                DD_MCN_ID                   NUMBER(16,0)        NOT NULL,
                DD_CAN_ID                   NUMBER(16,0)        NOT NULL,
                CNA_DESCRIPCION             VARCHAR2(500 CHAR),
                ACT_FECHA_SUBSANACION       DATE,
                DD_EMN_ID                   NUMBER(16,0),
                DD_RSU_ID                   NUMBER(16,0),
                HTA_ID                      NUMBER(16,0),
                CNA_PRINCIPAL               NUMBER(1,0)         NOT NULL,
                CNA_MATRICULA_PROP          NUMBER(16,0),
                VERSION                     NUMBER(1,0)         DEFAULT 0,
                USUARIOCREAR                VARCHAR2(50 CHAR), 
				FECHACREAR                  TIMESTAMP(6)        DEFAULT SYSTIMESTAMP,
                USUARIOMODIFICAR            VARCHAR2(50 CHAR), 
                FECHAMODIFICAR              TIMESTAMP(6),
                USUARIOBORRAR               VARCHAR2(50 CHAR),
                FECHABORRAR                 TIMESTAMP(6),
                BORRADO                     NUMBER(1,0)         DEFAULT 0,
				CONSTRAINT PK_ACT_CNA_ID PRIMARY KEY(ACT_CNA_ID), 
				CONSTRAINT FK_ACT_CNA_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID),
				CONSTRAINT FK_ACT_CNA_DD_MCN_ID FOREIGN KEY (DD_MCN_ID) REFERENCES '||V_ESQUEMA||'.DD_MCN_MOTIVO_CALIFIC_NEG (DD_MCN_ID),
				CONSTRAINT FK_ACT_CNA_DD_CAN_ID FOREIGN KEY (DD_CAN_ID) REFERENCES '||V_ESQUEMA||'.DD_CAN_CALIFICACION_NEG (DD_CAN_ID),
				CONSTRAINT FK_ACT_CNA_DD_EMN_ID FOREIGN KEY (DD_EMN_ID) REFERENCES '||V_ESQUEMA||'.DD_EMN_ESTADO_MOTIVO_CAL_NEG (DD_EMN_ID),
				CONSTRAINT FK_ACT_CNA_DD_RSU_ID FOREIGN KEY (DD_RSU_ID) REFERENCES '||V_ESQUEMA||'.DD_RSU_RESPONSABLE_SUBSANAR (DD_RSU_ID),
				CONSTRAINT FK_ACT_CNA_HTA_ID FOREIGN KEY (HTA_ID) REFERENCES '||V_ESQUEMA||'.ACT_HTA_HISTORICO_TITULO_AD (HTA_ID),
				CONSTRAINT FK_ACT_CNA_MATRICULA_PROP FOREIGN KEY (CNA_MATRICULA_PROP) REFERENCES '||V_ESQUEMA||'.ACT_CNA_CALIFICACION_NEG_AD (ACT_CNA_ID)

			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
				
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla calificación negativa adicional de los activos.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_CNA_ID IS ''Identificador único de la calificacion negativa del título adicional''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_ID IS ''Id Activo FK a ACT_ACTIVO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_MCN_ID IS ''Clave ajena DD_MCN_MOTIVO_CALIFIC_NEG''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_CAN_ID IS ''Clave ajena DD_CAN_CALIFICACION_NEG.'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CNA_DESCRIPCION IS ''Descripción del motivo de la calificacion negativa del título adicional''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_FECHA_SUBSANACION IS ''Fecha subsanacion calificacion negativa''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_EMN_ID IS ''Clave ajena DD_EMN_ESTADO_MOTIVO_CAL_NEG''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_RSU_ID IS ''Clave ajena DD_RSU_RESPONSABLE_SUBSANAR''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.HTA_ID IS ''Clave ajena ACT_HTA_HISTORICO_TITULO_AD''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CNA_PRINCIPAL IS ''Indica si es principal con propagación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CNA_MATRICULA_PROP IS ''Registro original de la propagación, clave ajena ACT_CNA_CALIFICACION_NEG_AD''';
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
