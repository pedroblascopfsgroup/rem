--/*
--##########################################
--## AUTOR=Manuel Mejias
--## FECHA_CREACION=20150605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.1-hy-rc01
--## INCIDENCIA_LINK=HR-905
--## PRODUCTO=SI
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ASU_ASUNTOS... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME=''ERROR_ENVIO_CDD'' AND TABLE_NAME=''ASU_ASUNTOS'' AND OWNER = ''' || V_ESQUEMA || '''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.ASU_ASUNTOS...no se modifica nada.');
	ELSE
	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ASU_ASUNTOS ADD ERROR_ENVIO_CDD NUMBER(1,0)'; 
				
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.ASU_ASUNTOS insertados correctamente.');
	
    END IF;	
    
    COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	