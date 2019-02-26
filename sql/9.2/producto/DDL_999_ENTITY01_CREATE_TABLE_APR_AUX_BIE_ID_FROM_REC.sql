--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20181211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4930
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla temporal para los ID de los Bienes que vienen desde Recovery
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
    V_TABLA VARCHAR2(27 CHAR) := 'APR_AUX_BIE_ID_FROM_REC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-4930';
    
 BEGIN
 
 V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

 EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
 
 IF V_COUNT = 0 THEN
 
 V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
 			   BIE_ID NUMBER(16,0) NOT NULL
 			 , FECHA_ANYADIDO DATE DEFAULT SYSDATE
			 , USUARIO_ANYADIDO VARCHAR(20 CHAR) DEFAULT ''HREOS-4930''
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
