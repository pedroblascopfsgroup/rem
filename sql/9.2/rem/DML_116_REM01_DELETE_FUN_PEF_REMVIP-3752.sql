--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190326
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=REMVIP-3752
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

    V_FP_ID NUMBER(16); -- Vble. para almacenar el id de la tabla FUN_PEF con la relación perfil/función.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-3752';

    -- EDITAR: FUNCIONES
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(

        --         NOMBRE_FUNCION                                NOMBRE_PERFIL
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'FVDBACKOFERTA'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'FVDBACKVENTA'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'FVDNEGOCIO'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESMIN'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESPROV'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESRES'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GESTIAFORM'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESTIAFORM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GESTOADM'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESTOADM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GESTOCED'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESTOCED'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GESTOPDV'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESTOPDV'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GESTOPLUS'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GESTOPLUS'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'GTOPOSTV'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'GTOPOSTV'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAADM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYACAL'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYACAL'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYACERTI'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYACONSU'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAFSV'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGBOFIN'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGBOINM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYAGESTADM'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTADM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYAGESTADMT'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTADMT'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTCOM'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTCOMRET'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTCOMSIN'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTFORM'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGESTPREC'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAGOLDTREE'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYALLA'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYALLA'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYAPROV'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASADM'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASBOFIN'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASBOINM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYASLLA'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASLLA'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYASUPACT'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPACT'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYASUPADM'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPADM'),
  
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'HAYASUPCAL'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPCAL'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPCOM'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPCOMRET'),
  
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPCOMSIN'),
  
        /*T_FUNCION('SUBIR_CARGA_GESTORES'                      ,   'HAYASUPER'),
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPER'),*/
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPFORM'),
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPPREC'),
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'HAYASUPPUBL'),
 
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'PERFGCCBANKIA'),
 
        T_FUNCION('SUBIR_CARGA_GESTORES'                        , 'PERFGCCLIBERBANK'),
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'SUPFVD'),
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'SUPMIN'),
 
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'SUPRES'),
        
        T_FUNCION('PERIMETRO_ACTUALIZAR'                        , 'VALORACIONES'),

        T_FUNCION('PERIMETRO_ACTUALIZAR'                        ,'HAYAGESACT'),
        T_FUNCION('SUBIR_CARGA_GESTORES'                        ,'HAYAGESACT'),

        T_FUNCION('PERIMETRO_ACTUALIZAR'                        ,'HAYAGESTPUBL')

    ); 
    V_TMP_FUNCION T_FUNCION;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Empezando a borrar datos en la tabla.');
    
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

                DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_EXISTE_RELACION||'.');

                IF V_EXISTE_RELACION > 0 THEN

                    V_MSQL := 'SELECT FPEF.FP_ID FROM '||V_ESQUEMA||'.PEF_PERFILES PEF
                               INNER JOIN '||V_ESQUEMA||'.FUN_PEF FPEF ON FPEF.PEF_ID = PEF.PEF_ID
                               INNER JOIN '||V_ESQUEMA_M||'.FUN_FUNCIONES FUN ON FUN.FUN_ID = FPEF.FUN_ID 
                               WHERE FUN.FUN_DESCRIPCION = '''||TRIM(V_TMP_FUNCION(1))||''' 
                               AND PEF.PEF_CODIGO = '''||TRIM(V_TMP_FUNCION(2))||'''';

                    EXECUTE IMMEDIATE V_MSQL INTO V_FP_ID;                    

                    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF
                               WHERE FP_ID = '||V_FP_ID||'';
                    EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... Borrada la relación perfil/función satisfactoriamente.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.FUN_PEF... No se ha encontrado la relación entre el perfil '||TRIM(V_TMP_FUNCION(2))||' y la función '||TRIM(V_TMP_FUNCION(1))||'.');
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
          ROLLBACK;
          RAISE;   
END;
/
EXIT;