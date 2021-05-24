--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-8842
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

    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-8842'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		SUBCARTERA_CODIGO			PRECIO_UNITARIO			CFT_UNIDAD_MEDIDA		NIF_PVE			DD_TTF_DESCRIPCION
		
        T_TIPO_DATA('BK-ANTIOC17',  '03',  '40', '03',  '',  '49'  ,'€/ud' ,'10010725', 'Alquiler puerta'),
		T_TIPO_DATA('BK-ANTIOC18',  '03',  '40', '03',  '',  '31'  ,'€/ud' ,'10010725', 'Alquiler Pantallas'),
		T_TIPO_DATA('BK-ANTIOC19',  '03',  '40', '03',  '',  '20'  ,'€' ,'10010725', 'Hora Fija Intervencion'),
		T_TIPO_DATA('BK-ANTIOC20',  '03',  '40', '03',  '',  '60'  ,'€' ,'10010725', 'Lanzamiento/Desalojo'),
		T_TIPO_DATA('BK-ANTIOC21',  '03',  '40', '03',  '',  '50'  ,'€' ,'10010725', 'Servicio Mínimo'),
		T_TIPO_DATA('BK-ANTIOC22',  '03',  '40', '03',  '',  '45'  ,'€' ,'10010725', 'Apertura'),
		T_TIPO_DATA('BK-ANTIOC23',  '03',  '40', '03',  '',  '20'  ,'€' ,'10010725', 'Llave Extra'),
		T_TIPO_DATA('BK-ANTIOC24',  '03',  '40', '03',  '',  '40'  ,'€' ,'10010725', 'Mantenimiento'),
		T_TIPO_DATA('BK-ANTIOC25',  '03',  '40', '03',  '',  '50'  ,'€' ,'10010725', 'Urgencia'),
		T_TIPO_DATA('BK-ANTIOC26',  '03',  '40', '03',  '',  '80'  ,'€' ,'10010725', 'Servicio Nocturno'),
		T_TIPO_DATA('BK-ANTIOC27',  '03',  '40', '03',  '',  '40'  ,'€' ,'10010725', 'Hora Extra'),
		T_TIPO_DATA('BK-ANTIOC28',  '03',  '40', '03',  '',  '45'  ,'€' ,'10010725', 'Bombín'),
		T_TIPO_DATA('BK-ANTIOC29',  '03',  '40', '03',  '',  '110'  ,'€' ,'10010725', 'Cerradura'),
		T_TIPO_DATA('BK-ANTIOC30',  '03',  '40', '03',  '',  '350'  ,'€/elemento' ,'10010725', 'Puerta No Devuelta'),
        T_TIPO_DATA('BK-ANTIOC31',  '03',  '40', '03',  '',  '350'  ,'€/elemento' ,'10010725', 'Pantalla No Devuelta'),
        T_TIPO_DATA('BK-ANTIOC32',  '03',  '40', '03',  '',  '350'  ,'€/elemento' ,'10010725', 'Puerta No Devuelta (Canarias)'),
        T_TIPO_DATA('BK-ANTIOC33',  '03',  '40', '03',  '',  '350'  ,'€/elemento' ,'10010725', 'Pantalla No Devuelta (Canarias)')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_TTF_TIPO_TARIFA Y ACT_CFT_CONFIG_TARIFA');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS < 1 THEN

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA (DD_TTF_ID, DD_TTF_CODIGO, DD_TTF_DESCRIPCION, DD_TTF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) VALUES (
				'||V_ESQUEMA||'.S_DD_TTF_TIPO_TARIFA.NEXTVAL,
				'''||TRIM(V_TMP_TIPO_DATA(1))||''',
				'''||TRIM(V_TMP_TIPO_DATA(9))||''',
				'''||TRIM(V_TMP_TIPO_DATA(9))||''',
				'||V_USU_MODIFICAR||',
				SYSDATE
			)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO '''||TRIM(V_TMP_TIPO_DATA(1))||''' EN DD_TTF_TIPO_TARIFA');

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE LA TARIFA '''||TRIM(V_TMP_TIPO_DATA(1))||''' EN DD_TTF_TIPO_TARIFA');

		END IF;

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA (CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, CFT_PRECIO_UNITARIO, CFT_PRECIO_UNITARIO_CLIENTE, CFT_UNIDAD_MEDIDA, USUARIOCREAR, FECHACREAR, PVE_ID) VALUES (
				'||V_ESQUEMA||'.S_ACT_CFT_CONFIG_TARIFA.NEXTVAL,
				(SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), 
				(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), 
				(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), 
				(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 
				'''||TRIM(V_TMP_TIPO_DATA(6))||''', 
				'''||TRIM(V_TMP_TIPO_DATA(6))||''', 
				'''||TRIM(V_TMP_TIPO_DATA(7))||''', 
				'||V_USU_MODIFICAR||', 
				SYSDATE, 
				(SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(8))||''' AND BORRADO = 0 AND DD_TPR_ID = (SELECT DD_TPR_ID FROM '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR WHERE DD_TPR_CODIGO = ''05'') AND PVE_FECHA_BAJA IS NULL)
			)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADO '''||TRIM(V_TMP_TIPO_DATA(1))||''' EN ACT_CFT_CONFIG_TARIFA');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO]: YA EXISTE LA TARIFA '''||TRIM(V_TMP_TIPO_DATA(1))||''' EN ACT_CFT_CONFIG_TARIFA');

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