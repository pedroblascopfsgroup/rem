--/*
--##########################################
--## AUTOR=Nacho A
--## FECHA_CREACION=20150926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.5-hy-rc03
--## INCIDENCIA_LINK=HR-849
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
	-- ELIMINANDO PERMISOS --
	V_MSQL_1 := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF ' ||
					' WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''EDIT_GESTORES'') ' ||
					' AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO IN (''HAYAGEST'',''HAYAGESTEXT''))';
    	
	EXECUTE IMMEDIATE V_MSQL_1;
	DBMS_OUTPUT.PUT_LINE('[INFO] Eliminados los permisos.');
	
    -- INSERTANDO PERMISOS --
    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ASU_GESTOR_SOLOPROPIAS'') ' ||
    		 ' AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO IN (''HAYAGEST'',''HAYAGESTEXT''))';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ASU_GESTOR_SOLOPROPIAS'' AND PEF.PEF_CODIGO IN '||
					' (''HAYAGEST'',''HAYAGESTEXT'')';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ASU_GESTOR_SOLOPROPIAS insertado correctamente.');
	
    END IF;	
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ASU_GESTOR_SOLOPROPIAS_ADIC'')' ||
			' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTEXT'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ASU_GESTOR_SOLOPROPIAS_ADIC'' AND PEF.PEF_CODIGO IN '||
					' (''HAYAGESTEXT'')';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ASU_GESTOR_SOLOPROPIAS_ADIC insertado correctamente.');
	
    END IF;	
    
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ASU_PROCURADOR_SOLOPROPIAS_ADIC'')' ||
			' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYAGESTEXT'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ASU_PROCURADOR_SOLOPROPIAS_ADIC'' AND PEF.PEF_CODIGO IN '||
					' (''HAYAGESTEXT'')';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ASU_PROCURADOR_SOLOPROPIAS_ADIC insertado correctamente.');
	
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
