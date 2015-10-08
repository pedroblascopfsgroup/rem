--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20151005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.6-rc07
--## INCIDENCIA_LINK=HR-1250
--## PRODUCTO=NO
--##
--## Finalidad: Insertar en el perfil de haya FPFSRFUNSUPER el permiso para FUNCION_SUPERVISOR
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
    V_FUNCTION VARCHAR(150 CHAR); -- Vble. para el codigo de la funcion.
    V_PERFIL VARCHAR(150 CHAR); -- Vble. para el codigo del perfil.
BEGIN	
    
	V_FUNCTION := 'FUNCION_SUPERVISOR';
	V_PERFIL := 'HAYAGESTCONC';
	
    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_FUNCTION||''')';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe los valores
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.FUN_PEF...no se modifica nada.');
	ELSE
		V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0' ||
					' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
					' WHERE FUN.FUN_DESCRIPCION = '''||V_FUNCTION||''' AND PEF.PEF_CODIGO = '''||V_PERFIL||'''';
    	
		EXECUTE IMMEDIATE V_MSQL_1;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');
	
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
