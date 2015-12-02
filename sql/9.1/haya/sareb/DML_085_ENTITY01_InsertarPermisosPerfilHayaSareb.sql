--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151021
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.8-hy-rc01
--## INCIDENCIA_LINK=HR-1336
--## PRODUCTO=NO
--##
--## Finalidad: Permisos perfil restringido SAREB
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
    
    --Valores de FUN_FUNCIONES cuyos IDs se insertarán en FUN_PEF
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    V_FUNCION T_FUNCION := T_FUNCION(   
	    'MENU-LIST-CLI', 'MENU-LIST-ASU', 'BUSQUEDA', 'MENU-LIST-CNT', 'TAB-CNT-EXP-ASU',
	    'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 
	    'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO','TAB_CLIENTE_HISTORICOS',
	    'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 
	    'TAB_CLIENTE_CIRBE', 'VER_TAB_GESTORES','SOLO_CONSULTA'
    ); 
    V_TMP_FUNCION VARCHAR2(150);
    
    PEF_ID NUMBER(16);
    FUN_ID NUMBER(16);
     
    
BEGIN	
	
	-- Si existe el perfil.
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASAREB''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
    IF V_NUM_TABLAS != 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] No existe el perfil HAYASAREB o hay varios perfiles HAYASAREB en la tabla '||V_ESQUEMA||'.PEF_PERFILES... no se modifica nada.');    	
    ELSE    	
       	V_SQL := 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASAREB''';
		EXECUTE IMMEDIATE V_SQL INTO PEF_ID;
    
    	DBMS_OUTPUT.PUT_LINE('[INFO] Eliminando permisos de HAYASAREB.');
    	V_MSQL_1 := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF' ||
					' WHERE PEF_ID ='||PEF_ID||'';    	
		EXECUTE IMMEDIATE V_MSQL_1;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Permisos de HAYASAREB eliminados correctamente.');
		DBMS_OUTPUT.PUT_LINE('[INFO] Insertando nuevos permisos para HAYASAREB.');
		
		FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      	LOOP
        	--V_TMP_FUNCION nos servirá para recorrer la lista de funciones a insertar.
      		V_TMP_FUNCION := V_FUNCION(I);
            
            V_SQL := 'SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION||''' ';
			EXECUTE IMMEDIATE V_SQL INTO FUN_ID;
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||V_TMP_FUNCION||''' ';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS != 1 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe en valor en la tabla ' || V_ESQUEMA_M || '.FUN_FUNCIONES... no se modifica nada');
			ELSE		
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
					' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
					'  VALUES ('||FUN_ID||','||PEF_ID||','||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''DD'', SYSDATE, 0)';
					DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION||'''');
				EXECUTE IMMEDIATE V_MSQL_1;
			END IF;
      	END LOOP;
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