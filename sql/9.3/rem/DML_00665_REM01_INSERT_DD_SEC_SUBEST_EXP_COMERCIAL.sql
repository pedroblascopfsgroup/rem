--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20210909
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14748
--## PRODUCTO=NO
--## Finalidad:  Script que añade en DD_SEC_SUBEST_EXP_COMERCIAL los datos añadidos en T_ARRAY_DATA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 HREOS-14964 - Añadimos subestado 'Enviado' y 'No enviado' relacionado al estado 'En tramitacion'
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

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(

	T_TIPO_DATA('01','44','Pendiente sanción hre','Pendiente sanción hre'),
	T_TIPO_DATA('02','44','Pendiente de la propiedad hre','Pendiente de la propiedad hre'),
	T_TIPO_DATA('03','44','Pendiente aceptación contraoferta','Pendiente aceptación contraoferta'),
	T_TIPO_DATA('04','44','Pendiente confirmación oferta','Pendiente confirmación oferta'),
	T_TIPO_DATA('05','45','Congelada','Congelada'),
	T_TIPO_DATA('06','45','Rechazada por el inquilino','Rechazada por el inquilino'),
	T_TIPO_DATA('07','45','Rechazada económicamente','Rechazada económicamente'),
	T_TIPO_DATA('08','45','Rechazada contraste de lista','Rechazada contraste de lista'),
	T_TIPO_DATA('09','45','No se entrega documentación','No se entrega documentación'),
	T_TIPO_DATA('10','45','Scoring ko','Scoring ko'),
	T_TIPO_DATA('11','45','Activo no disponible','Activo no disponible'),
	T_TIPO_DATA('12','45','Activo okupado','Activo okupado'),
	T_TIPO_DATA('13','46','Descartada','Descartada'),
	T_TIPO_DATA('14','47','Pendiente pago de reserva','Pendiente pago de reserva'),
	T_TIPO_DATA('15','47','Pendiente envio contrato a firma','Pendiente envio contrato a firma'),
	T_TIPO_DATA('16','47','Pendiente firma de inquilino (contrato de reserva)','Pendiente firma de inquilino (contrato de reserva)'),
	T_TIPO_DATA('17','47','Pendiente apoderado hre (contrato de reserva)','Pendiente apoderado hre (contrato de reserva)'),
	T_TIPO_DATA('18','48','Pendiente obtención de documentación','Pendiente obtención de documentación'),
	T_TIPO_DATA('19','48','Pendiente envio documentación a scoring','Pendiente envio documentación a scoring'),
	T_TIPO_DATA('20','48','Pendiente sanción scoring','Pendiente sanción scoring'),
	T_TIPO_DATA('21','48','Pendiente aportación garantias adicionales (avalista)','Pendiente aportación garantias adicionales (avalista)'),
	T_TIPO_DATA('22','48','Pendiente sanción de la propiedad','Pendiente sanción de la propiedad'),
	T_TIPO_DATA('23','48','Pendiente aportación garantias adicionales (depósito)','Pendiente aportación garantias adicionales (depósito)'),
	T_TIPO_DATA('24','49','Pendiente trámites previos','Pendiente trámites previos'),
	T_TIPO_DATA('25','49','Pendiente fecha de firma','Pendiente fecha de firma'),
	T_TIPO_DATA('26','50','Pendiente elaboración contrato','Pendiente elaboración contrato'),
	T_TIPO_DATA('27','50','Pendiente validación api','Pendiente validación api'),
	T_TIPO_DATA('28','51','Pendiente firma de inquilino (contrato de alquiler)','Pendiente firma de inquilino (contrato de alquiler)'),
	T_TIPO_DATA('29','51','Pendiente firma apoderado hre (contrato de alquiler)','Pendiente firma apoderado hre (contrato de alquiler)'),
  T_TIPO_DATA('30','01','Enviado','Enviado'),
  T_TIPO_DATA('31','01','No enviado','No enviado')

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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SEC_SUBEST_EXP_COMERCIAL WHERE DD_SEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN				
 
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' - '''|| TRIM(V_TMP_TIPO_DATA(2))||'''');   
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
          EXECUTE IMMEDIATE V_MSQL INTO DD_EEC_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_SEC_ID ,DD_SEC_CODIGO, DD_EEC_ID, DD_SEC_DESCRIPCION, DD_SEC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','|| DD_EEC_ID || ','''||TRIM(V_TMP_TIPO_DATA(3))||''','''||TRIM(V_TMP_TIPO_DATA(4))||''' ,0, ''HREOS-7795'',SYSDATE,0 FROM DUAL';
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