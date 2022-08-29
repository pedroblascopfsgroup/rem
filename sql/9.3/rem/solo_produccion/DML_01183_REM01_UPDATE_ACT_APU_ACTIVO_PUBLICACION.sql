--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220829
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12329
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar publicación de activos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 

DECLARE


    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-12329';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTADO_PUBLICACION NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA(5951601),
            T_TIPO_DATA(7096432),
            T_TIPO_DATA(7432780),
            T_TIPO_DATA(5925457),
            T_TIPO_DATA(5929797),
            T_TIPO_DATA(5933338),
            T_TIPO_DATA(5943426),
            T_TIPO_DATA(5944647),
            T_TIPO_DATA(5966042),
            T_TIPO_DATA(5930347),
            T_TIPO_DATA(6758720),
            T_TIPO_DATA(5951070),
            T_TIPO_DATA(6763573),
            T_TIPO_DATA(6801437),
            T_TIPO_DATA(6775903),
            T_TIPO_DATA(6788197),
            T_TIPO_DATA(6796986),
            T_TIPO_DATA(6060606),
            T_TIPO_DATA(6814540),
            T_TIPO_DATA(6814539),
            T_TIPO_DATA(5945667),
            T_TIPO_DATA(5969248),
            T_TIPO_DATA(6814476),
            T_TIPO_DATA(5940661),
            T_TIPO_DATA(6747456),
            T_TIPO_DATA(6943722),
            T_TIPO_DATA(6815791),
            T_TIPO_DATA(6054830),
            T_TIPO_DATA(6818295),
            T_TIPO_DATA(5935305),
            T_TIPO_DATA(5926048),
            T_TIPO_DATA(5940726),
            T_TIPO_DATA(5944274),
            T_TIPO_DATA(6062124),
            T_TIPO_DATA(7076247),
            T_TIPO_DATA(7089074),
            T_TIPO_DATA(7089374),
            T_TIPO_DATA(6934364),
            T_TIPO_DATA(7099597),
            T_TIPO_DATA(6995286),
            T_TIPO_DATA(6994950),
            T_TIPO_DATA(6995084),
            T_TIPO_DATA(6978769),
            T_TIPO_DATA(6941621),
            T_TIPO_DATA(6965190),
            T_TIPO_DATA(6966400),
            T_TIPO_DATA(6996532),
            T_TIPO_DATA(6965754),
            T_TIPO_DATA(7296747),
            T_TIPO_DATA(7296829),
            T_TIPO_DATA(6966893),
            T_TIPO_DATA(6966910),
            T_TIPO_DATA(7294372),
            T_TIPO_DATA(6966986),
            T_TIPO_DATA(6980902),
            T_TIPO_DATA(7002204),
            T_TIPO_DATA(7300357),
            T_TIPO_DATA(7300353),
            T_TIPO_DATA(7001949),
            T_TIPO_DATA(7300560),
            T_TIPO_DATA(7300802),
            T_TIPO_DATA(7092369),
            T_TIPO_DATA(7092358),
            T_TIPO_DATA(7092343),
            T_TIPO_DATA(7092357),
            T_TIPO_DATA(7092372),
            T_TIPO_DATA(7092370),
            T_TIPO_DATA(7092383),
            T_TIPO_DATA(7386207),
            T_TIPO_DATA(7386198),
            T_TIPO_DATA(7423615),
            T_TIPO_DATA(7432553),
            T_TIPO_DATA(7434825),
            T_TIPO_DATA(6986238),
            T_TIPO_DATA(7074947),
            T_TIPO_DATA(6988053),
            T_TIPO_DATA(6989751),
            T_TIPO_DATA(6991160),
            T_TIPO_DATA(6991161),
            T_TIPO_DATA(6991162),
            T_TIPO_DATA(6991163),
            T_TIPO_DATA(6991164),
            T_TIPO_DATA(6991165),
            T_TIPO_DATA(6991166),
            T_TIPO_DATA(6991191),
            T_TIPO_DATA(6991192),
            T_TIPO_DATA(6991193),
            T_TIPO_DATA(6991194),
            T_TIPO_DATA(6991195),
            T_TIPO_DATA(6991196),
            T_TIPO_DATA(6991197),
            T_TIPO_DATA(6991198),
            T_TIPO_DATA(6991223),
            T_TIPO_DATA(6991224),
            T_TIPO_DATA(6991225),
            T_TIPO_DATA(6991226),
            T_TIPO_DATA(6991227),
            T_TIPO_DATA(6991228),
            T_TIPO_DATA(6991229),
            T_TIPO_DATA(6991230),
            T_TIPO_DATA(6991255),
            T_TIPO_DATA(6991256),
            T_TIPO_DATA(6991257),
            T_TIPO_DATA(6991258),
            T_TIPO_DATA(6991259),
            T_TIPO_DATA(6991260),
            T_TIPO_DATA(6991261),
            T_TIPO_DATA(6991262),
            T_TIPO_DATA(6991287),
            T_TIPO_DATA(6991288),
            T_TIPO_DATA(6991289),
            T_TIPO_DATA(6991290),
            T_TIPO_DATA(6991291),
            T_TIPO_DATA(6991292),
            T_TIPO_DATA(6991293),
            T_TIPO_DATA(6991294),
            T_TIPO_DATA(6990815),
            T_TIPO_DATA(6990816),
            T_TIPO_DATA(6990817),
            T_TIPO_DATA(6990818),
            T_TIPO_DATA(6990819),
            T_TIPO_DATA(6990820),
            T_TIPO_DATA(6990821),
            T_TIPO_DATA(6990822),
            T_TIPO_DATA(6990823),
            T_TIPO_DATA(6990824),
            T_TIPO_DATA(6990825),
            T_TIPO_DATA(6990826),
            T_TIPO_DATA(6990827),
            T_TIPO_DATA(6990828),
            T_TIPO_DATA(6990829),
            T_TIPO_DATA(6990830),
            T_TIPO_DATA(6990831),
            T_TIPO_DATA(6990835),
            T_TIPO_DATA(7510707)
    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACTIVOS A PUBLICADOS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Comprobamos si el activo está oculto
            V_MSQL := 'SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ESTADO_PUBLICACION;

            IF V_ESTADO_PUBLICACION = 4 THEN

                --Actualizamos el estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''03''),
                APU_CHECK_PUBLICAR_V = 1,
                APU_CHECK_OCULTAR_V = 0,
                DD_MTO_V_ID = NULL,
                APU_MOT_OCULTACION_MANUAL_V = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_VENTA = SYSDATE
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = SYSDATE,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||' AND AHP_FECHA_INI_VENTA IS NOT NULL AND AHP_FECHA_FIN_VENTA IS NULL';

                EXECUTE IMMEDIATE V_MSQL;

                V_MSQL:= 'INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION(AHP_ID,ACT_ID
		                                          ,DD_TPU_A_ID,DD_TPU_V_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_V,AHP_CHECK_PUBLICAR_V,AHP_CHECK_OCULTAR_V
		                                          ,AHP_CHECK_OCULTAR_PRECIO_V,AHP_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,AHP_MOT_OCULTACION_MANUAL_A,AHP_CHECK_PUBLICAR_A
		                                          ,AHP_CHECK_OCULTAR_A,AHP_CHECK_OCULTAR_PRECIO_A
		                                          ,AHP_CHECK_PUB_SIN_PRECIO_A
		                                          ,AHP_FECHA_INI_VENTA
                                              	  ,DD_POR_ID
		                                          ,VERSION
		                                          ,USUARIOCREAR,FECHACREAR
		                                          ,BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR)
		    	SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, ACT_ID
		                                          ,DD_TPU_A_ID
		                                          ,DD_TPU_V_ID
		                                          ,DD_EPV_ID
		                                          ,DD_EPA_ID
		                                          ,DD_TCO_ID
		                                          ,DD_MTO_V_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_V,APU_CHECK_PUBLICAR_V,APU_CHECK_OCULTAR_V
		                                          ,APU_CHECK_OCULTAR_PRECIO_V,APU_CHECK_PUB_SIN_PRECIO_V
		                                          ,DD_MTO_A_ID
		                                          ,APU_MOT_OCULTACION_MANUAL_A,APU_CHECK_PUBLICAR_A
		                                          ,APU_CHECK_OCULTAR_A,APU_CHECK_OCULTAR_PRECIO_A
		                                          ,APU_CHECK_PUB_SIN_PRECIO_A
		                                          ,SYSDATE
                                                  ,DD_POR_ID
		                                          ,VERSION
		                                          ,'''||V_USUARIO||''' USUARIOCREAR, SYSDATE FECHACREAR
												  ,0 BORRADO
		                                          ,ES_CONDICONADO_ANTERIOR
		      	FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION
		       	WHERE BORRADO = 0 AND ACT_ID = '||V_ID||'';
    
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' NO SE ENCUENTRA OCULTO');

            END IF;
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

    ROLLBACK;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
 
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