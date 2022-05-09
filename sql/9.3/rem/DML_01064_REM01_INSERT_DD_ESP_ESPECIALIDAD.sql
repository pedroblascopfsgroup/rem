--/*
--##########################################
--## AUTOR=Pedro Blasco
--## FECHA_CREACION=20220506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17597
--## PRODUCTO=NO
--## Finalidad:  Script que añade en DD_ESP_ESPECIALIDAD los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial: Santi Monzó
--##        1.0 Versión: Pedro Blasco, cambio de valores del diccionario
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
    DD_EEC_ID NUMBER(16); -- Vble. para almacenar el id del estado del expediente
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ESP_ESPECIALIDAD'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

    T_TIPO_DATA('01','Vivienda','Vivienda'),
    T_TIPO_DATA('02','Obra Nueva','Obra Nueva'),
    T_TIPO_DATA('03','Suelo','Suelo'),
    T_TIPO_DATA('04','Industrial','Industrial'),
    T_TIPO_DATA('05','Comercial','Comercial'),
    T_TIPO_DATA('06','Otros','Otros'),
    T_TIPO_DATA('07','Oficina','Oficina'),
    T_TIPO_DATA('08','Garaje','Garaje'),
    T_TIPO_DATA('09','Trastero	','Trastero	')

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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ESP_ESPECIALIDAD WHERE DD_ESP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      IF V_NUM_TABLAS > 0 THEN				
 
          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||
              ' SET DD_ESP_DESCRIPCION=:1, DD_ESP_DESCRIPCION_LARGA=:2, VERSION=:3, USUARIOMODIFICAR=:4, FECHAMODIFICAR=:5 ' ||
              ' WHERE DD_ESP_CODIGO = :6';
          EXECUTE IMMEDIATE V_MSQL USING V_TMP_TIPO_DATA(2), V_TMP_TIPO_DATA(3), 1, 'HREOS-17597', SYSDATE, V_TMP_TIPO_DATA(1);
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ' || V_TMP_TIPO_DATA(1) || ' YA EXISTENTE: ACTUALIZADO CORRECTAMENTE');

      ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_ESP_ID ,DD_ESP_CODIGO, DD_ESP_DESCRIPCION, DD_ESP_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''' ,0, ''HREOS-17597'',SYSDATE,0 FROM DUAL';
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
