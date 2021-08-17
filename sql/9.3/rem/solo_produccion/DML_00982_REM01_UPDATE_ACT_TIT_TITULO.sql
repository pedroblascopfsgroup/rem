--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210730
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10236
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10236'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7433522','26/10/2020'),
            T_TIPO_DATA('7433537','26/10/2020'),
            T_TIPO_DATA('7434420','26/10/2020'),
            T_TIPO_DATA('7433427','26/10/2020'),
            T_TIPO_DATA('7433433','26/10/2020'),
            T_TIPO_DATA('7433499','26/10/2020'),
            T_TIPO_DATA('7433521','26/10/2020'),
            T_TIPO_DATA('7433526','26/10/2020'),
            T_TIPO_DATA('7434410','26/10/2020'),
            T_TIPO_DATA('7433574','26/10/2020'),
            T_TIPO_DATA('7433425','26/10/2020'),
            T_TIPO_DATA('7433444','26/10/2020'),
            T_TIPO_DATA('7433465','26/10/2020'),
            T_TIPO_DATA('7433501','26/10/2020'),
            T_TIPO_DATA('7433420','26/10/2020'),
            T_TIPO_DATA('7433543','26/10/2020'),
            T_TIPO_DATA('7433561','26/10/2020'),
            T_TIPO_DATA('7433565','26/10/2020'),
            T_TIPO_DATA('7433419','26/10/2020'),
            T_TIPO_DATA('7433423','26/10/2020'),
            T_TIPO_DATA('7433459','26/10/2020'),
            T_TIPO_DATA('7433481','26/10/2020'),
            T_TIPO_DATA('7433484','26/10/2020'),
            T_TIPO_DATA('7433497','26/10/2020'),
            T_TIPO_DATA('7433519','26/10/2020'),
            T_TIPO_DATA('7433523','26/10/2020'),
            T_TIPO_DATA('7433524','26/10/2020'),
            T_TIPO_DATA('7433546','26/10/2020'),
            T_TIPO_DATA('7434414','26/10/2020'),
            T_TIPO_DATA('7433563','26/10/2020'),
            T_TIPO_DATA('7433428','26/10/2020'),
            T_TIPO_DATA('7433443','26/10/2020'),
            T_TIPO_DATA('7433461','26/10/2020'),
            T_TIPO_DATA('7433464','26/10/2020'),
            T_TIPO_DATA('7433479','26/10/2020'),
            T_TIPO_DATA('7433482','26/10/2020'),
            T_TIPO_DATA('7433483','26/10/2020'),
            T_TIPO_DATA('7433505','26/10/2020'),
            T_TIPO_DATA('7433513','26/10/2020'),
            T_TIPO_DATA('7433468','26/10/2020'),
            T_TIPO_DATA('7434406','26/10/2020'),
            T_TIPO_DATA('7434416','26/10/2020'),
            T_TIPO_DATA('7433569','26/10/2020'),
            T_TIPO_DATA('7433436','26/10/2020'),
            T_TIPO_DATA('7433449','26/10/2020'),
            T_TIPO_DATA('7433457','26/10/2020'),
            T_TIPO_DATA('7433469','26/10/2020'),
            T_TIPO_DATA('7435010','26/10/2020'),
            T_TIPO_DATA('7433525','26/10/2020'),
            T_TIPO_DATA('7433528','26/10/2020'),
            T_TIPO_DATA('7433531','26/10/2020'),
            T_TIPO_DATA('7434403','26/10/2020'),
            T_TIPO_DATA('7434413','26/10/2020'),
            T_TIPO_DATA('7434418','26/10/2020'),
            T_TIPO_DATA('7433445','26/10/2020'),
            T_TIPO_DATA('7433446','26/10/2020'),
            T_TIPO_DATA('7433500','26/10/2020'),
            T_TIPO_DATA('7433440','26/10/2020'),
            T_TIPO_DATA('7433527','26/10/2020'),
            T_TIPO_DATA('7433535','26/10/2020'),
            T_TIPO_DATA('7433538','26/10/2020'),
            T_TIPO_DATA('7433541','26/10/2020'),
            T_TIPO_DATA('7434412','26/10/2020'),
            T_TIPO_DATA('7433562','26/10/2020'),
            T_TIPO_DATA('7433426','26/10/2020'),
            T_TIPO_DATA('7433463','26/10/2020'),
            T_TIPO_DATA('7433474','26/10/2020'),
            T_TIPO_DATA('7433478','26/10/2020'),
            T_TIPO_DATA('7433511','26/10/2020'),
            T_TIPO_DATA('7433564','26/10/2020'),
            T_TIPO_DATA('7433548','26/10/2020'),
            T_TIPO_DATA('7433549','26/10/2020'),
            T_TIPO_DATA('7433551','26/10/2020'),
            T_TIPO_DATA('7433558','26/10/2020'),
            T_TIPO_DATA('7433487','26/10/2020'),
            T_TIPO_DATA('7433489','26/10/2020'),
            T_TIPO_DATA('7434399','26/10/2020'),
            T_TIPO_DATA('7433491','26/10/2020'),
            T_TIPO_DATA('7433438','26/10/2020'),
            T_TIPO_DATA('7433536','26/10/2020'),
            T_TIPO_DATA('7434404','26/10/2020'),
            T_TIPO_DATA('7433421','26/10/2020'),
            T_TIPO_DATA('7433434','26/10/2020'),
            T_TIPO_DATA('7433439','26/10/2020'),
            T_TIPO_DATA('7433441','26/10/2020'),
            T_TIPO_DATA('7433460','26/10/2020'),
            T_TIPO_DATA('7433473','26/10/2020'),
            T_TIPO_DATA('7433477','26/10/2020'),
            T_TIPO_DATA('7433504','26/10/2020'),
            T_TIPO_DATA('7433470','26/10/2020'),
            T_TIPO_DATA('7434402','26/10/2020'),
            T_TIPO_DATA('7433539','26/10/2020'),
            T_TIPO_DATA('7434408','26/10/2020'),
            T_TIPO_DATA('7433559','26/10/2020'),
            T_TIPO_DATA('7433567','26/10/2020'),
            T_TIPO_DATA('7433437','26/10/2020'),
            T_TIPO_DATA('7433442','26/10/2020'),
            T_TIPO_DATA('7433448','26/10/2020'),
            T_TIPO_DATA('7433462','26/10/2020'),
            T_TIPO_DATA('7433510','26/10/2020'),
            T_TIPO_DATA('7433514','26/10/2020'),
            T_TIPO_DATA('7434405','26/10/2020'),
            T_TIPO_DATA('7433544','26/10/2020'),
            T_TIPO_DATA('7433570','26/10/2020'),
            T_TIPO_DATA('7433422','26/10/2020'),
            T_TIPO_DATA('7433430','26/10/2020'),
            T_TIPO_DATA('7433431','26/10/2020'),
            T_TIPO_DATA('7433455','26/10/2020'),
            T_TIPO_DATA('7433458','26/10/2020'),
            T_TIPO_DATA('7433475','26/10/2020'),
            T_TIPO_DATA('7434395','26/10/2020'),
            T_TIPO_DATA('7434419','26/10/2020'),
            T_TIPO_DATA('7322096','26/10/2020'),
            T_TIPO_DATA('7433507','26/10/2020'),
            T_TIPO_DATA('7433520','26/10/2020'),
            T_TIPO_DATA('7433534','26/10/2020'),
            T_TIPO_DATA('7434415','26/10/2020'),
            T_TIPO_DATA('7433557','26/10/2020'),
            T_TIPO_DATA('7434421','26/10/2020'),
            T_TIPO_DATA('7433451','26/10/2020'),
            T_TIPO_DATA('7433493','26/10/2020'),
            T_TIPO_DATA('7434393','26/10/2020'),
            T_TIPO_DATA('7433550','26/10/2020'),
            T_TIPO_DATA('7433502','26/10/2020'),
            T_TIPO_DATA('7433485','26/10/2020'),
            T_TIPO_DATA('7433529','26/10/2020'),
            T_TIPO_DATA('7434407','26/10/2020'),
            T_TIPO_DATA('7433542','26/10/2020'),
            T_TIPO_DATA('7433553','26/10/2020'),
            T_TIPO_DATA('7433554','26/10/2020'),
            T_TIPO_DATA('7434417','26/10/2020'),
            T_TIPO_DATA('7433435','26/10/2020'),
            T_TIPO_DATA('7433466','26/10/2020'),
            T_TIPO_DATA('7433467','26/10/2020'),
            T_TIPO_DATA('7433471','26/10/2020'),
            T_TIPO_DATA('7433472','26/10/2020'),
            T_TIPO_DATA('7433486','26/10/2020'),
            T_TIPO_DATA('7433488','26/10/2020'),
            T_TIPO_DATA('7433495','26/10/2020'),
            T_TIPO_DATA('7433496','26/10/2020'),
            T_TIPO_DATA('7433506','26/10/2020'),
            T_TIPO_DATA('7433516','26/10/2020'),
            T_TIPO_DATA('7433518','26/10/2020'),
            T_TIPO_DATA('7434396','26/10/2020'),
            T_TIPO_DATA('7434409','26/10/2020'),
            T_TIPO_DATA('7433556','26/10/2020'),
            T_TIPO_DATA('7433572','26/10/2020'),
            T_TIPO_DATA('7433453','26/10/2020'),
            T_TIPO_DATA('7433424','26/10/2020'),
            T_TIPO_DATA('7433432','26/10/2020'),
            T_TIPO_DATA('7433450','26/10/2020'),
            T_TIPO_DATA('7433452','26/10/2020'),
            T_TIPO_DATA('7433454','26/10/2020'),
            T_TIPO_DATA('7433492','26/10/2020'),
            T_TIPO_DATA('7433498','26/10/2020'),
            T_TIPO_DATA('7433503','26/10/2020'),
            T_TIPO_DATA('7433512','26/10/2020'),
            T_TIPO_DATA('7433545','26/10/2020'),
            T_TIPO_DATA('7433555','26/10/2020'),
            T_TIPO_DATA('7433530','26/10/2020'),
            T_TIPO_DATA('7434400','26/10/2020'),
            T_TIPO_DATA('7433532','26/10/2020'),
            T_TIPO_DATA('7433552','26/10/2020'),
            T_TIPO_DATA('7433566','26/10/2020'),
            T_TIPO_DATA('7433568','26/10/2020'),
            T_TIPO_DATA('7433571','26/10/2020'),
            T_TIPO_DATA('7433509','26/10/2020'),
            T_TIPO_DATA('7434394','26/10/2020'),
            T_TIPO_DATA('7433540','26/10/2020'),
            T_TIPO_DATA('7434401','26/10/2020'),
            T_TIPO_DATA('7434397','26/10/2020'),
            T_TIPO_DATA('7434398','26/10/2020'),
            T_TIPO_DATA('7433533','26/10/2020'),
            T_TIPO_DATA('7433547','26/10/2020'),
            T_TIPO_DATA('7434411','26/10/2020'),
            T_TIPO_DATA('7433560','26/10/2020'),
            T_TIPO_DATA('7433573','26/10/2020'),
            T_TIPO_DATA('7433429','26/10/2020'),
            T_TIPO_DATA('7433447','26/10/2020'),
            T_TIPO_DATA('7433456','26/10/2020'),
            T_TIPO_DATA('7433476','26/10/2020'),
            T_TIPO_DATA('7433480','26/10/2020'),
            T_TIPO_DATA('7433490','26/10/2020'),
            T_TIPO_DATA('7433494','26/10/2020'),
            T_TIPO_DATA('7433508','26/10/2020'),
            T_TIPO_DATA('7433515','26/10/2020'),
            T_TIPO_DATA('7433517','26/10/2020')


    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

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
            DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE DD_ETI_CODIGO = ''02''),
            TIT_FECHA_INSC_REG = TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),               
            USUARIOMODIFICAR = '''|| V_USUARIO ||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            --Se selecciona el TIT_ID del activo
            V_MSQL := 'SELECT TIT_ID FROM '||V_ESQUEMA||'.ACT_TIT_TITULO WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_TIT_ID;

            --Se selecciona el DD_ESP_ID
            V_MSQL := 'SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03''';
            EXECUTE IMMEDIATE V_MSQL INTO V_ESP_ID;

            --Se crea registro en el historico
            V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO (AHT_ID, TIT_ID, AHT_FECHA_PRES_REGISTRO, AHT_FECHA_INSCRIPCION, DD_ESP_ID, USUARIOCREAR, FECHACREAR)
            VALUES (
                '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL,
                '||V_TIT_ID||',
                TO_DATE(''29/07/2021'', ''DD-MM-YYYY''), 
                TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),  
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