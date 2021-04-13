--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210407
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9402
--## PRODUCTO=NO
--##
--## Finalidad: Script informa TBJ_FECHA_VALIDACION trabajos
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9402'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			NUM_TRABAJO  
		T_TIPO_DATA(9000283789),
		T_TIPO_DATA(916964355204),
		T_TIPO_DATA(916964376620),
		T_TIPO_DATA(916964350615),
		T_TIPO_DATA(916964369359),
		T_TIPO_DATA(916964374975),
		T_TIPO_DATA(916964377421),
		T_TIPO_DATA(916964369904),
		T_TIPO_DATA(916964376487),
		T_TIPO_DATA(916964375546),
		T_TIPO_DATA(916964372120),
		T_TIPO_DATA(916964374001),
		T_TIPO_DATA(916964374882),
		T_TIPO_DATA(916964351131),
		T_TIPO_DATA(916964371526),
		T_TIPO_DATA(916964374876),
		T_TIPO_DATA(916964369820),
		T_TIPO_DATA(916964359942),
		T_TIPO_DATA(916964368196),
		T_TIPO_DATA(916964374941),
		T_TIPO_DATA(916964372753),
		T_TIPO_DATA(916964374039),
		T_TIPO_DATA(916964369828),
		T_TIPO_DATA(916964374844),
		T_TIPO_DATA(916964374851),
		T_TIPO_DATA(916964374916),
		T_TIPO_DATA(916964377214),
		T_TIPO_DATA(916964375495)); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

    
BEGIN		

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR TBJ_FECHA_VALIDACION EN '||V_TEXT_TABLA);

		V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT = 1 THEN

			V_MSQL:= 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
						TBJ_FECHA_VALIDACION = TO_DATE(''05/04/2021'',''DD/MM/YYYY''),
						TBJ_FECHA_CAMBIO_ESTADO = TO_DATE(''05/04/2021'',''DD/MM/YYYY''),
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS TBJ_FECHA_VALIDACION ''05/04/2021'' EN TRABAJO '||V_TMP_TIPO_DATA(1)||'');

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