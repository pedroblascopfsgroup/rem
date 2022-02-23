--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220223
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17169
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MON_TIPO_MONEDA los datos añadidos en T_ARRAY_DATA.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_MON_TIPO_MONEDA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'MON'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USUARIO VARCHAR2(2400 CHAR) := 'HREOS-17169'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('ADP','Peseta'),
      T_TIPO_DATA('AED','Dirham'),
      T_TIPO_DATA('AFA','Afgani'),
      T_TIPO_DATA('AFN','Afgani'),
      T_TIPO_DATA('ALL','Lek'),
      T_TIPO_DATA('AMD','Dram'),
      T_TIPO_DATA('ANG','Florines ant.'),
      T_TIPO_DATA('AOA','Kwanza'),
      T_TIPO_DATA('AON','Nuevo kwanza'),
      T_TIPO_DATA('AOR','Kwanza reajust.'),
      T_TIPO_DATA('ARS','Peso argentino'),
      T_TIPO_DATA('ATS','Chelín'),
      T_TIPO_DATA('AUD','Dólar austral.'),
      T_TIPO_DATA('AWG','Florín arubeño'),
      T_TIPO_DATA('AZM','Manat'),
      T_TIPO_DATA('AZN','Manat'),
      T_TIPO_DATA('BAM','Marco convert.'),
      T_TIPO_DATA('BBD','Dólar'),
      T_TIPO_DATA('BDT','Taka'),
      T_TIPO_DATA('BEF','Franco belga'),
      T_TIPO_DATA('BGN','Lev'),
      T_TIPO_DATA('BHD','Dinar'),
      T_TIPO_DATA('BIF','Franco burundés'),
      T_TIPO_DATA('BMD','Dólar Bermudas'),
      T_TIPO_DATA('BND','Dólar'),
      T_TIPO_DATA('BOB','Boliviano'),
      T_TIPO_DATA('BRL','Real'),
      T_TIPO_DATA('BSD','Dólar'),
      T_TIPO_DATA('BTN','Ngultrum'),
      T_TIPO_DATA('BWP','Pula'),
      T_TIPO_DATA('BYB','Rublo bielorr.'),
      T_TIPO_DATA('BYR','Rublo'),
      T_TIPO_DATA('BZD','Dólar'),
      T_TIPO_DATA('CAD','Dólar canad.'),
      T_TIPO_DATA('CDF','Franco'),
      T_TIPO_DATA('CFP','FRF (pacífico)'),
      T_TIPO_DATA('CHF','Franco suizo'),
      T_TIPO_DATA('CLP','Pesos'),
      T_TIPO_DATA('CNY','Yuan R.P.China'),
      T_TIPO_DATA('COP','Peso'),
      T_TIPO_DATA('CRC','Colón costarr.'),
      T_TIPO_DATA('CSD','Dinar serbio'),
      T_TIPO_DATA('CUC','Peso Convertib.'),
      T_TIPO_DATA('CUP','Peso cubano'),
      T_TIPO_DATA('CVE','Escudo'),
      T_TIPO_DATA('CYP','Libra chipriota'),
      T_TIPO_DATA('CZK','Corona'),
      T_TIPO_DATA('DEM','Marco alemán'),
      T_TIPO_DATA('DEM3','(Interno)DEM 3d'),
      T_TIPO_DATA('DJF','Franco Yibuti'),
      T_TIPO_DATA('DKK','Corona danesa'),
      T_TIPO_DATA('DOP','Peso dominicano'),
      T_TIPO_DATA('DZD','Dinar'),
      T_TIPO_DATA('ECS','Sucre'),
      T_TIPO_DATA('EEK','Corona'),
      T_TIPO_DATA('EGP','Libra'),
      T_TIPO_DATA('ERN','Nakfa'),
      T_TIPO_DATA('ESP','Peseta'),
      T_TIPO_DATA('ETB','Birr'),
      T_TIPO_DATA('EUR','Euro'),
      T_TIPO_DATA('FIM','Marco finlandés'),
      T_TIPO_DATA('FJD','Dólar'),
      T_TIPO_DATA('FKP','Libra Malvinas'),
      T_TIPO_DATA('FRF','Franco franc.'),
      T_TIPO_DATA('GBP','Libra'),
      T_TIPO_DATA('GEL','Lari'),
      T_TIPO_DATA('GHC','Cedi'),
      T_TIPO_DATA('GHS','Cedi'),
      T_TIPO_DATA('GIP','Libra Gibraltar'),
      T_TIPO_DATA('GMD','Dalasi'),
      T_TIPO_DATA('GNF','Franco'),
      T_TIPO_DATA('GRD','Dracma'),
      T_TIPO_DATA('GTQ','Quetzal'),
      T_TIPO_DATA('GWP','Peso guineano'),
      T_TIPO_DATA('GYD','Dólar guyanés'),
      T_TIPO_DATA('HKD','Dólar H.K.'),
      T_TIPO_DATA('HNL','Lempira'),
      T_TIPO_DATA('HRK','Kuna'),
      T_TIPO_DATA('HTG','Gourde'),
      T_TIPO_DATA('HUF','Forint'),
      T_TIPO_DATA('IDR','Rupia'),
      T_TIPO_DATA('IEP','Libra irlandesa'),
      T_TIPO_DATA('ILS','Shekel'),
      T_TIPO_DATA('INR','Rupia'),
      T_TIPO_DATA('IQD','Dinar'),
      T_TIPO_DATA('IRR','Rial'),
      T_TIPO_DATA('ISK','Corona'),
      T_TIPO_DATA('ITL','Lira'),
      T_TIPO_DATA('JMD','Dólar jamaicano'),
      T_TIPO_DATA('JOD','Dinar jordano'),
      T_TIPO_DATA('JPY','Yen'),
      T_TIPO_DATA('KES','Chelín'),
      T_TIPO_DATA('KGS','Som'),
      T_TIPO_DATA('KHR','Riel'),
      T_TIPO_DATA('KMF','Franco Comores'),
      T_TIPO_DATA('KPW','Won norcoreano'),
      T_TIPO_DATA('KRW','Won surcoreano'),
      T_TIPO_DATA('KWD','Dinar'),
      T_TIPO_DATA('KYD','Dólar Caimanes'),
      T_TIPO_DATA('KZT','Tenge'),
      T_TIPO_DATA('LAK','Kip'),
      T_TIPO_DATA('LBP','Libra libanesa'),
      T_TIPO_DATA('LKR','Rupia Sri Lanka'),
      T_TIPO_DATA('LRD','Dólar liberiano'),
      T_TIPO_DATA('LSL','Loti'),
      T_TIPO_DATA('LTL','Lita lituano'),
      T_TIPO_DATA('LUF','Francos luxemb.'),
      T_TIPO_DATA('LVL','Lat'),
      T_TIPO_DATA('LYD','Dinar libio'),
      T_TIPO_DATA('MAD','Dirham'),
      T_TIPO_DATA('MDL','Lei'),
      T_TIPO_DATA('MGA','Ariary malgache'),
      T_TIPO_DATA('MGF','Franco malgache'),
      T_TIPO_DATA('MKD','Dinar mac.'),
      T_TIPO_DATA('MMK','Kyat'),
      T_TIPO_DATA('MNT','Tugrik'),
      T_TIPO_DATA('MOP','Pataca'),
      T_TIPO_DATA('MRO','Ouguiya'),
      T_TIPO_DATA('MTL','Lira'),
      T_TIPO_DATA('MUR','Rupia'),
      T_TIPO_DATA('MVR','Rufiyaa'),
      T_TIPO_DATA('MWK','Kwacha malaw.'),
      T_TIPO_DATA('MXN','Pesos'),
      T_TIPO_DATA('MYR','Ringgit'),
      T_TIPO_DATA('MZM','Metical'),
      T_TIPO_DATA('MZN','Metical'),
      T_TIPO_DATA('NAD','Dolar namíbio'),
      T_TIPO_DATA('NGN','Naira'),
      T_TIPO_DATA('NIO','Cordoba Oro'),
      T_TIPO_DATA('NLG','Florín'),
      T_TIPO_DATA('NOK','Corona noruega'),
      T_TIPO_DATA('NPR','Rupia'),
      T_TIPO_DATA('NZD','Dólar neozel.'),
      T_TIPO_DATA('NZD5','Dólar neozel.'),
      T_TIPO_DATA('OMR','Rial omaní'),
      T_TIPO_DATA('PAB','Balboa'),
      T_TIPO_DATA('PEN','Nuevo Sol'),
      T_TIPO_DATA('PGK','Kina'),
      T_TIPO_DATA('PHP','Peso'),
      T_TIPO_DATA('PKR','Rupia'),
      T_TIPO_DATA('PLN','Zloty'),
      T_TIPO_DATA('PTE','Escudo'),
      T_TIPO_DATA('PYG','Guaraní'),
      T_TIPO_DATA('QAR','Riyal'),
      T_TIPO_DATA('RMB','RMB Yuan'),
      T_TIPO_DATA('ROL','Leu (antiguo)'),
      T_TIPO_DATA('RON','Leu'),
      T_TIPO_DATA('RSD','Dinar serbio'),
      T_TIPO_DATA('RUB','Rublo'),
      T_TIPO_DATA('RWF','Franco'),
      T_TIPO_DATA('SAR','Riyal'),
      T_TIPO_DATA('SBD','Rupia'),
      T_TIPO_DATA('SCR','Rupia'),
      T_TIPO_DATA('SDD','Dinar'),
      T_TIPO_DATA('SDG','Libra'),
      T_TIPO_DATA('SDP','Libra'),
      T_TIPO_DATA('SEK','Corona sueca'),
      T_TIPO_DATA('SGD','Dólar Singapur'),
      T_TIPO_DATA('SHP','Libra Sta.Elena'),
      T_TIPO_DATA('SIT','Tolar'),
      T_TIPO_DATA('SKK','Corona'),
      T_TIPO_DATA('SLL','Leone'),
      T_TIPO_DATA('SOS','Chelín'),
      T_TIPO_DATA('SRD','Dólar surinam.'),
      T_TIPO_DATA('SRG','Florín surinam.'),
      T_TIPO_DATA('SSP','Libra'),
      T_TIPO_DATA('STD','Dobra'),
      T_TIPO_DATA('SVC','Colón'),
      T_TIPO_DATA('SYP','Libra siria'),
      T_TIPO_DATA('SZL','Lilangeni'),
      T_TIPO_DATA('THB','Bhat'),
      T_TIPO_DATA('TJR','Rublo'),
      T_TIPO_DATA('TJS','Somoni'),
      T_TIPO_DATA('TMM','Manat (antiguo)'),
      T_TIPO_DATA('TMT','Manat'),
      T_TIPO_DATA('TND','Dinar'),
      T_TIPO_DATA('TOP','Pa''anga'),
      T_TIPO_DATA('TPE','Escudo de Timor'),
      T_TIPO_DATA('TRL','Lira (antigua)'),
      T_TIPO_DATA('TRY','Lira'),
      T_TIPO_DATA('TTD','Dólar T. y T.'),
      T_TIPO_DATA('TWD','Dólar'),
      T_TIPO_DATA('TZS','Chelín'),
      T_TIPO_DATA('UAH','Griwna'),
      T_TIPO_DATA('UGX','Chelín'),
      T_TIPO_DATA('USD','Dólar USA'),
      T_TIPO_DATA('USDN','Dólar USA'),
      T_TIPO_DATA('UYU','Peso'),
      T_TIPO_DATA('UZS','Sum'),
      T_TIPO_DATA('VEB','Bolívar (ant.)'),
      T_TIPO_DATA('VEF','Bolívar'),
      T_TIPO_DATA('VND','Dong'),
      T_TIPO_DATA('VUV','Vatu'),
      T_TIPO_DATA('WST','Tala'),
      T_TIPO_DATA('XAF','Franco CFA BEAC'),
      T_TIPO_DATA('XCD','Dólar'),
      T_TIPO_DATA('XDS','Dólar'),
      T_TIPO_DATA('XEU','ECU'),
      T_TIPO_DATA('XOF','Fr.CFA BCEAO'),
      T_TIPO_DATA('XPF','Franco'),
      T_TIPO_DATA('YER','Rial yemení'),
      T_TIPO_DATA('YUM','Dinar nuevo'),
      T_TIPO_DATA('ZAR','Margen'),
      T_TIPO_DATA('ZMK','Kwacha'),
      T_TIPO_DATA('ZMW','Kwacha'),
      T_TIPO_DATA('ZRN','Zaire'),
      T_TIPO_DATA('ZWD','Dólar Zimbabue'),
      T_TIPO_DATA('ZWL','Dól.Zimbabuense'),
      T_TIPO_DATA('ZWN','Dólar Zimbabue'),
      T_TIPO_DATA('ZWR','Dólar Zimbabue')
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
        
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' YA EXISTE');

       ELSE
       	-- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;
          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
          (DD_'||V_TEXT_CHARS||'_ID
          , DD_'||V_TEXT_CHARS||'_CODIGO
          , DD_'||V_TEXT_CHARS||'_DESCRIPCION
          , DD_'||V_TEXT_CHARS||'_DESCRIPCION_LARGA 
          , USUARIOCREAR
          , FECHACREAR) 
            SELECT '|| V_ID || '
            , '''||V_TMP_TIPO_DATA(1)||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , '''||TRIM(V_TMP_TIPO_DATA(2))||'''
            , '''||V_USUARIO||'''
            , SYSDATE
            FROM DUAL';
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
