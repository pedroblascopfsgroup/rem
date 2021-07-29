--/*
--##########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20210729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14778
--## PRODUCTO=NO
--## Finalidad: Insert la tabla DD_ETF_ENTIDAD_FINANCIERA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE --
--## VERSIONES:
--##        0.1 Versión inicial --
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_ETF_ENTIDAD_FINANCIERA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      	T_TIPO_DATA('14','241','A&G Banca Privada, S.A.'),
		T_TIPO_DATA('15','2080','Abanca Corporacion Bancaria, S.A.'),
		T_TIPO_DATA('16','1535','AKF Bank GmbH & Co Kg, Sucursal en España'),
		T_TIPO_DATA('17','11','Allfunds Bank, S.A.'),
		T_TIPO_DATA('18','1544','Andbank España, S.A.'),
		T_TIPO_DATA('19','136','Aresbank, S.A.'),
		T_TIPO_DATA('20','3183','Arquia Bank, S.A.'),
		T_TIPO_DATA('21','1541','Attijariwafa Bank Europe, Sucursal en España'),
		T_TIPO_DATA('22','1554','Banca Farmafactoring SpA, Sucursal en España'),
		T_TIPO_DATA('23','61','Banca March, S.A.'),
		T_TIPO_DATA('24','1550','Banca Popolare Etica Società Cooperativa per Azioni, Sucursal en España'),
		T_TIPO_DATA('25','78','Banca Pueyo, S.A.'),
		T_TIPO_DATA('26','188','Banco Alcalá, S.A.'),
		T_TIPO_DATA('27','182','Banco Bilbao Vizcaya Argentaria, S.A.'),
		T_TIPO_DATA('28','234','Banco Caminos, S.A.'),
		T_TIPO_DATA('29','225','Banco Cetelem, S.A.'),
		T_TIPO_DATA('30','198','Banco Cooperativo Español, S.A.'),
		T_TIPO_DATA('31','91','Banco de Albacete, S.A.'),
		T_TIPO_DATA('32','240','Banco de Crédito Social Cooperativo'),
		T_TIPO_DATA('33','3','Banco de Depósitos, S.A.'),
		T_TIPO_DATA('34','9000','Banco de España'),
		T_TIPO_DATA('35','1569','Banco de Investimento Global SA, Sucursal en España'),
		T_TIPO_DATA('36','169','Banco de la Nación Argentina, Sucursal en España'),
		T_TIPO_DATA('37','81','Banco de Sabadell, S.A.'),
		T_TIPO_DATA('38','184','Banco Europeo de Finanzas, S.A.'),
		T_TIPO_DATA('39','220','Banco Finantia Spain, S.A.'),
		T_TIPO_DATA('40','113','Banco Industrial de Bilbao, S.A.'),
		T_TIPO_DATA('41','232','Banco Inversis, S.A.'),
		T_TIPO_DATA('42','186','Banco Mediolanum, S.A.'),
		T_TIPO_DATA('43','121','Banco Occidental, S.A.'),
		T_TIPO_DATA('44','235','Banco Pichincha España, S.A..'),
		T_TIPO_DATA('45','1509','Banco Primus, S.A., Sucursal en España'),
		T_TIPO_DATA('46','49','Banco Santander, S.A.'),
		T_TIPO_DATA('47','125','Bancofar, S.A.'),
		T_TIPO_DATA('48','200','Bank Degroof Petercam Spain, S.A.'),
		T_TIPO_DATA('49','1574','Bank Julius Baer Europe, S.A, Sucursal en España'),
		T_TIPO_DATA('50','1485','Bank of America Europe DAC, Sucursal en España'),
		T_TIPO_DATA('51','128','Bankinter, S.A.'),
		T_TIPO_DATA('52','138','Bankoa, S.A.'),
		T_TIPO_DATA('53','1525','Banque Chaabi du Maroc, Sucursal en España'),
		T_TIPO_DATA('54','152','Barclays Bank Ireland PLC, Sucursal en España'),
		T_TIPO_DATA('55','1521','Binckbank NV, Sucursal en España'),
		T_TIPO_DATA('56','219','BMCE Bank International, S.A.'),
		T_TIPO_DATA('57','1533','BMW Bank GmbH, Sucursal en España'),
		T_TIPO_DATA('58','167','BNP Paribas Fortis, S.A., N.V., Sucursal en España'),
		T_TIPO_DATA('59','1492','BNP Paribas Lease Group S.A. Sucursal en España'),
		T_TIPO_DATA('60','149','BNP Paribas S.A., Sucursal en España'),
		T_TIPO_DATA('61','144','BNP Paribas Securities Services, Sucursal en España'),
		T_TIPO_DATA('62','1500','BPCE Lease, Sucursal en España'),
		T_TIPO_DATA('63','1545','CA Indosuez Wealth (Europe), Sucursal en España'),
		T_TIPO_DATA('64','38','CACEIS Bank Spain, S.A.'),
		T_TIPO_DATA('65','1451','Caisse Régionale de Crédit Agricole Mutuel Sud-Méditerranée (Ariège et Pyrénées-Orientales)'),
		T_TIPO_DATA('66','1493','Caixa Banco de Investimento, S.A. Sucursal en España'),
		T_TIPO_DATA('67','3025','Caixa de Crédit dels Enginyers- Caja de Crédito de los Ingenieros, S. Coop. de Crédito'),
		T_TIPO_DATA('68','3159','Caixa Popular-Caixa Rural, S. Coop. de Crédito V.'),
		T_TIPO_DATA('69','3045','Caixa Rural Altea, Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('70','3162','Caixa Rural Benicarló, S. Coop. de Credit V.'),
		T_TIPO_DATA('71','3117','Caixa Rural D''''Algemesí, S. Coop. V. de Crédit'),
		T_TIPO_DATA('72','3105','Caixa Rural de Callosa d''''en Sarrià, Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('73','3096','Caixa Rural de L''''Alcudia, Sociedad Cooperativa Valenciana de Crédito'),
		T_TIPO_DATA('74','3123','Caixa Rural de Turís, Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('75','3070','Caixa Rural Galega, Sociedad Cooperativa de Crédito Limitada Gallega'),
		T_TIPO_DATA('76','3111','Caixa Rural La Vall ''''San Isidro'''', Sociedad Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('77','3166','Caixa Rural Les Coves de Vinromá, S. Coop. de Crédit V.'),
		T_TIPO_DATA('78','3160','Caixa Rural Sant Josep de Vilavella, S. Coop. de Crédito V.'),
		T_TIPO_DATA('79','3102','Caixa Rural Sant Vicent Ferrer de La Vall D''''Uixó, Coop. de Credit V.'),
		T_TIPO_DATA('80','3118','Caixa Rural Torrent Cooperativa de Credit Valenciana'),
		T_TIPO_DATA('81','3174','Caixa Rural Vinarós, S. Coop. de Credit. V.'),
		T_TIPO_DATA('82','2100','Caixabank, S.A.'),
		T_TIPO_DATA('83','2045','Caja de Ahorros y Monte de Piedad de Ontinyent'),
		T_TIPO_DATA('84','3029','Caja de Crédito de Petrel, Caja Rural, Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('85','3035','Caja Laboral Popular Coop. de Crédito'),
		T_TIPO_DATA('86','3115','Caja Rural ''''Nuestra Madre del Sol'''', S. Coop. Andaluza de Crédito'),
		T_TIPO_DATA('87','3110','Caja Rural Católico Agraria, S. Coop. de Crédito V.'),
		T_TIPO_DATA('88','3005','Caja Rural Central, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('89','3190','Caja Rural de Albacete, Ciudad Real y Cuenca, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('90','3150','Caja Rural de Albal, Coop. de Crédito V.'),
		T_TIPO_DATA('91','3179','Caja Rural de Alginet, Sociedad Cooperativa Crédito Valenciana'),
		T_TIPO_DATA('92','3001','Caja Rural de Almendralejo, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('93','3191','Caja Rural de Aragón, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('94','3059','Caja Rural de Asturias, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('95','3089','Caja Rural de Baena Ntra. Sra. de Guadalupe Sociedad Cooperativa de Crédito Andaluza'),
		T_TIPO_DATA('96','3060','Caja Rural de Burgos, Fuentepelayo, Segovia y Castelldans, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('97','3104','Caja Rural de Cañete de Las Torres Ntra. Sra. del Campo Sociedad Cooperativa Andaluza de Crédito'),
		T_TIPO_DATA('98','3127','Caja Rural de Casas Ibáñez, S. Coop. de Crédito de Castilla-La Mancha'),
		T_TIPO_DATA('99','3121','Caja Rural de Cheste, Sociedad Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('100','3009','Caja Rural de Extremadura, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('101','3007','Caja Rural de Gijón, Sociedad Cooperativa Asturiana de Crédito'),
		T_TIPO_DATA('102','3023','Caja Rural de Granada, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('103','3140','Caja Rural de Guissona, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('104','3067','Caja Rural de Jaén, Barcelona y Madrid, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('105','3008','Caja Rural de Navarra, S. Coop. de Crédito'),
		T_TIPO_DATA('106','3098','Caja Rural de Nueva Carteya, Sociedad Cooperativa Andaluza de Crédito'),
		T_TIPO_DATA('107','3016','Caja Rural de Salamanca, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('108','3017','Caja Rural de Soria, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('109','3080','Caja Rural de Teruel, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('110','3020','Caja Rural de Utrera, Sociedad Cooperativa Andaluza de Crédito'),
		T_TIPO_DATA('111','3144','Caja Rural de Villamalea, S. Coop. de Crédito Agrario de Castilla-La Mancha'),
		T_TIPO_DATA('112','3152','Caja Rural de Villar, Coop. de Crédito V.'),
		T_TIPO_DATA('113','3085','Caja Rural de Zamora, Cooperativa de Crédito'),
		T_TIPO_DATA('114','3187','Caja Rural del Sur, S. Coop. de Crédito'),
		T_TIPO_DATA('115','3157','Caja Rural La Junquera de Chilches, S. Coop. de Crédito V.'),
		T_TIPO_DATA('116','3134','Caja Rural Nuestra Señora de la Esperanza de Onda, S. Coop. de Crédito V.'),
		T_TIPO_DATA('117','3018','Caja Rural Regional San Agustín Fuente Álamo Murcia, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('118','3165','Caja Rural San Isidro de Vilafames S. Coop. de Crédito V.'),
		T_TIPO_DATA('119','3119','Caja Rural San Jaime de Alquerías Niño Perdido S. Coop. de Crédito V.'),
		T_TIPO_DATA('120','3113','Caja Rural San José de Alcora S. Coop. de Crédito V.'),
		T_TIPO_DATA('121','3130','Caja Rural San José de Almassora, S. Coop. de Crédito V.'),
		T_TIPO_DATA('122','3112','Caja Rural San José de Burriana, S. Coop. de Crédito V.'),
		T_TIPO_DATA('123','3135','Caja Rural San José de Nules S. Coop. de Crédito V.'),
		T_TIPO_DATA('124','3095','Caja Rural San Roque de Almenara S. Coop. de Crédito V.'),
		T_TIPO_DATA('125','3058','Cajamar Caja Rural, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('126','3076','Cajasiete, Caja Rural, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('127','237','Cajasur Banco, S.A.'),
		T_TIPO_DATA('128','2000','Cecabank, S.A.'),
		T_TIPO_DATA('129','1553','China Construction Bank (Europe), S.A., Sucursal en España'),
		T_TIPO_DATA('130','1474','Citibank Europe Plc, Sucursal en España'),
		T_TIPO_DATA('131','1499','Claas Financial Services, S.A.S., Sucursal en España'),
		T_TIPO_DATA('132','1546','CNH Industrial Capital Europe, S.A.S., Sucursal en España'),
		T_TIPO_DATA('133','1514','CNH Industrial Financial Services, Sucursal en España'),
		T_TIPO_DATA('134','1543','Cofidis, S.A. Sucursal en España'),
		T_TIPO_DATA('135','2056','Colonya - Caixa D''''estalvis de Pollensa'),
		T_TIPO_DATA('136','159','Commerzbank Aktiengesellschaft, Sucursal en España'),
		T_TIPO_DATA('137','1459','Cooperatieve Rabobank U.A., Sucursal en España'),
		T_TIPO_DATA('138','154','Crédit Agricole Corporate and Investment Bank, Sucursal en España'),
		T_TIPO_DATA('139','1472','Crédit Agricole Leasing & Factoring, Sucursal en España'),
		T_TIPO_DATA('140','1555','Crédit Mutuel Leasing, Sucursal en España'),
		T_TIPO_DATA('141','1460','Crédit Suisse Ag, Sucursal en España'),
		T_TIPO_DATA('142','1457','De Lage Landen International B.V., Sucursal en España'),
		T_TIPO_DATA('143','1548','Dell Bank International Designated Activity Company, Sucursal en España'),
		T_TIPO_DATA('144','145','Deutsche Bank, A.G., Sucursal en España'),
		T_TIPO_DATA('145','19','Deutsche Bank, Sociedad Anónima Española'),
		T_TIPO_DATA('146','1501','Deutsche Pfandbriefbank AG, Sucursal en España'),
		T_TIPO_DATA('147','211','EBN Banco de Negocios, S.A.'),
		T_TIPO_DATA('148','1473','Edmond de Rothschild (Europe), Sucursal en España'),
		T_TIPO_DATA('149','1512','Elavon Financial Services Designated Activity Company, Sucursal en España'),
		T_TIPO_DATA('150','3081','Eurocaja Rural, Sociedad Cooperativa de Crédito'),
		T_TIPO_DATA('151','239','Evo Banco S.A.'),
		T_TIPO_DATA('152','218','FCE Bank Plc Sucursal en España'),
		T_TIPO_DATA('153','1496','Genefim, Sucursal en España'),
		T_TIPO_DATA('154','1564','Goldman Sachs Bank Europe SE, Sucursal en España'),
		T_TIPO_DATA('155','1497','Haitong Bank, S.A., Sucursal en España'),
		T_TIPO_DATA('156','1504','Honda Bank GmbH, Sucursal en España'),
		T_TIPO_DATA('157','162','HSBC Continental Europe, Sucursal en España'),
		T_TIPO_DATA('158','2085','Ibercaja Banco, S.A.'),
		T_TIPO_DATA('159','1538','Industrial and Commercial Bank of China (Europe) S.A., Sucursal en España'),
		T_TIPO_DATA('160','1465','Ing Bank, N.V. Sucursal en España'),
		T_TIPO_DATA('161','1000','Instituto de Crédito Oficial'),
		T_TIPO_DATA('162','1494','Intesa Sanpaolo S.p.A., Sucursal en España'),
		T_TIPO_DATA('163','1567','J.P. Morgan AG, Sucursal en España'),
		T_TIPO_DATA('164','1516','J.P. Morgan Bank Luxembourg S.A., Sucursal en España'),
		T_TIPO_DATA('165','1482','John Deere Bank, S.A., Sucursal en España'),
		T_TIPO_DATA('166','151','JPMorgan Chase Bank National Association, Sucursal en España'),
		T_TIPO_DATA('167','2095','Kutxabank, S.A'),
		T_TIPO_DATA('168','2048','Liberbank, S.A.'),
		T_TIPO_DATA('169','1547','Lombard Odier (Europe), S.A., Sucursal en España'),
		T_TIPO_DATA('170','1520','Mediobanca, Sucursal en España'),
		T_TIPO_DATA('171','1523','Mercedes-Benz Bank AG, Sucursal en España'),
		T_TIPO_DATA('172','1552','Mirabaud & Cie (Europe) S.A., Sucursal en España'),
		T_TIPO_DATA('173','1559','Mizuho Bank Europe N.V., Sucursal en España'),
		T_TIPO_DATA('174','160','MUFG Bank (Europe) N.V., Sucursal en España'),
		T_TIPO_DATA('175','1563','N26 Bank GmbH, Sucursal en España'),
		T_TIPO_DATA('176','1479','Natixis, S.A., Sucursal en España'),
		T_TIPO_DATA('177','1566','Natwest Markets N.V., Sucursal en España'),
		T_TIPO_DATA('178','131','Novo Banco, S.A., Sucursal en España'),
		T_TIPO_DATA('179','133','Nuevo Micro Bank, S.A.'),
		T_TIPO_DATA('180','1565','Opel Bank, S.A., Sucursal en España'),
		T_TIPO_DATA('181','73','Open Bank, S.A.'),
		T_TIPO_DATA('182','1568','Orange Bank, S.A., Sucursal en España'),
		T_TIPO_DATA('183','1488','Pictet & Cie (Europe), S.A., Sucursal en España'),
		T_TIPO_DATA('184','1534','Quintet Private Bank (Europe), S.A., Sucursal en España'),
		T_TIPO_DATA('185','1508','RCI Banque, S.A., Sucursal en España'),
		T_TIPO_DATA('186','83','Renta 4 Banco, S.A.'),
		T_TIPO_DATA('187','3138','Ruralnostra, Sociedad Cooperativa de Crédito Valenciana'),
		T_TIPO_DATA('188','242','Sabadell Consumer Finance, S.A.'),
		T_TIPO_DATA('189','224','Santander Consumer Finance, S.A.'),
		T_TIPO_DATA('190','36','Santander Investment, S.A.'),
		T_TIPO_DATA('191','1490','Singular Bank, S.A.'),
		T_TIPO_DATA('192','1551','SMBC Bank EU AG, Sucursal en España'),
		T_TIPO_DATA('193','108','Société Genérale, Sucursal en España'),
		T_TIPO_DATA('194','1572','Stifel Europe Bank, A.G, Sucursal en España'),
		T_TIPO_DATA('195','216','Targobank, S.A.'),
		T_TIPO_DATA('196','1573','The Bank of New York Mellon SA/SV, S.E'),
		T_TIPO_DATA('197','1570','The Governor and Company of the Bank of Ireland, Sucursal en España'),
		T_TIPO_DATA('198','1487','Toyota Kreditbank GmbH, Sucursal en España'),
		T_TIPO_DATA('199','1491','Triodos Bank, N.V., S.E.'),
		T_TIPO_DATA('200','226','UBS Europe SE, Sucursal en España'),
		T_TIPO_DATA('201','2103','Unicaja Banco, S.A.'),
		T_TIPO_DATA('202','1557','Unicredit, S.p.A., Sucursal en España'),
		T_TIPO_DATA('203','1480','Volkswagen Bank GmbH, Sucursal en España'),
		T_TIPO_DATA('204','1575','Western Union International Bank GMBH, Sucursal en España'),
		T_TIPO_DATA('205','229','WIZINK BANK, S.A..'),
		T_TIPO_DATA('206','1560','Younited, Sucursal en España'),
		T_TIPO_DATA('207','1','Otros + Tex')

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
					WHERE DD_ETF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' no existe');

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              DD_ETF_ID,
              DD_ETF_CODIGO,
              DD_ETF_DESCRIPCION,
              DD_ETF_DESCRIPCION_LARGA,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO,
			  DD_ETF_CODIGO_CAIXA
              ) VALUES (
               '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              '''||TRIM(V_TMP_TIPO_DATA(1))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              '''||TRIM(V_TMP_TIPO_DATA(3))||''',
              0,
              ''HREOS-14778'',
              SYSDATE, 0,
			  '''||TRIM(V_TMP_TIPO_DATA(2))||''')';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||'''');

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
