--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9914
--## PRODUCTO=NO
--## 
--## Finalidad: Poner activos en Publicado venta
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9914';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTA_PUBLICADO NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('66177'),
            T_TIPO_DATA('68371'),
            T_TIPO_DATA('68373'),
            T_TIPO_DATA('68613'),
            T_TIPO_DATA('68655'),
            T_TIPO_DATA('68710'),
            T_TIPO_DATA('71735'),
            T_TIPO_DATA('117517'),
            T_TIPO_DATA('118721'),
            T_TIPO_DATA('124165'),
            T_TIPO_DATA('131970'),
            T_TIPO_DATA('134642'),
            T_TIPO_DATA('137404'),
            T_TIPO_DATA('143589'),
            T_TIPO_DATA('143999'),
            T_TIPO_DATA('150778'),
            T_TIPO_DATA('153255'),
            T_TIPO_DATA('154033'),
            T_TIPO_DATA('157001'),
            T_TIPO_DATA('165794'),
            T_TIPO_DATA('165795'),
            T_TIPO_DATA('165958'),
            T_TIPO_DATA('171258'),
            T_TIPO_DATA('172660'),
            T_TIPO_DATA('172661'),
            T_TIPO_DATA('172662'),
            T_TIPO_DATA('178652'),
            T_TIPO_DATA('179645'),
            T_TIPO_DATA('180445'),
            T_TIPO_DATA('180446'),
            T_TIPO_DATA('180654'),
            T_TIPO_DATA('180655'),
            T_TIPO_DATA('183868'),
            T_TIPO_DATA('195772'),
            T_TIPO_DATA('198777'),
            T_TIPO_DATA('199704'),
            T_TIPO_DATA('201302'),
            T_TIPO_DATA('202821'),
            T_TIPO_DATA('202822'),
            T_TIPO_DATA('203284'),
            T_TIPO_DATA('203285'),
            T_TIPO_DATA('203622'),
            T_TIPO_DATA('204121'),
            T_TIPO_DATA('933677'),
            T_TIPO_DATA('5933271'),
            T_TIPO_DATA('5948399'),
            T_TIPO_DATA('6756916'),
            T_TIPO_DATA('6995438'),
            T_TIPO_DATA('7038400'),
            T_TIPO_DATA('7042071'),
            T_TIPO_DATA('7043493'),
            T_TIPO_DATA('7044382'),
            T_TIPO_DATA('7044477'),
            T_TIPO_DATA('7045355'),
            T_TIPO_DATA('7045356'),
            T_TIPO_DATA('7045357'),
            T_TIPO_DATA('7047124'),
            T_TIPO_DATA('7049500'),
            T_TIPO_DATA('7060688'),
            T_TIPO_DATA('7060760'),
            T_TIPO_DATA('7067528'),
            T_TIPO_DATA('7228986'),
            T_TIPO_DATA('7230597'),
            T_TIPO_DATA('7232030'),
            T_TIPO_DATA('7232473'),
            T_TIPO_DATA('7233381'),
            T_TIPO_DATA('7235837'),
            T_TIPO_DATA('7238228'),
            T_TIPO_DATA('7240490'),
            T_TIPO_DATA('7240492'),
            T_TIPO_DATA('7241562'),
            T_TIPO_DATA('7242316'),
            T_TIPO_DATA('7245083'),
            T_TIPO_DATA('7245606'),
            T_TIPO_DATA('7247133'),
            T_TIPO_DATA('7247139'),
            T_TIPO_DATA('7247140'),
            T_TIPO_DATA('7247151'),
            T_TIPO_DATA('7247181'),
            T_TIPO_DATA('7247182'),
            T_TIPO_DATA('7247619'),
            T_TIPO_DATA('7248857'),
            T_TIPO_DATA('7248858'),
            T_TIPO_DATA('7248859'),
            T_TIPO_DATA('7248860'),
            T_TIPO_DATA('7248861'),
            T_TIPO_DATA('7248862'),
            T_TIPO_DATA('7248863'),
            T_TIPO_DATA('7248864'),
            T_TIPO_DATA('7248865'),
            T_TIPO_DATA('7248866'),
            T_TIPO_DATA('7248867'),
            T_TIPO_DATA('7248868'),
            T_TIPO_DATA('7248869'),
            T_TIPO_DATA('7248870'),
            T_TIPO_DATA('7248871'),
            T_TIPO_DATA('7248872'),
            T_TIPO_DATA('7248873'),
            T_TIPO_DATA('7248874'),
            T_TIPO_DATA('7248875'),
            T_TIPO_DATA('7248876'),
            T_TIPO_DATA('7248877'),
            T_TIPO_DATA('7248878'),
            T_TIPO_DATA('7248879'),
            T_TIPO_DATA('7248880'),
            T_TIPO_DATA('7248881'),
            T_TIPO_DATA('7248882'),
            T_TIPO_DATA('7248883'),
            T_TIPO_DATA('7248884'),
            T_TIPO_DATA('7248885'),
            T_TIPO_DATA('7248886'),
            T_TIPO_DATA('7248887'),
            T_TIPO_DATA('7248888'),
            T_TIPO_DATA('7248889'),
            T_TIPO_DATA('7248890'),
            T_TIPO_DATA('7248891'),
            T_TIPO_DATA('7248892'),
            T_TIPO_DATA('7248893'),
            T_TIPO_DATA('7248894'),
            T_TIPO_DATA('7248895'),
            T_TIPO_DATA('7248896'),
            T_TIPO_DATA('7248897'),
            T_TIPO_DATA('7248898'),
            T_TIPO_DATA('7248899'),
            T_TIPO_DATA('7248900'),
            T_TIPO_DATA('7248901'),
            T_TIPO_DATA('7248902'),
            T_TIPO_DATA('7248903'),
            T_TIPO_DATA('7248904'),
            T_TIPO_DATA('7248905'),
            T_TIPO_DATA('7248906'),
            T_TIPO_DATA('7248907'),
            T_TIPO_DATA('7248908'),
            T_TIPO_DATA('7249397'),
            T_TIPO_DATA('7252150'),
            T_TIPO_DATA('7252473'),
            T_TIPO_DATA('7252474'),
            T_TIPO_DATA('7253152'),
            T_TIPO_DATA('7254164'),
            T_TIPO_DATA('7255972'),
            T_TIPO_DATA('7256402'),
            T_TIPO_DATA('7257341'),
            T_TIPO_DATA('7258433'),
            T_TIPO_DATA('7258706'),
            T_TIPO_DATA('7259436'),
            T_TIPO_DATA('7260369'),
            T_TIPO_DATA('7261396'),
            T_TIPO_DATA('7264496'),
            T_TIPO_DATA('7264510'),
            T_TIPO_DATA('7264511'),
            T_TIPO_DATA('7264515'),
            T_TIPO_DATA('7266385'),
            T_TIPO_DATA('7266514'),
            T_TIPO_DATA('7267106'),
            T_TIPO_DATA('7267505'),
            T_TIPO_DATA('7267557'),
            T_TIPO_DATA('7267569'),
            T_TIPO_DATA('7267605'),
            T_TIPO_DATA('7267608'),
            T_TIPO_DATA('7267945'),
            T_TIPO_DATA('7268716'),
            T_TIPO_DATA('7268928'),
            T_TIPO_DATA('7270511'),
            T_TIPO_DATA('7273453'),
            T_TIPO_DATA('7276359'),
            T_TIPO_DATA('7276362'),
            T_TIPO_DATA('7276363'),
            T_TIPO_DATA('7276387'),
            T_TIPO_DATA('7276975'),
            T_TIPO_DATA('7279458'),
            T_TIPO_DATA('7280236'),
            T_TIPO_DATA('7280861'),
            T_TIPO_DATA('7282085'),
            T_TIPO_DATA('7282086'),
            T_TIPO_DATA('7282087'),
            T_TIPO_DATA('7282088'),
            T_TIPO_DATA('7282089'),
            T_TIPO_DATA('7282090'),
            T_TIPO_DATA('7282091'),
            T_TIPO_DATA('7282092'),
            T_TIPO_DATA('7282093'),
            T_TIPO_DATA('7282094'),
            T_TIPO_DATA('7282095'),
            T_TIPO_DATA('7282096'),
            T_TIPO_DATA('7282097'),
            T_TIPO_DATA('7282098'),
            T_TIPO_DATA('7282099'),
            T_TIPO_DATA('7282100'),
            T_TIPO_DATA('7282999'),
            T_TIPO_DATA('7303746'),
            T_TIPO_DATA('7303968'),
            T_TIPO_DATA('7305913'),
            T_TIPO_DATA('7306820'),
            T_TIPO_DATA('7306893'),
            T_TIPO_DATA('7312564'),
            T_TIPO_DATA('7312842'),
            T_TIPO_DATA('7312984'),
            T_TIPO_DATA('7313569'),
            T_TIPO_DATA('7327542')

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
                DD_EPV_ID = (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''04''),
                APU_CHECK_OCULTAR_V = 1,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_VENTA = TO_DATE(''10/06/2021'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = TO_DATE(''10/06/2021'',''DD/MM/YYYY''),
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
                    1,
                    1,
                    0,
                    0,
                    0,
                    0,
                    TO_DATE(''10/06/2021'',''DD/MM/YYYY''),
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