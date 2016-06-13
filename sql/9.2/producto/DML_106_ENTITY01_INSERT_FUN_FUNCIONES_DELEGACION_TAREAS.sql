--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20160516
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1414
--## PRODUCTO=SI
--## Finalidad: Insertar nueva función
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
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

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE FUN_DESCRIPCION= ''DELEGAR-MIS-TAREAS''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro DELEGAR-MIS-TAREAS en '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'Insert into '||V_ESQUEMA_M||'.'||V_DDNAME||' '||
	  '(FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values '||
	  '('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Delegar mis tareas'',''DELEGAR-MIS-TAREAS'',''0'',''DML'',sysdate,''0'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK insertado DELEGAR-MIS-TAREAS');

	END IF;
	
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE FUN_DESCRIPCION= ''DELEGAR-CUALQUIER-TAREAS''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro DELEGAR-CUALQUIER-TAREAS en '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'Insert into '||V_ESQUEMA_M||'.'||V_DDNAME||' '||
	  '(FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values '||
	  '('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Delegar las tareas de cualquier usuario'',''DELEGAR-CUALQUIER-TAREAS'',''0'',''DML'',sysdate,''0'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK insertado DELEGAR-MIS-TAREAS');

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
  	