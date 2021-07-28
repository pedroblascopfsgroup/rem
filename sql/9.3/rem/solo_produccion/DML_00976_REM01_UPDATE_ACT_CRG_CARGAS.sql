--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10232
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10232'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
    V_COUNT2 NUMBER(16);
	V_ID NUMBER(16);
    BIE_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7433574'),
            T_TIPO_DATA('7433420'),
            T_TIPO_DATA('7433561'),
            T_TIPO_DATA('7433481'),
            T_TIPO_DATA('7433497'),
            T_TIPO_DATA('7433524'),
            T_TIPO_DATA('7434414'),
            T_TIPO_DATA('7433464'),
            T_TIPO_DATA('7433482'),
            T_TIPO_DATA('7434406'),
            T_TIPO_DATA('7434416'),
            T_TIPO_DATA('7433436'),
            T_TIPO_DATA('7434413'),
            T_TIPO_DATA('7434418'),
            T_TIPO_DATA('7433478'),
            T_TIPO_DATA('7433511'),
            T_TIPO_DATA('7433491'),
            T_TIPO_DATA('7433421'),
            T_TIPO_DATA('7433504'),
            T_TIPO_DATA('7433510'),
            T_TIPO_DATA('7433475'),
            T_TIPO_DATA('7434419'),
            T_TIPO_DATA('7433493'),
            T_TIPO_DATA('7433485'),
            T_TIPO_DATA('7433496'),
            T_TIPO_DATA('7433572'),
            T_TIPO_DATA('7433453'),
            T_TIPO_DATA('7433452'),
            T_TIPO_DATA('7433503'),
            T_TIPO_DATA('7433568'),
            T_TIPO_DATA('7434394'),
            T_TIPO_DATA('7434397'),
            T_TIPO_DATA('7433573'),
            T_TIPO_DATA('7433476')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia NUM ACTIVO
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ACT_ID
            V_MSQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

             --Obtenemos el BIE_ID
            V_MSQL := 'SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO BIE_ID;

            --Comprobamos la existencia NUM ACTIVO
            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS WHERE BIE_ID = '||BIE_ID||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_COUNT2;	

            IF V_COUNT2 = 1 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE EL BIEN '''||BIE_ID||''' EN LA BIE_CAR_CARGAS, SE ACTUALIZA');

             --Actualizamos en BIE_CAR_CARGAS
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.BIE_CAR_CARGAS SET
               BIE_CAR_TITULAR = ''BBVA'',
               BIE_CAR_IMPORTE_REGISTRAL = 310400,
               BIE_CAR_FECHA_INSCRIPCION = TO_DATE(''05/11/2018'', ''DD/MM/YYYY''),
               USUARIOMODIFICAR = '''||V_USUARIO||''',
               FECHAMODIFICAR = SYSDATE               
               WHERE BIE_ID = '||BIE_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO EN BIE_CAR_CARGAS');

            --Actualizamos en ACT_CRG_CARGAS
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_CRG_CARGAS SET
               DD_TCA_ID = (SELECT DD_TCA_ID FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA WHERE DD_TCA_CODIGO = ''REG''),
               CRG_CARGAS_PROPIAS = 1,
               DD_STC_ID = (SELECT DD_STC_ID FROM '||V_ESQUEMA||'.DD_STC_SUBTIPO_CARGA WHERE DD_STC_CODIGO = ''01''),
               DD_ECG_ID = (SELECT DD_ECG_ID FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_CARGA WHERE DD_ECG_CODIGO = ''01''),
               DD_SCG_ID = (SELECT DD_SCG_ID FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA WHERE DD_SCG_CODIGO = ''02''),
               CRG_IMPIDE_VENTA = 2,
               USUARIOMODIFICAR = '''||V_USUARIO||''',
               FECHAMODIFICAR = SYSDATE               
               WHERE ACT_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '||V_TMP_TIPO_DATA(1)||' ACTUALIZADO EN ACT_CRG_CARGAS');

            ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL BIEN '''||BIE_ID||''' EN LA BIE_CAR_CARGAS, SE INSERTA');

             --Insertamos en BIE_CAR_CARGAS
	        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.BIE_CAR_CARGAS (BIE_ID, BIE_CAR_ID, DD_TPC_ID, BIE_CAR_TITULAR, BIE_CAR_IMPORTE_REGISTRAL, BIE_CAR_FECHA_INSCRIPCION, USUARIOCREAR, FECHACREAR) 
	                    VALUES (
	                    (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ID||'),
						 '||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL,
                        (SELECT DD_TPC_ID FROM '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA WHERE DD_TPC_CODIGO = ''0''),
                        ''BBVA'',
                        310400,
                        TO_DATE(''05/11/2018'', ''DD/MM/YYYY''),
	                    '''||V_USUARIO||''',
	                    SYSDATE
						)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '||V_TMP_TIPO_DATA(1)||' INSERTADO EN BIE_CAR_CARGAS');
            COMMIT;


            --Insertamos en ACT_CRG_CARGAS
	        V_MSQL :='INSERT INTO '||V_ESQUEMA||'.ACT_CRG_CARGAS (CRG_ID, ACT_ID, BIE_CAR_ID, DD_TCA_ID, CRG_CARGAS_PROPIAS, DD_STC_ID, DD_ECG_ID, DD_SCG_ID, CRG_IMPIDE_VENTA, USUARIOCREAR, FECHACREAR) 
	                    VALUES (
						 '||V_ESQUEMA||'.S_ACT_CRG_CARGAS.NEXTVAL,                       
                        '||V_ID||',
                        (SELECT bie.BIE_CAR_ID FROM BIE_CAR_CARGAS bie JOIN ACT_ACTIVO act ON act.BIE_ID = bie.BIE_ID  WHERE act.ACT_ID = '||V_ID||'),
                        (SELECT DD_TCA_ID FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA WHERE DD_TCA_CODIGO = ''REG''),
                        1,
                        (SELECT DD_STC_ID FROM '||V_ESQUEMA||'.DD_STC_SUBTIPO_CARGA WHERE DD_STC_CODIGO = ''01''),
                        (SELECT DD_ECG_ID FROM '||V_ESQUEMA||'.DD_ECG_ESTADO_CARGA WHERE DD_ECG_CODIGO = ''01''),
                        (SELECT DD_SCG_ID FROM '||V_ESQUEMA||'.DD_SCG_SUBESTADO_CARGA WHERE DD_SCG_CODIGO = ''02''),
                        2,
	                    '''||V_USUARIO||''',
	                    SYSDATE
						)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '||V_TMP_TIPO_DATA(1)||' INSERTADO EN ACT_CRG_CARGAS');


            END IF;

          
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL ACTIVO '||V_TMP_TIPO_DATA(1)||'');

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
