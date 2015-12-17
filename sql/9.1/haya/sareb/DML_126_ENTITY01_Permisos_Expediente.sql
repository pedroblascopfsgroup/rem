--/*
--##########################################
--## AUTOR=Nacho Arcos
--## FECHA_CREACION=20151216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-hy-rc03
--## INCIDENCIA_LINK=HR-1601
--## PRODUCTO=NO
--## Finalidad: DML Añadir permisos a los perfiles de Haya
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
    V_MSQL_1 VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR); 	-- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); 	-- Vble. para validar la existencia de una tabla.     
   	PEF_ID NUMBER(16);			-- Vble. auxiliar para almacenar id del perfil.
    FUN_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la función.
    ZON_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de la zona.
    USU_ID NUMBER(16);			-- Vble. auxiliar para almacenar id de usuario
    TYPE ARRAY_T IS TABLE OF VARCHAR2(250 CHAR);
    A_PERFILES ARRAY_T;			-- Vble. auxiliar para almacenar usuarios a modificar.
       
BEGIN
	
     -- INSERTANDO PERMISOS --
    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MENU_ACC_MULTIPLES_SUBASTA'') ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''MENU_ACC_MULTIPLES_SUBASTA'' ';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso MENU_ACC_MULTIPLES_SUBASTA insertado correctamente.');
	
    END IF;
    
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_CLIENTES'') ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_CLIENTES'' ';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ROLE_PUEDE_VER_TAB_EXP_CLIENTES insertado correctamente.');
	
    END IF;	
    
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_TITULOS'') ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_TITULOS'' ';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ROLE_PUEDE_VER_TAB_EXP_TITULOS insertado correctamente.');
	
    END IF;	
    
     V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_GESTION'') ';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_GESTION'' ';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permiso ROLE_PUEDE_VER_TAB_EXP_GESTION insertado correctamente.');
	
    END IF;	
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION IN (''TAB_PRECONTENCIOSO_DOC_BTN'', ''TAB_PRECONTENCIOSO_LIQ_BTN'', ''TAB_PRECONTENCIOSO_BUR_BTN'')) ' ||
    		 ' AND PEF_ID IN (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO IN (''FULLPRECON''))';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION IN (''TAB_PRECONTENCIOSO_DOC_BTN'', ''TAB_PRECONTENCIOSO_LIQ_BTN'', ''TAB_PRECONTENCIOSO_BUR_BTN'')'||
					' AND PEF.PEF_CODIGO IN (''FULLPRECON'')';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Permisos Botones precontencioso insertados correctamente.');
	
    END IF;	
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION     
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE; 
END;
/
 
EXIT; 
