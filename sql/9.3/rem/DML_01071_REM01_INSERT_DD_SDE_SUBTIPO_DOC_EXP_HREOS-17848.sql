--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220520
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17848
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_SDE_SUBTIPO_DOC_EXP los datos añadidos en T_ARRAY_DATA.
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'SDE'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('92', 'DNI','10', 'OP-12-DOCI-01'),
        T_TIPO_DATA('93', 'NIE','10', 'OP-12-DOCI-06'),
        T_TIPO_DATA('94', 'Tarjeta de residente','10', null),
        T_TIPO_DATA('95', 'Pasaporte','10', 'OP-12-DOCI-05'),
        T_TIPO_DATA('96', 'DNI país extranjero','10', null),
        T_TIPO_DATA('97', 'TJ identifiación diplomática','10', null),
        T_TIPO_DATA('98', 'Menor','10', null),
        T_TIPO_DATA('99', 'Otros persona física','10', null),
        T_TIPO_DATA('100', 'Otros persona jurídica','10', null),
        T_TIPO_DATA('101', 'Ident Banco de España','10', null),
        T_TIPO_DATA('102', 'NIF','10', null),
        T_TIPO_DATA('103', 'NIF PAIS ORIGEN','10', null),
        T_TIPO_DATA('104', 'Otro','10', 'OP-12-DOCI-02')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN			
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(2)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (DD_'||V_TEXT_CHARS||'_ID, 
						DD_TDE_ID
						,DD_'||V_TEXT_CHARS||'_CODIGO
						, DD_'||V_TEXT_CHARS||'_DESCRIPCION
						, DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA
						, USUARIOCREAR, FECHACREAR, BORRADO
						, DD_'||V_TEXT_CHARS||'_MATRICULA_GD)
                      SELECT '|| V_ID || '
						, (SELECT DD_TDE_ID FROM '||V_ESQUEMA||'.DD_TDE_TIPO_DOC_EXP WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
                      	, '''||V_TMP_TIPO_DATA(1)||'''
						,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
						,'''||TRIM(V_TMP_TIPO_DATA(2))||'''
						, ''HREOS-17848'',SYSDATE,0, '''||TRIM(V_TMP_TIPO_DATA(4))||''' FROM DUAL';
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
