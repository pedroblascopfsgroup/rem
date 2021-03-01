--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9050
--## PRODUCTO=NO
--##
--## Finalidad: Script realiza una carga masiva de fases
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM NUMBER(16); -- Vble. auxiliar para almacenar el número de registros
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_HFP_HIST_FASES_PUB'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9050'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_ACT_ID NUMBER(16);
	V_USU_ID NUMBER(16);
	V_COUNT NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	ACTIVO | FASE | SUBFASE | COMENTARIO
		T_TIPO_DATA('6344597','10','19',''),
		T_TIPO_DATA('6343468','10','19',''),
		T_TIPO_DATA('6344477','10','19',''),
		T_TIPO_DATA('6344600','10','19',''),
		T_TIPO_DATA('6344380','10','19',''),
		T_TIPO_DATA('6344437','10','19',''),
		T_TIPO_DATA('6343474','10','19',''),
		T_TIPO_DATA('6344438','10','19',''),
		T_TIPO_DATA('6343483','10','19',''),
		T_TIPO_DATA('6343485','10','19',''),
		T_TIPO_DATA('6344509','10','19',''),
		T_TIPO_DATA('6344567','10','19',''),
		T_TIPO_DATA('6344599','10','19',''),
		T_TIPO_DATA('6343486','10','19',''),
		T_TIPO_DATA('6343470','10','19',''),
		T_TIPO_DATA('6343465','10','19',''),
		T_TIPO_DATA('6343490','10','19',''),
		T_TIPO_DATA('6344568','10','19',''),
		T_TIPO_DATA('6344404','10','19',''),
		T_TIPO_DATA('6344439','10','19',''),
		T_TIPO_DATA('6344508','10','19',''),
		T_TIPO_DATA('6344538','10','19',''),
		T_TIPO_DATA('6344475','10','19',''),
		T_TIPO_DATA('6344378','10','19',''),
		T_TIPO_DATA('6344569','10','19',''),
		T_TIPO_DATA('6344405','10','19',''),
		T_TIPO_DATA('6344440','10','19',''),
		T_TIPO_DATA('6344379','10','19',''),
		T_TIPO_DATA('6343487','10','19',''),
		T_TIPO_DATA('6344377','10','19',''),
		T_TIPO_DATA('6344598','10','19',''),
		T_TIPO_DATA('6343489','10','19',''),
		T_TIPO_DATA('6344476','10','19',''),
		T_TIPO_DATA('6344474','10','19',''),
		T_TIPO_DATA('6343464','10','19',''),
		T_TIPO_DATA('6344441','10','19',''),
		T_TIPO_DATA('6994482','10','19',''),
		T_TIPO_DATA('6994483','10','19',''),
		T_TIPO_DATA('6994484','10','19',''),
		T_TIPO_DATA('6994485','10','19',''),
		T_TIPO_DATA('6994486','10','19',''),
		T_TIPO_DATA('6994487','10','19',''),
		T_TIPO_DATA('6994488','10','19',''),
		T_TIPO_DATA('6994489','10','19',''),
		T_TIPO_DATA('6994490','10','19',''),
		T_TIPO_DATA('6994491','10','19',''),
		T_TIPO_DATA('6994492','10','19',''),
		T_TIPO_DATA('6994493','10','19',''),
		T_TIPO_DATA('6994494','10','19',''),
		T_TIPO_DATA('6994495','10','19',''),
		T_TIPO_DATA('6994496','10','19',''),
		T_TIPO_DATA('6994497','10','19',''),
		T_TIPO_DATA('6994498','10','19',''),
		T_TIPO_DATA('6994499','10','19',''),
		T_TIPO_DATA('6994500','10','19',''),
		T_TIPO_DATA('6994501','10','19',''),
		T_TIPO_DATA('6994502','10','19',''),
		T_TIPO_DATA('6994503','10','19',''),
		T_TIPO_DATA('6994504','10','19',''),
		T_TIPO_DATA('6994505','10','19',''),
		T_TIPO_DATA('6994506','10','19',''),
		T_TIPO_DATA('6994507','10','19',''),
		T_TIPO_DATA('6994508','10','19',''),
		T_TIPO_DATA('6994509','10','19',''),
		T_TIPO_DATA('6994510','10','19',''),
		T_TIPO_DATA('6994511','10','19',''),
		T_TIPO_DATA('6994512','10','19',''),
		T_TIPO_DATA('6994513','10','19',''),
		T_TIPO_DATA('6994514','10','19',''),
		T_TIPO_DATA('6994515','10','19',''),
		T_TIPO_DATA('6994516','10','19',''),
		T_TIPO_DATA('6994517','10','19',''),
		T_TIPO_DATA('6994518','10','19',''),
		T_TIPO_DATA('6994519','10','19',''),
		T_TIPO_DATA('6994520','10','19',''),
		T_TIPO_DATA('6994521','10','19',''),
		T_TIPO_DATA('6994522','10','19',''),
		T_TIPO_DATA('6994523','10','19',''),
		T_TIPO_DATA('6994524','10','19',''),
		T_TIPO_DATA('6994525','10','19',''),
		T_TIPO_DATA('6994526','10','19',''),
		T_TIPO_DATA('6994527','10','19',''),
		T_TIPO_DATA('6994528','10','19',''),
		T_TIPO_DATA('6994529','10','19',''),
		T_TIPO_DATA('6994530','10','19',''),
		T_TIPO_DATA('6994531','10','19',''),
		T_TIPO_DATA('6994532','10','19',''),
		T_TIPO_DATA('6994533','10','19',''),
		T_TIPO_DATA('6994534','10','19',''),
		T_TIPO_DATA('6994535','10','19',''),
		T_TIPO_DATA('6994536','10','19',''),
		T_TIPO_DATA('6994537','10','19',''),
		T_TIPO_DATA('6994538','10','19',''),
		T_TIPO_DATA('6994539','10','19',''),
		T_TIPO_DATA('6994540','10','19',''),
		T_TIPO_DATA('6994541','10','19',''),
		T_TIPO_DATA('6994542','10','19',''),
		T_TIPO_DATA('6994543','10','19',''),
		T_TIPO_DATA('6994544','10','19',''),
		T_TIPO_DATA('6994545','10','19',''),
		T_TIPO_DATA('6994546','10','19',''),
		T_TIPO_DATA('6994547','10','19',''),
		T_TIPO_DATA('6994548','10','19',''),
		T_TIPO_DATA('6994549','10','19',''),
		T_TIPO_DATA('6994550','10','19',''),
		T_TIPO_DATA('6994551','10','19',''),
		T_TIPO_DATA('6994560','10','19',''),
		T_TIPO_DATA('6994561','10','19',''),
		T_TIPO_DATA('6994562','10','19',''),
		T_TIPO_DATA('6994563','10','19',''),
		T_TIPO_DATA('6994564','10','19',''),
		T_TIPO_DATA('6994565','10','19',''),
		T_TIPO_DATA('6994566','10','19',''),
		T_TIPO_DATA('6994567','10','19',''),
		T_TIPO_DATA('6994584','10','19',''),
		T_TIPO_DATA('6994585','10','19',''),
		T_TIPO_DATA('6994586','10','19',''),
		T_TIPO_DATA('6994587','10','19',''),
		T_TIPO_DATA('6994588','10','19',''),
		T_TIPO_DATA('7300712','10','19',''),
		T_TIPO_DATA('7300713','10','19',''),
		T_TIPO_DATA('7300714','10','19',''),
		T_TIPO_DATA('7300715','10','19',''),
		T_TIPO_DATA('7300716','10','19',''),
		T_TIPO_DATA('7300717','10','19',''),
		T_TIPO_DATA('7300718','10','19',''),
		T_TIPO_DATA('7300719','10','19',''),
		T_TIPO_DATA('7300720','10','19',''),
		T_TIPO_DATA('7300721','10','19',''),
		T_TIPO_DATA('7300722','10','19',''),
		T_TIPO_DATA('7300723','10','19',''),
		T_TIPO_DATA('7300724','10','19',''),
		T_TIPO_DATA('7300725','10','19',''),
		T_TIPO_DATA('7300726','10','19',''),
		T_TIPO_DATA('7300728','10','19',''),
		T_TIPO_DATA('7300729','10','19',''),
		T_TIPO_DATA('7300730','10','19',''),
		T_TIPO_DATA('7300731','10','19',''),
		T_TIPO_DATA('7300732','10','19',''),
		T_TIPO_DATA('7300733','10','19',''),
		T_TIPO_DATA('7300734','10','19',''),
		T_TIPO_DATA('7300735','10','19',''),
		T_TIPO_DATA('7300736','10','19',''),
		T_TIPO_DATA('7300737','10','19',''),
		T_TIPO_DATA('7300738','10','19',''),
		T_TIPO_DATA('7300739','10','19',''),
		T_TIPO_DATA('7300740','10','19',''),
		T_TIPO_DATA('7300741','10','19',''),
		T_TIPO_DATA('7300742','10','19',''),
		T_TIPO_DATA('7300743','10','19',''),
		T_TIPO_DATA('7300744','10','19',''),
		T_TIPO_DATA('7300745','10','19',''),
		T_TIPO_DATA('7300746','10','19',''),
		T_TIPO_DATA('7300747','10','19',''),
		T_TIPO_DATA('7300748','10','19',''),
		T_TIPO_DATA('7300749','10','19',''),
		T_TIPO_DATA('7300750','10','19',''),
		T_TIPO_DATA('7300751','10','19',''),
		T_TIPO_DATA('7300752','10','19',''),
		T_TIPO_DATA('7300753','10','19',''),
		T_TIPO_DATA('7300754','10','19',''),
		T_TIPO_DATA('7300755','10','19',''),
		T_TIPO_DATA('7300756','10','19',''),
		T_TIPO_DATA('7300757','10','19',''),
		T_TIPO_DATA('7300758','10','19',''),
		T_TIPO_DATA('7300759','10','19',''),
		T_TIPO_DATA('7300760','10','19',''),
		T_TIPO_DATA('7300761','10','19',''),
		T_TIPO_DATA('7300762','10','19',''),
		T_TIPO_DATA('7300763','10','19',''),
		T_TIPO_DATA('7300764','10','19',''),
		T_TIPO_DATA('7300767','10','19',''),
		T_TIPO_DATA('7300768','10','19',''),
		T_TIPO_DATA('7300769','10','19',''),
		T_TIPO_DATA('7300770','10','19',''),
		T_TIPO_DATA('7300772','10','19',''),
		T_TIPO_DATA('7300773','10','19',''),
		T_TIPO_DATA('7300774','10','19',''),
		T_TIPO_DATA('7300775','10','19',''),
		T_TIPO_DATA('7300776','10','19',''),
		T_TIPO_DATA('7300777','10','19',''),
		T_TIPO_DATA('7300781','10','19',''),
		T_TIPO_DATA('7300783','10','19',''),
		T_TIPO_DATA('7300784','10','19',''),
		T_TIPO_DATA('7300785','10','19',''),
		T_TIPO_DATA('7300786','10','19',''),
		T_TIPO_DATA('7300787','10','19',''),
		T_TIPO_DATA('7300790','10','19',''),
		T_TIPO_DATA('7300792','10','19',''),
		T_TIPO_DATA('7300793','10','19',''),
		T_TIPO_DATA('7300794','10','19',''),
		T_TIPO_DATA('7300795','10','19',''),
		T_TIPO_DATA('7300796','10','19',''),
		T_TIPO_DATA('7300797','10','19',''),
		T_TIPO_DATA('7300798','10','19',''),
		T_TIPO_DATA('7300799','10','19',''),
		T_TIPO_DATA('7300800','10','19',''),
		T_TIPO_DATA('7300801','10','19','')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: FINALIZAR FASE EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_MSQL:='SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

		IF V_COUNT > 0 THEN

			V_MSQL:='SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||V_TMP_TIPO_DATA(1)||'';
			EXECUTE IMMEDIATE V_MSQL INTO V_ACT_ID;

			V_MSQL:='SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER''';
			EXECUTE IMMEDIATE V_MSQL INTO V_USU_ID;

			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
			HFP_FECHA_FIN = SYSDATE,
			USUARIOMODIFICAR = '''||V_USU||''',
			FECHAMODIFICAR = SYSDATE
			WHERE
			ACT_ID = '||V_ACT_ID||'
			AND HFP_FECHA_FIN IS NULL';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE FINALIZADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
				
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (HFP_ID, ACT_ID, DD_FSP_ID, DD_SFP_ID, USU_ID, HFP_FECHA_INI, HFP_COMENTARIO, USUARIOCREAR, FECHACREAR)
			VALUES (
			'||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
			'||V_ACT_ID||',
			(SELECT DD_FSP_ID FROM '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION WHERE DD_FSP_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
			(SELECT DD_SFP_ID FROM '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION WHERE DD_SFP_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),
			'||V_USU_ID||',
			SYSDATE,
			'''||V_TMP_TIPO_DATA(4)||''',
			'''||V_USU||''',
			SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE INSERTADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
		
		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: EL ACTIVO: '||V_TMP_TIPO_DATA(1)||' NO EXISTE');

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