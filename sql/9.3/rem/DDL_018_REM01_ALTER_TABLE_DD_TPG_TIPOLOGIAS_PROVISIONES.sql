--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200116
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9116
--## PRODUCTO=NO
--##
--## Finalidad: Crear clave única compuesta para la tabla DD_TPG_TIPOLOGIAS_PROVISIONES
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
    V_TABLA VARCHAR2(50 CHAR) := 'DD_TPG_TIPOLOGIAS_PROVISIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-9116';
    
    
 BEGIN
   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TABLA||' ADD CONSTRAINT UK_TPG_TGA_STG UNIQUE(DD_TPG_CODIGO, DD_TGA_ID, DD_STG_ID) ';
		EXECUTE IMMEDIATE V_SQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] CREADA CLAVE UNICA COMPUESTA');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[ERROR] ' || V_ESQUEMA || '.'||V_TABLA||'... No existe.');
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
