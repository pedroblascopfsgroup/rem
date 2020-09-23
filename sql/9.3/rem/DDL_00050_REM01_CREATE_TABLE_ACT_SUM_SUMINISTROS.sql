--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20200702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10433
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_SUM_SUMINISTROS
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
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_SUM_SUMINISTROS'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** ACT_SUM_SUMINISTROS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_SUM_SUMINISTROS
    
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
      
    ELSE
     
    	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');

    END IF; 
 
     
    	 --Creamos la tabla
      DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
    			  SUM_ID                     	NUMBER(16,0)        NOT NULL
				 ,ACT_ID                     	NUMBER(16,0)        NOT NULL
				 ,DD_TSU_ID                     NUMBER(16,0)
				 ,DD_SSU_ID                     NUMBER(16,0)
				 ,SUM_COMPANIA_SUMINISTRO       NUMBER(16,0) 
				 ,SUM_DOMICILIADO      			NUMBER(16,0)
				 ,SUM_NUMERO_CONTRATO    		VARCHAR2(250 CHAR)
				 ,SUM_NUMERO_CUPS               VARCHAR2(250 CHAR)
				 ,SUM_PERIODICIDAD				NUMBER(16,0)
				 ,SUM_FECHA_ALTA              	DATE
				 ,SUM_MOTIVO_ALTA               NUMBER(16,0)
				 ,SUM_FECHA_BAJA               	DATE
				 ,SUM_MOTIVO_BAJA               NUMBER(16,0)
				 ,SUM_VALIDADO               	NUMBER(16,0)
				 ,VERSION                       NUMBER(1,0)         DEFAULT 0
				 ,USUARIOCREAR                  VARCHAR2(50 CHAR) 
				 ,FECHACREAR                    TIMESTAMP(6)        DEFAULT SYSTIMESTAMP
				 ,USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
				 ,FECHAMODIFICAR                TIMESTAMP(6)
				 ,USUARIOBORRAR                 VARCHAR2(50 CHAR)
				 ,FECHABORRAR                   TIMESTAMP(6)
				 ,BORRADO                       NUMBER(1,0)         DEFAULT 0
				 ,CONSTRAINT PK_SUM_ID PRIMARY KEY(SUM_ID)
				 ,CONSTRAINT FK_SUM_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID)
				 ,CONSTRAINT FK_SUM_DD_TSU_ID FOREIGN KEY (DD_TSU_ID) REFERENCES '||V_ESQUEMA||'.DD_TSU_TIPO_SUMINISTRO (DD_TSU_ID)
				 ,CONSTRAINT FK_SUM_DD_SSU_ID FOREIGN KEY (DD_SSU_ID) REFERENCES '||V_ESQUEMA||'.DD_SSU_SUBTIPO_SUMINISTRO (DD_SSU_ID)
				 ,CONSTRAINT FK_SUM_COMPANIA_SUMINISTRO FOREIGN KEY (SUM_COMPANIA_SUMINISTRO) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID)
				 ,CONSTRAINT FK_SUM_DOMICILIADO FOREIGN KEY (SUM_DOMICILIADO) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID)
				 ,CONSTRAINT FK_SUM_PERIODICIDAD FOREIGN KEY (SUM_PERIODICIDAD) REFERENCES '||V_ESQUEMA||'.DD_TPE_TIPOS_PERIOCIDAD (DD_TPE_ID)
				 ,CONSTRAINT FK_SUM_MOTIVO_ALTA FOREIGN KEY (SUM_MOTIVO_ALTA) REFERENCES '||V_ESQUEMA||'.DD_MAS_MOTIVO_ALTA_SUM (DD_MAS_ID)
				 ,CONSTRAINT FK_SUM_MOTIVO_BAJA FOREIGN KEY (SUM_MOTIVO_BAJA) REFERENCES '||V_ESQUEMA||'.DD_MBS_MOTIVO_BAJA_SUM (DD_MBS_ID)
				 ,CONSTRAINT FK_SUM_VALIDADO FOREIGN KEY (SUM_VALIDADO) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID)

			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
				
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla suministros de los activos.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_ID IS ''Identificador de tabla''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_ID IS ''Id Activo FK a ACT_ACTIVO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_TSU_ID IS ''FK a diccionario DD_TSU_TIPO_SUMINISTRO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_SSU_ID IS ''FK a diccionario DD_SSU_SUBTIPO_SUMINISTRO'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_COMPANIA_SUMINISTRO IS ''Proveedor FK a ACT_PVE_PROVEEDOR''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_DOMICILIADO IS ''Domiciliado FK a DD_SIN_SINO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_NUMERO_CONTRATO IS ''Número contrato''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_NUMERO_CUPS IS ''Número cups''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_PERIODICIDAD IS ''Periodicidad suministro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_FECHA_ALTA IS ''Fecha alta suministro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_MOTIVO_ALTA IS ''Motivo alta suministro FK a DD_MAS_MOTIVO_ALTA_SUM''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_FECHA_BAJA IS ''Fecha baja suministro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_MOTIVO_BAJA IS ''Motivo fecha baja suministro FK a DD_MBS_MOTIVO_BAJA_SUM''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.SUM_VALIDADO IS ''Validado suministro FK a DD_SIN_SINO''';
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
