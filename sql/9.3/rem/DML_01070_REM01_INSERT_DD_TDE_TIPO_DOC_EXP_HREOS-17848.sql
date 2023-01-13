--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20220511
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17848
--## PRODUCTO=NO
--##
--## Finalidad: DML add valores al diccionario DD_TDE_TIPO_DOC_EXP
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REGISTROS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_TEXT_TABLA VARCHAR2(30):= 'DD_TDE_TIPO_DOC_EXP'; -- Vble. del nombre de la tabla
    V_TOF_ID NUMBER(16) := 0; -- Vble.auxiliar para sacar un ID.
    V_TOF_COD VARCHAR2(16 CHAR):= '01'; -- Vble.auxiliar para sacar un ID.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                --CODIGO    DESCRIPCION
	    T_TIPO_DATA('10',	'10.- Documentos de la persona', 'Documentos de la persona')

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
					WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe. Modificamos nombre');

          V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET DD_TDE_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              DD_TDE_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              USUARIOMODIFICAR = ''HREOS-17848'', FECHAMODIFICAR = SYSDATE
              WHERE DD_TDE_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_MSQL;
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

          V_SQL := 'SELECT DD_TOF_ID FROM '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA
					WHERE DD_TOF_CODIGO = '''||V_TOF_COD||''' AND BORRADO = 0';
          EXECUTE IMMEDIATE V_SQL INTO V_TOF_ID;

          IF V_TOF_ID != 0 THEN

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_TDE_ID,
              DD_TDE_CODIGO,
              DD_TDE_DESCRIPCION,
              DD_TDE_DESCRIPCION_LARGA,
              USUARIOCREAR,
              FECHACREAR,
              DD_TOF_ID
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              ''HREOS-17848'',SYSDATE, '||V_TOF_ID||')';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

          ELSE

            DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '||V_TOF_COD||' no existe en DD_TOF_TIPOS_OFERTA');

          END IF;

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
