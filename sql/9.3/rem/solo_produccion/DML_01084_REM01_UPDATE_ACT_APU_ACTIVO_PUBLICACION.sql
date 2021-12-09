--/*
--#########################################
--## AUTOR=Alejandra García 
--## FECHA_CREACION=20211112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10669
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10669';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTA_PUBLICADO NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7322231'),
            T_TIPO_DATA('7322233'),
            T_TIPO_DATA('7322234'),
            T_TIPO_DATA('7322235'),
            T_TIPO_DATA('7322236'),
            T_TIPO_DATA('7322237'),
            T_TIPO_DATA('7322238'),
            T_TIPO_DATA('7322239'),
            T_TIPO_DATA('7322240'),
            T_TIPO_DATA('7322241'),
            T_TIPO_DATA('7322242'),
            T_TIPO_DATA('7322243'),
            T_TIPO_DATA('7322244'),
            T_TIPO_DATA('7322245'),
            T_TIPO_DATA('7322246'),
            T_TIPO_DATA('7322247'),
            T_TIPO_DATA('7322248'),
            T_TIPO_DATA('7322249'),
            T_TIPO_DATA('7322250'),
            T_TIPO_DATA('7322251'),
            T_TIPO_DATA('7322252'),
            T_TIPO_DATA('7322253'),
            T_TIPO_DATA('7322254'),
            T_TIPO_DATA('7322255'),
            T_TIPO_DATA('7322256'),
            T_TIPO_DATA('7322257'),
            T_TIPO_DATA('7322258'),
            T_TIPO_DATA('7322259'),
            T_TIPO_DATA('7322260'),
            T_TIPO_DATA('7322261'),
            T_TIPO_DATA('7322262'),
            T_TIPO_DATA('7322263'),
            T_TIPO_DATA('7322264'),
            T_TIPO_DATA('7322265'),
            T_TIPO_DATA('7322266'),
            T_TIPO_DATA('7322267'),
            T_TIPO_DATA('7322268'),
            T_TIPO_DATA('7322269'),
            T_TIPO_DATA('7322270'),
            T_TIPO_DATA('7322271'),
            T_TIPO_DATA('7322272'),
            T_TIPO_DATA('7322273'),
            T_TIPO_DATA('7322274'),
            T_TIPO_DATA('7322275'),
            T_TIPO_DATA('7322276'),
            T_TIPO_DATA('7322277'),
            T_TIPO_DATA('7322278'),
            T_TIPO_DATA('7322279'),
            T_TIPO_DATA('7322280'),
            T_TIPO_DATA('7322281'),
            T_TIPO_DATA('7322282'),
            T_TIPO_DATA('7322283'),
            T_TIPO_DATA('7322284'),
            T_TIPO_DATA('7322285'),
            T_TIPO_DATA('7322286'),
            T_TIPO_DATA('7322287'),
            T_TIPO_DATA('7322288'),
            T_TIPO_DATA('7322289'),
            T_TIPO_DATA('7322290'),
            T_TIPO_DATA('7322291'),
            T_TIPO_DATA('7322292'),
            T_TIPO_DATA('7322293'),
            T_TIPO_DATA('7322294'),
            T_TIPO_DATA('7322295'),
            T_TIPO_DATA('7322296'),
            T_TIPO_DATA('7322297'),
            T_TIPO_DATA('7322298'),
            T_TIPO_DATA('7322299'),
            T_TIPO_DATA('7322300'),
            T_TIPO_DATA('7322301'),
            T_TIPO_DATA('7322302'),
            T_TIPO_DATA('7322303'),
            T_TIPO_DATA('7322304'),
            T_TIPO_DATA('7322305'),
            T_TIPO_DATA('7322306'),
            T_TIPO_DATA('7322307'),
            T_TIPO_DATA('7322308'),
            T_TIPO_DATA('7322309'),
            T_TIPO_DATA('7322310'),
            T_TIPO_DATA('7322311'),
            T_TIPO_DATA('7322312'),
            T_TIPO_DATA('7322313'),
            T_TIPO_DATA('7322314'),
            T_TIPO_DATA('7322315'),
            T_TIPO_DATA('7322316'),
            T_TIPO_DATA('7322317'),
            T_TIPO_DATA('7322318'),
            T_TIPO_DATA('7322319'),
            T_TIPO_DATA('7322320'),
            T_TIPO_DATA('7322321'),
            T_TIPO_DATA('7322322'),
            T_TIPO_DATA('7322323'),
            T_TIPO_DATA('7322324'),
            T_TIPO_DATA('7322325'),
            T_TIPO_DATA('7322326'),
            T_TIPO_DATA('7322327'),
            T_TIPO_DATA('7322328'),
            T_TIPO_DATA('7322329'),
            T_TIPO_DATA('7322330'),
            T_TIPO_DATA('7322331'),
            T_TIPO_DATA('7322332'),
            T_TIPO_DATA('7322333'),
            T_TIPO_DATA('7322334')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACTIVOS A OCULTOS');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0 ';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0 ';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Comprobamos si el activo está oculto
            V_MSQL := 'SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||V_ID||' AND BORRADO = 0 ';
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
                APU_FECHA_CAMB_PUBL_VENTA = TO_DATE(''26/10/2021'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = TO_DATE(''26/10/2021'',''DD/MM/YYYY''),
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
                    TO_DATE(''26/10/2021'',''DD/MM/YYYY''),
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