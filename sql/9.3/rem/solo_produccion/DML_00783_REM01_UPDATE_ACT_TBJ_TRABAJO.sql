--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9386
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9386'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_COUNT NUMBER(16);

	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- 			NUM_TRABAJO  FECHA_VAL
		T_TIPO_DATA(916964359294,'30/12/2020'),
		T_TIPO_DATA(916964358415,'04/01/2021'),
		T_TIPO_DATA(9000297475,'30/12/2020'),
		T_TIPO_DATA(916964311715,'05/01/2021'),
		T_TIPO_DATA(916964325384,'05/01/2021'),
		T_TIPO_DATA(916964361680,'05/01/2021'),
		T_TIPO_DATA(916964358690,'05/01/2021'),
		T_TIPO_DATA(916964358689,'05/01/2021'),
		T_TIPO_DATA(916964358688,'05/01/2021'),
		T_TIPO_DATA(916964358687,'05/01/2021'),
		T_TIPO_DATA(916964358686,'05/01/2021'),
		T_TIPO_DATA(916964358685,'05/01/2021'),
		T_TIPO_DATA(916964358684,'05/01/2021'),
		T_TIPO_DATA(916964358682,'05/01/2021'),
		T_TIPO_DATA(916964358681,'05/01/2021'),
		T_TIPO_DATA(916964358679,'05/01/2021'),
		T_TIPO_DATA(916964358677,'05/01/2021'),
		T_TIPO_DATA(916964355179,'05/01/2021'),
		T_TIPO_DATA(916964371985,'05/01/2021'),
		T_TIPO_DATA(916964370697,'05/01/2021'),
		T_TIPO_DATA(916964369033,'05/01/2021'),
		T_TIPO_DATA(916964365358,'08/01/2021')); 
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
						TBJ_FECHA_VALIDACION = TO_DATE('''||V_TMP_TIPO_DATA(2)||''',''DD/MM/YYYY''),
						USUARIOMODIFICAR = '''||V_USU||''',
						FECHAMODIFICAR = SYSDATE
						WHERE TBJ_NUM_TRABAJO = '||V_TMP_TIPO_DATA(1)||' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS TBJ_FECHA_VALIDACION = '||V_TMP_TIPO_DATA(2)||' EN TRABAJO '||V_TMP_TIPO_DATA(1)||'');

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