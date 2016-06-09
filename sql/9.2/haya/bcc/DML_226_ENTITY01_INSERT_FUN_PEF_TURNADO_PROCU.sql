--/*
--##########################################
--## AUTOR=Enrique Badenes
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.6
--## INCIDENCIA_LINK= PRODUCTO-1366
--## PRODUCTO=NO
--##
--## Finalidad: Insertar funcion VER_TAB_BUSCADOR_TURNADO_PROCU al perfil 
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
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    
	
	V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''CENTROPROCURA''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''VER_TAB_BUSCADOR_TURNADO_PROCU''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS2;
		
		IF V_NUM_TABLAS2 > 0 THEN
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (FUN_ID,PEF_ID,FP_ID,USUARIOCREAR,FECHACREAR,BORRADO)(SELECT(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''VER_TAB_BUSCADOR_TURNADO_PROCU'') AS FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL AS PF_ID, ''PRODUCTO-1366'',SYSDATE,''0'' FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''CENTROPROCURA'')';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('OK INSERTADO');
		ELSE
		 	DBMS_OUTPUT.PUT_LINE('NO EXISTE LA FUNCION');		
		END IF;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('NO EXISTE EL PERFIL');
	
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
  	