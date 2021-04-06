--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20210324
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9293
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

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

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-9293'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		SUBCARTERA_CODIGO			PRECIO_UNITARIO			CFT_UNIDAD_MEDIDA		NIF_PVE
		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '153',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '153',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '153',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '153',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '153',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '153',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '153',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '153',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '153',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '153',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '153',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '153',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '153',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '153',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '153',  '75'  ,'€/ud' ,'B63434633'),

		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '154',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '154',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '154',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '154',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '154',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '154',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '154',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '154',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '154',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '154',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '154',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '154',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '154',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '154',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '154',  '75'  ,'€/ud' ,'B63434633'),

		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '155',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '155',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '155',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '155',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '155',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '155',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '155',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '155',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '155',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '155',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '155',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '155',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '155',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '155',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '155',  '75'  ,'€/ud' ,'B63434633'),

		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '156',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '156',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '156',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '156',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '156',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '156',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '156',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '156',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '156',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '156',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '156',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '156',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '156',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '156',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '156',  '75'  ,'€/ud' ,'B63434633'),

		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '157',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '157',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '157',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '157',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '157',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '157',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '157',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '157',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '157',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '157',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '157',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '157',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '157',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '157',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '157',  '75'  ,'€/ud' ,'B63434633'),

		T_TIPO_DATA('PAO1',  '03',  '40', '16',  '158',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '16',  '158',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '16',  '158',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '16',  '158',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '16',  '158',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '16',  '158',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '16',  '158',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '16',  '158',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '16',  '158',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '16',  '158',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '16',  '158',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '16',  '158',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '16',  '158',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '16',  '158',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '16',  '158',  '75'  ,'€/ud' ,'B63434633')
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
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
		'AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
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
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PVE_ID) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      '(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||'''), '||
                      ''''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 , (SELECT MAX(PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(8))||''' AND BORRADO = 0) FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizada correctamente.');


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
