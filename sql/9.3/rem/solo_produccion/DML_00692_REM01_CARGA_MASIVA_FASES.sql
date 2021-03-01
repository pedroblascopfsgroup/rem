--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210224
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
		T_TIPO_DATA('7032501','03','07',''),
		T_TIPO_DATA('7034357','03','07',''),
		T_TIPO_DATA('7035005','03','07',''),
		T_TIPO_DATA('7036224','03','07',''),
		T_TIPO_DATA('7050422','03','07',''),
		T_TIPO_DATA('7050524','03','07',''),
		T_TIPO_DATA('7050735','03','07',''),
		T_TIPO_DATA('7232271','03','07',''),
		T_TIPO_DATA('7234277','03','07',''),
		T_TIPO_DATA('7240754','03','07',''),
		T_TIPO_DATA('7263341','03','07',''),
		T_TIPO_DATA('7300001','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299994','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299993','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299992','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299991','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299990','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299989','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299987','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299986','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299985','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299984','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299983','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299982','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299981','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299980','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299979','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299978','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299977','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299976','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299974','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299973','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7299972','05','25','Falta descripción y distribución'),
		T_TIPO_DATA('7034788','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034789','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034790','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034792','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034793','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034794','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034795','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034796','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034797','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034798','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034799','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034800','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034802','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034805','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034806','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034807','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034808','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034810','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034811','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034812','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('7034813','10','19','Avance fase VI - Publicado.'),
		T_TIPO_DATA('6028874','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028875','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028876','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028877','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028878','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028879','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6028887','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032323','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032324','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032590','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032591','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032592','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032594','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032595','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032596','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032597','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6032598','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6037586','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040085','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040086','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040087','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040088','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040089','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040090','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040091','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040092','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040357','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040358','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040359','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040360','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040361','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040362','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040363','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040364','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040365','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6040366','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6077809','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6082058','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6133608','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6135803','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6525009','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7007789','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7075670','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7076229','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7076230','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7224112','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7294902','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7300234','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7300235','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7301004','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7302373','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7328525','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7330012','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7385833','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7386847','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403293','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403294','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403296','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403299','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403300','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403301','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403302','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403304','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403305','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403306','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403307','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403309','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403310','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403313','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403315','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403316','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403318','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403319','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403321','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403325','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403328','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403329','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403330','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403332','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403335','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403336','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403338','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403339','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403340','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403341','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403342','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403343','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403344','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403345','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403346','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7403347','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7423090','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432908','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432919','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432920','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432945','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432972','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7432986','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7457792','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7457793','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7459318','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7459321','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7459324','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7459361','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('7459372','03','07','Activo sin ok tecnico de mantenimiento'),
		T_TIPO_DATA('6133904','05','09','alquilado pendiente de informe'),
		T_TIPO_DATA('6134786','05','09','alquilado pendiente de informe'),
		T_TIPO_DATA('6135428','05','09','alquilado pendiente de informe'),
		T_TIPO_DATA('6135773','05','09','alquilado pendiente de informe'),
		T_TIPO_DATA('6135908','05','09','alquilado pendiente de informe'),
		T_TIPO_DATA('6030662','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6031300','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6042152','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6081064','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6135258','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6135274','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6711185','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6780877','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6839506','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6966151','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('7386237','05','09','ocupado pendiente de informe'),
		T_TIPO_DATA('6043101','09','16','Oferta Express'),
		T_TIPO_DATA('7101789','09','16','Oferta Express'),
		T_TIPO_DATA('7224419','09','16','Oferta Express'),
		T_TIPO_DATA('7302388','09','16','Oferta Express'),
		T_TIPO_DATA('6029337','09','16','reservado'),
		T_TIPO_DATA('6029572','09','16','reservado'),
		T_TIPO_DATA('6034161','09','16','reservado'),
		T_TIPO_DATA('6035265','09','16','reservado'),
		T_TIPO_DATA('6036718','09','16','reservado'),
		T_TIPO_DATA('6036959','09','16','reservado'),
		T_TIPO_DATA('6038501','09','16','reservado'),
		T_TIPO_DATA('6041081','09','16','reservado'),
		T_TIPO_DATA('6041645','09','16','reservado'),
		T_TIPO_DATA('6041676','09','16','reservado'),
		T_TIPO_DATA('6042309','09','16','reservado'),
		T_TIPO_DATA('6042397','09','16','reservado'),
		T_TIPO_DATA('6043042','09','16','reservado'),
		T_TIPO_DATA('6043286','09','16','reservado'),
		T_TIPO_DATA('6076762','09','16','reservado'),
		T_TIPO_DATA('6077245','09','16','reservado'),
		T_TIPO_DATA('6079536','09','16','reservado'),
		T_TIPO_DATA('6134307','09','16','reservado'),
		T_TIPO_DATA('6823575','09','16','reservado'),
		T_TIPO_DATA('6838555','09','16','reservado'),
		T_TIPO_DATA('7012937','09','16','reservado'),
		T_TIPO_DATA('7013375','09','16','reservado'),
		T_TIPO_DATA('7013379','09','16','reservado'),
		T_TIPO_DATA('7076068','09','16','reservado'),
		T_TIPO_DATA('7226164','09','16','reservado')

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