--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16796
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a un perfil o a todos los perfiles, las funciones añadidas en T_ARRAY_FUNCION.
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
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error

    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    TYPE T_ARRAY_PERFILES IS TABLE OF T_PERFIL;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
      T_FUNCION('CARGA_MASIVA_INSCRIPCIONES')); 
    V_TMP_FUNCION T_FUNCION;
    V_TMP_PERFIL T_PERFIL;
    -- ARRAY DE PERFILES para otorgales los permisos o '%'
    V_PERFILES T_ARRAY_PERFILES := T_ARRAY_PERFILES(
      T_PERFIL('HAYAGESTADM'), -- Gestor de admisión.
      T_PERFIL('HAYASUPADM'), -- Supervisor de admisión.
      T_PERFIL('HAYASUPER') -- SUPER.
    );   
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN	
    -- LOOP Insertando valores en FUN_PEF
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
    	LOOP
            V_TMP_FUNCION := V_FUNCION(I);
            
            FOR I IN V_PERFILES.FIRST .. V_PERFILES.LAST
      			LOOP
            		
      				V_TMP_PERFIL := V_PERFILES(I);            
            		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_PERFIL(1))||''') AND FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''')';
					
            		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
					-- Si existe la FUNCION PARA EL PERFIL
					IF V_NUM_TABLAS > 0 THEN				
						DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.FUN_FUNCIONES... Ya existe la funcion '''|| TRIM(V_TMP_FUNCION(1))||'''');
					ELSE
						V_MSQL_1 := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF' ||
							' (FUN_ID, PEF_ID, FP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' || 
							' SELECT FUN.FUN_ID, PEF_ID, '||V_ESQUEMA||'.S_FUN_PEF.NEXTVAL, 0, ''HREOS-16796'', SYSDATE, 0' ||
							' FROM '||V_ESQUEMA||'.PEF_PERFILES, '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN' ||
							' WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' AND PEF_CODIGO LIKE ('''||TRIM(V_TMP_PERFIL(1))||''') ';
		    	
						EXECUTE IMMEDIATE V_MSQL_1;
					END IF;
					DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.FUN_PEF insertados correctamente.');		
				END LOOP;
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
