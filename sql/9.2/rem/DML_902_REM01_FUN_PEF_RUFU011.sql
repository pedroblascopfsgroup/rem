--/*
--##########################################
--## AUTOR= Juan Beltrán
--## FECHA_CREACION=20190709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6821
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a un perfil o a todos los perfiles, las funciones añadidas en T_ARRAY_FUNCION
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

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    				-- Descripcion funcion 		-- Descripcion perfil
	T_FUNCION('MASIVO_CONTROL_TRIBUTOS', 'Super'),
	T_FUNCION('MASIVO_CONTROL_TRIBUTOS', 'Gestor de Administración'),
	T_FUNCION('MASIVO_CONTROL_TRIBUTOS', 'Gestoría de administración'),
	T_FUNCION('MASIVO_CONTROL_TRIBUTOS', 'Supervisor de Administración')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
			
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            
            V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.FUN_PEF ' ||
					' WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''') ' ||
					' AND PEF_ID = (SELECT FUN_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(2))||''' )';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS = 0 THEN	
				V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
							' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT FUN.FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''HREOS-6821'', SYSDATE, 0' ||
							' FROM '||V_ESQUEMA||'.PEF_PERFILES, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
							' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' AND PEF_DESCRIPCION LIKE ('''||TRIM(V_TMP_FUNCION(2))||''') ';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');
			ELSE
				DBMS_OUTPUT.PUT_LINE('El perfil ya existe para esta funcion');
			END IF;
			

      END LOOP;
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
