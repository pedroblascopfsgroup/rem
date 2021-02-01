--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20201218
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8402
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-8402'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN		
	V_SQL := 'SELECT COUNT(*)
				FROM USER_TAB_COLS
				WHERE COLUMN_NAME = ''DD_SAC_ID''
				AND TABLE_NAME = ''ACT_CFD_CONFIG_DOCUMENTO''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INICIO] ADD COLUMN DD_SAC_ID');
		
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO ADD DD_SAC_ID NUMBER(16)';
	    EXECUTE IMMEDIATE V_MSQL;
    
        V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO.DD_SAC_ID IS ''FK refenciada ID subtipo activo''';
        EXECUTE IMMEDIATE V_MSQL;

        V_MSQL :='ALTER TABLE '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO ADD CONSTRAINT FK_DD_SAC_ID FOREIGN KEY (DD_SAC_ID) REFERENCES '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO (DD_SAC_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		
        DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA AÑADIDA');
		
	ELSE
		 DBMS_OUTPUT.PUT_LINE('[FIN] COLUMNA YA EXISTE');		
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