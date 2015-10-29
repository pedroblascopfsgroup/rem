--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.7-hy-rc01
--## INCIDENCIA_LINK=HR-1270
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
DECLARE
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
    -- ELIMINANDO FUNCIONES-PERFILES --
    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION IN(''ROLE_REVISAR_TAREA'',''ROLE_REVISAR_ALERTA'',''ROLE_REVISAR_NOTIFICACION'',''ROLE_REVISAR_ESPERA'')) AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO IN (''HAYAADMIN'',''HAYASUPVISOR'',''HAYAGEST'',''HAYAGESTEXT''))';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existen los valores
    IF V_NUM_TABLAS < 1 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Los valores no existen en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION IN(''ROLE_REVISAR_TAREA'',''ROLE_REVISAR_ALERTA'',''ROLE_REVISAR_NOTIFICACION'',''ROLE_REVISAR_ESPERA'')) AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO IN (''HAYAADMIN'',''HAYASUPVISOR'',''HAYAGEST'',''HAYAGESTEXT''))';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Funciones - Perfiles eliminados correctamente.');
	
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