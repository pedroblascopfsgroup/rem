--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210304
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
	T_TIPO_DATA('6044089','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6762365','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6762387','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7226967','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6044260','09','16','reservado'),
	T_TIPO_DATA('6762226','09','16','reservado'),
	T_TIPO_DATA('7043087','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7044130','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241504','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241996','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7253145','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7253146','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7256694','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7276035','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7280020','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7059249','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7059250','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7059251','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7059253','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7059254','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7060279','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7060282','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6078549','01',null,'No aplica. Sin posesión'), 
	T_TIPO_DATA('6079025','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6079558','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6083666','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6084432','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6082178','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6713433','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6713560','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6716003','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6727988','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6730898','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6731410','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6736673','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6741538','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6742094','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('6744683','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7423804','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7423803','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7432231','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7432368','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7433177','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7433206','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434657','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434666','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434668','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434690','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434775','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434919','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434921','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434922','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434924','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434926','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434928','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434930','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434931','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434932','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434936','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434937','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434938','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434939','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434942','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434943','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434944','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434945','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434946','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434947','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434948','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434950','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434951','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434952','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434953','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434956','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434959','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434960','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434961','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434963','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434964','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434965','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434966','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434967','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434968','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434969','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434970','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7434971','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7025919','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7025921','01',null,'No aplica. Sin posesión')

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

			DBMS_OUTPUT.PUT_LINE('[INFO]: FASE CAMBIADA PARA EL ACTIVO: '||V_TMP_TIPO_DATA(1)||'');
		
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