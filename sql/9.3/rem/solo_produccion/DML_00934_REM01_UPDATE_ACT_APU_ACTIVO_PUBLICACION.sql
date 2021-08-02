--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10084
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10084';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTA_PUBLICADO NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('185576'),
            T_TIPO_DATA('182044'),
            T_TIPO_DATA('193927'),
            T_TIPO_DATA('193748'),
            T_TIPO_DATA('193228'),
            T_TIPO_DATA('194630'),
            T_TIPO_DATA('193931'),
            T_TIPO_DATA('182045'),
            T_TIPO_DATA('185678'),
            T_TIPO_DATA('193749'),
            T_TIPO_DATA('194631'),
            T_TIPO_DATA('185679'),
            T_TIPO_DATA('182127'),
            T_TIPO_DATA('193663'),
            T_TIPO_DATA('194632'),
            T_TIPO_DATA('193658'),
            T_TIPO_DATA('185511'),
            T_TIPO_DATA('185587'),
            T_TIPO_DATA('193830'),
            T_TIPO_DATA('181884'),
            T_TIPO_DATA('185581'),
            T_TIPO_DATA('182099'),
            T_TIPO_DATA('193660'),
            T_TIPO_DATA('185590'),
            T_TIPO_DATA('193838'),
            T_TIPO_DATA('193536'),
            T_TIPO_DATA('185580'),
            T_TIPO_DATA('193230'),
            T_TIPO_DATA('193751'),
            T_TIPO_DATA('185513'),
            T_TIPO_DATA('193666'),
            T_TIPO_DATA('185684'),
            T_TIPO_DATA('193840'),
            T_TIPO_DATA('185686'),
            T_TIPO_DATA('185683'),
            T_TIPO_DATA('181885'),
            T_TIPO_DATA('194635'),
            T_TIPO_DATA('185583'),
            T_TIPO_DATA('185593'),
            T_TIPO_DATA('182102'),
            T_TIPO_DATA('193841'),
            T_TIPO_DATA('185591'),
            T_TIPO_DATA('185592'),
            T_TIPO_DATA('185687'),
            T_TIPO_DATA('193930'),
            T_TIPO_DATA('194634'),
            T_TIPO_DATA('182128'),
            T_TIPO_DATA('185785'),
            T_TIPO_DATA('193665')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACTIVOS A OCULTOS');

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
            EXECUTE IMMEDIATE V_MSQL INTO V_ESTA_PUBLICADO;

            IF V_ESTA_PUBLICADO = 4 THEN

                --Actualizamos el estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''03''),
                APU_CHECK_PUBLICAR_V = 1,
                APU_CHECK_OCULTAR_V = 0,
                DD_MTO_V_ID = NULL,
                APU_MOT_OCULTACION_MANUAL_V = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_VENTA = TO_DATE(''01/07/2021'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = TO_DATE(''01/07/2021'',''DD/MM/YYYY''),
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||' AND AHP_FECHA_INI_VENTA IS NOT NULL AND AHP_FECHA_FIN_VENTA IS NULL';

                EXECUTE IMMEDIATE V_MSQL;

                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (AHP_ID, ACT_ID, DD_EPV_ID, DD_EPA_ID, DD_TCO_ID, 
                            AHP_CHECK_PUBLICAR_V, AHP_CHECK_OCULTAR_V, AHP_CHECK_OCULTAR_PRECIO_V, AHP_CHECK_PUB_SIN_PRECIO_V,
                            AHP_CHECK_PUBLICAR_A, AHP_CHECK_OCULTAR_A, AHP_CHECK_OCULTAR_PRECIO_A, AHP_CHECK_PUB_SIN_PRECIO_A,
                            AHP_FECHA_INI_VENTA, USUARIOCREAR, FECHACREAR, ES_CONDICONADO_ANTERIOR, DD_TPU_V_ID, DD_POR_ID)
                VALUES(
                    '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                    '||V_ID||',
                    (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''03''),
                    (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01''),
                    (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02''),
                    1,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    TO_DATE(''01/07/2021'',''DD/MM/YYYY''),
                    '''|| V_USUARIO ||''',
                    SYSDATE,
                    0,
                    2,
                    (SELECT DD_POR_ID FROM '||V_ESQUEMA||'.DD_POR_PORTAL WHERE DD_POR_CODIGO = ''02''))';
    
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' NO SE ENCUENTRA OCULTO');

            END IF;
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

    COMMIT;

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