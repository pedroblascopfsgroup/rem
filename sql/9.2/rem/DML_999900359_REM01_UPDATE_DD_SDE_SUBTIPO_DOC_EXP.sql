--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20180913
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4373
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SDE_SUBTIPO_DOC_EXP los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Añadimos las Matriculas
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
                    --DD_TDE_CODIGO      --DD_SDE_CODIGO         --DESCRIPCION                                    --DESC LARGA                         --Matricula
        T_TIPO_DATA('06',                 '43'	                   ,'Scoring'					      			  ,'Scoring',               			'OP-29-ESIN-BP'),
        T_TIPO_DATA('06',                 '44'	                   ,'Seguro rentas'				                  ,'Seguro rentas',                     'OP-29-SEGU-21'),
        T_TIPO_DATA('06',                 '45'	                   ,'Sanción de la oferta'				          ,'Sanción de la oferta',              'OP-29-ACUI-28'),
        T_TIPO_DATA('06',                 '46'	                   ,'Renovación contrato'				          ,'Renovación contrato',               'OP-29-CNCV-85'),
        T_TIPO_DATA('06',                 '47'	                   ,'Pre-Contrato'				                  ,'Pre-Contrato',                      'OP-29-CNCV-86'),
        T_TIPO_DATA('06',                 '48'	                   ,'Pre-Liquidación ITP'				          ,'Pre-Liquidación ITP',               'OP-29-DECL-14'),
        T_TIPO_DATA('06',                 '49'	                   ,'Contrato'				                      ,'Contrato',                          'OP-29-CNCV-04'),
        T_TIPO_DATA('06',                 '50'	                   ,'Liquidación ITP'				              ,'Liquidación ITP',                   'OP-29-DECL-11'),
        T_TIPO_DATA('06',                 '51'	                   ,'Fianza'				                      ,'Fianza',                            'OP-29-CERJ-54'),
        T_TIPO_DATA('06',                 '52'	                   ,'Aval bancario'				                  ,'Aval bancario',                     'OP-29-FIAV-06'),
        T_TIPO_DATA('06',                 '53'	                   ,'Justificante de ingresos'				      ,'Justificante de ingresos',          'OP-29-CERJ-75')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

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
            ', DD_SDE_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(5))||''''||
            ', USUARIOMODIFICAR = ''HREOS-4373'' , FECHAMODIFICAR = SYSDATE '||
            'WHERE DD_SDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

     --Si no existe, lo insertamos
     ELSE

        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
        V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_SDE_SUBTIPO_DOC_EXP.NEXTVAL FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL INTO V_ID;
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_SDE_SUBTIPO_DOC_EXP (' ||
          'DD_SDE_ID, DD_TDE_ID, DD_SDE_CODIGO, DD_SDE_DESCRIPCION, DD_SDE_DESCRIPCION_LARGA, DD_SDE_MATRICULA_GD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
          'SELECT '|| V_ID ||
           ', (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') '||
           ','''||V_TMP_TIPO_DATA(2)||''' '||
           ','''||TRIM(V_TMP_TIPO_DATA(3))||''' '||
           ','''||TRIM(V_TMP_TIPO_DATA(4))||''' '||
           ','''||TRIM(V_TMP_TIPO_DATA(5))||''', 0, ''HREOS-4373'',SYSDATE,0 FROM DUAL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

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
