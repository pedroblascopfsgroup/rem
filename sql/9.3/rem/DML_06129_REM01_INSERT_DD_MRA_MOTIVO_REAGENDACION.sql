--/*
--##########################################
--## AUTOR= Alvaro Valero
--## FECHA_CREACION=202200927
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18745 
--## PRODUCTO=NO
--## Finalidad: Inserción diccionario DD_MRA_MOTIVO_REAGENDACION
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18745';
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MRA_MOTIVO_REAGENDACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CLAVE_DICCIONARIO VARCHAR2(25 CHAR):= 'MRA';

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('Por petición del inquilino (Problemas personales)','101'),
      T_TIPO_DATA('Desacuerdo con el modelo a firmar','111'),
      T_TIPO_DATA('Documentación no disponible','121'),
      T_TIPO_DATA('NIF no vigente', '131'),
      T_TIPO_DATA('Mora en el contrato anterior', '141'),
      T_TIPO_DATA('Revisión clausulado contrato', '151'),
      T_TIPO_DATA('Sin ingreso de las fianzas y/o garantías adicionales', '161')
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
					WHERE DD_'||V_CLAVE_DICCIONARIO||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
           V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET
                        DD_'||V_CLAVE_DICCIONARIO||'_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(1))||''',
                        DD_'||V_CLAVE_DICCIONARIO||'_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(1))||''',
          			        DD_'||V_CLAVE_DICCIONARIO||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
                        FECHAMODIFICAR = SYSDATE
                        WHERE DD_'||V_CLAVE_DICCIONARIO||'_CODIGO_C4C = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
                      EXECUTE IMMEDIATE V_MSQL;
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_'||V_CLAVE_DICCIONARIO||'_ID,
              DD_'||V_CLAVE_DICCIONARIO||'_CODIGO,
              DD_'||V_CLAVE_DICCIONARIO||'_DESCRIPCION,
              DD_'||V_CLAVE_DICCIONARIO||'_DESCRIPCION_LARGA,
			        DD_'||V_CLAVE_DICCIONARIO||'_CODIGO_C4C,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
			        '''||TRIM(V_TMP_TIPO_DATA(2))||''',
              0,
              '''||V_USUARIO||''',
              SYSDATE, 0)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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
