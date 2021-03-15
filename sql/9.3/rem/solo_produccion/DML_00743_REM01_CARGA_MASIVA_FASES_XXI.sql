--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9146
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
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-9146'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
	V_ACT_ID NUMBER(16);
	V_USU_ID NUMBER(16);
	V_COUNT NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(1024);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --	ACTIVO | FASE | SUBFASE | COMENTARIO
	T_TIPO_DATA('6037586','03','07','no ok tecnico'),
	T_TIPO_DATA('6078228','03','07','no ok tecnico'),
	T_TIPO_DATA('6082178','03','07','no ok tecnico'),
	T_TIPO_DATA('6133608','03','07','no ok tecnico'),
	T_TIPO_DATA('6134872','03','07','no ok tecnico'),
	T_TIPO_DATA('6135212','03','07','no ok tecnico'),
	T_TIPO_DATA('6762022','03','07','no ok tecnico'),
	T_TIPO_DATA('6786818','03','07','no ok tecnico'),
	T_TIPO_DATA('6786833','03','07','no ok tecnico'),
	T_TIPO_DATA('6786847','03','07','no ok tecnico'),
	T_TIPO_DATA('6786862','03','07','no ok tecnico'),
	T_TIPO_DATA('6786866','03','07','no ok tecnico'),
	T_TIPO_DATA('7295344','03','07','no ok tecnico'),
	T_TIPO_DATA('7386288','03','07','no ok tecnico'),
	T_TIPO_DATA('7432368','03','07','no ok tecnico'),
	T_TIPO_DATA('7432920','03','07','no ok tecnico'),
	T_TIPO_DATA('7432972','03','07','no ok tecnico'),
	T_TIPO_DATA('7434665','03','07','no ok tecnico'),
	T_TIPO_DATA('7434919','03','07','no ok tecnico'),
	T_TIPO_DATA('7434921','03','07','no ok tecnico'),
	T_TIPO_DATA('7434922','03','07','no ok tecnico'),
	T_TIPO_DATA('7434924','03','07','no ok tecnico'),
	T_TIPO_DATA('7434926','03','07','no ok tecnico'),
	T_TIPO_DATA('7434928','03','07','no ok tecnico'),
	T_TIPO_DATA('7434930','03','07','no ok tecnico'),
	T_TIPO_DATA('7434931','03','07','no ok tecnico'),
	T_TIPO_DATA('7434932','03','07','no ok tecnico'),
	T_TIPO_DATA('7434936','03','07','no ok tecnico'),
	T_TIPO_DATA('7434937','03','07','no ok tecnico'),
	T_TIPO_DATA('7434939','03','07','no ok tecnico'),
	T_TIPO_DATA('7434942','03','07','no ok tecnico'),
	T_TIPO_DATA('7434943','03','07','no ok tecnico'),
	T_TIPO_DATA('7434944','03','07','no ok tecnico'),
	T_TIPO_DATA('7434945','03','07','no ok tecnico'),
	T_TIPO_DATA('7434946','03','07','no ok tecnico'),
	T_TIPO_DATA('7434947','03','07','no ok tecnico'),
	T_TIPO_DATA('7434948','03','07','no ok tecnico'),
	T_TIPO_DATA('7434950','03','07','no ok tecnico'),
	T_TIPO_DATA('7434951','03','07','no ok tecnico'),
	T_TIPO_DATA('7434952','03','07','no ok tecnico'),
	T_TIPO_DATA('7434953','03','07','no ok tecnico'),
	T_TIPO_DATA('7434956','03','07','no ok tecnico'),
	T_TIPO_DATA('7434959','03','07','no ok tecnico'),
	T_TIPO_DATA('7434960','03','07','no ok tecnico'),
	T_TIPO_DATA('7434961','03','07','no ok tecnico'),
	T_TIPO_DATA('7434963','03','07','no ok tecnico'),
	T_TIPO_DATA('7434964','03','07','no ok tecnico'),
	T_TIPO_DATA('7434965','03','07','no ok tecnico'),
	T_TIPO_DATA('7434966','03','07','no ok tecnico'),
	T_TIPO_DATA('7434967','03','07','no ok tecnico'),
	T_TIPO_DATA('7434968','03','07','no ok tecnico'),
	T_TIPO_DATA('7434969','03','07','no ok tecnico'),
	T_TIPO_DATA('7434970','03','07','no ok tecnico'),
	T_TIPO_DATA('7434971','03','07','no ok tecnico'),
	T_TIPO_DATA('7460082','03','07','no ok tecnico'),
	T_TIPO_DATA('7460083','03','07','no ok tecnico'),
	T_TIPO_DATA('7460085','03','07','no ok tecnico'),
	T_TIPO_DATA('7460089','03','07','no ok tecnico'),
	T_TIPO_DATA('7460092','03','07','no ok tecnico'),
	T_TIPO_DATA('7460093','03','07','no ok tecnico'),
	T_TIPO_DATA('7460094','03','07','no ok tecnico'),
	T_TIPO_DATA('7460097','03','07','no ok tecnico'),
	T_TIPO_DATA('7460098','03','07','no ok tecnico')

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