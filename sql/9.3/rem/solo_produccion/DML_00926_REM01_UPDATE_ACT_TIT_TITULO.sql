--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10045
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10045'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ETI_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7465018'),
                T_TIPO_DATA('7465019'),
                T_TIPO_DATA('7465021'),
                T_TIPO_DATA('7465022'),
                T_TIPO_DATA('7465024'),
                T_TIPO_DATA('7465025'),
                T_TIPO_DATA('7465028'),
                T_TIPO_DATA('7465030'),
                T_TIPO_DATA('7465031'),
                T_TIPO_DATA('7465033'),
                T_TIPO_DATA('7465038'),
                T_TIPO_DATA('7465040'),
                T_TIPO_DATA('7465041'),
                T_TIPO_DATA('7465042'),
                T_TIPO_DATA('7465045'),
                T_TIPO_DATA('7465046'),
                T_TIPO_DATA('7465047'),
                T_TIPO_DATA('7465049'),
                T_TIPO_DATA('7465050'),
                T_TIPO_DATA('7465051'),
                T_TIPO_DATA('7465052')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --Obtenemos el ID del estado
    V_MSQL := 'SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE DD_ETI_CODIGO = ''02''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ETI_ID;

    --Se selecciona el DD_ESP_ID
    V_MSQL := 'SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03''';
    EXECUTE IMMEDIATE V_MSQL INTO V_ESP_ID;

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del activo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            V_COUNT := 0;

            --Obtenemos el ID del activo
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TIT_TITULO SET
            DD_ETI_ID = '||V_ETI_ID||',
            TIT_FECHA_INSC_REG = TO_DATE(''08/07/2014'', ''DD-MM-YYYY''),               
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            --Se selecciona el TIT_ID del activo
            V_MSQL := 'SELECT TIT_ID FROM '||V_ESQUEMA||'.ACT_TIT_TITULO WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_TIT_ID;

            --Se crea registro en el historico
            V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR)
            VALUES (
                '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                '||V_TIT_ID||',
                TO_DATE(''23/06/2021'', ''DD-MM-YYYY''), 
                TO_DATE(''08/07/2014'', ''DD-MM-YYYY''),  
                '||V_ESP_ID||',
                '''||V_USUARIO||''',
                SYSDATE
            )';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '''||V_TMP_TIPO_DATA(1)||'''');

        END IF;

    END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
		WHEN OTHERS THEN
			err_num := SQLCODE;
			err_msg := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;          

END;

/

EXIT