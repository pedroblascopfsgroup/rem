--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10039
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla ACT_PRINEX_ACTIVOS
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
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_PRINEX_ACTIVOS'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
	  V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';

BEGIN

    -- ******** ACT_PRINEX_ACTIVOS *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
   

    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    IF V_NUM_TABLAS = 1 THEN
     	
	    DBMS_OUTPUT.PUT_LINE('[INFO] La secuencia ya existe');
      
    ELSE
     
    	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';		
	    EXECUTE IMMEDIATE V_MSQL;		
	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TABLA||' creada');

    END IF; 

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    -- Si existe la tabla se borra
    IF V_NUM_TABLAS = 1 THEN 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe.');
	    ELSE
			 --Creamos la tabla
      DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				  PRINEX_ID                     	NUMBER(16,0)        NOT NULL
				 ,ACT_ID                     	NUMBER(16,0)        NOT NULL
				 ,DD_DIA_ID                  NUMBER(16,0)      
				 ,DD_DIT_ID                   NUMBER(16,0)
				 ,DD_MTC_ID                   NUMBER(16,0) 			 	 
				 ,PRINEX_COSTE_ADQUISICION		NUMBER(16,2)
				 ,VERSION                       NUMBER(38,0)         DEFAULT 0
				 ,USUARIOCREAR                  VARCHAR2(50 CHAR) 
				 ,FECHACREAR                    TIMESTAMP(6)        DEFAULT SYSTIMESTAMP
				 ,USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
				 ,FECHAMODIFICAR                TIMESTAMP(6)
				 ,USUARIOBORRAR                 VARCHAR2(50 CHAR)
				 ,FECHABORRAR                   TIMESTAMP(6)
				 ,BORRADO                       NUMBER(1,0)         DEFAULT 0
				 ,CONSTRAINT PK_PRINEX_ID PRIMARY KEY(PRINEX_ID)
				 ,CONSTRAINT FK_PRINEX_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID)	
         ,CONSTRAINT FK_PRINEX_DD_DIA_ID FOREIGN KEY (DD_DIA_ID) REFERENCES '||V_ESQUEMA||'.DD_DIA_DISP_ADMINISTRATIVO (DD_DIA_ID)
         ,CONSTRAINT FK_PRINEX_DD_DIT_ID FOREIGN KEY (DD_DIT_ID) REFERENCES '||V_ESQUEMA||'.DD_DIT_DISP_TECNICO (DD_DIT_ID)
         ,CONSTRAINT FK_PRINEX_DD_MTC_ID FOREIGN KEY (DD_MTC_ID) REFERENCES '||V_ESQUEMA||'.DD_MTC_MOTIVO_TECNICO (DD_MTC_ID)			
			  )';         	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
				
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla para datos prinex''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.PRINEX_ID IS ''Identificador de tabla''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_ID IS ''Id Activo FK a ACT_ACTIVO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_DIA_ID IS ''Id Disponibilidad administrativa del activo''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_DIT_ID IS ''Id Disponibilidad tecnica del activo'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_MTC_ID IS ''Id Motivo tecnico del activo''';
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
    END IF;

     IF V_ESQUEMA_M != V_ESQUEMA THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_M||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_M||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

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
