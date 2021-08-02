--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9656
--## PRODUCTO=NO
--##
--## Finalidad: Script que quita borrado lógico
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9656'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);
	V_ACT_ID NUMBER(16);
    V_AGR_ID NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			ACTIVO  
        T_TIPO_DATA(134450),
        T_TIPO_DATA(202729),
        T_TIPO_DATA(202746),
        T_TIPO_DATA(203228),
        T_TIPO_DATA(203562),
        T_TIPO_DATA(933676),
        T_TIPO_DATA(933752),
        T_TIPO_DATA(933919),
        T_TIPO_DATA(934176),
        T_TIPO_DATA(934655),
        T_TIPO_DATA(934843),
        T_TIPO_DATA(934861),
        T_TIPO_DATA(935061),
        T_TIPO_DATA(935371),
        T_TIPO_DATA(935641),
        T_TIPO_DATA(935679),
        T_TIPO_DATA(935735),
        T_TIPO_DATA(936841),
        T_TIPO_DATA(937043),
        T_TIPO_DATA(937481),
        T_TIPO_DATA(937950),
        T_TIPO_DATA(937996),
        T_TIPO_DATA(938151),
        T_TIPO_DATA(938736),
        T_TIPO_DATA(938984),
        T_TIPO_DATA(939005),
        T_TIPO_DATA(939074),
        T_TIPO_DATA(939134),
        T_TIPO_DATA(939916),
        T_TIPO_DATA(939935),
        T_TIPO_DATA(940086),
        T_TIPO_DATA(940218),
        T_TIPO_DATA(940267),
        T_TIPO_DATA(940304),
        T_TIPO_DATA(940388),
        T_TIPO_DATA(940948),
        T_TIPO_DATA(941029),
        T_TIPO_DATA(941272),
        T_TIPO_DATA(941350),
        T_TIPO_DATA(941501),
        T_TIPO_DATA(941849),
        T_TIPO_DATA(941883),
        T_TIPO_DATA(941960),
        T_TIPO_DATA(942175),
        T_TIPO_DATA(942222),
        T_TIPO_DATA(942283),
        T_TIPO_DATA(942323),
        T_TIPO_DATA(942388),
        T_TIPO_DATA(942580),
        T_TIPO_DATA(942669),
        T_TIPO_DATA(942696),
        T_TIPO_DATA(942831),
        T_TIPO_DATA(943008),
        T_TIPO_DATA(943087),
        T_TIPO_DATA(943207),
        T_TIPO_DATA(943349),
        T_TIPO_DATA(943374),
        T_TIPO_DATA(943405),
        T_TIPO_DATA(943580),
        T_TIPO_DATA(943658),
        T_TIPO_DATA(944101),
        T_TIPO_DATA(944568),
        T_TIPO_DATA(944599),
        T_TIPO_DATA(944736),
        T_TIPO_DATA(944853),
        T_TIPO_DATA(945023),
        T_TIPO_DATA(945031),
        T_TIPO_DATA(945076),
        T_TIPO_DATA(945307),
        T_TIPO_DATA(945516),
        T_TIPO_DATA(945559)

        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL:= 'SELECT AGR_ID FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE AGR_NUM_AGRUP_REM = 5089965 AND BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_AGR_ID;     

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    V_TMP_TIPO_DATA := V_TIPO_DATA(I); 

        V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

        IF V_COUNT = 1 THEN

            V_MSQL:= 'SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

            V_MSQL:= 'UPDATE '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO SET
                    USUARIOMODIFICAR = '''||V_USU||''',
                    FECHAMODIFICAR = SYSDATE,
                    USUARIOBORRAR = NULL,
                    FECHABORRAR = NULL,
                    BORRADO = 0
                    WHERE ACT_ID = '||V_ACT_ID||' AND AGR_ID = '||V_AGR_ID||'';
            EXECUTE IMMEDIATE V_MSQL;

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '||V_TMP_TIPO_DATA(1)||' REVIVIDO EN LA AGRUPACIÓN');

        ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO]: ACTIVO '||V_TMP_TIPO_DATA(1)||' NO EXISTE O ESTA BORRADO');

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