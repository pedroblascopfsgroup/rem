--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=REMVIP-3982
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade a uno varios perfiles, las funciones añadidas en T_ARRAY_PERFIL
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

    V_FP_ID NUMBER(16); -- Vble. para almacenar el id de la tabla FUN_PEF con la relación perfil/función.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-3982';

    -- EDITAR: FUNCIONES
    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PERFIL IS TABLE OF T_PERFIL;
    V_PERFIL T_ARRAY_PERFIL := T_ARRAY_PERFIL(

        --        CODIGO_NUEVO_PERFIL
        T_PERFIL('HAYAADMCARGASGESTACT')
    ); 
    V_TMP_PERFIL T_PERFIL;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.PEF_PERFILES... Empezando a insertar datos en la tabla.');
    
    FOR I IN V_PERFIL.FIRST .. V_PERFIL.LAST 
    LOOP
        V_TMP_PERFIL := V_PERFIL(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobamos que existe el perfil ' ||TRIM(V_TMP_PERFIL(1))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES
                   WHERE PEF_CODIGO = '''||TRIM(V_TMP_PERFIL(1))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_PERFIL;

        IF V_EXISTE_PERFIL = 0 THEN 

            V_MSQL :=  'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (
                          PEF_ID
                        , PEF_DESCRIPCION_LARGA
                        , PEF_DESCRIPCION
                        , VERSION
                        , USUARIOCREAR
                        , FECHACREAR
                        , PEF_CODIGO
                        , PEF_ES_CARTERIZADO
                        , DTYPE
                        ) VALUES (
                            S_PEF_PERFILES.NEXTVAL
                            , ''Gestor de admisión de cargas de activos''
                            , ''Gestor de admisión de cargas de activos''
                            , 0
                            , '''||V_ITEM||'''
                            , SYSDATE
                            , '''||TRIM(V_TMP_PERFIL(1))||'''
                            , 0
                            , ''EXTPerfil''
                        )';

            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Insertado el perfil '||TRIM(V_TMP_PERFIL(1))||' satisfactoriamente.');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... No se hace nada, se ha encontrado el perfil '||TRIM(V_TMP_PERFIL(1))||'.');
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