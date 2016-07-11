--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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
       T_FUNCION('OPTIMIZACION_BUZON_TAREAS', 	'HAYACERTI'),
       T_FUNCION('MENU_DASHBOARD', 'HAYACERTI'),
       T_FUNCION('MENU_AGENDA', 'HAYACERTI'),
       T_FUNCION('MENU_ACTIVOS', 'HAYACERTI'),
       T_FUNCION('MENU_AGRUPACIONES', 'HAYACERTI'),
       T_FUNCION('MENU_TRABAJOS', 'HAYACERTI'),
       T_FUNCION('MENU_MASIVO', 'HAYACERTI'),
       T_FUNCION('TAB_ACTIVO_ADMISION', 'HAYACERTI'),
       T_FUNCION('TAB_ACTIVO_GESTION', 'HAYACERTI'),
       T_FUNCION('TAB_ACTIVO_GESTORES', 'HAYACERTI'),
       T_FUNCION('TAB_ACTIVO_DATOS_BASICOS', 'HAYACERTI'),
       T_FUNCION('TAB_ACTIVO_ACTUACIONES', 'HAYACERTI')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_PERFILES VARCHAR2(100 CHAR) := '%';  -- Cambiar por ALGÚN PERFIL para otorgar permisos a ese perfil.
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'DELETE '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''') AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||''')';
			EXECUTE IMMEDIATE V_SQL;

			V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
						' (FP_ID, PEF_ID, FUN_ID, USUARIOCREAR, FECHACREAR, BORRADO)' || 
						' SELECT '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL,' ||
						' (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''),' ||
						' (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||'''),' ||
						' ''DML'',SYSDATE,0 FROM DUAL'; 	
						
							
			EXECUTE IMMEDIATE V_MSQL_1;
			DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');
		
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