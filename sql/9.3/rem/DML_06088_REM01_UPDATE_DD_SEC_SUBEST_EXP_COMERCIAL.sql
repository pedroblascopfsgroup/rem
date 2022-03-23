--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11310
--## PRODUCTO=NO
--## Finalidad:  Script que actualiza en DD_SEC_SUBEST_EXP_COMERCIAL los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    DD_EEC_ID NUMBER(16); -- Vble. para almacenar el id del estado del expediente
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SEC_SUBEST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(200 CHAR):='REMVIP-11310';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA('47','44','144'),
	T_TIPO_DATA('48','44','144'),
	T_TIPO_DATA('49','44','144'),
	T_TIPO_DATA('50','44','144'),
	T_TIPO_DATA('54','45','145'),
	T_TIPO_DATA('38','54','154'),
	T_TIPO_DATA('37','54','154'),
	T_TIPO_DATA('36','54','154'),
	T_TIPO_DATA('40','54','154'),
	T_TIPO_DATA('39','54','154'),
	T_TIPO_DATA('41','54','154'),
	T_TIPO_DATA('13','46','146'),
	T_TIPO_DATA('19','47','147'),
	T_TIPO_DATA('20','47','147'),
	T_TIPO_DATA('21','47','147'),
	T_TIPO_DATA('22','47','147'),
	T_TIPO_DATA('23','48','148'),
	T_TIPO_DATA('24','48','148'),
	T_TIPO_DATA('25','48','148'),
	T_TIPO_DATA('27','48','148'),
	T_TIPO_DATA('26','48','148'),
	T_TIPO_DATA('28','49','149'),
	T_TIPO_DATA('29','49','149'),
	T_TIPO_DATA('30','50','150'),
	T_TIPO_DATA('31','50','150'),
	T_TIPO_DATA('32','51','151'),
	T_TIPO_DATA('33','51','151'),
	T_TIPO_DATA('34','52','152'),
	T_TIPO_DATA('35','52','152'),
	T_TIPO_DATA('52','54','154'),
	T_TIPO_DATA('55','55','155'),
	T_TIPO_DATA('53','53','153')

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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SEC_SUBEST_EXP_COMERCIAL SEC
        JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID=SEC.DD_EEC_ID
        
        WHERE DD_SEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
        AND EEC.DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
 
		DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' ');
  		V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' 
        		SET 
        		DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''),
			USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE 					
			WHERE DD_SEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' ');

       ELSE
        DBMS_OUTPUT.PUT_LINE('[WARN]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''' NO EXISTE');

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
