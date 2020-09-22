--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11250
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla MSG_CALC_DIARIOS
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
    V_TABLA VARCHAR2(27 CHAR) := 'MSG_CALC_DIARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_INDEX VARCHAR2(27 CHAR) := 'IDX_ERR_CALC_DIARIOS';
    
    
 BEGIN
 
	V_SQL := 'SELECT COUNT(1) 
		FROM ALL_TABLES 
		WHERE OWNER = '''||V_ESQUEMA||''' 
			AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN
 
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
			(
				GPV_ID NUMBER(16) NOT NULL
				, RESULTADO VARCHAR2(2 CHAR) NOT NULL
				, ERR_MSG VARCHAR2(4000 CHAR) NOT NULL
			)';
		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existía la tabla '||V_TABLA);	
	
	END IF;

	V_SQL := 'SELECT COUNT(1)
		FROM ALL_INDEXES
		WHERE INDEX_NAME = '''||V_INDEX||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

	IF V_COUNT = 1 THEN

		V_SQL := 'DROP INDEX '||V_INDEX;
		EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Índice '||V_INDEX||' eliminado.');

	END IF;

	V_SQL := 'CREATE UNIQUE INDEX '||V_INDEX||' ON '||V_TABLA||' (GPV_ID)';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Índice creado '||V_INDEX);	


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
