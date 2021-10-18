--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15719
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SDE_SUBTIPO_DOC_EXP los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'SDE'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_TDE_COD VARCHAR2(16 CHAR):= '09'; -- Vble.auxiliar para sacar un ID.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('70'	,'Scoring' 	,'', 'OP-29-ESIN-BP', '0'),
      T_TIPO_DATA('71'	,'Seguro rentas' 	,'', 'OP-29-SEGU-21', '0'),
      T_TIPO_DATA('72'	,'Sanción de la oferta' 	,'', 'OP-29-ACUI-28', '0'),
      T_TIPO_DATA('73'	,'Renovación contrato' 	,'42', 'OP-29-CNCV-85', '1'),
      T_TIPO_DATA('74'	,'Pre-Contrato' 	,'', 'OP-29-CNCV-86', '0'),
      T_TIPO_DATA('75'	,'Pre-Liquidación ITP' 	,'', 'OP-29-DECL-14', '0'),
      T_TIPO_DATA('76'	,'Contrato' 	,'42', 'OP-29-CNCV-04', '1'),
      T_TIPO_DATA('77'	,'Liquidación ITP' 	,'', 'OP-29-DECL-11', '0'),
      T_TIPO_DATA('78'	,'Fianza' 	,'44', 'OP-29-CERJ-54', '1'),
      T_TIPO_DATA('79'	,'Aval bancario' 	,'73', 'OP-29-FIAV-06', '1'),
      T_TIPO_DATA('80'	,'Justificante de ingresos' 	,'74', 'OP-29-CERJ-75', '1'),
      T_TIPO_DATA('81'	,'Contrato de alquiler con opción a compra' 	,'43', 'OP-29-CNCV-05', '1')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN			
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_'||V_TEXT_CHARS||'_ID, DD_TDE_ID, 
                      DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, 
                      DD_'||V_TEXT_CHARS||'_MATRICULA_GD, USUARIOCREAR, FECHACREAR, DD_'||V_TEXT_CHARS||'_VINCULABLE,DD_'||V_TEXT_CHARS||'_TPD_ID) 
                      SELECT '|| V_ID || ', (SELECT DD_TDE_ID FROM DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||V_TDE_COD||''')
                      , '''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||'''
                      , '''||TRIM(V_TMP_TIPO_DATA(4))||''', ''HREOS-15719'',SYSDATE, '||TRIM(V_TMP_TIPO_DATA(5))||'
                      , (SELECT DD_TPD_ID FROM DD_TPD_TIPO_DOCUMENTO WHERE DD_TPD_CODIGO = '''||V_TMP_TIPO_DATA(3)||''')  FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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