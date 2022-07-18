--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220627
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11957
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11957';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTADO_PUBLICACION NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_APU_ACTIVO_PUBLICACION';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('6063686')

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
            V_MSQL := 'SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ESTADO_PUBLICACION;

            IF V_ESTADO_PUBLICACION = 3 THEN

                --Actualizamos el estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
                DD_EPA_ID = (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''04''),
                APU_CHECK_OCULTAR_A = 1,
                DD_MTO_A_ID = 12,
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE ,
                APU_FECHA_CAMB_PUBL_ALQ = TO_DATE(''27/06/2022'',''DD/MM/YYYY'')
                WHERE ACT_ID = '||V_ID||'';

                EXECUTE IMMEDIATE V_MSQL;

                --Actualizamos el histórico estado de publicación
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION SET
                AHP_FECHA_FIN_ALQUILER = TO_DATE(''27/06/2022'',''DD/MM/YYYY''),
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE 
                WHERE ACT_ID = '||V_ID||' AND AHP_FECHA_INI_ALQUILER IS NOT NULL AND AHP_FECHA_FIN_ALQUILER IS NULL';

                EXECUTE IMMEDIATE V_MSQL;

                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (AHP_ID, ACT_ID, DD_EPV_ID, DD_EPA_ID, DD_TCO_ID, 
                            AHP_CHECK_OCULTAR_A,DD_MTO_A_ID,AHP_FECHA_INI_ALQUILER, USUARIOCREAR, FECHACREAR, DD_TPU_A_ID, DD_POR_ID)
                VALUES(
                    '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL,
                    '||V_ID||',
                    (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''04''),
                    (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''04''),
                    (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02''),
                    1,12,TO_DATE(''27/06/2022'',''DD/MM/YYYY''),'''|| V_USUARIO ||''',SYSDATE,2,
                    (SELECT DD_POR_ID FROM '||V_ESQUEMA||'.DD_POR_PORTAL WHERE DD_POR_CODIGO = ''02'')
                    )';
    
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