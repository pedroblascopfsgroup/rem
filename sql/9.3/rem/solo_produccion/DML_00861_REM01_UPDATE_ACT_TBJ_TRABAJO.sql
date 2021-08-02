--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9757
--## PRODUCTO=NO
--##
--## Finalidad: Script modifica area peticionaria y albaran trabajos
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9757'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_TBJ_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			NUM_TRABAJO  
        T_TIPO_DATA(921503000001),
        T_TIPO_DATA(921996400001),
        T_TIPO_DATA(922009300001),
        T_TIPO_DATA(922205100001),
        T_TIPO_DATA(922205200001),
        T_TIPO_DATA(922272800001),
        T_TIPO_DATA(922273000001),
        T_TIPO_DATA(922273100001),
        T_TIPO_DATA(922273200001),
        T_TIPO_DATA(922296200001),
        T_TIPO_DATA(922349100001),
        T_TIPO_DATA(923203000001),
        T_TIPO_DATA(923255700001),
        T_TIPO_DATA(923276700001),
        T_TIPO_DATA(923286000001),
        T_TIPO_DATA(923296300001),
        T_TIPO_DATA(923349800001)

        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR AREA Y PREFACTURA EN '||V_TEXT_TABLA);

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
                    DD_IRE_ID = NULL,
                    PFA_ID = NULL,
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