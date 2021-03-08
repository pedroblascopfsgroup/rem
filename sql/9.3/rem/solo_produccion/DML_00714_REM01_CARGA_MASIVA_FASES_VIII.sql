--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210302
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
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('728546','1','1','Avance fase VI - Publicado.'),
	T_TIPO_DATA('723757','0','0','Sin OK Técnico'),
	T_TIPO_DATA('724243','0','0','Sin OK Técnico'),
	T_TIPO_DATA('724270','0','0','Sin OK Técnico'),
	T_TIPO_DATA('727512','0','0','Sin OK Técnico'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('704033','0','3','Avance fase IV - Pendiente precio'),
	T_TIPO_DATA('703462','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703488','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703533','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703626','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703655','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703672','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('703785','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704019','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704318','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704409','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704441','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704506','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704517','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704584','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704614','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('705040','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('705110','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('705173','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('705552','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('706335','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('706339','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('706343','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('723728','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('723740','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('723857','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('723920','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('724401','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('725712','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('725938','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('726858','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('726877','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('728265','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('728324','0','0','Viene de Fase 0. Sin check técnico'),
	T_TIPO_DATA('704028','0','2','Sin fotos'),
	T_TIPO_DATA('704028','0','2','Sin fotos'),
	T_TIPO_DATA('704029','0','2','Sin fotos'),
	T_TIPO_DATA('704147','0','2','Sin fotos válidas. Texto web insuficiente'),
	T_TIPO_DATA('704803','0','2','Sin fotos'),
	T_TIPO_DATA('704914','0','2','Sin fotos'),
	T_TIPO_DATA('724860','0','2','Sin fotos interiores. Sin descripción web'),
	T_TIPO_DATA('103339','10','19','Publicado minorista'),
	T_TIPO_DATA('103340','10','19','Publicado minorista'),
	T_TIPO_DATA('103341','10','19','Publicado minorista'),
	T_TIPO_DATA('103449','10','19','Publicado minorista'),
	T_TIPO_DATA('103450','10','19','Publicado minorista'),
	T_TIPO_DATA('103578','10','19','Publicado minorista'),
	T_TIPO_DATA('103826','10','19','Publicado minorista'),
	T_TIPO_DATA('103827','10','19','Publicado minorista'),
	T_TIPO_DATA('103828','10','19','Publicado minorista'),
	T_TIPO_DATA('103829','10','19','Publicado minorista'),
	T_TIPO_DATA('103830','10','19','Publicado minorista'),
	T_TIPO_DATA('120248','10','19','Publicado minorista'),
	T_TIPO_DATA('120249','10','19','Publicado minorista'),
	T_TIPO_DATA('120250','10','19','Publicado minorista'),
	T_TIPO_DATA('120251','10','19','Publicado minorista'),
	T_TIPO_DATA('120526','10','19','Publicado minorista'),
	T_TIPO_DATA('120527','10','19','Publicado minorista'),
	T_TIPO_DATA('120566','10','19','Publicado minorista'),
	T_TIPO_DATA('120567','10','19','Publicado minorista'),
	T_TIPO_DATA('120716','10','19','Publicado minorista'),
	T_TIPO_DATA('120717','10','19','Publicado minorista'),
	T_TIPO_DATA('120718','10','19','Publicado minorista'),
	T_TIPO_DATA('121478','10','19','Publicado minorista'),
	T_TIPO_DATA('121479','10','19','Publicado minorista'),
	T_TIPO_DATA('121480','10','19','Publicado minorista'),
	T_TIPO_DATA('121481','10','19','Publicado minorista'),
	T_TIPO_DATA('121650','10','19','Publicado minorista'),
	T_TIPO_DATA('121651','10','19','Publicado minorista'),
	T_TIPO_DATA('121861','10','19','Publicado minorista'),
	T_TIPO_DATA('121862','10','19','Publicado minorista'),
	T_TIPO_DATA('122925','10','19','Publicado minorista'),
	T_TIPO_DATA('122926','10','19','Publicado minorista'),
	T_TIPO_DATA('122927','10','19','Publicado minorista'),
	T_TIPO_DATA('123268','10','19','Publicado minorista'),
	T_TIPO_DATA('123566','10','19','Publicado minorista'),
	T_TIPO_DATA('123567','10','19','Publicado minorista'),
	T_TIPO_DATA('123568','10','19','Publicado minorista'),
	T_TIPO_DATA('123569','10','19','Publicado minorista'),
	T_TIPO_DATA('123570','10','19','Publicado minorista'),
	T_TIPO_DATA('123571','10','19','Publicado minorista'),
	T_TIPO_DATA('160543','10','19','Publicado minorista'),
	T_TIPO_DATA('171619','10','19','Publicado minorista'),
	T_TIPO_DATA('176819','10','19','Publicado minorista')

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