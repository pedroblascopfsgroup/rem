--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2053
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SDE_SUBTIPO_DOC_EXP los datos añadidos en T_ARRAY_DATA
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --DD_TDE_CODIGO      --DD_SDE_CODIGO         --DESCRIPCION                                    --DESC LARGA
        T_TIPO_DATA('05',                 '08'	                   ,'Denegación por Comité'					             ,'Denegación por Comité'),
        T_TIPO_DATA('03',                 '24'	                   ,'Contrato ampliación arras'					         ,'Contrato ampliación arras'),
        T_TIPO_DATA('04',                 '25'	                   ,'Contrato alquiler'					                 ,'Contrato alquiler'),
        T_TIPO_DATA('02',                 '05'	                   ,'Resolución tanteo por la Administración'	   ,'Resolución tanteo por la Administración'),
        T_TIPO_DATA('02',                 '13'	                   ,'Comunicación de oferta a la Administración' ,'Comunicación de oferta a la Administración'),
        T_TIPO_DATA('04',                 '26'	                   ,'Informe jurídico'					                 ,'Informe jurídico'),
        T_TIPO_DATA('04',                 '27'	                   ,'Catastro: declaración de alteración'	       ,'Catastro: declaración de alteración'),
        T_TIPO_DATA('04',                 '28'	                   ,'Subsanación de escritura de venta'	         ,'Subsanación de escritura de venta'),
        T_TIPO_DATA('01',                 '29'	                   ,'Documento identificativo del cliente DNI'   ,'Documento identificativo del cliente DNI'),
        T_TIPO_DATA('01',                 '30'	                   ,'Documento identificativo del cliente NIF'   ,'Documento identificativo del cliente NIF'),
        T_TIPO_DATA('01',                 '31'	                   ,'Poder del representante del cliente'	       ,'Poder del representante del cliente'),
        T_TIPO_DATA('02',                 '32'	                   ,'Solicitud de visita por la Administración'	 ,'Solicitud de visita por la Administración'),
        T_TIPO_DATA('04',                 '33'	                   ,'Autorización venta VPO'	                   ,'Autorización venta VPO'),
        T_TIPO_DATA('04',                 '34'	                   ,'Comunicación Comunidad de Propietarios'	   ,'Comunicación Comunidad de Propietarios'),
        T_TIPO_DATA('04',                 '35'	                   ,'Retrocesión de la venta'	                    ,'Retrocesión de la venta')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

    -- FILAS A BORRAR LOGICO
    TYPE T_ARRAY_DATA_BORRAR IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA_BORRAR T_ARRAY_DATA_BORRAR := T_ARRAY_DATA_BORRAR(
                    --DD_SDE_CODIGO        --DESCRIPCION
        T_TIPO_DATA('01',                 'CIF'),
        T_TIPO_DATA('02',                 'DNI'),
        T_TIPO_DATA('03',                 'NIF'),
        T_TIPO_DATA('09',                 'Contrato alquiler'),
        T_TIPO_DATA('10',                 'Ficha legal'),
        T_TIPO_DATA('16',                 'Escritura compraventa'),
        T_TIPO_DATA('07',                 'Minuta'),
        T_TIPO_DATA('14',                 'Respuesta de Habitatge'),
        T_TIPO_DATA('21',                 'Autorización venta')
    );
    V_TMP_TIPO_DATA_BORRAR T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_SDE_SUBTIPO_DOC_EXP -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_SDE_SUBTIPO_DOC_EXP] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SDE_SUBTIPO_DOC_EXP WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP '||
          'SET DD_TDE_ID = (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') ' ||
          ', DD_SDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||''''||
    			', DD_SDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(4))||''''||
    			', USUARIOMODIFICAR = ''HREOS-2053'' , FECHAMODIFICAR = SYSDATE '||
    			'WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

     --Si no existe, lo insertamos
     ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SDE_SUBTIPO_DOC_EXP.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP (' ||
          'DD_SDE_ID, DD_TDE_ID, DD_SDE_CODIGO, DD_SDE_DESCRIPCION, DD_SDE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
          'SELECT '|| V_ID ||
           ', (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') '||
           ','''||V_TMP_TIPO_DATA(2)||''' '||
           ','''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
           ','''||TRIM(V_TMP_TIPO_DATA(4))||''', 0, ''HREOS-2053'',SYSDATE,0 FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

     END IF;
    END LOOP;

    -- LOOP para BORRAR los valores en DD_SDE_SUBTIPO_DOC_EXP -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO EN DD_SDE_SUBTIPO_DOC_EXP] ');
    FOR I IN V_TIPO_DATA_BORRAR.FIRST .. V_TIPO_DATA_BORRAR.LAST
      LOOP

        V_TMP_TIPO_DATA_BORRAR := V_TIPO_DATA_BORRAR(I);

        --Comprobamos el dato a borrar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_SDE_SUBTIPO_DOC_EXP WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA_BORRAR(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        --Si existe lo BORRAMOS
        IF V_NUM_TABLAS > 0 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: BORRAMOS LOGICAMENT EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA_BORRAR(2)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP  SET BORRADO=1, USUARIOMODIFICAR = ''HREOS-2053'' '||
					'WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA_BORRAR(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO BORRADO CORRECTAMENTE');
       END IF;
      END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_SDE_SUBTIPO_DOC_EXP ACTUALIZADO CORRECTAMENTE ');

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
