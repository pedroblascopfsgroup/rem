--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210528
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9835
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9835'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
            T_TIPO_DATA('9000302386'),
            T_TIPO_DATA('9000277255'),
            T_TIPO_DATA('9000287922'),
            T_TIPO_DATA('916964368397'),
            T_TIPO_DATA('916964374492'),
            T_TIPO_DATA('916964336605'),
            T_TIPO_DATA('916964334936'),
            T_TIPO_DATA('916964371665'),
            T_TIPO_DATA('916964361014'),
            T_TIPO_DATA('916964377689'),
            T_TIPO_DATA('9000291567'),
            T_TIPO_DATA('916964358914'),
            T_TIPO_DATA('916964378364'),
            T_TIPO_DATA('916964366987'),
            T_TIPO_DATA('916950101073'),
            T_TIPO_DATA('916964377744'),
            T_TIPO_DATA('916964352008'),
            T_TIPO_DATA('9000286481'),
            T_TIPO_DATA('916964355854'),
            T_TIPO_DATA('9000185304'),
            T_TIPO_DATA('916964377709'),
            T_TIPO_DATA('916964347970'),
            T_TIPO_DATA('916964368075'),
            T_TIPO_DATA('9000301489'),
            T_TIPO_DATA('9000304487'),
            T_TIPO_DATA('916964365002'),
            T_TIPO_DATA('916964317641'),
            T_TIPO_DATA('9000304486'),
            T_TIPO_DATA('9000299963'),
            T_TIPO_DATA('9000142977'),
            T_TIPO_DATA('916964305615'),
            T_TIPO_DATA('916964344075'),
            T_TIPO_DATA('916964377759'),
            T_TIPO_DATA('916964328987'),
            T_TIPO_DATA('916964358926'),
            T_TIPO_DATA('916950103481'),
            T_TIPO_DATA('9000256121'),
            T_TIPO_DATA('916964358925'),
            T_TIPO_DATA('916964368392'),
            T_TIPO_DATA('916964302220'),
            T_TIPO_DATA('916964367747'),
            T_TIPO_DATA('916964379090'),
            T_TIPO_DATA('9000303104'),
            T_TIPO_DATA('916964370056'),
            T_TIPO_DATA('9000300631'),
            T_TIPO_DATA('916964353668'),
            T_TIPO_DATA('916964331796'),
            T_TIPO_DATA('916964374113'),
            T_TIPO_DATA('916964379346')

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
               DD_IRE_ID = (SELECT DD_IRE_ID FROM '||V_ESQUEMA||'.DD_IRE_IDENTIFICADOR_REAM WHERE DD_IRE_CODIGO = ''01''),               
               USUARIOMODIFICAR = '''|| V_USUARIO ||''',
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