--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20190115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2604
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-2604'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ALTER TABLA TMP_FUN_PEF');
	
	V_MSQL := 'SELECT COUNT(*) 
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''TFI''
				AND TABLE_NAME = ''TMP_FUN_PEF''';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
		
		V_MSQL := 'SELECT COUNT(*) 
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''FTI''
				AND TABLE_NAME = ''TMP_FUN_PEF''';
	
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;
		
		IF V_NUM_FILAS = 0 THEN
	
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_FUN_PEF
						ADD FTI VARCHAR2(1 CHAR)';
	
			EXECUTE IMMEDIATE V_MSQL;
	
			DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');
		END IF;
	
	ELSE
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_FUN_PEF
			   RENAME COLUMN TFI TO FTI';
	
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA RENOMBRADA');
	
	END IF;
 
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
