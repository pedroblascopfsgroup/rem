--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170710
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2089
--## PRODUCTO=NO
--##
--## Finalidad: Script que para crear la función SUBIR_LISTA_ACTIVOS_IBI y las asigna a los perfiles de 'HAYASUPER'.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
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
  	
    V_MSQL_1 VARCHAR2(4000 CHAR);
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    --			Descripción Larga														Descripción
      T_FUNCION('Permitir subir excel masivo para marcar/desmarcar la exención del IBI en el activo.',			'SUBIR_LISTA_ACTIVOS_IBI')
    ); 
    V_TMP_FUNCION T_FUNCION;

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_FUNCIONES... EMPEZANDO A INSERTAR FUNCIONES');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
        V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_FUN_FUNCIONES.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN				
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(2))||'''');
			ELSE		
				V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.FUN_FUNCIONES (' ||
						'FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						'SELECT '|| V_ENTIDAD_ID || ','''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||''','||
						'0, ''HREOS-2089'',SYSDATE,0 FROM DUAL';
				DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_FUNCION(1)||''','''||TRIM(V_TMP_FUNCION(2))||'''');
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
      END LOOP;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... DATOS INSERTADOS.');

    
    
    
    
    
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF...  EMPEZANDO A INSERTAR DATOS EN LA TABLA');

    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            
            V_SQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||''')';
			EXECUTE IMMEDIATE V_SQL;

			V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
						' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT FUN.FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''HREOS-1983'', SYSDATE, 0' ||
						' FROM '||V_ESQUEMA||'.PEF_PERFILES PEF, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
						' WHERE FUN.FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||''' AND PEF.PEF_CODIGO IN (''HAYASUPER'')';
	    	
			EXECUTE IMMEDIATE V_MSQL_1;
      END LOOP;
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] DATOS DE LA TABLA '||V_ESQUEMA||'.FUN_PEF INSERTADOS CORRECTAMENTE.');
    
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
  	