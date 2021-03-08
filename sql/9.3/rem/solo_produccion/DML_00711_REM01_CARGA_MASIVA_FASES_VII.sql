--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210301
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
	T_TIPO_DATA('7029401','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029404','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029408','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029409','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029421','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029422','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029424','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029425','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029427','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029428','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029429','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029430','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029433','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029434','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029435','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029436','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029437','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029442','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029444','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029445','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029446','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029448','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029449','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029450','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029451','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029452','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029454','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029455','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029457','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029459','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029460','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029461','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029462','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029463','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029468','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029469','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029470','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029471','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029472','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029473','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029474','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029475','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029476','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029477','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029481','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029482','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029484','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029485','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029486','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029487','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029489','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029490','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029491','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029492','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029493','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029494','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029496','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029497','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('7029498','03','03','No disponible tecnico - En estudio'),
	T_TIPO_DATA('6078228','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6530073','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6762022','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6786847','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6833286','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7071582','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7295295','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7295344','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299220','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299221','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299222','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299223','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7299225','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7301057','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7302383','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7330015','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7386288','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432816','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432827','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432831','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432851','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432857','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432876','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432887','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432889','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432953','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7432967','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7433027','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7434005','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7457794','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459912','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459914','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459915','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7459916','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6044089','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6762365','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('6762387','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7226967','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7300819','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7300820','03','07','sin ok tecnico de Mantenimiento'),
	T_TIPO_DATA('7068208','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7071393','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7101066','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7386280','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7386289','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7386290','05','09','pendiente de informe - alquilado'),
	T_TIPO_DATA('7300818','05','09','pendiente de informe'),
	T_TIPO_DATA('6076900','05','09','pendiente de informe'),
	T_TIPO_DATA('7068192','05','09','pendiente de informe'),
	T_TIPO_DATA('7068203','05','09','pendiente de informe'),
	T_TIPO_DATA('7385845','05','09','pendiente de informe'),
	T_TIPO_DATA('6031295','09','16','Oferta Express'),
	T_TIPO_DATA('6032484','09','16','Oferta Express'),
	T_TIPO_DATA('6032561','09','16','Oferta Express'),
	T_TIPO_DATA('6134085','09','16','Oferta Express'),
	T_TIPO_DATA('6135875','09','16','Oferta Express'),
	T_TIPO_DATA('6135896','09','16','Oferta Express'),
	T_TIPO_DATA('6780728','09','16','Oferta Express'),
	T_TIPO_DATA('6780761','09','16','Oferta Express'),
	T_TIPO_DATA('6780941','09','16','Oferta Express'),
	T_TIPO_DATA('6780991','09','16','Oferta Express'),
	T_TIPO_DATA('6840269','09','16','Oferta Express'),
	T_TIPO_DATA('7301123','09','16','Oferta Express'),
	T_TIPO_DATA('7301937','09','16','Oferta Express'),
	T_TIPO_DATA('6872907','09','14','cartera cliente'),
	T_TIPO_DATA('6876019','09','14','cartera cliente'),
	T_TIPO_DATA('7005863','09','14','cartera cliente'),
	T_TIPO_DATA('7292519','09','14','cartera cliente'),
	T_TIPO_DATA('7293200','09','14','cartera cliente'),
	T_TIPO_DATA('6978609','09','14','cartera cliente'),
	T_TIPO_DATA('6028695','09','16','reservado'),
	T_TIPO_DATA('6029583','09','16','reservado'),
	T_TIPO_DATA('6031358','09','16','reservado'),
	T_TIPO_DATA('6032902','09','16','reservado'),
	T_TIPO_DATA('6033082','09','16','reservado'),
	T_TIPO_DATA('6036705','09','16','reservado'),
	T_TIPO_DATA('6036715','09','16','reservado'),
	T_TIPO_DATA('6036740','09','16','reservado'),
	T_TIPO_DATA('6038264','09','16','reservado'),
	T_TIPO_DATA('6039562','09','16','reservado'),
	T_TIPO_DATA('6042079','09','16','reservado'),
	T_TIPO_DATA('6042302','09','16','reservado'),
	T_TIPO_DATA('6043055','09','16','reservado'),
	T_TIPO_DATA('6044260','09','16','reservado'),
	T_TIPO_DATA('6075936','09','16','reservado'),
	T_TIPO_DATA('6076553','09','16','reservado'),
	T_TIPO_DATA('6076554','09','16','reservado'),
	T_TIPO_DATA('6076556','09','16','reservado'),
	T_TIPO_DATA('6077987','09','16','reservado'),
	T_TIPO_DATA('6136473','09','16','reservado'),
	T_TIPO_DATA('6745118','09','16','reservado'),
	T_TIPO_DATA('6762226','09','16','reservado'),
	T_TIPO_DATA('6780913','09','16','reservado'),
	T_TIPO_DATA('6789017','09','16','reservado'),
	T_TIPO_DATA('6798425','09','16','reservado'),
	T_TIPO_DATA('6798912','09','16','reservado'),
	T_TIPO_DATA('6823311','09','16','reservado'),
	T_TIPO_DATA('6840229','09','16','reservado'),
	T_TIPO_DATA('6841875','09','16','reservado'),
	T_TIPO_DATA('6967594','09','16','reservado'),
	T_TIPO_DATA('7030141','09','16','reservado'),
	T_TIPO_DATA('7071238','09','16','reservado'),
	T_TIPO_DATA('7075962','09','16','reservado'),
	T_TIPO_DATA('7076218','09','16','reservado'),
	T_TIPO_DATA('7100351','09','16','reservado'),
	T_TIPO_DATA('7298327','09','16','reservado'),
	T_TIPO_DATA('7075095','10','19','vuelta de reserva')

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