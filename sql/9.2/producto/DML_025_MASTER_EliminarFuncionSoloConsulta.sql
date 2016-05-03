--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160421
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.8-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-1253
--## PRODUCTO=SI
--##
--## Finalidad: Eliminar la funcionalidad SOLO_CONSULTA
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
    V_DDNAME VARCHAR2(30):= 'FUN_FUNCIONES';
BEGIN	

	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''SOLO_CONSULTA''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	
		DBMS_OUTPUT.PUT_LINE('Se elimina la relacion función_perfil SOLO_CONSULTA.');
	
		V_MSQL_1:= 'DELETE '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''SOLO_CONSULTA'')';
		EXECUTE IMMEDIATE V_MSQL_1;
	
	  	DBMS_OUTPUT.PUT_LINE('Se elimina la función SOLO_CONSULTA.');
	  
	  	V_MSQL_1:= 'DELETE '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''SOLO_CONSULTA''';
		EXECUTE IMMEDIATE V_MSQL_1;

	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe SOLO_CONSULTA en FUN_FUNCIONES.');
	
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
  	