--/*
--##########################################
--## AUTOR=Bruno Anlgés
--## FECHA_CREACION=20170717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2435
--## PRODUCTO=NO
--##
--## Finalidad: Asocia el nuevo registro en DD_CIP_CONDIC_IND_PRECIOS a todas las carteras.
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
    V_ITEM_LINK VARCHAR2(50 CHAR):= 'HREOS-2435';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CCP_CARTERA_CONDIC_PRECIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	-- 	Código CIP de la tabla 'DD_CIP_CONDIC_IND_PRECIOS'
        T_TIPO_DATA('50')

    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

        -- Se modifican los registros que coincidan con los códigos del array.
        DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR REGISTROS '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');

        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
            '(CCP_ID, DD_CRA_ID, DD_TPP_ID, DD_CIP_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)'||
            ' SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.nextval as cpp_id, DD_CRA_ID, TPP.DD_TPP_ID, CIP.DD_CIP_ID, 0, '''||V_ITEM_LINK||''', SYSDATE, 0'||
            ' from '||V_ESQUEMA||'.DD_CRA_CARTERA CRA JOIN '||V_ESQUEMA||'.DD_CIP_CONDIC_IND_PRECIOS CIP ON CIP.DD_CIP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''''||
            ' JOIN '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO TPP ON TPP.BORRADO = 0' ||
            ' where cra.borrado = 0 '||
            ' AND NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' WHERE DD_CRA_ID = CRA.DD_CRA_ID AND DD_CIP_ID = CIP.DD_CIP_ID AND DD_TPP_ID = TPP.DD_TPP_ID)';


        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS.');

      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');


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
