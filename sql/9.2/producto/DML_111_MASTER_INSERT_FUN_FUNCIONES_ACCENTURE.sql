--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=RECOVERY-2095
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_DDNAME VARCHAR2(30):= 'FUN_FUNCIONES';
BEGIN	

    
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.'||V_DDNAME||' WHERE FUN_DESCRIPCION= ''ROLE_PUEDE_VER_OBSERVACIONES_EDP''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN    
	  DBMS_OUTPUT.PUT_LINE('OK no se modifica nada.');
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro ROLE_PUEDE_VER_OBSERVACIONES_EDP en '||V_DDNAME||'.');
	
	ELSE
	
	  execute immediate 'Insert into '||V_ESQUEMA_M||'.'||V_DDNAME||' '||
	  '(FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) values '||
	  '('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Función que permite ver las observaciones en incluir y editar documento del precontencioso'',''ROLE_PUEDE_VER_OBSERVACIONES_EDP'',''0'',''RECOVERY-2095'',sysdate,''0'') ';
	
	  DBMS_OUTPUT.PUT_LINE('OK modificado');
	
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
  	