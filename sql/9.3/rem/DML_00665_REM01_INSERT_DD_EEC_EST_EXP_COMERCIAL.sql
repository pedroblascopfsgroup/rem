--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211103
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15264
--## PRODUCTO=NO
--## Finalidad:  Script que añade en DD_EEC_EST_EXP_COMERCIAL los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadir campo finalizada
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA('152','Pendiente registro de firmas en sistema','Pendiente registro de firmas en sistema','0','1'),
	T_TIPO_DATA('153','Finalizada','Finalizada','0','1'),
	T_TIPO_DATA('154','Cancelada','Cancelada','0','1'),
 	T_TIPO_DATA('155','Borrador','Borrador','0','0'),
  	T_TIPO_DATA('153','Finalizada','Finalizada','0','0')

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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2))||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_EEC_ID, DD_EEC_CODIGO ,DD_EEC_DESCRIPCION, DD_EEC_DESCRIPCION_LARGA, DD_EEC_VENTA, DD_EEC_ALQUILER, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','||TRIM(V_TMP_TIPO_DATA(4))||','||TRIM(V_TMP_TIPO_DATA(5))||' ,0, ''HREOS-15264'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Borramos el registro con codigo 18 ');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL SET 
              BORRADO = 1,
              USUARIOBORRAR = ''HREOS-15264'',
              FECHABORRAR = SYSDATE
              WHERE DD_EEC_CODIGO =''18''';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Cambiamos el DD_EEC_ID de la tabla ECO_EXPEDIENTE_COMERCIAL de los registros con el estado que hemos borrado');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_EEC_CODIGO = ''48''),           
              USUARIOMODIFICAR = ''HREOS-15264'',
              FECHAMODIFICAR = SYSDATE
              WHERE DD_EEC_ID= (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_EEC_CODIGO = ''18'')';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS CORRECTAMENTE');





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
