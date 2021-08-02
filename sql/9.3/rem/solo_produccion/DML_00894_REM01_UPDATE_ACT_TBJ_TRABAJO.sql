--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210603
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9892
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9892'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('924567816266', '13', '02/06/2021'),
                T_TIPO_DATA('916964349138', 'CUR', '03/06/2021')

    	); 
    	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
        LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobamos la existencia del trabajo
        V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;	

        IF V_COUNT = 1 THEN

            --Obtenemos el ID del trabajo
            V_MSQL := 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_ID;

            --Actualizamos el dato
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET
               DD_EST_ID = (SELECT DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO WHERE DD_EST_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
               TBJ_FECHA_CAMBIO_ESTADO = TO_DATE('''||V_TMP_TIPO_DATA(3)||''', ''DD-MM-YYYY''),      
               USUARIOMODIFICAR = '''||V_USUARIO||''',
               FECHAMODIFICAR = SYSDATE               
               WHERE TBJ_ID = '||V_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '''||V_TMP_TIPO_DATA(1)||''' ACTUALIZADO');
            
        ELSE 

            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE EL TRABAJO '''||V_TMP_TIPO_DATA(1)||'''');

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