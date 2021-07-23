--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10165
--## PRODUCTO=NO
--##
--## Finalidad: Cambiar fecha finalización
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
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_TBJ_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10165'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_TBJ_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			NUM_TRABAJO  
        T_TIPO_DATA('916964387640','24/05/2021'),
        T_TIPO_DATA('924567813844','24/05/2021'),
        T_TIPO_DATA('924567848037','24/05/2021'),
        T_TIPO_DATA('924567848036','24/05/2021'),
        T_TIPO_DATA('924567848033','24/05/2021'),
        T_TIPO_DATA('924567829508','24/05/2021'),
        T_TIPO_DATA('924567846145','24/05/2021'),
        T_TIPO_DATA('924567843776','24/05/2021'),
        T_TIPO_DATA('924567842229','24/05/2021'),
        T_TIPO_DATA('924567842226','24/05/2021'),
        T_TIPO_DATA('924567842225','24/05/2021'),
        T_TIPO_DATA('924567838734','24/05/2021'),
        T_TIPO_DATA('924567842222','24/05/2021'),
        T_TIPO_DATA('924567840058','24/05/2021'),
        T_TIPO_DATA('924567850405','24/05/2021'),
        T_TIPO_DATA('924567850402','24/05/2021'),
        T_TIPO_DATA('924567850401','24/05/2021'),
        T_TIPO_DATA('924567848893','24/05/2021')


        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_TBJ_ID:= 0;        

        V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            V_MSQL:= 'SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_TBJ_ID;

            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET                   
                    TBJ_FECHA_FIN = TO_DATE('''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', ''DD/MM/YYYY'') ,
                    USUARIOMODIFICAR = '''||V_USU||''',
                    FECHAMODIFICAR = SYSDATE
                    WHERE TBJ_ID = '||V_TBJ_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICADO CORRECTAMENTE TRABAJO '||V_TMP_TIPO_DATA(1)||'');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO]: TRABAJO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

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