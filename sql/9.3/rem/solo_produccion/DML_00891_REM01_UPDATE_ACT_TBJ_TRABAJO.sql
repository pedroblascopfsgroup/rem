--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210602
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9877
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-9877'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ID NUMBER(16);
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('921525600001'),
                T_TIPO_DATA('921608200001'),
                T_TIPO_DATA('923337300001'),
                T_TIPO_DATA('923887100001'),
                T_TIPO_DATA('923890300001'),
                T_TIPO_DATA('924477000001'),
                T_TIPO_DATA('924558400001'),
                T_TIPO_DATA('924559800001'),
                T_TIPO_DATA('924567803908'),
                T_TIPO_DATA('924567809567'),
                T_TIPO_DATA('924567814302'),
                T_TIPO_DATA('924567814308'),
                T_TIPO_DATA('924567817882'),
                T_TIPO_DATA('924567817967'),
                T_TIPO_DATA('924567820788'),
                T_TIPO_DATA('924567820805'),
                T_TIPO_DATA('924567820984'),
                T_TIPO_DATA('924567820991'),
                T_TIPO_DATA('924567824781'),
                T_TIPO_DATA('924567833322'),
                T_TIPO_DATA('924567834153'),
                T_TIPO_DATA('924567834161'),
                T_TIPO_DATA('924567836827'),
                T_TIPO_DATA('924567836834'),
                T_TIPO_DATA('924567836840'),
                T_TIPO_DATA('924567836857'),
                T_TIPO_DATA('924567837337'),
                T_TIPO_DATA('924567838280'),
                T_TIPO_DATA('924567841374'),
                T_TIPO_DATA('924567842786'),
                T_TIPO_DATA('924567845305'),
                T_TIPO_DATA('924567845464'),
                T_TIPO_DATA('924567845906'),
                T_TIPO_DATA('924567849024'),
                T_TIPO_DATA('924567849400'),
                T_TIPO_DATA('924567849406'),
                T_TIPO_DATA('924567849414'),
                T_TIPO_DATA('924567849429'),
                T_TIPO_DATA('924567849432'),
                T_TIPO_DATA('924567849437'),
                T_TIPO_DATA('924567849445'),
                T_TIPO_DATA('924567849447'),
                T_TIPO_DATA('924567849453'),
                T_TIPO_DATA('924567849459'),
                T_TIPO_DATA('924567849464'),
                T_TIPO_DATA('924567850776'),
                T_TIPO_DATA('924567851954'),
                T_TIPO_DATA('924567853815')

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
               DD_IRE_ID = NULL,
               PFA_ID = NULL,      
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