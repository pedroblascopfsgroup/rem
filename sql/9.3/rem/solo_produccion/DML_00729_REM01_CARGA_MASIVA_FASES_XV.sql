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
	T_TIPO_DATA('7038579','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7040363','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7059770','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7059773','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7059776','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7246419','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7262077','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7266783','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7268743','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7269491','03','07','Sin OK Técnico'),
	T_TIPO_DATA('7279037','03','07','Sin OK Técnico'),
	T_TIPO_DATA('6134158','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6135887','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6520944','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7101238','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459412','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459415','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7302344','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7294884','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7294886','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6714585','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6082062','05','09','ocupado pendiente de informe'),
	T_TIPO_DATA('6520159','05','09','ocupado pendiente de informe'),
	T_TIPO_DATA('6080552','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6080553','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6084396','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6084397','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6837480','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299666','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7302030','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7302678','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7302679','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7330201','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7330481','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7387082','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7403308','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7423088','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7423092','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7423188','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7423219','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7292750','09','16','reservado'),
	T_TIPO_DATA('7292755','09','16','reservado'),
	T_TIPO_DATA('7043087','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7044130','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241504','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241996','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7253145','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7253146','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7256694','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7276035','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7280020','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7062789','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7062806','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7062813','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7063352','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7063363','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7045021','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7042656','05','09','Garajes Apple'),
	T_TIPO_DATA('7042657','05','09','Garajes Apple'),
	T_TIPO_DATA('7042658','05','09','Garajes Apple'),
	T_TIPO_DATA('7038837','05','09','Garajes Apple'),
	T_TIPO_DATA('7038839','05','09','Garajes Apple'),
	T_TIPO_DATA('7038830','05','09','Garajes Apple'),
	T_TIPO_DATA('7038836','05','09','Garajes Apple'),
	T_TIPO_DATA('7038838','05','09','Garajes Apple'),
	T_TIPO_DATA('7038831','05','09','Garajes Apple'),
	T_TIPO_DATA('7038841','05','09','Garajes Apple'),
	T_TIPO_DATA('7038829','05','09','Garajes Apple'),
	T_TIPO_DATA('7038840','05','09','Garajes Apple'),
	T_TIPO_DATA('7038843','05','09','Garajes Apple'),
	T_TIPO_DATA('7045430','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7046624','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7046853','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7048629','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7048980','05','09','OK Tecnico llavs api'),
	T_TIPO_DATA('7050680','05','09','OK Tecnico llavs api')

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