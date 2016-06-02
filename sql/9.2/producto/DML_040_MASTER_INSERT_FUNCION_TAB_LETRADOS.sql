--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.4-bk
--## INCIDENCIA_LINK=PRODUCTO-1274
--## PRODUCTO=SI
--##
--## Finalidad: Inser nueva funcion que permita ver pestaña LETRADOS del buscador asuntos
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''VER_TAB_LETRADOS_BUSCADOR_ASU''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe funcion: VER_TAB_LETRADOS_BUSCADOR_ASU');
	
	ELSE
	  V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval, ''Función que muestra el tab LETRADOS del buscador de asuntos'',''VER_TAB_LETRADOS_BUSCADOR_ASU'', 0,''PRODUCTO-1274'', sysdate, 0) ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('OK VER_TAB_LETRADOS_BUSCADOR_ASU INSERTADO en fun_funciones');
	
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
  	