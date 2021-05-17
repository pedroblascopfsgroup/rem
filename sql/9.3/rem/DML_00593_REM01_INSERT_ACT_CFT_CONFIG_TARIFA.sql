--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210505
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
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-9293_V2'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		SUBCARTERA_CODIGO			PRECIO_UNITARIO			CFT_UNIDAD_MEDIDA		NIF_PVE
		
        -- cerberus -> jaipur inmobiliario
        T_TIPO_DATA('PAO1',  '03',  '40', '07',  '37',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '07',  '37',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '07',  '37',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '07',  '37',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '07',  '37',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '07',  '37',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '07',  '37',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '07',  '37',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '07',  '37',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '07',  '37',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '07',  '37',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '07',  '37',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '07',  '37',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '07',  '37',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '07',  '37',  '75'  ,'€/ud' ,'B63434633'),

        -- cerberus -> jaipur financiero

        T_TIPO_DATA('PAO1',  '03',  '40', '07',  '38',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '07',  '38',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '07',  '38',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '07',  '38',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '07',  '38',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '07',  '38',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '07',  '38',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '07',  '38',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '07',  '38',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '07',  '38',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '07',  '38',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '07',  '38',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '07',  '38',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '07',  '38',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '07',  '38',  '75'  ,'€/ud' ,'B63434633'),

        -- cerberus -> Apple inmobiliario
        T_TIPO_DATA('PAO1',  '03',  '40', '07',  '138',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '07',  '138',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '07',  '138',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '07',  '138',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '07',  '138',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '07',  '138',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '07',  '138',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '07',  '138',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '07',  '138',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '07',  '138',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '07',  '138',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '07',  '138',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '07',  '138',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '07',  '138',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '07',  '138',  '75'  ,'€/ud' ,'B63434633'),

        -- cerberus -> Divarian industrial
        T_TIPO_DATA('PAO1',  '03',  '40', '07',  '151',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '07',  '151',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '07',  '151',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '07',  '151',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '07',  '151',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '07',  '151',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '07',  '151',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '07',  '151',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '07',  '151',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '07',  '151',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '07',  '151',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '07',  '151',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '07',  '151',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '07',  '151',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '07',  '151',  '75'  ,'€/ud' ,'B63434633'),
        
        -- cerberus -> Divarian Remaining
        T_TIPO_DATA('PAO1',  '03',  '40', '07',  '152',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON1',  '03',  '40', '07',  '152',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('DES1',  '03',  '40', '07',  '152',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ1',  '03',  '40', '07',  '152',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('REJ2',  '03',  '40', '07',  '152',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('URG1',  '03',  '40', '07',  '152',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP1',  '03',  '40', '07',  '152',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('ESP2',  '03',  '40', '07',  '152',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('PRO1',  '03',  '40', '07',  '152',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('HOR1',  '03',  '40', '07',  '152',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('CAN1',  '03',  '40', '07',  '152',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('APE1',  '03',  '40', '07',  '152',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('MON2',  '03',  '40', '07',  '152',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('BOM1',  '03',  '40', '07',  '152',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA('RET1',  '03',  '40', '07',  '152',  '75'  ,'€/ud' ,'B63434633')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2
    (
    --	TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO			PRECIO_UNITARIO			CFT_UNIDAD_MEDIDA		NIF_PVE
		
        -- Liberbank
        T_TIPO_DATA2('PAO1',  '03',  '40', '08',  '385'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('MON1',  '03',  '40', '08',  '110'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('DES1',  '03',  '40', '08',  '120'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('REJ1',  '03',  '40', '08',  '195'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('REJ2',  '03',  '40', '08',  '328'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('URG1',  '03',  '40', '08',  '50'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('ESP1',  '03',  '40', '08',  '70'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('ESP2',  '03',  '40', '08',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('PRO1',  '03',  '40', '08',  '20'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('HOR1',  '03',  '40', '08',  '40'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('CAN1',  '03',  '40', '08',  '65'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('APE1',  '03',  '40', '08',  '35'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('MON2',  '03',  '40', '08',  '90'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('BOM1',  '03',  '40', '08',  '55'  ,'€/ud' ,'B63434633'),
		T_TIPO_DATA2('RET1',  '03',  '40', '08',  '75'  ,'€/ud' ,'B63434633')

    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

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
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_PRECIO_UNITARIO_CLIENTE, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PVE_ID) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      '(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||'''), '||
                      ''''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 , (SELECT MAX(PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA(8))||''' AND BORRADO = 0) FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
            V_COUNT:=V_COUNT+1;

		END IF;
	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS REGISTROS CON SUBCARTERA CORRECTAMENTE: '''|| V_COUNT ||''' DE '''||V_COUNT_TOTAL||''' ');
    V_COUNT:=0;
    V_COUNT_TOTAL:=0;

    FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
	LOOP

		V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;
        
		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(4))||''') ';
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
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_PRECIO_UNITARIO_CLIENTE, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, PVE_ID) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(4))||'''), '||
                      ''''||TRIM(V_TMP_TIPO_DATA2(5))||''', '''||TRIM(V_TMP_TIPO_DATA2(5))||''', '''||TRIM(V_TMP_TIPO_DATA2(6))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 , (SELECT MAX(PVE_ID) FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_DOCIDENTIF = '''||TRIM(V_TMP_TIPO_DATA2(7))||''' AND BORRADO = 0) FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
            V_COUNT:=V_COUNT+1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE EL REGISTRO: '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||''' NO SE INSERTA ');
		END IF;
	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS REGISTROS CON SUBCARTERA CORRECTAMENTE: '''|| V_COUNT ||''' DE '''||V_COUNT_TOTAL||''' ');

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