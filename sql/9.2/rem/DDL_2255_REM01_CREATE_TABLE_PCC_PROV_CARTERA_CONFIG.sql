--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20190708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6959
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla PCC_PROV_CARTERA_CONFIG
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
    V_TABLA VARCHAR2(27 CHAR) := 'PCC_PROV_CARTERA_CONFIG'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-6959';
    
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
 			 PCC_ID              NUMBER(16,0) NOT NULL
       , PVE_ID 					 NUMBER(16,0) NOT NULL
			 , DD_CRA_ID 				 NUMBER(16,0) NOT NULL
			 , ID_HAYA					 NUMBER(16,0) NOT NULL
			)
		  ';

  EXECUTE IMMEDIATE V_MSQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);
  
  -- Creamos indice.
  V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(PCC_ID) TABLESPACE '||V_TABLESPACE_IDX;		
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... Indice creado.');
  
  -- Creamos indice.
  --V_MSQL := 'CREATE UNIQUE INDEX ESH_ACT_ID_PK ON '||V_ESQUEMA|| '.'||V_TABLA||'(DD_CRA_ID) TABLESPACE '||V_TABLESPACE_IDX;		
  --EXECUTE IMMEDIATE V_MSQL;
  --DBMS_OUTPUT.PUT_LINE('[INFO] ESH_ACT_ID_PK... Indice creado.');
  
  -- Creamos primary key.
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT PCC_ID_PK PRIMARY KEY (PCC_ID) USING INDEX)';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] PCC_ID_PK... PK creada.');
  
  -- Creamos unique key ACT_ID.
  --V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT UK_ESH_ACT_ID UNIQUE (ACT_ID))';
  --EXECUTE IMMEDIATE V_MSQL;
  --DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.UK_ESH_ACT_ID... Unique key creada.');
  
  -- Creamos foreign key PVE_ID.
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_PCC_PVE_ID FOREIGN KEY (PVE_ID) REFERENCES '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR (PVE_ID))';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_PCC_PVE_ID... Foreign key creada.');

    -- Creamos foreign key DD_CRA_ID.
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_PCC_DD_CRA_ID FOREIGN KEY (DD_CRA_ID) REFERENCES '||V_ESQUEMA||'.DD_CRA_CARTERA (DD_CRA_ID))';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FK_PCC_DD_CRA_ID... Foreign key creada.');
  
  -- Creamos comentario de tabla.
  V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla que contiene la relación Proveedor - Cartera''';		
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');

  -- Creamos comentario de columnas.
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.PCC_ID IS ''ID de la tabla.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.PVE_ID IS ''Código identificador único del proveedor.''';  
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_CRA_ID IS ''Código identificador único de la cartera.'''; 
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ID_HAYA IS ''Código identificador único del proveedor en Maestro de Personas.''';
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

