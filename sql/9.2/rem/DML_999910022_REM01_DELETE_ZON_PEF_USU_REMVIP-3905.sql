--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.0
--## INCIDENCIA_LINK=REMVIP-3905
--## PRODUCTO=NO
--##
--## Finalidad: Script que elimina usuarios de los perfiles que aparecen en el T_ARRAY_USUARIO
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

    V_EXISTE_USUARIO NUMBER(16); -- Vble. para almacenar la busqueda del usuario.
    V_EXISTE_PERFIL NUMBER(16); -- Vble. para almacenar la busqueda de la perfil.
    V_EXISTE_RELACION NUMBER(16); -- Vble. para almacenar la busqueda de la relación usuario/perfil.

    V_ZON_ID NUMBER(16); -- Vble. para almacenar el id de la tabla ZON_PEF_USU con la relación usuario/perfil.

    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

    -- EDITAR NÚMERO DE ITEM
    V_ITEM VARCHAR2(20) := 'REMVIP-3905';

    -- EDITAR: FUNCIONES
    TYPE T_USUARIO IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_USUARIO IS TABLE OF T_USUARIO;
    V_USUARIO T_ARRAY_USUARIO := T_ARRAY_USUARIO(

        --         NOMBRE_USUARIO          NOMBRE_PERFIL
        T_USUARIO('03887362V'           , 'HAYAGESTPUBL'),
        T_USUARIO('03877533D'           , 'HAYAGESTPUBL'),
        T_USUARIO('buk.ggonzalez'       , 'HAYAGESTPUBL'),
        T_USUARIO('buk.enavarrete'      , 'HAYAGESTPUBL'),
        T_USUARIO('buk.jromero'         , 'HAYAGESTPUBL'),
        T_USUARIO('buk.vgomez'          , 'HAYAGESTPUBL'),
        T_USUARIO('buk.sgarcia'         , 'HAYAGESTPUBL'),
        T_USUARIO('buk.svazquez'        , 'HAYAGESTPUBL'),
        T_USUARIO('buk.bvilarrasa'      , 'HAYAGESTPUBL'),
        T_USUARIO('chuerta'             , 'HAYAGESTPUBL'),
        T_USUARIO('buk.pcapitanelli'    , 'HAYAGESTPUBL'),
        T_USUARIO('buk.jgutierrez'      , 'HAYAGESTPUBL'),
        T_USUARIO('asorianol'           , 'HAYAGESTPUBL'),
        T_USUARIO('merazo'              , 'HAYAGESTPUBL'),
        T_USUARIO('buk.vgomezm'         , 'HAYAGESTPUBL'),
        T_USUARIO('pmelero'             , 'HAYAGESTPUBL'),
        T_USUARIO('buk.jvilches'        , 'HAYAGESTPUBL'),
        T_USUARIO('buk.itrujillo'       , 'HAYAGESTPUBL'),
        T_USUARIO('lgalan'              , 'HAYAGESTPUBL'),
        T_USUARIO('buk.cporras'         , 'HAYAGESTPUBL'),
        T_USUARIO('buk.vmartin'         , 'HAYAGESTPUBL'),
        T_USUARIO('buk.dmolina'         , 'HAYAGESTPUBL')

    ); 
    V_TMP_USUARIO T_USUARIO;


BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.ZON_PEF_USU... Empezando a borrar datos en la tabla.');
    
    FOR I IN V_USUARIO.FIRST .. V_USUARIO.LAST 
    LOOP
        V_TMP_USUARIO := V_USUARIO(I);
       
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.USU_USUARIOS... Comprobamos que existe el usuario ' ||TRIM(V_TMP_USUARIO(1))||'.');
		
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS
                   WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||'''';

        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_USUARIO;

        IF V_EXISTE_USUARIO > 0 THEN 

            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... Comprobamos que existe el perfil ' ||TRIM(V_TMP_USUARIO(2))||'.');
		
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES
                       WHERE PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||'''';

            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_PERFIL;

            IF V_EXISTE_PERFIL > 0 THEN

                V_MSQL := 'SELECT COUNT(1) 
                           FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
                           INNER JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZON ON ZON.USU_ID = USU.USU_ID
                           INNER JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON ZON.PEF_ID = PEF.PEF_ID 
                           WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''' 
                           AND PEF.PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||'''';

                EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE_RELACION;

                DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_EXISTE_RELACION||'.');

                IF V_EXISTE_RELACION > 0 THEN

                    V_MSQL := 'SELECT ZON.ZON_ID 
                               FROM '||V_ESQUEMA||'.ZON_PEF_USU ZON
                               INNER JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_ID = ZON.PEF_ID
                               INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_ID = ZON.USU_ID 
                               WHERE USU.USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''' 
                               AND PEF.PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||'''';

                    EXECUTE IMMEDIATE V_MSQL INTO V_ZON_ID;                    

                    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ZON_PEF_USU
                               WHERE ZON_ID = '||V_ZON_ID||'';
                    --EXECUTE IMMEDIATE V_MSQL;

                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ZON_PEF_USU... Borrada la relación usuario/perfil satisfactoriamente.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ZON_PEF_USU... No se ha encontrado la relación entre el usuario '||TRIM(V_TMP_USUARIO(1))||' y el perfil '||TRIM(V_TMP_USUARIO(2))||'.');
                END IF;

            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PEF_PERFILES... No se ha encontrado el pefil '||TRIM(V_TMP_USUARIO(2))||'.');
            END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.USU_USUARIOS... No se ha encontrado al usuario '||TRIM(V_TMP_USUARIO(1))||'.');
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