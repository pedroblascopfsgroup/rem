--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2053
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_TDE_TIPO_DOC_EXP los datos añadidos en T_ARRAY_DATA
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
                    --DD_TDE_CODIGO      --DESCRIPCION
        T_TIPO_DATA('01',                '1.- Identificación'),
        T_TIPO_DATA('02',                '4.- Tanteo'),
        T_TIPO_DATA('03',                '3.- Reserva'),
        T_TIPO_DATA('04',                '5.- Formalización'),
        T_TIPO_DATA('05',                '2.- Sanción')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_TDE_TIPO_DOC_EXP -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: Actualizacion EN DD_TDE_TIPO_DOC_EXP] ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
     	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_TDE_TIPO_DOC_EXP '||
          'SET ' ||
          'DD_TDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
    			', USUARIOMODIFICAR = ''HREOS-2053'' , FECHAMODIFICAR = SYSDATE '||
    			'WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

     END IF;
    END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_TDE_TIPO_DOC_EXP ACTUALIZADO CORRECTAMENTE ');

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
