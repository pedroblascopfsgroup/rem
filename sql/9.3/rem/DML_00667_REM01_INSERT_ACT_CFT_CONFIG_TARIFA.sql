--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210819
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10343
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
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-10343'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    V_COUNT NUMBER(16):=0;
    V_COUNT_TOTAL NUMBER(16):=0;

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	DD_TTF_CODIGO A COPIAR		SUBTIPO_TRABAJO_CODIGO  DD_TTF_CODIGO NUEVO

        T_TIPO_DATA('DIV029','INT','AP-OM391'),
        T_TIPO_DATA('DIV030','INT','AP-OM392'),
        T_TIPO_DATA('DIV034','ACO','AP-OM393'),
        T_TIPO_DATA('DIV035','ACO','AP-OM394'),
        T_TIPO_DATA('DIV099','125','AP-OM395'),
        T_TIPO_DATA('DIV100','125','AP-OM396'),
        T_TIPO_DATA('DIV101','125','AP-OM397'),
        T_TIPO_DATA('DIV102','125','AP-OM398'),
        T_TIPO_DATA('DIV103','123','AP-OM399'),
        T_TIPO_DATA('DIV104','123','AP-OM400'),
        T_TIPO_DATA('DIV105','123','AP-OM401'),
        T_TIPO_DATA('DIV106','123','AP-OM402'),
        T_TIPO_DATA('DIV107','123','AP-OM403'),
        T_TIPO_DATA('DIV108','123','AP-OM404'),
        T_TIPO_DATA('DIV109','123','AP-OM405'),
        T_TIPO_DATA('DIV110','123','AP-OM406'),
        T_TIPO_DATA('DIV133','125','AP-OM407'),
        T_TIPO_DATA('DIV134','125','AP-OM408'),
        T_TIPO_DATA('DIV135','125','AP-OM409'),
        T_TIPO_DATA('DIV136','125','AP-OM410'),
        T_TIPO_DATA('DIV137','125','AP-OM411'),
        T_TIPO_DATA('DIV138','125','AP-OM412'),
        T_TIPO_DATA('DIV139','125','AP-OM413'),
        T_TIPO_DATA('DIV140','125','AP-OM414'),
        T_TIPO_DATA('DIV141','125','AP-OM415'),
        T_TIPO_DATA('DIV142','125','AP-OM416'),
        T_TIPO_DATA('DIV182','ACO','AP-OM417'),
        T_TIPO_DATA('DIV183','ACO','AP-OM418'),
        T_TIPO_DATA('DIV184','ACO','AP-OM419'),
        T_TIPO_DATA('DIV185','ACO','AP-OM420'),
        T_TIPO_DATA('DIV186','ACO','AP-OM421'),
        T_TIPO_DATA('DIV187','ACO','AP-OM422'),
        T_TIPO_DATA('DIV188','ACO','AP-OM423'),
        T_TIPO_DATA('DIV189','ACO','AP-OM424'),
        T_TIPO_DATA('DIV190','ACO','AP-OM425'),
        T_TIPO_DATA('DIV191','ACO','AP-OM426'),
        T_TIPO_DATA('DIV192','ACO','AP-OM427'),
        T_TIPO_DATA('DIV193','ACO','AP-OM428'),
        T_TIPO_DATA('DIV194','ACO','AP-OM429'),
        T_TIPO_DATA('DIV195','ACO','AP-OM430'),
        T_TIPO_DATA('DIV196','ACO','AP-OM431'),
        T_TIPO_DATA('DIV233','125','AP-OM432'),
        T_TIPO_DATA('DIV254','125','AP-OM433'),
        T_TIPO_DATA('DIV260','40','AP-OM434'),
        T_TIPO_DATA('DIV261','123','AP-OM435'),
        T_TIPO_DATA('DIV262','123','AP-OM436'),
        T_TIPO_DATA('DIV263','123','AP-OM437'),
        T_TIPO_DATA('DIV264','123','AP-OM438'),
        T_TIPO_DATA('DIV274','123','AP-OM439'),
        T_TIPO_DATA('DIV275','123','AP-OM440'),
        T_TIPO_DATA('DIV278','125','AP-OM441'),
        T_TIPO_DATA('DIV284','125','AP-OM442'),
        T_TIPO_DATA('DIV285','125','AP-OM443'),
        T_TIPO_DATA('DIV286','125','AP-OM444'),
        T_TIPO_DATA('DIV287','125','AP-OM445'),
        T_TIPO_DATA('DIV299','62','AP-OM446')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        V_COUNT_TOTAL:=V_COUNT_TOTAL+1;

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07'') '||
		'AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138'')';
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
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||'');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_PRECIO_UNITARIO_CLIENTE, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      'CFT.DD_TTR_ID, '||
                      'CFT.DD_STR_ID, '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''07''), '||
                      '(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = ''138''), '||
                      'CFT.CFT_PRECIO_UNITARIO, CFT.CFT_PRECIO_UNITARIO_CLIENTE, CFT.CFT_UNIDAD_MEDIDA, 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0  
                      FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CFT
                      JOIN '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA TTF ON TTF.DD_TTF_ID=CFT.DD_TTF_ID AND TTF.BORRADO=0
                      JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID=CFT.DD_STR_ID AND STR.BORRADO=0
                      JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID=CFT.DD_SCR_ID AND SCR.BORRADO = 0
                      WHERE STR.DD_STR_CODIGO='''||TRIM(V_TMP_TIPO_DATA(2))||''' AND TTF.DD_TTF_CODIGO='''||TRIM(V_TMP_TIPO_DATA(1))||'''
                      AND SCR.DD_SCR_CODIGO=''152''
                      ';
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
            V_COUNT:=V_COUNT+1;

		END IF;
	END LOOP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTADOS REGISTROS CON SUBCARTERA CORRECTAMENTE: '''|| V_COUNT ||''' DE '''||V_COUNT_TOTAL||''' ');
    V_COUNT:=0;
    V_COUNT_TOTAL:=0;

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