--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20190114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= HREOS-5208
--## PRODUCTO=NO
--##
--## Finalidad: Crear el diccionario para el responsable subsanar.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(50 CHAR) := 'DD_RSU_RESPONSABLE_SUBSANAR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-5208';
    
 BEGIN
 
 V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
 
 EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
 
 IF V_COUNT = 0 THEN
 
 	V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
 	
 	EXECUTE IMMEDIATE V_SQL;
 	
 	DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

  ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
  END IF;
 
 
 V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

 EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
 
 IF V_COUNT = 0 THEN
 
 V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
        DD_RSU_ID                 NUMBER(16,0) NOT NULL
        , DD_RSU_CODIGO            VARCHAR2(20 CHAR) NOT NULL
        , DD_RSU_DESCRIPCION       VARCHAR2(100 CHAR)
        , DD_RSU_DESCRIPCION_LARGA VARCHAR2(100 CHAR)
			 , VERSION                  NUMBER(38,0) DEFAULT 0 NOT NULL 
 			 , USUARIOCREAR             VARCHAR2(50 CHAR) NOT NULL ENABLE
			 , FECHACREAR               TIMESTAMP (6) NOT NULL ENABLE
			 , USUARIOMODIFICAR         VARCHAR2(50 CHAR)
			 , FECHAMODIFICAR           TIMESTAMP (6)
			 , USUARIOBORRAR            VARCHAR2(50 CHAR)
			 , FECHABORRAR              TIMESTAMP (6)
			 , BORRADO                  NUMBER(1,0) DEFAULT 0 NOT NULL
			 , CONSTRAINT DD_RSU_ID PRIMARY KEY (DD_RSU_ID)
			)
		  ';

  EXECUTE IMMEDIATE V_SQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

  DBMS_OUTPUT.PUT_LINE('[INFO] Creacion de los comentarios en la tabla '||V_TABLA);


    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_RSU_ID IS ''Identificador único del responsable subsanar''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_RSU_CODIGO IS ''Identificador único del responsable subsanar''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_RSU_DESCRIPCION IS ''Descripcion del responsable subsanar''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_RSU_DESCRIPCION_LARGA IS ''Descripcion larga del responsable subsanar''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Indica la versión del registro''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';    EXECUTE IMMEDIATE V_SQL;
    V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla diccionario del responsable subsanar''';    EXECUTE IMMEDIATE V_SQL;


    DBMS_OUTPUT.PUT_LINE('[INFO] La creacion de los comentarios en la tabla '||V_TABLA || ' ha finalizado correctamente');

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

