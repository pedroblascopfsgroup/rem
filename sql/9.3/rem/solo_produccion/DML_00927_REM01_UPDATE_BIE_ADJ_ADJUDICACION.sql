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
    V_ADJ_ID NUMBER(16);
    V_BIE_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('7465018','11/02/2013'),
            T_TIPO_DATA('7465019','11/02/2013'),
            T_TIPO_DATA('7465021','11/02/2013'),
            T_TIPO_DATA('7465022','11/02/2013'),
            T_TIPO_DATA('7465024','11/02/2013'),
            T_TIPO_DATA('7465025','11/02/2013'),
            T_TIPO_DATA('7465028','11/02/2013'),
            T_TIPO_DATA('7465030','11/02/2013'),
            T_TIPO_DATA('7465031','11/02/2013'),
            T_TIPO_DATA('7465033','11/02/2013'),
            T_TIPO_DATA('7465038','11/02/2013'),
            T_TIPO_DATA('7465040','11/02/2013'),
            T_TIPO_DATA('7465041','11/02/2013'),
            T_TIPO_DATA('7465042','11/02/2013'),
            T_TIPO_DATA('7465045','11/02/2013'),
            T_TIPO_DATA('7465046','11/02/2013'),
            T_TIPO_DATA('7465047','11/02/2013'),
            T_TIPO_DATA('7465049','11/02/2013'),
            T_TIPO_DATA('7465050','11/02/2013'),
            T_TIPO_DATA('7465051','11/02/2013'),
            T_TIPO_DATA('7465052','11/02/2013')

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