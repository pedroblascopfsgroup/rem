--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10178
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
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-10178'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                T_TIPO_DATA('7026769'),
                T_TIPO_DATA('7026770'),
                T_TIPO_DATA('7026771'),
                T_TIPO_DATA('7026772'),
                T_TIPO_DATA('7026773'),
                T_TIPO_DATA('7026774'),
                T_TIPO_DATA('7026775'),
                T_TIPO_DATA('7026776'),
                T_TIPO_DATA('7026777'),
                T_TIPO_DATA('7026778'),
                T_TIPO_DATA('7026779'),
                T_TIPO_DATA('7026780'),
                T_TIPO_DATA('7026781'),
                T_TIPO_DATA('7026782'),
                T_TIPO_DATA('7026783'),
                T_TIPO_DATA('7026784'),
                T_TIPO_DATA('7026785'),
                T_TIPO_DATA('7026786'),
                T_TIPO_DATA('7026787'),
                T_TIPO_DATA('7026788'),
                T_TIPO_DATA('7026789'),
                T_TIPO_DATA('7026790'),
                T_TIPO_DATA('7026791'),
                T_TIPO_DATA('7026792'),
                T_TIPO_DATA('7026793'),
                T_TIPO_DATA('7026794'),
                T_TIPO_DATA('7026795'),
                T_TIPO_DATA('7026796'),
                T_TIPO_DATA('7026797'),
                T_TIPO_DATA('7026798'),
                T_TIPO_DATA('7026799'),
                T_TIPO_DATA('7026800'),
                T_TIPO_DATA('7026801'),
                T_TIPO_DATA('7026802'),
                T_TIPO_DATA('7026803'),
                T_TIPO_DATA('7026804'),
                T_TIPO_DATA('7026805'),
                T_TIPO_DATA('7026806'),
                T_TIPO_DATA('7026807'),
                T_TIPO_DATA('7026808'),
                T_TIPO_DATA('7026809'),
                T_TIPO_DATA('7026810'),
                T_TIPO_DATA('7026811'),
                T_TIPO_DATA('7026812'),
                T_TIPO_DATA('7026813'),
                T_TIPO_DATA('7026814'),
                T_TIPO_DATA('7026815'),
                T_TIPO_DATA('7026816'),
                T_TIPO_DATA('7026817'),
                T_TIPO_DATA('7026818'),
                T_TIPO_DATA('7026819'),
                T_TIPO_DATA('7026820'),
                T_TIPO_DATA('7026821'),
                T_TIPO_DATA('7026822'),
                T_TIPO_DATA('7026823'),
                T_TIPO_DATA('7026824'),
                T_TIPO_DATA('7026825'),
                T_TIPO_DATA('7026826'),
                T_TIPO_DATA('7026827'),
                T_TIPO_DATA('7026828'),
                T_TIPO_DATA('7026829'),
                T_TIPO_DATA('7026830')

                


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
            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET           
            DD_STA_ID =(SELECT DD_STA_ID FROM '||V_ESQUEMA||'.DD_STA_SUBTIPO_TITULO_ACTIVO WHERE DD_STA_CODIGO = ''NCC''),               
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