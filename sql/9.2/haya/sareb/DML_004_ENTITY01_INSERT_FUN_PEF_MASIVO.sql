--/*
--##########################################
--## AUTOR=IVAN PICAZO
--## FECHA_CREACION=20160314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-857
--## PRODUCTO=SI
--## Finalidad: DML que inserta a los perfiles correspondientes, las funciones necesarias para habilitar el nuevo menú de Masivo.
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

	-- Se insertarán las funciones  MENU_MASIVO_GENERAL y PROCESADOR TAREAS con perfil ADMINISTRADOR en la tabla FUN_PEF

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	v_pef_cod VARCHAR2(100 CHAR):= 'HAYAADMIN';
    v_numero NUMBER(16);
  	
    V_ENTIDAD_ID NUMBER(16);
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
	
    	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobaciones previas');
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||v_pef_cod||''' ';
		EXECUTE IMMEDIATE V_SQL INTO v_numero;	
		
		IF v_numero > 0 THEN
		
			--Insercción Funcion MENU_MASIVO_GENERAL
    		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Comprobaciones previas'); 
   			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MENU_MASIVO_GENERAL'' ';
	    	EXECUTE IMMEDIATE V_SQL INTO v_numero;
	    
	    	IF v_numero > 0 THEN
		
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = ' ||
				' (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MENU_MASIVO_GENERAL'') ' ||
				' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||v_pef_cod||''') ';
				
				EXECUTE IMMEDIATE V_SQL INTO v_numero;
				
				IF v_numero = 0 THEN
				
			  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
							 ' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
							 ' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PRODUCTO-857'', SYSDATE, 0 '||
							 ' FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN, '||V_ESQUEMA||'.PEF_PERFILES PEF '||
							 ' WHERE FUN.FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''MENU_MASIVO_GENERAL'' ) '||
			         		 ' AND PEF.PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||v_pef_cod||''') ';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[FIN] Función MENU_MASIVO_GENERAL insertada en la tabla FUN_PEF ');
				
				ELSE 
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la función MENU_MASIVO_GENERAL con perfil PEF_CODIGO '''||v_pef_cod||''' en la tabla FUN_PEF');
				END IF;
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe la función MENU_MASIVO_GENERAL en la tabla FUN_FUNCIONES');
			END IF;
			
			--Insercción Funcion PROCESADO_TAREAS
    		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Comprobaciones previas'); 
   			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''PROCESADO_TAREAS'' ';
	    	EXECUTE IMMEDIATE V_SQL INTO v_numero;
	    
	    	IF v_numero > 0 THEN
		
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = ' ||
				' (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''PROCESADO_TAREAS'') ' ||
				' AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||v_pef_cod||''') ';
				
				EXECUTE IMMEDIATE V_SQL INTO v_numero;
				
				IF v_numero = 0 THEN
				
			  		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
							 ' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
							 ' SELECT FUN.FUN_ID, PEF.PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''PRODUCTO-857'', SYSDATE, 0 '||
							 ' FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN, '||V_ESQUEMA||'.PEF_PERFILES PEF '||
							 ' WHERE FUN.FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''PROCESADO_TAREAS'' ) '||
			         		 ' AND PEF.PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||v_pef_cod||''') ';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[FIN] Función PROCESADO_TAREAS insertada en la tabla FUN_PEF ');
				
				ELSE 
					DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la función PROCESADO_TAREAS con perfil PEF_CODIGO '''||v_pef_cod||''' en la tabla FUN_PEF');
				END IF;
			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No existe la función PROCESADO_TAREAS en la tabla FUN_FUNCIONES');
			END IF;
			
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe El Perfil con PEF_CODIGO '''||v_pef_cod||''' en la tabla PEF_PERFILES');
		
	END IF;
	
    COMMIT;
   

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
