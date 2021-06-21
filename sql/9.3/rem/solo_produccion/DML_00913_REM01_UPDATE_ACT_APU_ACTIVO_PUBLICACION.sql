--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10000
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10000';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTA_PUBLICADO NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('202821','04','1','1'),
            T_TIPO_DATA('202822','04','1','1'),
            T_TIPO_DATA('203284','04','1','1'),
            T_TIPO_DATA('203285','04','1','1'),
            T_TIPO_DATA('203622','04','1','1'),
            T_TIPO_DATA('204121','04','1','1'),
            T_TIPO_DATA('5948399','04','1','1'),
            T_TIPO_DATA('5933271','04','1','1'),
            T_TIPO_DATA('6995438','04','1','1'),
            T_TIPO_DATA('7038400','04','1','1'),
            T_TIPO_DATA('7042071','04','1','1'),
            T_TIPO_DATA('7043493','04','1','1'),
            T_TIPO_DATA('7045355','04','1','1'),
            T_TIPO_DATA('7045356','04','1','1'),
            T_TIPO_DATA('7045357','04','1','1'),
            T_TIPO_DATA('7060688','04','1','1'),
            T_TIPO_DATA('7060760','04','1','1'),
            T_TIPO_DATA('7067528','04','1','1'),
            T_TIPO_DATA('117517','01','0','0'),
            T_TIPO_DATA('7230597','04','1','1'),
            T_TIPO_DATA('7268716','04','1','1'),
            T_TIPO_DATA('7268928','04','1','1'),
            T_TIPO_DATA('7232030','04','1','1'),
            T_TIPO_DATA('7232473','04','1','1'),
            T_TIPO_DATA('7233381','04','1','1'),
            T_TIPO_DATA('7238228','04','1','1'),
            T_TIPO_DATA('7240490','04','1','1'),
            T_TIPO_DATA('7240492','04','1','1'),
            T_TIPO_DATA('7245083','04','1','1'),
            T_TIPO_DATA('7245606','04','1','1'),
            T_TIPO_DATA('7247133','04','1','1'),
            T_TIPO_DATA('7247139','04','1','1'),
            T_TIPO_DATA('7247140','04','1','1'),
            T_TIPO_DATA('7247151','04','1','1'),
            T_TIPO_DATA('7247181','04','1','1'),
            T_TIPO_DATA('7247182','04','1','1'),
            T_TIPO_DATA('7247619','04','1','1'),
            T_TIPO_DATA('7248857','04','1','1'),
            T_TIPO_DATA('7248858','04','1','1'),
            T_TIPO_DATA('7248859','04','1','1'),
            T_TIPO_DATA('7248860','04','1','1'),
            T_TIPO_DATA('7248861','04','1','1'),
            T_TIPO_DATA('7248862','04','1','1'),
            T_TIPO_DATA('7248863','04','1','1'),
            T_TIPO_DATA('7248864','04','1','1'),
            T_TIPO_DATA('7248865','04','1','1'),
            T_TIPO_DATA('7248866','04','1','1'),
            T_TIPO_DATA('7248867','04','1','1'),
            T_TIPO_DATA('7248868','04','1','1'),
            T_TIPO_DATA('7248869','04','1','1'),
            T_TIPO_DATA('7248870','04','1','1'),
            T_TIPO_DATA('7248871','04','1','1'),
            T_TIPO_DATA('7248872','04','1','1'),
            T_TIPO_DATA('7248873','04','1','1'),
            T_TIPO_DATA('7248874','04','1','1'),
            T_TIPO_DATA('7248875','04','1','1'),
            T_TIPO_DATA('7248876','04','1','1'),
            T_TIPO_DATA('7248877','04','1','1'),
            T_TIPO_DATA('7248878','04','1','1'),
            T_TIPO_DATA('7248879','04','1','1'),
            T_TIPO_DATA('7248880','04','1','1'),
            T_TIPO_DATA('7248881','04','1','1'),
            T_TIPO_DATA('7248882','04','1','1'),
            T_TIPO_DATA('7248883','04','1','1'),
            T_TIPO_DATA('7248884','04','1','1'),
            T_TIPO_DATA('7248885','04','1','1'),
            T_TIPO_DATA('7248886','04','1','1'),
            T_TIPO_DATA('7248887','04','1','1'),
            T_TIPO_DATA('7248888','04','1','1'),
            T_TIPO_DATA('7248889','04','1','1'),
            T_TIPO_DATA('7248890','04','1','1'),
            T_TIPO_DATA('7248891','04','1','1'),
            T_TIPO_DATA('7248892','04','1','1'),
            T_TIPO_DATA('7248893','04','1','1'),
            T_TIPO_DATA('7248894','04','1','1'),
            T_TIPO_DATA('7248895','04','1','1'),
            T_TIPO_DATA('7248896','04','1','1'),
            T_TIPO_DATA('7248897','04','1','1'),
            T_TIPO_DATA('7248898','04','1','1'),
            T_TIPO_DATA('7248899','04','1','1'),
            T_TIPO_DATA('7248900','04','1','1'),
            T_TIPO_DATA('7248901','04','1','1'),
            T_TIPO_DATA('7248902','04','1','1'),
            T_TIPO_DATA('7248903','04','1','1'),
            T_TIPO_DATA('7248904','04','1','1'),
            T_TIPO_DATA('7248905','04','1','1'),
            T_TIPO_DATA('7248906','04','1','1'),
            T_TIPO_DATA('7248907','04','1','1'),
            T_TIPO_DATA('7248908','04','1','1'),
            T_TIPO_DATA('7249397','04','1','1'),
            T_TIPO_DATA('7252150','04','1','1'),
            T_TIPO_DATA('7252473','04','1','1'),
            T_TIPO_DATA('7252474','04','1','1'),
            T_TIPO_DATA('7253152','04','1','1'),
            T_TIPO_DATA('7254164','04','1','1'),
            T_TIPO_DATA('7255972','04','1','1'),
            T_TIPO_DATA('7256402','04','1','1'),
            T_TIPO_DATA('7257341','04','1','1'),
            T_TIPO_DATA('7258433','04','1','1'),
            T_TIPO_DATA('7258706','04','1','1'),
            T_TIPO_DATA('7260369','04','1','1'),
            T_TIPO_DATA('7261396','04','1','1'),
            T_TIPO_DATA('7264511','04','1','1'),
            T_TIPO_DATA('7264515','04','1','1'),
            T_TIPO_DATA('7266385','04','1','1'),
            T_TIPO_DATA('7266514','04','1','1'),
            T_TIPO_DATA('7267106','04','1','1'),
            T_TIPO_DATA('7267505','04','1','1'),
            T_TIPO_DATA('7267945','04','1','1'),
            T_TIPO_DATA('7276359','04','1','1'),
            T_TIPO_DATA('7276362','04','1','1'),
            T_TIPO_DATA('7276363','04','1','1'),
            T_TIPO_DATA('7276387','04','1','1'),
            T_TIPO_DATA('7276975','04','1','1'),
            T_TIPO_DATA('7279458','04','1','1'),
            T_TIPO_DATA('7280236','04','1','1'),
            T_TIPO_DATA('7280861','04','1','1'),
            T_TIPO_DATA('7282999','04','1','1'),
            T_TIPO_DATA('7303746','04','1','1'),
            T_TIPO_DATA('7303968','04','1','1'),
            T_TIPO_DATA('7306820','04','1','1'),
            T_TIPO_DATA('7306893','04','1','1'),
            T_TIPO_DATA('7312564','04','1','1'),
            T_TIPO_DATA('7312842','04','1','1'),
            T_TIPO_DATA('7312984','04','1','1'),
            T_TIPO_DATA('7313569','04','1','1')

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

            --Comprobamos si el activo está publicado
            V_MSQL := 'SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ESTA_PUBLICADO;

            IF V_ESTA_PUBLICADO = 3 THEN

                --Actualizamos el estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                APU_CHECK_PUBLICAR_V = '||V_TMP_TIPO_DATA(3)||',
                APU_CHECK_OCULTAR_V = '||V_TMP_TIPO_DATA(4)||',
                DD_MTO_V_ID = 12,
                APU_MOT_OCULTACION_MANUAL_V = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_VENTA = TO_DATE(''21/06/2021'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = TO_DATE(''21/06/2021'',''DD/MM/YYYY''),
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
                    (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                    (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01''),
                    (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02''),
                    '||V_TMP_TIPO_DATA(3)||',
                    '||V_TMP_TIPO_DATA(4)||',
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    TO_DATE(''21/06/2021'',''DD/MM/YYYY''),
                    '''|| V_USUARIO ||''',
                    SYSDATE,
                    0,
                    2,
                    (SELECT DD_POR_ID FROM '||V_ESQUEMA||'.DD_POR_PORTAL WHERE DD_POR_CODIGO = ''02''))';
    
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' NO SE ENCUENTRA PUBLICADO');

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