--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-898
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla de gestores sustitutos
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
    V_TABLA VARCHAR2(27 CHAR) := 'SGS_GESTOR_SUSTITUTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-898';
    
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
 			   SGS_ID NUMBER(16,0) NOT NULL
 			 , USU_ID_ORI NUMBER(16,0) NOT NULL
 			 , USU_ID_SUS NUMBER(16,0) NOT NULL
 			 , FECHA_INICIO DATE NOT NULL
			 , FECHA_FIN DATE
			 , VERSION NUMBER(38,0) DEFAULT 0 NOT NULL 
 			 , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ENABLE
			 , FECHACREAR TIMESTAMP (6) NOT NULL ENABLE
			 , USUARIOMODIFICAR VARCHAR2(50 CHAR)
			 , FECHAMODIFICAR TIMESTAMP (6)
			 , USUARIOBORRAR VARCHAR2(50 CHAR)
			 , FECHABORRAR TIMESTAMP (6)
			 , BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
			 , CONSTRAINT SGS_ID_PK PRIMARY KEY (SGS_ID)
			 , CONSTRAINT FK_USU_ID_ORI
		       FOREIGN KEY (USU_ID_ORI)
	           REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS(USU_ID)
			 , CONSTRAINT FK_USU_ID_SUS
			 FOREIGN KEY (USU_ID_SUS)
			 REFERENCES '||V_ESQUEMA_M||'.USU_USUARIOS(USU_ID)
			)
		  ';

  EXECUTE IMMEDIATE V_SQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

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

