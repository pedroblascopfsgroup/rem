--/*
--##########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20190708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.16.0
--## INCIDENCIA_LINK=HREOS-6976
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_COS_COMITES_SANCION los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL3 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS3 NUMBER(16); -- Vble. para validar la existencia de una tabla.
    DESCRIP VARCHAR2(1024 CHAR);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
    V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'DD_COS_COMITES_SANCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'COS'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-6976'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    --        CODIGO    DESCRIPCION         DESCRIPCION_LARGA   TIPO_TRABAJO_CODIGO
        -- cartera Giants
        T_TIPO_DATA('20',   'Haya'  ,   'Haya',   '12', null),
        -- cartera Galeon
        T_TIPO_DATA('28',   'Haya'  ,   'Haya',   '15', null),
        -- cartera Egeo 
        T_TIPO_DATA('33',   'Haya'  ,   'Haya',   '13', '41')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN 

  DBMS_OUTPUT.PUT_LINE('[INICIO]');


  -- LOOP para insertar los valores --
  DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP

    V_TMP_TIPO_DATA := V_TIPO_DATA(I);
      --BORRAMOS REGISTRO DIFERENTE DEL QUE LE PASAMOS
      DBMS_OUTPUT.PUT_LINE('[INFO]: ITERAMOS SOBRE EL CÓDIGO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        SET   
          USUARIOBORRAR = '||V_USU_MODIFICAR||'
        , FECHABORRAR = SYSDATE
        , BORRADO = 1
        WHERE DD_'||V_TEXT_CHARS||'_CODIGO <> '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
    EXECUTE IMMEDIATE V_MSQL;
  END LOOP;

  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
  LOOP

    V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    V_SQL2 := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
    EXECUTE IMMEDIATE V_SQL2 INTO V_NUM_TABLAS;

    V_SQL3 := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_COS_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 1';
      EXECUTE IMMEDIATE V_SQL3 INTO V_NUM_TABLAS3;
    
    -- Si no existe se inserta.
    IF V_NUM_TABLAS = 0 THEN  

      -- Comprobar secuencias de la tabla.
      V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;

      -- INSERTAMOS REGISTRO SI NO ESTA 
      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'DD_'||V_TEXT_CHARS||'_ID, DD_'||V_TEXT_CHARS||'_CODIGO, DD_'||V_TEXT_CHARS||'_DESCRIPCION, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, DD_CRA_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_SCR_ID) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', '''||V_TMP_TIPO_DATA(1)||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), 0, '|| V_USU_MODIFICAR ||',SYSDATE,0,(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''') FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
    
    -- Si EXISTE BORRADO =1.
    ELSIF V_NUM_TABLAS3 = 1 THEN  

      DBMS_OUTPUT.PUT_LINE('[INFO]: NO BORRAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
      V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
        SET
          USUARIOMODIFICAR = '||V_USU_MODIFICAR||'
        , FECHAMODIFICAR =  SYSDATE
        , USUARIOBORRAR = null
        , FECHABORRAR = null
        , BORRADO = 0
        WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''')';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO NO BORRADO ');

    ELSE
      -- si existen los datos no hacemos nada
      DBMS_OUTPUT.PUT_LINE('[INFO]: DATOS YA REGISTRADOS');        
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