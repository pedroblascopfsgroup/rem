--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10149
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10149'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_TIT_ID NUMBER(16);
    V_ESP_ID NUMBER(16);
    V_ETI_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7042854'),
                T_TIPO_DATA('7042929'),
                T_TIPO_DATA('7042931'),
                T_TIPO_DATA('7043036'),
                T_TIPO_DATA('7043056'),
                T_TIPO_DATA('7043076'),
                T_TIPO_DATA('7043149'),
                T_TIPO_DATA('7043213'),
                T_TIPO_DATA('7043260'),
                T_TIPO_DATA('7043282'),
                T_TIPO_DATA('7043314'),
                T_TIPO_DATA('7043338'),
                T_TIPO_DATA('7043525'),
                T_TIPO_DATA('7043532'),
                T_TIPO_DATA('7043561'),
                T_TIPO_DATA('7043586'),
                T_TIPO_DATA('7043614'),
                T_TIPO_DATA('7043645'),
                T_TIPO_DATA('7043655'),
                T_TIPO_DATA('7043660'),
                T_TIPO_DATA('7043661'),
                T_TIPO_DATA('7043662'),
                T_TIPO_DATA('7043680'),
                T_TIPO_DATA('7043797'),
                T_TIPO_DATA('7043812'),
                T_TIPO_DATA('7043817'),
                T_TIPO_DATA('7043819'),
                T_TIPO_DATA('7043838'),
                T_TIPO_DATA('7043853'),
                T_TIPO_DATA('7043923'),
                T_TIPO_DATA('7044027'),
                T_TIPO_DATA('7044033'),
                T_TIPO_DATA('7044238'),
                T_TIPO_DATA('7044485'),
                T_TIPO_DATA('7044501'),
                T_TIPO_DATA('7044695'),
                T_TIPO_DATA('7044744'),
                T_TIPO_DATA('7044811'),
                T_TIPO_DATA('7044857'),
                T_TIPO_DATA('7044930'),
                T_TIPO_DATA('7045025'),
                T_TIPO_DATA('7045033'),
                T_TIPO_DATA('7045044'),
                T_TIPO_DATA('7045182'),
                T_TIPO_DATA('7045183'),
                T_TIPO_DATA('7045306'),
                T_TIPO_DATA('7045315'),
                T_TIPO_DATA('7045388'),
                T_TIPO_DATA('7045462'),
                T_TIPO_DATA('7045484'),
                T_TIPO_DATA('7045512'),
                T_TIPO_DATA('7045560'),
                T_TIPO_DATA('7045570'),
                T_TIPO_DATA('7045586'),
                T_TIPO_DATA('7045649'),
                T_TIPO_DATA('7045703'),
                T_TIPO_DATA('7045730'),
                T_TIPO_DATA('7045761'),
                T_TIPO_DATA('7045769'),
                T_TIPO_DATA('7045816'),
                T_TIPO_DATA('7045865'),
                T_TIPO_DATA('7045917'),
                T_TIPO_DATA('7045919'),
                T_TIPO_DATA('7045927'),
                T_TIPO_DATA('7045967'),
                T_TIPO_DATA('7046138'),
                T_TIPO_DATA('7046160'),
                T_TIPO_DATA('7046181'),
                T_TIPO_DATA('7046196'),
                T_TIPO_DATA('7046271'),
                T_TIPO_DATA('7046393'),
                T_TIPO_DATA('7046428'),
                T_TIPO_DATA('7046430'),
                T_TIPO_DATA('7046483'),
                T_TIPO_DATA('7046565'),
                T_TIPO_DATA('7046572'),
                T_TIPO_DATA('7046581'),
                T_TIPO_DATA('7046582'),
                T_TIPO_DATA('7046698'),
                T_TIPO_DATA('7047040'),
                T_TIPO_DATA('7047094'),
                T_TIPO_DATA('7047120'),
                T_TIPO_DATA('7047172'),
                T_TIPO_DATA('7047205'),
                T_TIPO_DATA('7047206'),
                T_TIPO_DATA('7047284'),
                T_TIPO_DATA('7047306'),
                T_TIPO_DATA('7047507'),
                T_TIPO_DATA('7047710'),
                T_TIPO_DATA('7047786'),
                T_TIPO_DATA('7047837'),
                T_TIPO_DATA('7048197'),
                T_TIPO_DATA('7048202'),
                T_TIPO_DATA('7048799'),
                T_TIPO_DATA('7048802'),
                T_TIPO_DATA('7049090'),
                T_TIPO_DATA('7049311'),
                T_TIPO_DATA('7049397'),
                T_TIPO_DATA('7049824'),
                T_TIPO_DATA('7049936'),
                T_TIPO_DATA('7049967'),
                T_TIPO_DATA('7050034'),
                T_TIPO_DATA('7050106'),
                T_TIPO_DATA('7050222'),
                T_TIPO_DATA('7050293'),
                T_TIPO_DATA('7050321'),
                T_TIPO_DATA('7050363'),
                T_TIPO_DATA('7050369'),
                T_TIPO_DATA('7050569'),
                T_TIPO_DATA('7050571'),
                T_TIPO_DATA('7050580'),
                T_TIPO_DATA('7050605'),
                T_TIPO_DATA('7050711'),
                T_TIPO_DATA('7050765'),
                T_TIPO_DATA('7050993'),
                T_TIPO_DATA('7051068'),
                T_TIPO_DATA('7051089'),
                T_TIPO_DATA('7051101'),
                T_TIPO_DATA('7051194'),
                T_TIPO_DATA('7051204'),
                T_TIPO_DATA('7051331'),
                T_TIPO_DATA('7051356'),
                T_TIPO_DATA('7051472'),
                T_TIPO_DATA('7051473'),
                T_TIPO_DATA('7051740'),
                T_TIPO_DATA('7051807'),
                T_TIPO_DATA('7051819'),
                T_TIPO_DATA('7051835'),
                T_TIPO_DATA('7051838'),
                T_TIPO_DATA('7055405')



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
            TIT_FECHA_PRESENT_HACIENDA ='''',               
            USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE               
            WHERE ACT_ID = '||V_ACT_ID||'';
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