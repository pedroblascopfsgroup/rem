--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17107
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR DD_STR_SUBTIPO_TRABAJO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_STR_SUBTIPO_TRABAJO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CHARS VARCHAR2(6 CHAR) := 'STR';
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-17107';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        --Codigo   Codigo Tbj   Descripcion Corta   Descripcion Larga
        T_TIPO_DATA('20','02','Cédula de Habitabilidad'),
        T_TIPO_DATA('18','02','Certificado Eficiencia Energética (CEE)'),
        T_TIPO_DATA('155','03','Derribos'),
        T_TIPO_DATA('156','03','Humedades'),
        T_TIPO_DATA('157','03','Acometidas'),
        T_TIPO_DATA('158','03','Adecuaciones para el cumplimiento de habitabilidad según normativa'),
        T_TIPO_DATA('ACO','03','Acompañamiento'),
        T_TIPO_DATA('159','03','Requerimientos Otros'),
        T_TIPO_DATA('160','03','Rehabilitaciones'),
        T_TIPO_DATA('161','03','Requerimientos Derribos'),
        T_TIPO_DATA('162','03','Requerimientos Limpiezas') 
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
					WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          
          	DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE SUBTIPO TRABAJO CON CODIGO '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

            -- Si existe se modifica.
            DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

            V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'
                      SET DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0)
                    , DD_'||V_CHARS||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                    , DD_'||V_CHARS||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||'''
                    , USUARIOMODIFICAR = '''||V_USUARIO||''' 
                    , FECHAMODIFICAR = SYSDATE 
                    WHERE DD_'||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' / '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' MODIFICADO CORRECTAMENTE');

        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe en '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_'||V_CHARS||'_ID,
              DD_TTR_ID,
              DD_'||V_CHARS||'_CODIGO,
              DD_'||V_CHARS||'_DESCRIPCION,
              DD_'||V_CHARS||'_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_DD_'||V_CHARS||'_SUBTIPO_TRABAJO.NEXTVAL,
              (SELECT DD_TTR_ID FROM '|| V_ESQUEMA ||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              0,
              '''||V_USUARIO||''',
              SYSDATE,
              0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''  /  '''||TRIM(V_TMP_TIPO_DATA(2))||''' /  '''||TRIM(V_TMP_TIPO_DATA(3))||''' ');

        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;