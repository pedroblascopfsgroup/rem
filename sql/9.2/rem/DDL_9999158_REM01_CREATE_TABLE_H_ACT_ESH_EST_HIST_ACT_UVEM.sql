--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20181110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4686
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla H_ACT_ESH_EST_HIST_ACT_UVEM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'H_ACT_ESH_EST_HIST_ACT_UVEM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-4686';
    
 BEGIN
 
 V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||''''; 
 EXECUTE IMMEDIATE V_MSQL INTO V_COUNT; 
 
 IF V_COUNT = 0 THEN
 
 	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||''; 	
 	EXECUTE IMMEDIATE V_MSQL; 	
 	DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
  END IF; 
 
 V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

 EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
 
 IF V_COUNT = 0 THEN
 
 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
 			 ESH_ID 					NUMBER(16,0) NOT NULL
			 , ACT_ID 					NUMBER(16,0) NOT NULL
			 , COESEN					VARCHAR2(2 CHAR) NOT NULL
			 , ESH_FECHA_INICIO			DATE NOT NULL
			 , ESH_FECHA_FIN			DATE NOT NULL
			 , VERSION					NUMBER(38,0) NOT NULL
			 , USUARIOCREAR				VARCHAR2(50 CHAR) NOT NULL
			 , FECHACREAR				TIMESTAMP(6) NOT NULL
			 , USUARIOMODIFICAR			VARCHAR2(50 CHAR)
			 , FECHAMODIFICAR			TIMESTAMP(6)
			 , USUARIOBORRAR			VARCHAR2(50 CHAR)
			 , FECHABORRAR				TIMESTAMP(6)
			 , BORRADO					NUMBER(1,0) DEFAULT 0 NOT NULL
			)
		  ';

  EXECUTE IMMEDIATE V_MSQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);
  
  -- Creamos indice.
  V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(ESH_ID) TABLESPACE '||V_TABLESPACE_IDX;		
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
  
  -- Creamos indice.
  --V_MSQL := 'CREATE UNIQUE INDEX ESH_ACT_ID_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;		
  --EXECUTE IMMEDIATE V_MSQL;
  --DBMS_OUTPUT.PUT_LINE('[INFO] ESH_ACT_ID_PK... Indice creado.');
  
  -- Creamos primary key.
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT ESH_ID_PK PRIMARY KEY (ESH_ID) USING INDEX)';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ESH_ID_PK... PK creada.');
  
  -- Creamos unique key ACT_ID.
  --V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT UK_ESH_ACT_ID UNIQUE (ACT_ID))';
  --EXECUTE IMMEDIATE V_MSQL;
  --DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.UK_ESH_ACT_ID... Unique key creada.');
  
  -- Creamos foreign key ACT_ID.
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_ESH_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID))';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_ESH_ACT_ID... Foreign key creada.');
  
  -- Creamos comentario de tabla.
  V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla que contiene el historico los estados de los activos de UVEM''';		
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');

  -- Creamos comentario de columnas.
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ESH_ID IS ''ID del estado del activo UVEM.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID IS ''Código identificador único del activo.''';  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.COESEN IS ''Codigo del estado del activo.'''; 
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ESH_FECHA_INICIO IS ''Fecha desde la cual el activo tiene asignado el estado.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ESH_FECHA_FIN IS ''Fecha hasta la cual el activo tiene asignado el estado.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la version del registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creo el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creo el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
  DBMS_OUTPUT.PUT_LINE('[INFO] Comentarios en las columnas creados.');

  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
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

