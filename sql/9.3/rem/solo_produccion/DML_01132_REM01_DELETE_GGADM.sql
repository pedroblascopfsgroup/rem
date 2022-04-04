--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20220217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11104
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tabla config gestores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master    
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-11104'; -- USUARIOCREAR/USUARIOMODIFICAR


    V_USU_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
     V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --          ACT_NUM_ACTIVO
            T_TIPO_DATA('6076025'),
            T_TIPO_DATA('6075893'),
            T_TIPO_DATA('6346457'),
            T_TIPO_DATA('6084348'),
            T_TIPO_DATA('6530085'),
            T_TIPO_DATA('6694804'),
            T_TIPO_DATA('6711298'),
            T_TIPO_DATA('6135295'),
            T_TIPO_DATA('6135046'),
            T_TIPO_DATA('6135574'),
            T_TIPO_DATA('6078576'),
            T_TIPO_DATA('6811671'),
            T_TIPO_DATA('6823482'),
            T_TIPO_DATA('6823411'),
            T_TIPO_DATA('6787694'),
            T_TIPO_DATA('6811690'),
            T_TIPO_DATA('6780627'),
            T_TIPO_DATA('6028574'),
            T_TIPO_DATA('6031752'),
            T_TIPO_DATA('6031310'),
            T_TIPO_DATA('6036724'),
            T_TIPO_DATA('6031388'),
            T_TIPO_DATA('6032953'),
            T_TIPO_DATA('6033593'),
            T_TIPO_DATA('6038840'),
            T_TIPO_DATA('6038841'),
            T_TIPO_DATA('6034156'),
            T_TIPO_DATA('6034165'),
            T_TIPO_DATA('6030754'),
            T_TIPO_DATA('6041088'),
            T_TIPO_DATA('6034630'),
            T_TIPO_DATA('6034631'),
            T_TIPO_DATA('6034633'),
            T_TIPO_DATA('6034634'),
            T_TIPO_DATA('6034328'),
            T_TIPO_DATA('6747310'),
            T_TIPO_DATA('6747354'),
            T_TIPO_DATA('6747446'),
            T_TIPO_DATA('6747382'),
            T_TIPO_DATA('6747322'),
            T_TIPO_DATA('6747416'),
            T_TIPO_DATA('6747403'),
            T_TIPO_DATA('6028754'),
            T_TIPO_DATA('6040318'),
            T_TIPO_DATA('6840184'),
            T_TIPO_DATA('6811797'),
            T_TIPO_DATA('6747402'),
            T_TIPO_DATA('6075896'),
            T_TIPO_DATA('6529743'),
            T_TIPO_DATA('6711374'),
            T_TIPO_DATA('6033594'),
            T_TIPO_DATA('6934587'),
            T_TIPO_DATA('6840292'),
            T_TIPO_DATA('6957196'),
            T_TIPO_DATA('7014350'),
            T_TIPO_DATA('7073279'),
            T_TIPO_DATA('6843521'),
            T_TIPO_DATA('6747379'),
            T_TIPO_DATA('7433022'),
            T_TIPO_DATA('6941652'),
            T_TIPO_DATA('7433020'),
            T_TIPO_DATA('7433029'),
            T_TIPO_DATA('7433019'),
            T_TIPO_DATA('7298430'),
            T_TIPO_DATA('7433122'),
            T_TIPO_DATA('7465013'),
            T_TIPO_DATA('6525239'),
            T_TIPO_DATA('7032086'),
            T_TIPO_DATA('6957218'),
            T_TIPO_DATA('6747328'),
            T_TIPO_DATA('6039961'),
            T_TIPO_DATA('6762768')
        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    DBMS_OUTPUT.PUT_LINE('[INFO] PONER FECHA FIN DE GESTORIA ADMISION DE ACTIVOS'); 

    V_MSQL :=   'UPDATE GEH_GESTOR_ENTIDAD_HIST T1
                SET   T1.GEH_FECHA_HASTA = SYSDATE,		     
                      T1.FECHAMODIFICAR = SYSDATE,
                      T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                WHERE T1.GEH_ID = (SELECT DISTINCT GEH.GEH_ID
                    FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                    INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                    INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID AND GEH.USU_ID = GEE.USU_ID
                    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID	
                    WHERE  ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
                    AND TGE.DD_TGE_CODIGO = ''GGADM''
                    AND GEH.GEH_FECHA_HASTA IS NULL
                    )';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEH_GESTOR_ENTIDAD_HIST');  

     V_MSQL :=   'UPDATE GEE_GESTOR_ENTIDAD T1				
                        SET	 T1.BORRADO = 1,	     
                             T1.FECHABORRAR = SYSDATE,
                             T1.USUARIOBORRAR ='''||V_USUARIO||'''
                        WHERE T1.GEE_ID = (SELECT DISTINCT GEE.GEE_ID
                            FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
                            INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
                            INNER JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID AND GEH.USU_ID = GEE.USU_ID
                            INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
                            INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
                            INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
                            INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID	
                            WHERE  ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'
                           AND TGE.DD_TGE_CODIGO = ''GGADM''
                           AND GEE.BORRADO = 0
                           )';
    EXECUTE IMMEDIATE V_MSQL;

     DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO EL GESTOR DE ADMISION PARA EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' EN GEE_GESTOR_ENTIDAD'); 

    END LOOP;   


    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;

END;

/

EXIT