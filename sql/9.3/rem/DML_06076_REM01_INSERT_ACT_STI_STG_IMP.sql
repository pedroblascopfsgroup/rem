--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220224
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17107
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_STI_STG_IMP los datos añadidos en T_ARRAY_DATA
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
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-17107';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_STI_STG_IMP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    FILTER_DD_TIT  VARCHAR2(500 CHAR);
    FILTER_DD_CCA  VARCHAR2(500 CHAR);
    FILTER_MERGE1  VARCHAR2(500 CHAR);
    FILTER_MERGE2  VARCHAR2(500 CHAR);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('185','01',NULL,'21'),
        T_TIPO_DATA('185','03','05','7'),
        T_TIPO_DATA('185','04','18','4'),
        T_TIPO_DATA('185','04','19','4'),
        T_TIPO_DATA('194','01',NULL,'21'),
        T_TIPO_DATA('194','03','05','7'),
        T_TIPO_DATA('194','04','18','4'),
        T_TIPO_DATA('194','04','19','4')
        ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN   

  -- LOOP para insertar los valores -----------------------------------------------------------------
  DBMS_OUTPUT.PUT_LINE('[START]: INSERCION EN '||V_TEXT_TABLA||' ');
  FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP
    
      V_TMP_TIPO_DATA := V_TIPO_DATA(I);

      V_MSQL := NULL;

    IF V_TMP_TIPO_DATA(4) IS NULL THEN 
        DBMS_OUTPUT.PUT_LINE('  [INFO]: El registro '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||''' no es válido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO]: Insertamos el registro (DD_STG_CODIGO, DD_TIT_CODIGO, DD_CCA_CODIGO, TIPO_IMPOSITIVO):
             '''||TRIM(V_TMP_TIPO_DATA(1))||''', '''||TRIM(V_TMP_TIPO_DATA(2))||''', '''||TRIM(V_TMP_TIPO_DATA(3))||''', '''||TRIM(V_TMP_TIPO_DATA(4))||'''');   

        IF V_TMP_TIPO_DATA(2) IS NOT NULL AND V_TMP_TIPO_DATA(3) IS NOT NULL THEN
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, DD_CCA_ID, STI_TIPO_IMPOSITIVO, USUARIOCREAR, FECHACREAR)
                SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                    , STG.DD_STG_ID
                    , TIT.DD_TIT_ID
                    , CCA.DD_CCA_ID
                    , '||V_TMP_TIPO_DATA(4)||' STI_TIPO_IMPOSITIVO
                    , '''||V_ITEM||'''
                    , CURRENT_TIMESTAMP(6)
                FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
                LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''
                LEFT JOIN '||V_ESQUEMA_M||'.DD_CCA_COMUNIDAD CCA ON CCA.DD_CCA_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''
                LEFT JOIN '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' STI ON STI.DD_STG_ID = STG.DD_STG_ID 
                    AND STI.DD_TIT_ID = TIT.DD_TIT_ID
                    AND STI.DD_CCA_ID = CCA.DD_CCA_ID
                    AND STI.STI_TIPO_IMPOSITIVO = '||V_TMP_TIPO_DATA(4)||'
                WHERE STG.DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
                    AND STI.STI_ID IS NULL';
        ELSIF V_TMP_TIPO_DATA(2) IS NULL AND V_TMP_TIPO_DATA(3) IS NULL THEN
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, STI_TIPO_IMPOSITIVO, USUARIOCREAR, FECHACREAR)
                SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                    , STG.DD_STG_ID
                    , '||V_TMP_TIPO_DATA(4)||' STI_TIPO_IMPOSITIVO
                    , '''||V_ITEM||'''
                    , CURRENT_TIMESTAMP(6)
                FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
                LEFT JOIN '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' STI ON STI.DD_STG_ID = STG.DD_STG_ID 
                    AND STI.DD_TIT_ID IS NULL
                    AND STI.DD_CCA_ID IS NULL
                    AND STI.STI_TIPO_IMPOSITIVO = '||V_TMP_TIPO_DATA(4)||'
                WHERE STG.DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
                    AND STI.STI_ID IS NULL';
        ELSIF V_TMP_TIPO_DATA(2) IS NOT NULL AND V_TMP_TIPO_DATA(3) IS NULL THEN
            V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' (STI_ID, DD_STG_ID, DD_TIT_ID, STI_TIPO_IMPOSITIVO, USUARIOCREAR, FECHACREAR)
                SELECT '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'.NEXTVAL
                    , STG.DD_STG_ID
                    , TIT.DD_TIT_ID
                    , '||V_TMP_TIPO_DATA(4)||' STI_TIPO_IMPOSITIVO
                    , '''||V_ITEM||'''
                    , CURRENT_TIMESTAMP(6)
                FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG
                LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT ON TIT.DD_TIT_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''
                LEFT JOIN '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' STI ON STI.DD_STG_ID = STG.DD_STG_ID 
                    AND STI.DD_TIT_ID = TIT.DD_TIT_ID
                    AND STI.DD_CCA_ID IS NULL
                    AND STI.STI_TIPO_IMPOSITIVO = '||V_TMP_TIPO_DATA(4)||'
                WHERE STG.DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''
                    AND STI.STI_ID IS NULL';
        END IF;
        
        --DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO]: '||SQL%ROWCOUNT||' REGISTRO/S INSERTADO/S CORRECTAMENTE');
      END IF;
    END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]');
   

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
