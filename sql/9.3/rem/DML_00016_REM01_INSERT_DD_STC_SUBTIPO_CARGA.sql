--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20191008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-7795
--## PRODUCTO=NO
--## Finalidad:  Script que añade en DD_STC_SUBTIPO_CARGA los datos añadidos en T_ARRAY_DATA.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_STC_SUBTIPO_CARGA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA('1' ,'16','Com. Propietarios','Com. Propietarios'),
	T_TIPO_DATA('1' ,'17','Impuesto','Impuesto'),
	T_TIPO_DATA('1' ,'18','Otros','Otros'),
	T_TIPO_DATA('1' ,'19','Embargo','Embargo'),
	T_TIPO_DATA('1' ,'20','Hipoteca','Hipoteca'),
	T_TIPO_DATA('1' ,'21','Certificación de cargas','Certificación de cargas'),
	T_TIPO_DATA('1' ,'22','Afección fiscal','Afección fiscal'),
	T_TIPO_DATA('1' ,'23','Afección urbanística','Afección urbanística'),
	T_TIPO_DATA('1' ,'24','Condición resolutoria','Condición resolutoria'),
	T_TIPO_DATA('1' ,'25','Anotación concurso','Anotación concurso'),
	T_TIPO_DATA('1' ,'26','Censo','Censo'),
	T_TIPO_DATA('1' ,'27','Arrendamiento financiero','Arrendamiento financiero'),
	T_TIPO_DATA('1' ,'28','Condición suspensiva','Condición suspensiva'),
	T_TIPO_DATA('1' ,'29','Proyecto de reparcelación (afección, nota marginal..)','Proyecto de reparcelación (afección, nota marginal..)'),
	T_TIPO_DATA('1' ,'30','Servidumbre','Servidumbre'),
	T_TIPO_DATA('1' ,'31','Derecho adquisición preferente/tanteo y retracto','Derecho adquisición preferente/tanteo y retracto'),
	T_TIPO_DATA('1' ,'32','Derecho reversión','Derecho reversión'),
	T_TIPO_DATA('1' ,'33','Prohibición de disponibilidad','Prohibición de disponibilidad'),
	T_TIPO_DATA('1' ,'34','Opción de compra','Opción de compra'),
	T_TIPO_DATA('1' ,'35','Arrendamiento inscrito','Arrendamiento inscrito'),
	T_TIPO_DATA('2' ,'36','Com. Propietarios','Com. Propietarios'),
	T_TIPO_DATA('2' ,'37','Impuesto','Impuesto'),
	T_TIPO_DATA('2' ,'38','Otros','Otros'),
	T_TIPO_DATA('3' ,'39','Com. Propietarios','Com. Propietarios'),
	T_TIPO_DATA('3' ,'40','Impuesto','Impuesto'),
	T_TIPO_DATA('3' ,'41','Otros','Otros'),
	T_TIPO_DATA('3' ,'42','Embargo','Embargo'),
	T_TIPO_DATA('3' ,'43','Hipoteca','Hipoteca'),
	T_TIPO_DATA('3' ,'44','Certificación de cargas','Certificación de cargas'),
	T_TIPO_DATA('3' ,'45','Afección fiscal','Afección fiscal'),
	T_TIPO_DATA('3' ,'46','Afección urbanística','Afección urbanística'),
	T_TIPO_DATA('3' ,'47','Condición resolutoria','Condición resolutoria'),
	T_TIPO_DATA('3' ,'48','Anotación Concurso','Anotación Concurso'),
	T_TIPO_DATA('3' ,'49','Censo','Censo'),
	T_TIPO_DATA('3' ,'50','Arrendamiento financiero','Arrendamiento financiero'),
	T_TIPO_DATA('3' ,'51','Condición suspensiva','Condición suspensiva'),
	T_TIPO_DATA('3' ,'52','Proyecto de reparcelación (afección, nota marginal..)','Proyecto de reparcelación (afección, nota marginal..)')

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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TCA_ID = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_STC_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2))||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_STC_ID, DD_TCA_ID ,DD_STC_CODIGO, DD_STC_DESCRIPCION, DD_STC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''' ,0, ''HREOS-7795'',SYSDATE,0 FROM DUAL';
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
