--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16362
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_RBC_TIT_STOCK_DATES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('29/11/21'),
      T_TIPO_DATA('30/12/21'),
      T_TIPO_DATA('28/01/22'),
      T_TIPO_DATA('25/02/22'),
      T_TIPO_DATA('30/03/22'),
      T_TIPO_DATA('28/04/22'),
      T_TIPO_DATA('30/05/22'),
      T_TIPO_DATA('29/06/22'),
      T_TIPO_DATA('28/07/22'),
      T_TIPO_DATA('30/08/22'),
      T_TIPO_DATA('29/09/22'),
      T_TIPO_DATA('28/10/22')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO DEL ACTIVO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
                    SELECT TO_DATE('''||TRIM(V_TMP_TIPO_DATA(1))||''',''dd/mm/yy'') FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          COMMIT;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');

      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' INSERTADO CORRECTAMENTE ');


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
