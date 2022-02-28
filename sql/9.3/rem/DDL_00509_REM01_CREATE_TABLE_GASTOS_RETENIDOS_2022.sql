--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17266
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'GASTOS_RETENIDOS_2022'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	  V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-17266';
    
    
 BEGIN
 
 	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	
	IF V_COUNT = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN 
		V_SQL := 'CREATE TABLE ' || V_ESQUEMA || '.'||V_TABLA||'
                    (
                      GPV_ID         		NUMBER(16)          NOT NULL
                      
                    )';
    EXECUTE IMMEDIATE V_SQL;
	        
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);		
	END IF;

  GRANT SELECT, INSERT, UPDATE, DELETE ON REM01.GASTOS_RETENIDOS_2022 TO PFSREM;

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
