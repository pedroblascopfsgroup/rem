--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11982
--## PRODUCTO=NO
--## 
--## Finalidad: Cambiar datos de activos
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
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-11982';

    V_ID NUMBER(16); -- Vble. para el id del activo
    V_ESTADO_PUBLICACION NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'ACT_ACTIVO';

	V_COUNT NUMBER(16); -- Vble. para comprobar
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA(7303783),
            T_TIPO_DATA(7304034),
            T_TIPO_DATA(7304309),
            T_TIPO_DATA(7304471),
            T_TIPO_DATA(7304550),
            T_TIPO_DATA(7306071),
            T_TIPO_DATA(7306072),
            T_TIPO_DATA(7306281),
            T_TIPO_DATA(7306648),
            T_TIPO_DATA(7306650),
            T_TIPO_DATA(7306729),
            T_TIPO_DATA(7306730),
            T_TIPO_DATA(7306734),
            T_TIPO_DATA(7306825),
            T_TIPO_DATA(7307268),
            T_TIPO_DATA(7308852),
            T_TIPO_DATA(7311271),
            T_TIPO_DATA(7311280),
            T_TIPO_DATA(7311296),
            T_TIPO_DATA(7311297),
            T_TIPO_DATA(7311298),
            T_TIPO_DATA(7311355),
            T_TIPO_DATA(7311366),
            T_TIPO_DATA(7311367),
            T_TIPO_DATA(7311395),
            T_TIPO_DATA(7311402),
            T_TIPO_DATA(7311463),
            T_TIPO_DATA(7311468),
            T_TIPO_DATA(7311471),
            T_TIPO_DATA(7311575),
            T_TIPO_DATA(7311581),
            T_TIPO_DATA(7311621),
            T_TIPO_DATA(7311651),
            T_TIPO_DATA(7311652),
            T_TIPO_DATA(7311654),
            T_TIPO_DATA(7311655),
            T_TIPO_DATA(7311714),
            T_TIPO_DATA(7311723),
            T_TIPO_DATA(7311728),
            T_TIPO_DATA(7311764),
            T_TIPO_DATA(7311861),
            T_TIPO_DATA(7312482),
            T_TIPO_DATA(7312651),
            T_TIPO_DATA(7312741),
            T_TIPO_DATA(7313982),
            T_TIPO_DATA(7314279),
            T_TIPO_DATA(7314609),
            T_TIPO_DATA(7316207),
            T_TIPO_DATA(7316309),
            T_TIPO_DATA(7316333),
            T_TIPO_DATA(7317028),
            T_TIPO_DATA(7317029),
            T_TIPO_DATA(7318014),
            T_TIPO_DATA(7318051),
            T_TIPO_DATA(7318359),
            T_TIPO_DATA(7318375),
            T_TIPO_DATA(7318376),
            T_TIPO_DATA(7318377),
            T_TIPO_DATA(7318786),
            T_TIPO_DATA(7318787),
            T_TIPO_DATA(7318788),
            T_TIPO_DATA(7318799),
            T_TIPO_DATA(7318868),
            T_TIPO_DATA(7319318),
            T_TIPO_DATA(7319367),
            T_TIPO_DATA(7319476),
            T_TIPO_DATA(7319535),
            T_TIPO_DATA(7319540),
            T_TIPO_DATA(7319562),
            T_TIPO_DATA(7319679),
            T_TIPO_DATA(7319782),
            T_TIPO_DATA(7322457),
            T_TIPO_DATA(7322464),
            T_TIPO_DATA(7323152),
            T_TIPO_DATA(7324848),
            T_TIPO_DATA(7386391)    	
            ); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACTIVOS BBVA');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Actualizamos el estado de publicación
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
            DD_TS_ID = (SELECT DD_TS_ID FROM '||V_ESQUEMA||'.DD_TS_TIPO_SEGMENTO WHERE DD_TS_CODIGO = ''00237''),
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE
            WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';

            EXECUTE IMMEDIATE V_MSQL;

            --Actualizamos el histórico estado de publicación
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO SET
            PAC_INCLUIDO = 0,
            PAC_CHECK_GESTIONAR = 0,
            PAC_FECHA_GESTIONAR= TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_MOTIVO_GESTIONAR = ''Baja contable'',
            PAC_CHECK_COMERCIALIZAR = 0,
            PAC_FECHA_COMERCIALIZAR= TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_MOT_EXCL_COMERCIALIZAR = ''Baja contable'',
            PAC_CHECK_FORMALIZAR = 0,
            PAC_FECHA_FORMALIZAR= TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_MOTIVO_FORMALIZAR = ''Baja contable'',
            PAC_CHECK_PUBLICAR = 0,
            PAC_FECHA_PUBLICAR= TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_MOTIVO_PUBLICAR = ''Baja contable'',
            PAC_CHECK_ADMISION = 0,
            PAC_FECHA_ADMISION = TO_DATE(SYSDATE, ''DD/MM/YY''),
            PAC_MOTIVO_ADMISION = ''Baja contable'',
            PAC_CHECK_GESTION_COMERCIAL = 0,
            PAC_FECHA_GESTION_COMERCIAL = TO_DATE(SYSDATE, ''DD/MM/YY''),
            DD_BCO_ID = (SELECT DD_BCO_ID FROM '||V_ESQUEMA||'.DD_BCO_BAJA_CONTABLE_BBVA WHERE DD_BCO_CODIGO = ''01''),
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE
            WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0)
            AND BORRADO = 0';

            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');
            
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