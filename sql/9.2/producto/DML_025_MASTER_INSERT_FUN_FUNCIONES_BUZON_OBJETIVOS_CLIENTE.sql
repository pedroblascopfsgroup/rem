--/*
--##########################################
--## AUTOR=Enrique_Badenes
--## FECHA_CREACION=20160503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK= PRODUCTO-1293
--## PRODUCTO=SI
--##
--## Finalidad: Insertar funciones "ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES" y "ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES" para permitir la elimicacion de las funciones restrictivas anteriores
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
		
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio insert en FUN_FUNCIONES...');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando la existencia del ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES');
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES');
	ELSE
	  V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Función que muestra el buzon objetivos pendientes'',''ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES'',''0'',''PRODUCTO-1293'',sysdate,''0'') ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado el ROLE_MOSTRAR_ARBOL_OBJETIVOS_PENDIENTES');
	END IF;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando la existencia del ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES');
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION= ''ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	IF V_NUM_TABLAS > 0 THEN
	  DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES');
	ELSE
	  V_MSQL:= 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES (FUN_ID, FUN_DESCRIPCION_LARGA,FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.nextval,''Función que muestra el buzon gestión clientes'',''ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES'',''0'',''PRODUCTO-1293'',sysdate,''0'') ';
	  EXECUTE IMMEDIATE V_MSQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado el ROLE_MOSTRAR_ARBOL_GESTION_CLIENTES');
	END IF;
	
	COMMIT;
	    
	DBMS_OUTPUT.PUT_LINE('[Fin] Script finalizado.');


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
  	