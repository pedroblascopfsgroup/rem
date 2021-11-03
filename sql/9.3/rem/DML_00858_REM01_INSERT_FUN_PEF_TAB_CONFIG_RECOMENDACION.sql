--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210830
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14969
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_FUNCION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);

    V_EXISTE_PERFIL NUMBER(16); -- Vble. para almacenar la busqueda del perfil.
    V_EXISTE_FUNCION NUMBER(16); -- Vble. para almacenar la busqueda de la función.
    V_EXISTE_RELACION NUMBER(16); -- Vble. para almacenar la busqueda de la relación perfil/función.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'HREOS-14969';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

        --         NOMBRE_FUNCION                       		NOMBRE_PERFIL
        T_FUNCION('TAB_CONFIG_RECOMENDACION',		'HAYASUPER')

    ); 
    V_TMP_FUNCION T_FUNCION;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Empezando a insertar datos en la tabla.');
    
    FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST 
    LOOP
        V_TMP_FUNCION := V_FUNCION(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobamos que existe el perfil ' ||TRIM(V_TMP_FUNCION(2))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES
                   WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_PERFIL;

        IF V_EXISTE_PERFIL > 0 THEN 

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... Comprobamos que existe la función ' ||TRIM(V_TMP_FUNCION(1))||'.');
		
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES
                       WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_FUNCION;

            IF V_EXISTE_FUNCION > 0 THEN

                V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES PEF
                           INNER JOIN '||V_ESQUEMA||'.FUN_PEF FPEF ON FPEF.PEF_ID = PEF.PEF_ID
                           INNER JOIN '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN ON FUN.FUN_ID = FPEF.FUN_ID 
                           WHERE FUN.FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' 
                           AND PEF.PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

                EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_RELACION;

                IF V_EXISTE_RELACION = 0 THEN

                    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.FUN_PEF (
                                 FUN_ID
                               , PEF_ID
                               , FP_ID
                               , USUARIOCREAR
                               , FECHACREAR
                               ) VALUES (
                                      (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES
                                       WHERE FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''')
                                    , (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES
                                       WHERE PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||''')
                                    , S_FUN_PEF.NEXTVAL
                                    , '''||V_ITEM||'''
                                    , SYSDATE
                               )';

                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Insertada la relación perfil/función satisfactoriamente.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Se ha encontrado la relación entre el perfil '||TRIM(V_TMP_FUNCION(2))||' y la función '||TRIM(V_TMP_FUNCION(1))||'.');
                END IF;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... No se ha encontrado la función '||TRIM(V_TMP_FUNCION(1))||'.');
            END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_FUNCIONES... No se ha encontrado al perfil '||TRIM(V_TMP_FUNCION(2))||'.');
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
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
