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
	T_TIPO_DATA('7063353','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7063393','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7063432','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7067625','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7067654','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7067824','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7067868','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7233862','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7233955','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241504','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7241996','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7256694','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7280020','03','07','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('7025919','01',null,'No aplica. Cargas'),
	T_TIPO_DATA('7025921','01',null,'No aplica. Cargas'),
	T_TIPO_DATA('7026064','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7026065','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7026068','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7026114','01',null,'No aplica. Sin posesión'),
	T_TIPO_DATA('7025919','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025920','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025921','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025922','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025923','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025924','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('7025925','08','31','Pendiente de precio. Advisory'),
	T_TIPO_DATA('6897701','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897702','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897703','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897704','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897705','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897706','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897707','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897708','10','19','Avance fase VI - Publicado.'),
	T_TIPO_DATA('6897709','10','19','Avance fase VI - Publicado.')

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