--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181010
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1729
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA
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
    V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-1729'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --				TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		PRECIO_UNITARIO		UNIDAD_MEDIDA
       			T_TIPO_DATA('SOL13',  '03',    '32',    '02',   '118.59',  '€/ud'),
			T_TIPO_DATA('SOL14',  '03',    '32',    '02',   '75.73',  '€/ud'),
			T_TIPO_DATA('SOL15',  '03',    '32',    '02',   '570.36',  '€/ud'),
			T_TIPO_DATA('SOL16',  '03',    '32',    '02',   '455.92',  '€/ud'),
			T_TIPO_DATA('SOL17',  '03',    '32',    '02',   '170.36',  '€/ud'),
			T_TIPO_DATA('SOL18',  '03',    '32',    '02',   '110.28',  '€/ud'),
			T_TIPO_DATA('SOL19',  '03',    '32',    '02',   '40.50',  '€/ud'),
			T_TIPO_DATA('SOL20',  '03',    '32',    '02',   '47.37',  '€/ud'),
			T_TIPO_DATA('SOL21',  '03',    '32',    '02',   '109.18',  '€/ud'),
			T_TIPO_DATA('SOL22',  '03',    '32',    '02',   '240.53',  '€/ud'),
			T_TIPO_DATA('OM274',  '03',    '37',    '02',   '7.43',  '€/m2'),
			T_TIPO_DATA('OM275',  '03',    '37',    '02',   '3.48',  '€/m3'),
			T_TIPO_DATA('OM276',  '03',    '37',    '02',   '15.89',  '€/m3'),
			T_TIPO_DATA('OM277',  '03',    '37',    '02',   '8.11',  '€/m3'),
			T_TIPO_DATA('OM278',  '03',    '37',    '02',   '14.33',  '€/m3'),
			T_TIPO_DATA('SAB-CER12',  '03',    '57',    '02',   '4.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER13',  '03',    '57',    '02',   '7.50',  '€/ud'),
			T_TIPO_DATA('SAB-CER14',  '03',    '57',    '02',   '20.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER15',  '03',    '57',    '02',   '20.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER16',  '03',    '57',    '02',   '35.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER12',  '03',    '26',    '02',   '4.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER13',  '03',    '26',    '02',   '7.50',  '€/ud'),
			T_TIPO_DATA('SAB-CER14',  '03',    '26',    '02',   '20.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER15',  '03',    '26',    '02',   '20.00',  '€/ud'),
			T_TIPO_DATA('SAB-CER16',  '03',    '26',    '02',   '35.00',  '€/ud'),
			T_TIPO_DATA('OM279',  '03',    '37',    '02',   '75.00',  '€/ud'),
			T_TIPO_DATA('OM279',  '03',    '40',    '02',   '75.00',  '€/ud'),
			T_TIPO_DATA('OM280',  '03',    '37',    '02',   '48.25',  '€/ud'),
			T_TIPO_DATA('OM281',  '03',    '37',    '02',   '175.00',  '€/ud'),
			T_TIPO_DATA('OM282',  '03',    '37',    '02',   '245.60',  '€/ud'),
			T_TIPO_DATA('OM283',  '03',    '37',    '02',   '557.51',  '€/ud'),
			T_TIPO_DATA('OM284',  '03',    '37',    '02',   '5.11',  '€/ml'),
			T_TIPO_DATA('OM285',  '03',    '37',    '02',   '3.50',  '€/ud'),
			T_TIPO_DATA('OM286',  '03',    '37',    '02',   '5.00',  '€/ud'),
			T_TIPO_DATA('OM287',  '03',    '37',    '02',   '51.01',  '€/m2'),
			T_TIPO_DATA('OM288',  '03',    '37',    '02',   '3.47',  '€/m2'),
			T_TIPO_DATA('LIMP9',  '03',    '29',    '02',   '45.00',  '€/ud'),
			T_TIPO_DATA('LIMP10',  '03',    '29',    '02',   '250.00',  '€/ud'),
			T_TIPO_DATA('LIMP11',  '03',    '29',    '02',   '315.00',  '€/ud'),
			T_TIPO_DATA('OM289',  '03',    '37',    '02',   '8.30',  '€/ml'),
			T_TIPO_DATA('OM290',  '03',    '37',    '02',   '29.22',  '€/ml'),
			T_TIPO_DATA('OM291',  '03',    '37',    '02',   '29.22',  '€/ml'),
			T_TIPO_DATA('OM292',  '03',    '37',    '02',   '32.47',  '€/ml'),
			T_TIPO_DATA('OM293',  '03',    '37',    '02',   '0.04',  '%PEM'),
			T_TIPO_DATA('OM294',  '03',    '37',    '02',   '0.03',  '%PEM'),
			T_TIPO_DATA('OM295',  '03',    '37',    '02',   '400.00',  '€/ud'),
			T_TIPO_DATA('OM296',  '03',    '37',    '02',   '0.04',  '%PEM'),
			T_TIPO_DATA('OM297',  '03',    '37',    '02',   '0.07',  '%PEM'),
			T_TIPO_DATA('OM298',  '03',    '37',    '02',   '0.05',  '%PEM'),
			T_TIPO_DATA('OM299',  '03',    '37',    '02',   '250.00',  '€/ud'),
			T_TIPO_DATA('OM300',  '03',    '37',    '02',   '0.01',  '%PEM'),
			T_TIPO_DATA('OM301',  '03',    '37',    '02',   '300.00',  '€/dia'),
			T_TIPO_DATA('OM302',  '03',    '37',    '02',   '120.00',  '€/ud'),
			T_TIPO_DATA('OM303',  '03',    '37',    '02',   '360.00',  '€/ud'),
			T_TIPO_DATA('OM304',  '03',    '37',    '02',   '75.00',  '€/ud'),
			T_TIPO_DATA('OM305',  '03',    '37',    '02',   '12.10',  '€/ud'),
			T_TIPO_DATA('OM306',  '03',    '37',    '02',   '27.15',  '€/ud'),
			T_TIPO_DATA('OM307',  '03',    '37',    '02',   '8.30',  '€/ud'),
			T_TIPO_DATA('OM308',  '03',    '37',    '02',   '60.00',  '€/ud'),
			T_TIPO_DATA('OM309',  '03',    '37',    '02',   '55.96',  '€/ud'),
			T_TIPO_DATA('OM310',  '03',    '37',    '02',   '439.20',  '€/ud'),
			T_TIPO_DATA('OM311',  '03',    '37',    '02',   '549.31',  '€/ud'),
			T_TIPO_DATA('OM312',  '03',    '37',    '02',   '658.80',  '€/ud'),
			T_TIPO_DATA('OM313',  '03',    '37',    '02',   '823.50',  '€/ud'),
			T_TIPO_DATA('OM314',  '03',    '37',    '02',   '220.00',  '€/ud'),
			T_TIPO_DATA('OM315',  '03',    '37',    '02',   '250.00',  '€/ud'),
			T_TIPO_DATA('OM316',  '03',    '37',    '02',   '250.00',  '€/ud'),
			T_TIPO_DATA('OM317',  '03',    '37',    '02',   '750.00',  '€/ud'),
			T_TIPO_DATA('OM318',  '03',    '37',    '02',   '72.75',  '€/ud'),
			T_TIPO_DATA('BOL8',  '02',    '23',    '02',   '550.00',  '€/ud'),
			T_TIPO_DATA('OM319',  '03',    '37',    '02',   '150.00',  '€/ud'),
			T_TIPO_DATA('OM320',  '03',    '37',    '02',   '1755.00',  '€/ud'),
			T_TIPO_DATA('OM321',  '03',    '37',    '02',   '2003.00',  '€/ud'),
			T_TIPO_DATA('OM322',  '03',    '37',    '02',   '1955.00',  '€/ud'),
			T_TIPO_DATA('OM323',  '03',    '37',    '02',   '2203.00',  '€/ud'),
			T_TIPO_DATA('OM324',  '03',    '37',    '02',   '2038.74',  '€/ud'),
			T_TIPO_DATA('OM325',  '03',    '37',    '02',   '2328.14',  '€/ud'),
			T_TIPO_DATA('OM326',  '03',    '37',    '02',   '2339.99',  '€/ud'),
			T_TIPO_DATA('OM327',  '03',    '37',    '02',   '2629.39',  '€/ud'),
			T_TIPO_DATA('OM328',  '03',    '37',    '02',   '6.10',  '€/ml'),
			T_TIPO_DATA('OM329',  '03',    '37',    '02',   '5.09',  '€/ml'),
			T_TIPO_DATA('OM330',  '03',    '37',    '02',   '5.09',  '€/ml'),
			T_TIPO_DATA('OM331',  '03',    '37',    '02',   '1.91',  '€/m2'),
			T_TIPO_DATA('OM332',  '03',    '37',    '02',   '8.25',  '€/m2'),
			T_TIPO_DATA('OM333',  '03',    '37',    '02',   '33.51',  '€/ud'),
			T_TIPO_DATA('OM334',  '03',    '37',    '02',   '21.81',  '€/m2'),
			T_TIPO_DATA('OM335',  '03',    '37',    '02',   '30.63',  '€/m2'),
			T_TIPO_DATA('SOL23',  '03',    '32',    '02',   '150.00',  '€/m3'),
			T_TIPO_DATA('OM336',  '03',    '37',    '02',   '41.24',  '€/m2'),
			T_TIPO_DATA('OM337',  '03',    '37',    '02',   '42.81',  '€/ud'),
			T_TIPO_DATA('OM338',  '03',    '37',    '02',   '78.21',  '€/m2'),
			T_TIPO_DATA('OM339',  '03',    '37',    '02',   '92.33',  '€/m2'),
			T_TIPO_DATA('OM340',  '03',    '37',    '02',   '145.04',  '€/m2')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

			-- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(CFT_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;

			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      ''||TRIM(V_TMP_TIPO_DATA(5))||', '''||TRIM(V_TMP_TIPO_DATA(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
 			V_COUNT_INSERT := V_COUNT_INSERT + 1;

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||V_COUNT_INSERT||' registros en la tabla ACT_CFT_CONFIG_TARIFA');
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');


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
