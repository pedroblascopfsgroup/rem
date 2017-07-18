--/*
--##########################################
--## AUTOR=JORGE MARTIN
--## FECHA_CREACION=20170712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2294
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
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDE_SUBTIPO_DOC_EXP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'SDE'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      --				CODIGO		MATRICULA
      T_TIPO_DATA('29', 'OP-12-DOCI-01'),
      T_TIPO_DATA('30', 'OP-12-DOCI-07'),
      T_TIPO_DATA('31', 'OP-12-ESCR-15'),
      T_TIPO_DATA('23', 'OP-09-ACUI-21'),
      T_TIPO_DATA('22', 'OP-09-ACUI-22'),
      T_TIPO_DATA('08', 'OP-09-ACUI-26'),
      T_TIPO_DATA('06', 'OP-08-CNCV-73'),
      T_TIPO_DATA('12', 'OP-08-CERA-76'),
      T_TIPO_DATA('24', 'OP-08-CNCV-79'),
      T_TIPO_DATA('04', 'OP-10-ESIN-AP'),
      T_TIPO_DATA('13', 'OP-10-ACUI-24'),
      T_TIPO_DATA('32', 'OP-10-CERJ-89'),
      T_TIPO_DATA('05', 'OP-10-ACUI-25'),
      T_TIPO_DATA('26', 'OP-07-ESIN-AS'),
      T_TIPO_DATA('33', 'OP-07-ACUE-07'),
      T_TIPO_DATA('17', 'OP-07-CERA-74'),
      T_TIPO_DATA('15', 'OP-07-FICH-07'),
      T_TIPO_DATA('20', 'OP-07-CERA-75'),
      T_TIPO_DATA('19', 'OP-07-ESCR-36'),
      T_TIPO_DATA('27', 'OP-07-DECL-01'),
      T_TIPO_DATA('34', 'OP-07-COMU-77'),
      T_TIPO_DATA('28', 'OP-07-ESCR-43'),
      T_TIPO_DATA('35', 'OP-07-CNCV-80'),
      T_TIPO_DATA('25', 'OP-07-CNCV-04'),
      T_TIPO_DATA('18', 'OP-07-CERJ-43')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        --Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
          -- Si existe se modifica.
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
                    'SET DD_'||V_TEXT_CHARS||'_MATRICULA_GD = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', USUARIOMODIFICAR = ''HREOS-2294'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

       ELSE
       	-- Si no existe.
          DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el codigo');

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
