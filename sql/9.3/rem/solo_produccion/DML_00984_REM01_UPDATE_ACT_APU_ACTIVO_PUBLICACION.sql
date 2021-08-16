--/*
--#########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10223
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10223';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTA_PUBLICADO NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7327542','01','02'),
            T_TIPO_DATA('6946530','01','01'),
            T_TIPO_DATA('6802991','01','01'),
            T_TIPO_DATA('6351769','01','01'),
            T_TIPO_DATA('6351768','01','01'),
            T_TIPO_DATA('6351763','01','01'),
            T_TIPO_DATA('6351760','01','01'),
            T_TIPO_DATA('6351759','01','01'),
            T_TIPO_DATA('6351756','01','01'),
            T_TIPO_DATA('6351751','01','01'),
            T_TIPO_DATA('6351748','01','01'),
            T_TIPO_DATA('6351744','01','01'),
            T_TIPO_DATA('6351741','01','01'),
            T_TIPO_DATA('6351732','01','01'),
            T_TIPO_DATA('6351731','01','01'),
            T_TIPO_DATA('6351730','01','01'),
            T_TIPO_DATA('6351689','01','01'),
            T_TIPO_DATA('6351687','01','01'),
            T_TIPO_DATA('6351686','01','01'),
            T_TIPO_DATA('6351671','01','01'),
            T_TIPO_DATA('6351670','01','01'),
            T_TIPO_DATA('6351669','01','01'),
            T_TIPO_DATA('6351663','01','01'),
            T_TIPO_DATA('6351659','01','01'),
            T_TIPO_DATA('6351654','01','01'),
            T_TIPO_DATA('6351652','01','01'),
            T_TIPO_DATA('6351648','01','01'),
            T_TIPO_DATA('6351647','01','01'),
            T_TIPO_DATA('6351643','01','01'),
            T_TIPO_DATA('6351637','01','01'),
            T_TIPO_DATA('6044493','01','01'),
            T_TIPO_DATA('5877033','01','01'),
            T_TIPO_DATA('951961','01','01'),
            T_TIPO_DATA('201924','01','02'),
            T_TIPO_DATA('199296','01','01'),
            T_TIPO_DATA('199152','01','01'),
            T_TIPO_DATA('199103','01','02'),
            T_TIPO_DATA('198547','01','01'),
            T_TIPO_DATA('194614','01','01'),
            T_TIPO_DATA('188344','01','02'),
            T_TIPO_DATA('183697','04','01'),
            T_TIPO_DATA('179231','01','01'),
            T_TIPO_DATA('178887','01','01'),
            T_TIPO_DATA('177114','01','01'),
            T_TIPO_DATA('176295','01','01'),
            T_TIPO_DATA('175620','01','02'),
            T_TIPO_DATA('174604','01','01'),
            T_TIPO_DATA('174541','01','01'),
            T_TIPO_DATA('173026','01','01'),
            T_TIPO_DATA('172661','01','02'),
            T_TIPO_DATA('169163','01','01'),
            T_TIPO_DATA('168886','01','02'),
            T_TIPO_DATA('168868','01','01'),
            T_TIPO_DATA('168244','01','01'),
            T_TIPO_DATA('167358','01','02'),
            T_TIPO_DATA('166035','01','01'),
            T_TIPO_DATA('165795','01','02'),
            T_TIPO_DATA('163449','01','01'),
            T_TIPO_DATA('162491','01','01'),
            T_TIPO_DATA('161361','01','01'),
            T_TIPO_DATA('161360','01','01'),
            T_TIPO_DATA('160419','01','02'),
            T_TIPO_DATA('159452','01','01'),
            T_TIPO_DATA('158923','01','01'),
            T_TIPO_DATA('158872','01','01'),
            T_TIPO_DATA('155248','01','01'),
            T_TIPO_DATA('153255','01','01'),
            T_TIPO_DATA('153043','01','01'),
            T_TIPO_DATA('151982','01','01'),
            T_TIPO_DATA('151677','01','02'),
            T_TIPO_DATA('151373','01','02'),
            T_TIPO_DATA('151372','01','02'),
            T_TIPO_DATA('148816','01','02'),
            T_TIPO_DATA('148815','01','02'),
            T_TIPO_DATA('148673','01','02'),
            T_TIPO_DATA('143997','03','01'),
            T_TIPO_DATA('137381','03','01'),
            T_TIPO_DATA('137240','01','02'),
            T_TIPO_DATA('134004','01','01'),
            T_TIPO_DATA('122721','01','01'),
            T_TIPO_DATA('111981','01','01'),
            T_TIPO_DATA('73491','01','01'),
            T_TIPO_DATA('73203','01','01'),
            T_TIPO_DATA('73202','01','01'),
            T_TIPO_DATA('72112','01','01'),
            T_TIPO_DATA('71735','04','02'),
            T_TIPO_DATA('71618','01','01'),
            T_TIPO_DATA('71112','01','02'),
            T_TIPO_DATA('70228','01','01'),
            T_TIPO_DATA('68907','01','01'),
            T_TIPO_DATA('68847','01','01'),
            T_TIPO_DATA('68372','01','01'),
            T_TIPO_DATA('67500','01','01'),
            T_TIPO_DATA('65934','01','01'),
            T_TIPO_DATA('65482','01','01'),
            T_TIPO_DATA('65397','01','01'),
            T_TIPO_DATA('65197','01','01'),
            T_TIPO_DATA('65174','01','01'),
            T_TIPO_DATA('64985','01','01')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: DESOCULTAR ACTIVOS');

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
                APU_CHECK_PUB_SIN_PRECIO_V = 1,
                DD_MTO_V_ID = NULL,
                APU_MOT_OCULTACION_MANUAL_V = NULL,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_VENTA = TO_DATE(''29/07/2021'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_VENTA = TO_DATE(''29/07/2021'',''DD/MM/YYYY''),
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
                    (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
                    (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''01''),
                    1,
                    0,
                    0,
                    1,
                    0,
                    0,
                    0,
                    0,
                    TO_DATE(''29/07/2021'',''DD/MM/YYYY''),
                    '''|| V_USUARIO ||''',
                    SYSDATE,
                    0,
                    2,
                    (SELECT DD_POR_ID FROM '||V_ESQUEMA||'.DD_POR_PORTAL WHERE DD_POR_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''))';
    
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