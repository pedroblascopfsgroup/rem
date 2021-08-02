--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210623
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10043
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10043'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_ADJ_ID NUMBER(16);
    V_BIE_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('6878600','12/07/2010'),
            T_TIPO_DATA('6876193','14/07/2010'),
            T_TIPO_DATA('6878125','30/10/2018'),
            T_TIPO_DATA('6850316','04/10/2010'),
            T_TIPO_DATA('6876607','30/06/2014'),
            T_TIPO_DATA('6876101','21/03/2012'),
            T_TIPO_DATA('6878611','22/05/2012'),
            T_TIPO_DATA('6875450','13/07/2012'),
            T_TIPO_DATA('6854025','26/06/2012'),
            T_TIPO_DATA('6882729','24/03/2014'),
            T_TIPO_DATA('6881806','24/03/2014'),
            T_TIPO_DATA('6882091','05/06/2014'),
            T_TIPO_DATA('6874150','01/12/2015'),
            T_TIPO_DATA('6875071','20/03/2015'),
            T_TIPO_DATA('6881793','18/07/2015'),
            T_TIPO_DATA('6876625','08/09/2015'),
            T_TIPO_DATA('6875158','27/03/2017'),
            T_TIPO_DATA('6875935','02/11/2016'),
            T_TIPO_DATA('6848451','18/02/2016'),
            T_TIPO_DATA('6848452','18/02/2016'),
            T_TIPO_DATA('6850768','18/02/2016'),
            T_TIPO_DATA('6874994','21/11/2017'),
            T_TIPO_DATA('6883891','26/05/2016'),
            T_TIPO_DATA('6883981','19/10/2016'),
            T_TIPO_DATA('6851158','05/05/2017'),
            T_TIPO_DATA('6935715','02/06/2021'),
            T_TIPO_DATA('7226843','08/06/2021'),
            T_TIPO_DATA('7462404','03/06/2021'),
            T_TIPO_DATA('7461509','31/05/2021'),
            T_TIPO_DATA('7461846','14/06/2021'),
            T_TIPO_DATA('7461893','14/06/2021'),
            T_TIPO_DATA('7461854','14/06/2021'),
            T_TIPO_DATA('7461906','14/06/2021'),
            T_TIPO_DATA('6882925','24/03/2014'),
            T_TIPO_DATA('6876918','15/06/2021'),
            T_TIPO_DATA('6875127','19/02/2018'),
            T_TIPO_DATA('6885229','18/06/2021'),
            T_TIPO_DATA('6876757','10/07/2020'),
            T_TIPO_DATA('6879220','01/10/2008'),
            T_TIPO_DATA('6878400','04/02/2005'),
            T_TIPO_DATA('6877999','04/02/2005'),
            T_TIPO_DATA('6877372','25/01/2011'),
            T_TIPO_DATA('6878437','15/12/2011'),
            T_TIPO_DATA('6852049','26/01/1993'),
            T_TIPO_DATA('6848888','22/04/1991'),
            T_TIPO_DATA('6849696','17/07/1996'),
            T_TIPO_DATA('6848631','28/11/2016'),
            T_TIPO_DATA('6849697','28/11/2016'),
            T_TIPO_DATA('6877339','17/11/2011'),
            T_TIPO_DATA('6881075','28/09/2010'),
            T_TIPO_DATA('6850566','04/10/2012'),
            T_TIPO_DATA('6853883','24/04/2012'),
            T_TIPO_DATA('6850822','24/04/2012'),
            T_TIPO_DATA('6850994','19/10/2011'),
            T_TIPO_DATA('6877803','22/10/2012'),
            T_TIPO_DATA('6877420','10/09/2012'),
            T_TIPO_DATA('6852294','11/01/2017'),
            T_TIPO_DATA('6854068','11/01/2017'),
            T_TIPO_DATA('6852295','11/01/2017'),
            T_TIPO_DATA('6850324','09/07/2019'),
            T_TIPO_DATA('6878706','19/09/2017'),
            T_TIPO_DATA('6854520','30/03/2017'),
            T_TIPO_DATA('6854787','30/03/2017'),
            T_TIPO_DATA('6874836','10/07/2020'),
            T_TIPO_DATA('7003827','16/07/2014'),
            T_TIPO_DATA('7461919','27/01/2021'),
            T_TIPO_DATA('7461799','27/01/2021'),
            T_TIPO_DATA('6883013','13/06/2014'),
            T_TIPO_DATA('6883572','13/06/2014'),
            T_TIPO_DATA('6883571','13/06/2014'),
            T_TIPO_DATA('6857387','08/07/2016'),
            T_TIPO_DATA('6862939','02/09/2015'),
            T_TIPO_DATA('6863991','02/09/2015'),
            T_TIPO_DATA('6876791','16/12/2015'),
            T_TIPO_DATA('6873711','28/04/2016'),
            T_TIPO_DATA('6875727','17/06/2021'),
            T_TIPO_DATA('6875728','17/06/2021'),
            T_TIPO_DATA('6875370','17/06/2021'),
            T_TIPO_DATA('6876340','17/06/2021'),
            T_TIPO_DATA('6876341','17/06/2021'),
            T_TIPO_DATA('6875740','03/11/2015'),
            T_TIPO_DATA('6881710','22/01/2016'),
            T_TIPO_DATA('6880938','22/01/2016'),
            T_TIPO_DATA('6881506','22/01/2016'),
            T_TIPO_DATA('6874285','22/07/2016'),
            T_TIPO_DATA('6852349','28/07/2020'),
            T_TIPO_DATA('6852987','15/02/2016'),
            T_TIPO_DATA('6866117','25/04/2017'),
            T_TIPO_DATA('6866358','25/04/2017'),
            T_TIPO_DATA('6874688','23/06/2015'),
            T_TIPO_DATA('6874968','23/06/2015'),
            T_TIPO_DATA('6872975','28/07/2020'),
            T_TIPO_DATA('6849389','18/02/2016'),
            T_TIPO_DATA('6848520','18/02/2016'),
            T_TIPO_DATA('6882741','01/10/2020'),
            T_TIPO_DATA('6882742','01/10/2020'),
            T_TIPO_DATA('6877040','18/05/2017'),
            T_TIPO_DATA('6884146','13/02/2020'),
            T_TIPO_DATA('6853173','03/11/2017'),
            T_TIPO_DATA('6867223','29/09/2016'),
            T_TIPO_DATA('6866959','29/09/2016'),
            T_TIPO_DATA('6866657','29/09/2016'),
            T_TIPO_DATA('6866658','29/09/2016'),
            T_TIPO_DATA('6873448','29/12/2017'),
            T_TIPO_DATA('6884633','24/10/2016'),
            T_TIPO_DATA('6866258','14/02/2019'),
            T_TIPO_DATA('6866745','14/02/2019'),
            T_TIPO_DATA('6866403','14/02/2019'),
            T_TIPO_DATA('6866935','14/02/2019'),
            T_TIPO_DATA('6866404','14/02/2019'),
            T_TIPO_DATA('6866747','14/02/2019'),
            T_TIPO_DATA('6866784','14/02/2019'),
            T_TIPO_DATA('6866936','14/02/2019'),
            T_TIPO_DATA('6867028','14/02/2019'),
            T_TIPO_DATA('6866937','14/02/2019'),
            T_TIPO_DATA('6866482','14/02/2019'),
            T_TIPO_DATA('6867529','14/02/2019'),
            T_TIPO_DATA('6866406','14/02/2019'),
            T_TIPO_DATA('6867622','14/02/2019'),
            T_TIPO_DATA('6866938','14/02/2019'),
            T_TIPO_DATA('6866407','14/02/2019'),
            T_TIPO_DATA('6871989','27/10/2016'),
            T_TIPO_DATA('6873651','27/10/2016'),
            T_TIPO_DATA('6873650','27/10/2016'),
            T_TIPO_DATA('6876882','14/12/2016'),
            T_TIPO_DATA('6874704','21/06/2017'),
            T_TIPO_DATA('6876136','21/06/2017'),
            T_TIPO_DATA('6871943','21/06/2017'),
            T_TIPO_DATA('6883740','04/10/2018'),
            T_TIPO_DATA('6882917','05/02/2020'),
            T_TIPO_DATA('6884237','02/01/2020'),
            T_TIPO_DATA('6874204','17/03/2021'),
            T_TIPO_DATA('6874740','26/06/2018'),
            T_TIPO_DATA('6871053','30/06/2017'),
            T_TIPO_DATA('6870733','30/06/2017'),
            T_TIPO_DATA('6870747','30/06/2017'),
            T_TIPO_DATA('6880652','01/09/2017'),
            T_TIPO_DATA('6883114','09/06/2020'),
            T_TIPO_DATA('6884694','09/06/2020'),
            T_TIPO_DATA('6882280','01/06/2021'),
            T_TIPO_DATA('6882922','01/06/2021'),
            T_TIPO_DATA('6883109','16/07/2019'),
            T_TIPO_DATA('6883108','16/07/2019'),
            T_TIPO_DATA('6883110','16/07/2019'),
            T_TIPO_DATA('6885156','24/01/2018'),
            T_TIPO_DATA('6884334','24/01/2018'),
            T_TIPO_DATA('6965334','02/10/2020'),
            T_TIPO_DATA('6873273','09/07/2019'),
            T_TIPO_DATA('6874678','09/07/2019'),
            T_TIPO_DATA('6852801','31/10/2019'),
            T_TIPO_DATA('6852079','31/10/2019'),
            T_TIPO_DATA('6935719','02/06/2021'),
            T_TIPO_DATA('6935724','02/06/2021'),
            T_TIPO_DATA('6935725','02/06/2021'),
            T_TIPO_DATA('6935708','02/06/2021'),
            T_TIPO_DATA('6938594','20/09/2018'),
            T_TIPO_DATA('6948284','20/10/2020'),
            T_TIPO_DATA('6957091','12/03/2020'),
            T_TIPO_DATA('7005325','30/09/2019'),
            T_TIPO_DATA('7017948','16/12/2019'),
            T_TIPO_DATA('7017965','16/12/2019'),
            T_TIPO_DATA('7015156','16/10/2019'),
            T_TIPO_DATA('7015096','16/10/2019'),
            T_TIPO_DATA('7072647','25/11/2019'),
            T_TIPO_DATA('7072618','25/11/2019'),
            T_TIPO_DATA('7072574','25/11/2019'),
            T_TIPO_DATA('7072602','25/11/2019'),
            T_TIPO_DATA('7072707','03/02/2020'),
            T_TIPO_DATA('7072701','03/02/2020'),
            T_TIPO_DATA('7072755','12/02/2021'),
            T_TIPO_DATA('7089574','17/09/2019'),
            T_TIPO_DATA('7073051','21/03/2019'),
            T_TIPO_DATA('7073040','21/03/2019'),
            T_TIPO_DATA('7073041','21/03/2019'),
            T_TIPO_DATA('7072982','21/03/2019'),
            T_TIPO_DATA('7298957','07/06/2021'),
            T_TIPO_DATA('7387203','12/02/2021'),
            T_TIPO_DATA('7423097','03/06/2021'),
            T_TIPO_DATA('7461982','10/06/2021'),
            T_TIPO_DATA('7431854','19/02/2021'),
            T_TIPO_DATA('7434346','08/06/2021'),
            T_TIPO_DATA('7461978','08/06/2021'),
            T_TIPO_DATA('7433241','14/06/2021'),
            T_TIPO_DATA('7461507','03/06/2021'),
            T_TIPO_DATA('7466140','10/06/2021'),
            T_TIPO_DATA('7471565','10/06/2021')

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

            --Comprobamos que existe
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL WHERE ACT_ID = '||V_ACT_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

            IF V_COUNT > 0 THEN

                --Obtenemos el ID del BIE
                V_MSQL := 'SELECT BIE_ADJ_ID FROM '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL WHERE ACT_ID = '||V_ACT_ID||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ADJ_ID;

                --Actualizamos el dato
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET
                BIE_ADJ_F_DECRETO_FIRME = TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),              
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE               
                WHERE BIE_ADJ_ID = '||V_ADJ_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: FECHA DEL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADAS');
            
            ELSE

                --El activo no tiene registros en las tablas de adjudicación, se procede a crearlas

                --Se selecciona el BIE_ID del activo
                V_MSQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.BIE_BIEN WHERE BIE_ENTIDAD_ID = '||V_TMP_TIPO_DATA(1)||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_BIE_ID;

                --Se crea registro en la tabla BIE_ADJ_ADJUDICACION
                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION (BIE_ID, BIE_ADJ_ID, BIE_ADJ_F_DECRETO_FIRME, USUARIOCREAR, FECHACREAR)
                VALUES (
                    '||V_BIE_ID||',
                    '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.NEXTVAL,
                    TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''), 
                    '''|| V_USUARIO ||''',
                    SYSDATE
                )';
                EXECUTE IMMEDIATE V_MSQL;

                --Se obtiene la secuencia creada en el insert anterior
                V_MSQL:= 'SELECT '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.CURRVAL FROM DUAL';
			    EXECUTE IMMEDIATE V_MSQL INTO V_ADJ_ID;

                --Se crea registro en la tabla ACT_AJD_ADJUDICIAL
                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL (AJD_ID, ACT_ID, BIE_ADJ_ID, USUARIOCREAR, FECHACREAR)
                VALUES (
                    '||V_ESQUEMA||'.S_ACT_AJD_ADJJUDICIAL.NEXTVAL,
                    '||V_ACT_ID||',
                    '||V_ADJ_ID||',
                    '''|| V_USUARIO ||''',
                    SYSDATE
                )';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' NO TENÍA REGISTROS EN LAS TABLAS DE ADJUDICACIÓN, SE HAN CREADO CON LAS FECHAS CORRESPONDIENTES');

            END IF;
            
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