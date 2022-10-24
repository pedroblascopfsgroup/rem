--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18086
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla ACT_AGE_ACTIVO_GESTION
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
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_AGE_ACTIVO_GESTION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-18086';
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
	
    
    
 BEGIN
 
 	-- Comprobación tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe la tabla '||V_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la tabla '||V_TABLA);
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (

				 AGE_ID NUMBER(16,0)
                , ACT_ID NUMBER(16,0)
                , DD_ELO_ID NUMBER(16,0)
                , DD_SEG_ID NUMBER(16,0)
                , USU_ID NUMBER(16,0)
                , AGE_FECHA_INICIO DATE
                , AGE_FECHA_FIN DATE
                , VERSION                       NUMBER(38,0)         DEFAULT 0 NOT NULL
				, USUARIOCREAR                  VARCHAR2(50 CHAR) NOT NULL
				, FECHACREAR                    TIMESTAMP(6)        DEFAULT SYSTIMESTAMP
				, USUARIOMODIFICAR              VARCHAR2(50 CHAR) 
				, FECHAMODIFICAR                TIMESTAMP(6)
				, USUARIOBORRAR                 VARCHAR2(50 CHAR)
				, FECHABORRAR                   TIMESTAMP(6)
				, BORRADO                       NUMBER(1,0)         DEFAULT 0

                ,CONSTRAINT PK_ACT_AGE_ID PRIMARY KEY(AGE_ID)
				,CONSTRAINT FK_AGE_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID)
                ,CONSTRAINT FK_AGE_DD_ELO_ID FOREIGN KEY (DD_ELO_ID) REFERENCES '||V_ESQUEMA||'.DD_ELO_ESTADO_LOCALIZACION (DD_ELO_ID)
				,CONSTRAINT FK_AGE_DD_SEG_ID FOREIGN KEY (DD_SEG_ID) REFERENCES '||V_ESQUEMA||'.DD_SEG_SUBESTADO_GESTION (DD_SEG_ID)
				,CONSTRAINT FK_AGE_USU_ID FOREIGN KEY (USU_ID) REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID)	
                
                
				)
			  ';

		EXECUTE IMMEDIATE V_SQL;


        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.AGE_ID IS ''Identificador de tabla''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.ACT_ID IS ''Activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_ELO_ID IS ''Estado localización''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.DD_SEG_ID IS ''Subestado gestión''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USU_ID IS ''Usuario''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.AGE_FECHA_INICIO IS ''Fecha inicio''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.AGE_FECHA_FIN IS ''Fecha fin''';
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
	
	END IF;


	-- Comprobamos sequence
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la secuencia');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 

	IF V_COUNT = 0 THEN
	 
		-- Creamos sequence	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
	  
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
