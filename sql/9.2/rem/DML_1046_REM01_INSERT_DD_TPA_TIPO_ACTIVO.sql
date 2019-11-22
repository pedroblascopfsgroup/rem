--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5757
--## PRODUCTO=NO
--## FINALIDAD: Script que añade en DD_TPA_TIPO_ACTIVO los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un registro.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_TPA_TIPO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TPA'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USUARIO_CREAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario crear
    V_USUARIO_MODIFICAR VARCHAR2(20 CHAR) := 'REMVIP-5757'; -- Vble. auxiliar para almacenar el usuario modificar

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --T_TIPO_DATA('DD_TPA_CODIGO',		'DD_TPA_DESCRIPCION',		'DD_TPA_DESCRIPCION_LARGA')
      T_TIPO_DATA('08','Dotacional'),
      T_TIPO_DATA('09','Concesión Administrativa')
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
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

        IF V_NUM_REGISTROS = 0 THEN
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');          
          
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
                      	DD_'||V_TEXT_CHARS||'_ID,
						DD_'||V_TEXT_CHARS||'_CODIGO, 
						DD_'||V_TEXT_CHARS||'_DESCRIPCION, 
						DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA, 
						VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
                     SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL, 
					 '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''',
					 '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''',
					 '''|| TRIM(V_TMP_TIPO_DATA(2)) ||''', 
					 0, '''|| V_USUARIO_CREAR ||''',SYSDATE, 0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
       END IF;
      END LOOP;
      
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
