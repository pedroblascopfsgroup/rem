--/*
--##########################################
--## AUTOR=Rasul Abdulaev
--## FECHA_CREACION=20180901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4471
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade valores en DD_EEC_VENTA
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

    V_COLUMN_NAME VARCHAR2(2400 CHAR) := 'DD_EEC_VENTA'; -- Vble. auxiliar para almacenar el nombre de la columna a añadir.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_EEC_EST_EXP_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --DD_EEC_CODIGO   --DD_EEC_VENTA                    
        T_TIPO_DATA('01',            '1'),
        T_TIPO_DATA('02',            '1'),
        T_TIPO_DATA('03',            '1'),
        T_TIPO_DATA('04',            '1'),
        T_TIPO_DATA('05',            '1'),
        T_TIPO_DATA('06',            '1'),
        T_TIPO_DATA('07',            '1'),
        T_TIPO_DATA('08',            '1'),
        T_TIPO_DATA('09',            '1'),
        T_TIPO_DATA('15',	            '1'),
        T_TIPO_DATA('10',	            '1'),
        T_TIPO_DATA('11',	            '1'),
        T_TIPO_DATA('12',	            '1'),
        T_TIPO_DATA('13',	            '1'),
        T_TIPO_DATA('14',	            '1'),
        T_TIPO_DATA('16',	            '1'),
        T_TIPO_DATA('18',	            '0'),
        T_TIPO_DATA('19',	             '0'),
        T_TIPO_DATA('20',	             '0'),
        T_TIPO_DATA('21',	             '0'),
        T_TIPO_DATA('22',	             '0'),
        T_TIPO_DATA('23',	             '0'),
        T_TIPO_DATA('24',	             '0'),
        T_TIPO_DATA('25',	             '0'),
        T_TIPO_DATA('26',	             '0'),
        T_TIPO_DATA('27',	             '0'),
        T_TIPO_DATA('28',	             '0'),
        T_TIPO_DATA('29',	             '0'),
        T_TIPO_DATA('17',	             '1')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  -- LOOP para insertar los valores en DD_EEC_EST_EXP_COMERCIAL -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_EEC_EST_EXP_COMERCIAL ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN

        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
            SET '||V_COLUMN_NAME||' = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            WHERE DD_EEC_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

     END IF;
    END LOOP;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_EEC_EST_EXP_COMERCIAL ACTUALIZADO CORRECTAMENTE ');

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
