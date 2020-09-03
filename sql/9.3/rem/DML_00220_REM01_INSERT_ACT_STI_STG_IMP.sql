--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200903
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10602
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-10602';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_STI_STG_IMP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    FILTER_DD_TIT  VARCHAR2(500 CHAR);
    FILTER_DD_CCA  VARCHAR2(500 CHAR);
    FILTER_MERGE1  VARCHAR2(500 CHAR);
    FILTER_MERGE2  VARCHAR2(500 CHAR);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01',NULL,NULL,'0'),
        T_TIPO_DATA('02',NULL,NULL,'0'),
        T_TIPO_DATA('03',NULL,NULL,'0'),
        T_TIPO_DATA('04',NULL,NULL,'0'),
        T_TIPO_DATA('05',NULL,NULL,'0'),
        T_TIPO_DATA('06',NULL,NULL,'0'),
        T_TIPO_DATA('07',NULL,NULL,'0'),
        T_TIPO_DATA('08',NULL,NULL,'0'),
        T_TIPO_DATA('09',NULL,NULL,'0'),
        T_TIPO_DATA('10',NULL,NULL,'0'),
        T_TIPO_DATA('11',NULL,NULL,'0'),
        T_TIPO_DATA('12',NULL,NULL,'0'),
        T_TIPO_DATA('13',NULL,NULL,'0'),
        T_TIPO_DATA('14',NULL,NULL,'0'),
        T_TIPO_DATA('15',NULL,NULL,'0'),
        T_TIPO_DATA('16',NULL,NULL,'0'),
        T_TIPO_DATA('17',NULL,NULL,'0'),
        T_TIPO_DATA('18',NULL,NULL,'0'),
        T_TIPO_DATA('19',NULL,NULL,'0'),
        T_TIPO_DATA('20',NULL,NULL,'0'),
        T_TIPO_DATA('21',NULL,NULL,'0'),
        T_TIPO_DATA('22',NULL,NULL,'0'),
        T_TIPO_DATA('23',NULL,NULL,'0'),
        T_TIPO_DATA('24',NULL,NULL,'0'),
        T_TIPO_DATA('25',NULL,NULL,'0'),
        T_TIPO_DATA('26',NULL,NULL,'0'),
        T_TIPO_DATA('27',NULL,NULL,'0'),
        T_TIPO_DATA('28',NULL,NULL,'0'),
        T_TIPO_DATA('29',NULL,NULL,'0'),
        T_TIPO_DATA('30','01',NULL,'21'),
        T_TIPO_DATA('30','03','05','7'),
        T_TIPO_DATA('30','04','18','4'),
        T_TIPO_DATA('30','04','19','4'),
        T_TIPO_DATA('31','01',NULL,'21'),
        T_TIPO_DATA('31','03','05','7'),
        T_TIPO_DATA('31','04','18','4'),
        T_TIPO_DATA('31','04','19','4'),
        T_TIPO_DATA('32','01',NULL,'21'),
        T_TIPO_DATA('32','03','05','7'),
        T_TIPO_DATA('32','04','18','4'),
        T_TIPO_DATA('32','04','19','4'),
        T_TIPO_DATA('33','01',NULL,'21'),
        T_TIPO_DATA('33','03','05','7'),
        T_TIPO_DATA('33','04','18','4'),
        T_TIPO_DATA('33','04','19','4'),
        T_TIPO_DATA('34','01',NULL,'21'),
        T_TIPO_DATA('34','03','05','7'),
        T_TIPO_DATA('34','04','18','4'),
        T_TIPO_DATA('34','04','19','4'),
        T_TIPO_DATA('35','01',NULL,'21'),
        T_TIPO_DATA('35','03','05','7'),
        T_TIPO_DATA('35','04','18','4'),
        T_TIPO_DATA('35','04','19','4'),
        T_TIPO_DATA('36','01',NULL,'21'),
        T_TIPO_DATA('36','01',NULL,'10'),
        T_TIPO_DATA('36','03','05','7'),
        T_TIPO_DATA('36','03','05','3'),
        T_TIPO_DATA('36','04','18','4'),
        T_TIPO_DATA('36','04','19','4'),
        T_TIPO_DATA('36','04','18','1'),
        T_TIPO_DATA('36','04','19','1'),
        T_TIPO_DATA('37','01',NULL,'21'),
        T_TIPO_DATA('37','03','05','7'),
        T_TIPO_DATA('37','04','18','4'),
        T_TIPO_DATA('37','04','19','4'),
        T_TIPO_DATA('38','01',NULL,'21'),
        T_TIPO_DATA('38','03','05','7'),
        T_TIPO_DATA('38','04','18','4'),
        T_TIPO_DATA('38','04','19','4'),
        T_TIPO_DATA('39',NULL,NULL,'0'),
        T_TIPO_DATA('40',NULL,NULL,'0'),
        T_TIPO_DATA('41',NULL,NULL,'0'),
        T_TIPO_DATA('42',NULL,NULL,'0'),
        T_TIPO_DATA('43','01',NULL,'21'),
        T_TIPO_DATA('43','03','05','7'),
        T_TIPO_DATA('43','04','18','4'),
        T_TIPO_DATA('43','04','19','4'),
        T_TIPO_DATA('44','01',NULL,'21'),
        T_TIPO_DATA('44','03','05','7'),
        T_TIPO_DATA('44','04','18','4'),
        T_TIPO_DATA('44','04','19','4'),
        T_TIPO_DATA('46','01',NULL,'21'),
        T_TIPO_DATA('46','03','05','7'),
        T_TIPO_DATA('46','04','18','4'),
        T_TIPO_DATA('46','04','19','4'),
        T_TIPO_DATA('47','01',NULL,'21'),
        T_TIPO_DATA('47','03','05','7'),
        T_TIPO_DATA('47','04','18','4'),
        T_TIPO_DATA('47','04','19','4'),
        T_TIPO_DATA('48','01',NULL,'21'),
        T_TIPO_DATA('48','03','05','7'),
        T_TIPO_DATA('48','04','18','4'),
        T_TIPO_DATA('48','04','19','4'),
        T_TIPO_DATA('49','01',NULL,'21'),
        T_TIPO_DATA('49','03','05','7'),
        T_TIPO_DATA('49','04','18','4'),
        T_TIPO_DATA('49','04','19','4'),
        T_TIPO_DATA('50','01',NULL,'21'),
        T_TIPO_DATA('50','03','05','7'),
        T_TIPO_DATA('50','04','18','4'),
        T_TIPO_DATA('50','04','19','4'),
        T_TIPO_DATA('51','01',NULL,'21'),
        T_TIPO_DATA('51','03','05','7'),
        T_TIPO_DATA('51','04','18','4'),
        T_TIPO_DATA('51','04','19','4'),
        T_TIPO_DATA('52','01',NULL,'21'),
        T_TIPO_DATA('52','03','05','7'),
        T_TIPO_DATA('52','04','18','4'),
        T_TIPO_DATA('52','04','19','4'),
        T_TIPO_DATA('53','01',NULL,'21'),
        T_TIPO_DATA('53','03','05','7'),
        T_TIPO_DATA('53','04','18','4'),
        T_TIPO_DATA('53','04','19','4'),
        T_TIPO_DATA('54','01',NULL,'21'),
        T_TIPO_DATA('54','03','05','7'),
        T_TIPO_DATA('54','04','18','4'),
        T_TIPO_DATA('54','04','19','4'),
        T_TIPO_DATA('55','01',NULL,'21'),
        T_TIPO_DATA('55','03','05','7'),
        T_TIPO_DATA('55','04','18','4'),
        T_TIPO_DATA('55','04','19','4'),
        T_TIPO_DATA('56','01',NULL,'21'),
        T_TIPO_DATA('56','03','05','7'),
        T_TIPO_DATA('56','04','18','4'),
        T_TIPO_DATA('56','04','19','4'),
        T_TIPO_DATA('57','01',NULL,'21'),
        T_TIPO_DATA('57','03','05','7'),
        T_TIPO_DATA('57','04','18','4'),
        T_TIPO_DATA('57','04','19','4'),
        T_TIPO_DATA('58','01',NULL,'21'),
        T_TIPO_DATA('58','03','05','7'),
        T_TIPO_DATA('58','04','18','4'),
        T_TIPO_DATA('58','04','19','4'),
        T_TIPO_DATA('59','01',NULL,'21'),
        T_TIPO_DATA('59','03','05','7'),
        T_TIPO_DATA('59','04','18','4'),
        T_TIPO_DATA('59','04','19','4'),
        T_TIPO_DATA('60','01',NULL,'21'),
        T_TIPO_DATA('60','03','05','7'),
        T_TIPO_DATA('60','04','18','4'),
        T_TIPO_DATA('60','04','19','4'),
        T_TIPO_DATA('61','01',NULL,'21'),
        T_TIPO_DATA('61','03','05','7'),
        T_TIPO_DATA('61','04','18','4'),
        T_TIPO_DATA('61','04','19','4'),
        T_TIPO_DATA('62','01',NULL,'21'),
        T_TIPO_DATA('62','03','05','7'),
        T_TIPO_DATA('62','04','18','4'),
        T_TIPO_DATA('62','04','19','4'),
        T_TIPO_DATA('63','01',NULL,'21'),
        T_TIPO_DATA('63','03','05','7'),
        T_TIPO_DATA('63','04','18','4'),
        T_TIPO_DATA('63','04','19','4'),
        T_TIPO_DATA('64','01',NULL,'21'),
        T_TIPO_DATA('64','03','05','7'),
        T_TIPO_DATA('64','04','18','4'),
        T_TIPO_DATA('64','04','19','4'),
        T_TIPO_DATA('65','01',NULL,'21'),
        T_TIPO_DATA('65','03','05','7'),
        T_TIPO_DATA('65','04','18','4'),
        T_TIPO_DATA('65','04','19','4'),
        T_TIPO_DATA('66','01',NULL,'21'),
        T_TIPO_DATA('66','03','05','7'),
        T_TIPO_DATA('66','04','18','4'),
        T_TIPO_DATA('66','04','19','4'),
        T_TIPO_DATA('67','01',NULL,'21'),
        T_TIPO_DATA('67','03','05','7'),
        T_TIPO_DATA('67','04','18','4'),
        T_TIPO_DATA('67','04','19','4'),
        T_TIPO_DATA('68','01',NULL,'21'),
        T_TIPO_DATA('68','03','05','7'),
        T_TIPO_DATA('68','04','18','4'),
        T_TIPO_DATA('68','04','19','4'),
        T_TIPO_DATA('69','01',NULL,'21'),
        T_TIPO_DATA('69','03','05','7'),
        T_TIPO_DATA('69','04','18','4'),
        T_TIPO_DATA('69','04','19','4'),
        T_TIPO_DATA('70','01',NULL,'21'),
        T_TIPO_DATA('70','03','05','7'),
        T_TIPO_DATA('70','04','18','4'),
        T_TIPO_DATA('70','04','19','4'),
        T_TIPO_DATA('71','01',NULL,'21'),
        T_TIPO_DATA('71','03','05','7'),
        T_TIPO_DATA('71','04','18','4'),
        T_TIPO_DATA('71','04','19','4'),
        T_TIPO_DATA('72','01',NULL,'21'),
        T_TIPO_DATA('72','03','05','7'),
        T_TIPO_DATA('72','04','18','4'),
        T_TIPO_DATA('72','04','19','4'),
        T_TIPO_DATA('73','01',NULL,'21'),
        T_TIPO_DATA('73','03','05','7'),
        T_TIPO_DATA('73','04','18','4'),
        T_TIPO_DATA('73','04','19','4'),
        T_TIPO_DATA('74','01',NULL,'21'),
        T_TIPO_DATA('74','03','05','7'),
        T_TIPO_DATA('74','04','18','4'),
        T_TIPO_DATA('74','04','19','4'),
        T_TIPO_DATA('75','01',NULL,'21'),
        T_TIPO_DATA('75','03','05','7'),
        T_TIPO_DATA('75','04','18','4'),
        T_TIPO_DATA('75','04','19','4'),
        T_TIPO_DATA('76','01',NULL,'21'),
        T_TIPO_DATA('76','03','05','7'),
        T_TIPO_DATA('76','04','18','4'),
        T_TIPO_DATA('76','04','19','4'),
        T_TIPO_DATA('77','01',NULL,'21'),
        T_TIPO_DATA('77','03','05','7'),
        T_TIPO_DATA('77','04','18','4'),
        T_TIPO_DATA('77','04','19','4'),
        T_TIPO_DATA('78','01',NULL,'21'),
        T_TIPO_DATA('78','03','05','7'),
        T_TIPO_DATA('78','04','18','4'),
        T_TIPO_DATA('78','04','19','4'),
        T_TIPO_DATA('79','01',NULL,'21'),
        T_TIPO_DATA('79','03','05','7'),
        T_TIPO_DATA('79','04','18','4'),
        T_TIPO_DATA('79','04','19','4'),
        T_TIPO_DATA('80','01',NULL,'21'),
        T_TIPO_DATA('80','03','05','7'),
        T_TIPO_DATA('80','04','18','4'),
        T_TIPO_DATA('80','04','19','4'),
        T_TIPO_DATA('81','01',NULL,'21'),
        T_TIPO_DATA('81','03','05','7'),
        T_TIPO_DATA('81','04','18','4'),
        T_TIPO_DATA('81','04','19','4'),
        T_TIPO_DATA('82','01',NULL,'21'),
        T_TIPO_DATA('82','03','05','7'),
        T_TIPO_DATA('82','04','18','4'),
        T_TIPO_DATA('82','04','19','4'),
        T_TIPO_DATA('83','01',NULL,'21'),
        T_TIPO_DATA('83','03','05','7'),
        T_TIPO_DATA('83','04','18','4'),
        T_TIPO_DATA('83','04','19','4'),
        T_TIPO_DATA('84','01',NULL,'21'),
        T_TIPO_DATA('84','03','05','7'),
        T_TIPO_DATA('84','04','18','4'),
        T_TIPO_DATA('84','04','19','4'),
        T_TIPO_DATA('85','01',NULL,'21'),
        T_TIPO_DATA('85','03','05','7'),
        T_TIPO_DATA('85','04','18','4'),
        T_TIPO_DATA('85','04','19','4'),
        T_TIPO_DATA('86','01',NULL,'21'),
        T_TIPO_DATA('86','03','05','7'),
        T_TIPO_DATA('86','04','18','4'),
        T_TIPO_DATA('86','04','19','4'),
        T_TIPO_DATA('87','01',NULL,'21'),
        T_TIPO_DATA('87','03','05','7'),
        T_TIPO_DATA('87','04','18','4'),
        T_TIPO_DATA('87','04','19','4'),
        T_TIPO_DATA('88','01',NULL,'21'),
        T_TIPO_DATA('88','03','05','7'),
        T_TIPO_DATA('88','04','18','4'),
        T_TIPO_DATA('88','04','19','4'),
        T_TIPO_DATA('89','01',NULL,'21'),
        T_TIPO_DATA('89','03','05','7'),
        T_TIPO_DATA('89','04','18','4'),
        T_TIPO_DATA('89','04','19','4'),
        T_TIPO_DATA('90',NULL,NULL,'0'),
        T_TIPO_DATA('91','01',NULL,'21'),
        T_TIPO_DATA('91','03','05','7'),
        T_TIPO_DATA('91','04','18','4'),
        T_TIPO_DATA('91','04','19','4'),
        T_TIPO_DATA('92',NULL,NULL,'0'),
        T_TIPO_DATA('93',NULL,NULL,'0'),
        T_TIPO_DATA('94','01',NULL,'21'),
        T_TIPO_DATA('94','03','05','7'),
        T_TIPO_DATA('94','04','18','4'),
        T_TIPO_DATA('94','04','19','4'),
        T_TIPO_DATA('95','01',NULL,'21'),
        T_TIPO_DATA('95','03','05','7'),
        T_TIPO_DATA('95','04','18','4'),
        T_TIPO_DATA('95','04','19','4'),
        T_TIPO_DATA('96','01',NULL,'21'),
        T_TIPO_DATA('96','03','05','7'),
        T_TIPO_DATA('96','04','18','4'),
        T_TIPO_DATA('96','04','19','4'),
        T_TIPO_DATA('97','01',NULL,'21'),
        T_TIPO_DATA('97','03','05','7'),
        T_TIPO_DATA('97','04','18','4'),
        T_TIPO_DATA('97','04','19','4'),
        T_TIPO_DATA('98',NULL,NULL,'0'),
        T_TIPO_DATA('99',NULL,NULL,'0'),
        T_TIPO_DATA('100',NULL,NULL,'0'),
        T_TIPO_DATA('101',NULL,NULL,'0'),
        T_TIPO_DATA('102',NULL,NULL,'0')
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
