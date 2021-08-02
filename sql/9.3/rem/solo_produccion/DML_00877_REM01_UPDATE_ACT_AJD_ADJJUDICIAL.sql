--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210525
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9796
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9796'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_ADJ_ID NUMBER(16);
    V_BIE_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7433934','05/09/2014','03/11/2014'),
            T_TIPO_DATA('7460101','29/04/2021','29/04/2021'),
            T_TIPO_DATA('7460103','29/04/2021','29/04/2021'),
            T_TIPO_DATA('6884763','05/11/2015','07/02/2018'),
            T_TIPO_DATA('7434729','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7386266','29/12/2020','29/12/2020'),
            T_TIPO_DATA('7327390','03/03/2011','03/03/2011'),
            T_TIPO_DATA('6873386','07/09/2018','22/04/2021'),
            T_TIPO_DATA('6876900','23/10/2012','14/03/2018'),
            T_TIPO_DATA('7293158','15/06/2018','20/03/2019'),
            T_TIPO_DATA('7293178','15/06/2018','20/03/2019'),
            T_TIPO_DATA('7386265','29/12/2020','29/12/2020'),
            T_TIPO_DATA('6964183','25/08/2020','18/12/2020'),
            T_TIPO_DATA('6885035','18/06/2015','20/06/2016'),
            T_TIPO_DATA('7327386','03/03/2011','03/03/2011'),
            T_TIPO_DATA('7434190','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434140','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434184','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434191','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434193','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434222','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434102','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434158','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434157','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434182','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434195','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434187','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434204','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434077','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434142','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434160','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434223','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434133','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434098','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434081','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434099','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434078','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434202','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434215','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434079','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434221','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434084','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434107','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434186','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434104','20/05/2014','31/07/2014'),
            T_TIPO_DATA('6876481','31/03/2015','30/04/2015'),
            T_TIPO_DATA('6964186','25/08/2020','18/12/2020'),
            T_TIPO_DATA('7434181','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434082','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434218','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434109','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434219','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7460099','29/04/2021','29/04/2021'),
            T_TIPO_DATA('7460100','29/04/2021','29/04/2021'),
            T_TIPO_DATA('7434743','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7075420','29/10/2020','16/11/2020'),
            T_TIPO_DATA('7075460','29/10/2020','16/11/2020'),
            T_TIPO_DATA('7075417','29/10/2020','16/11/2020'),
            T_TIPO_DATA('7075416','29/10/2020','16/11/2020'),
            T_TIPO_DATA('7434737','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434726','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434749','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434747','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434727','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434728','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434730','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434732','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434736','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434740','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434741','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434753','10/03/2021','10/03/2021'),
            T_TIPO_DATA('7434121','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434137','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434189','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434220','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434087','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434075','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434207','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434050','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434052','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434053','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434054','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434057','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434066','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434068','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434069','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434071','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434080','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434083','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434092','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434093','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434094','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434100','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434108','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434116','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434117','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434119','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434120','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434122','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434123','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434141','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434146','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434147','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434161','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434162','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434163','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434165','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434169','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434170','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434173','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434192','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434198','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434200','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434206','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434209','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434210','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434211','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434216','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434055','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434058','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434074','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434124','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434125','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434145','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434177','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434059','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434064','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434143','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434164','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7432714','05/03/2021','05/03/2021'),
            T_TIPO_DATA('7434067','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434070','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434085','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434086','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434095','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434101','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434105','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434113','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434118','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434126','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434134','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434151','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434154','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434156','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434172','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434176','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434197','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434208','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434213','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434217','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434129','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434063','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434090','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434128','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434132','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434178','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434180','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434185','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434148','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434065','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434076','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434136','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434196','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434062','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434097','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434061','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434130','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434060','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434091','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434139','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434166','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434171','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434179','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434183','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434188','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434199','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434073','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434089','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434106','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434114','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434127','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434131','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434138','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434153','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434175','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434194','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434201','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434203','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434144','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434155','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7434167','20/05/2014','31/07/2014'),
            T_TIPO_DATA('7431641','30/05/2019','02/01/2020'),
            T_TIPO_DATA('7460937','08/10/2020','20/11/2020'),
            T_TIPO_DATA('7460938','08/10/2020','20/11/2020'),
            T_TIPO_DATA('7460939','08/10/2020','20/11/2020'),
            T_TIPO_DATA('7460940','08/10/2020','20/11/2020'),
            T_TIPO_DATA('7460941','08/10/2020','20/11/2020')

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

                --Actualizamos el dato
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL SET
                AJD_FECHA_ADJUDICACION = TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''),               
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE               
                WHERE ACT_ID = '||V_ACT_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

                --Obtenemos el ID del BIE
                V_MSQL := 'SELECT BIE_ADJ_ID FROM '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL WHERE ACT_ID = '||V_ACT_ID||'';
                EXECUTE IMMEDIATE V_MSQL INTO V_ADJ_ID;

                --Actualizamos el dato
                V_MSQL:= 'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION SET
                BIE_ADJ_F_DECRETO_FIRME = TO_DATE('''||V_TMP_TIPO_DATA(3)||''', ''DD-MM-YYYY''),              
                USUARIOMODIFICAR = '''|| V_USUARIO ||''',
                FECHAMODIFICAR = SYSDATE               
                WHERE BIE_ADJ_ID = '||V_ADJ_ID||'';
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO]: FECHAS DEL ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADAS');
            
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
                    TO_DATE('''||V_TMP_TIPO_DATA(3)||''', ''DD-MM-YYYY''), 
                    '''|| V_USUARIO ||''',
                    SYSDATE
                )';
                EXECUTE IMMEDIATE V_MSQL;

                --Se obtiene la secuencia creada en el insert anterior
                V_MSQL:= 'SELECT '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION.CURRVAL FROM DUAL';
			    EXECUTE IMMEDIATE V_MSQL INTO V_ADJ_ID;

                --Se crea registro en la tabla ACT_AJD_ADJUDICIAL
                V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL (AJD_ID, ACT_ID, BIE_ADJ_ID, AJD_FECHA_ADJUDICACION, USUARIOCREAR, FECHACREAR)
                VALUES (
                    '||V_ESQUEMA||'.S_ACT_AJD_ADJJUDICIAL.NEXTVAL,
                    '||V_ACT_ID||',
                    '||V_ADJ_ID||',
                    TO_DATE('''||V_TMP_TIPO_DATA(2)||''', ''DD-MM-YYYY''), 
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