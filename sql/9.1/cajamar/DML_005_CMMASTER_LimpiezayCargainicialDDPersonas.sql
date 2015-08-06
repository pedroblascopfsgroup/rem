--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150724
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-436
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de datos de Diccionarios Personas Cajamar , esquema CMMASTER.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

  
   TYPE T_TIPO_NACIONALIDAD IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_NACIONALIDAD IS TABLE OF T_TIPO_NACIONALIDAD;
   
   TYPE T_TIPO_SEX IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_SEX IS TABLE OF T_TIPO_SEX;
   
   
 	
	
  -- Configuracion Esquemas
   V_ESQUEMA VARCHAR(25) := 'CM01';
   V_ESQUEMA_M VARCHAR(25) := 'CMMASTER';
   V_TipoContrado VARCHAR(50) := 'BNKContrato';

   V_USUARIO_CREAR VARCHAR2(10) := 'INICIAL';
   



	
	 V_TIPO_NACIONALIDAD T_ARRAY_NACIONALIDAD := T_ARRAY_NACIONALIDAD(
											T_TIPO_NACIONALIDAD('1','FRANCIA','FRANCIA'),
											T_TIPO_NACIONALIDAD('2','BELGICA','BELGICA'),
											T_TIPO_NACIONALIDAD('3','PAISES BAJOS','PAISES BAJOS'),
											T_TIPO_NACIONALIDAD('4','ALEMANIA','ALEMANIA'),
											T_TIPO_NACIONALIDAD('5','ITALIA','ITALIA'),
											T_TIPO_NACIONALIDAD('6','REINO UNIDO ','REINO UNIDO '),
											T_TIPO_NACIONALIDAD('7','IRLANDA ','IRLANDA '),
											T_TIPO_NACIONALIDAD('8','DINAMARCA','DINAMARCA'),
											T_TIPO_NACIONALIDAD('9','GRECIA','GRECIA'),
											T_TIPO_NACIONALIDAD('10','PORTUGAL','PORTUGAL'),
											T_TIPO_NACIONALIDAD('11','ESPAÑA','ESPAÑA'),
											T_TIPO_NACIONALIDAD('17','BELGICA ','BELGICA '),
											T_TIPO_NACIONALIDAD('18','LUXEMBURGO  ','LUXEMBURGO  '),
											T_TIPO_NACIONALIDAD('24','ISLANDIA','ISLANDIA'),
											T_TIPO_NACIONALIDAD('27','SVALBARD Y JAN MAYEN','SVALBARD Y JAN MAYEN'),
											T_TIPO_NACIONALIDAD('28','NORUEGA ','NORUEGA '),
											T_TIPO_NACIONALIDAD('30','SUECIA','SUECIA'),
											T_TIPO_NACIONALIDAD('32','FINLANDIA','FINLANDIA'),
											T_TIPO_NACIONALIDAD('36','SUIZA ','SUIZA '),
											T_TIPO_NACIONALIDAD('37','LIECHTENSTEIN','LIECHTENSTEIN'),
											T_TIPO_NACIONALIDAD('38','AUSTRIA ','AUSTRIA '),
											T_TIPO_NACIONALIDAD('39','SUIZA ','SUIZA '),
											T_TIPO_NACIONALIDAD('41','FEROE, ISLAS','FEROE, ISLAS'),
											T_TIPO_NACIONALIDAD('43','ANDORRA ','ANDORRA '),
											T_TIPO_NACIONALIDAD('44','GIBRALTAR','GIBRALTAR'),
											T_TIPO_NACIONALIDAD('45','VATICANO, CIUDAD DEL','VATICANO, CIUDAD DEL'),
											T_TIPO_NACIONALIDAD('46','MALTA ','MALTA '),
											T_TIPO_NACIONALIDAD('47','SAN MARINO  ','SAN MARINO  '),
											T_TIPO_NACIONALIDAD('52','TURQUIA ','TURQUIA '),
											T_TIPO_NACIONALIDAD('53','ESTONIA ','ESTONIA '),
											T_TIPO_NACIONALIDAD('54','LETONIA ','LETONIA '),
											T_TIPO_NACIONALIDAD('55','LITUANIA','LITUANIA'),
											T_TIPO_NACIONALIDAD('60','POLONIA ','POLONIA '),
											T_TIPO_NACIONALIDAD('61','CHECA, REPUBLICA','CHECA, REPUBLICA'),
											T_TIPO_NACIONALIDAD('63','ESLOVAQUIA  ','ESLOVAQUIA  '),
											T_TIPO_NACIONALIDAD('64','HUNGRIA ','HUNGRIA '),
											T_TIPO_NACIONALIDAD('66','RUMANIA ','RUMANIA '),
											T_TIPO_NACIONALIDAD('68','BULGARIA','BULGARIA'),
											T_TIPO_NACIONALIDAD('70','ALBANIA ','ALBANIA '),
											T_TIPO_NACIONALIDAD('72','UCRANIA ','UCRANIA '),
											T_TIPO_NACIONALIDAD('73','BIELORRUSIA (BELARÚS)','BIELORRUSIA (BELARÚS)'),
											T_TIPO_NACIONALIDAD('74','MOLDAVIA','MOLDAVIA'),
											T_TIPO_NACIONALIDAD('75','RUSIA ','RUSIA '),
											T_TIPO_NACIONALIDAD('76','GEORGIA ','GEORGIA '),
											T_TIPO_NACIONALIDAD('77','ARMENIA ','ARMENIA '),
											T_TIPO_NACIONALIDAD('78','AZERBAIYAN  ','AZERBAIYAN  '),
											T_TIPO_NACIONALIDAD('79','KAZAJISTAN  ','KAZAJISTAN  '),
											T_TIPO_NACIONALIDAD('80','TURKMENISTAN','TURKMENISTAN'),
											T_TIPO_NACIONALIDAD('81','UZBEKISTAN  ','UZBEKISTAN  '),
											T_TIPO_NACIONALIDAD('82','TAYIKISTAN  ','TAYIKISTAN  '),
											T_TIPO_NACIONALIDAD('83','KIRGUISTAN  ','KIRGUISTAN  '),
											T_TIPO_NACIONALIDAD('91','ESLOVENIA','ESLOVENIA'),
											T_TIPO_NACIONALIDAD('92','CROACIA ','CROACIA '),
											T_TIPO_NACIONALIDAD('93','BOSNIA-HERZEGOVINA  ','BOSNIA-HERZEGOVINA  '),
											T_TIPO_NACIONALIDAD('94','SERBIA Y MONTENEGRO ','SERBIA Y MONTENEGRO '),
											T_TIPO_NACIONALIDAD('96','MACEDONIA (Antigua República Yugoslava)','MACEDONIA (Antigua República Yugoslava)'),
											T_TIPO_NACIONALIDAD('97','MONTENEGRO  ','MONTENEGRO  '),
											T_TIPO_NACIONALIDAD('98','SERBIA','SERBIA'),
											T_TIPO_NACIONALIDAD('99','KOSOVO','KOSOVO'),
											T_TIPO_NACIONALIDAD('101','MONACO','MONACO'),
											T_TIPO_NACIONALIDAD('103','GUERNESEY','GUERNESEY'),
											T_TIPO_NACIONALIDAD('104','ISLA DE MAN ','ISLA DE MAN '),
											T_TIPO_NACIONALIDAD('107','COOK, ISLAS ','COOK, ISLAS '),
											T_TIPO_NACIONALIDAD('108','LUXEMBURGO  ','LUXEMBURGO  '),
											T_TIPO_NACIONALIDAD('204','MARRUECOS','MARRUECOS'),
											T_TIPO_NACIONALIDAD('208','ARGELIA ','ARGELIA '),
											T_TIPO_NACIONALIDAD('212','TUNEZ ','TUNEZ '),
											T_TIPO_NACIONALIDAD('216','LIBIA ','LIBIA '),
											T_TIPO_NACIONALIDAD('220','EGIPTO','EGIPTO'),
											T_TIPO_NACIONALIDAD('228','MAURITANIA  ','MAURITANIA  '),
											T_TIPO_NACIONALIDAD('232','MALI','MALI'),
											T_TIPO_NACIONALIDAD('236','BURKINA FASO','BURKINA FASO'),
											T_TIPO_NACIONALIDAD('240','NIGER ','NIGER '),
											T_TIPO_NACIONALIDAD('244','CHAD','CHAD'),
											T_TIPO_NACIONALIDAD('247','CABO VERDE  ','CABO VERDE  '),
											T_TIPO_NACIONALIDAD('248','SENEGAL ','SENEGAL '),
											T_TIPO_NACIONALIDAD('252','GAMBIA','GAMBIA'),
											T_TIPO_NACIONALIDAD('257','GUINEA-BISSAU','GUINEA-BISSAU'),
											T_TIPO_NACIONALIDAD('260','GUINEA','GUINEA'),
											T_TIPO_NACIONALIDAD('264','SIERRA LEONA','SIERRA LEONA'),
											T_TIPO_NACIONALIDAD('268','LIBERIA ','LIBERIA '),
											T_TIPO_NACIONALIDAD('272','COSTA DE MARFIL ','COSTA DE MARFIL '),
											T_TIPO_NACIONALIDAD('276','GHANA ','GHANA '),
											T_TIPO_NACIONALIDAD('280','TOGO','TOGO'),
											T_TIPO_NACIONALIDAD('284','BENIN ','BENIN '),
											T_TIPO_NACIONALIDAD('288','NIGERIA ','NIGERIA '),
											T_TIPO_NACIONALIDAD('302','CAMERUN ','CAMERUN '),
											T_TIPO_NACIONALIDAD('306','CENTROAFRICANA, REPÚBLICA','CENTROAFRICANA, REPÚBLICA'),
											T_TIPO_NACIONALIDAD('310','GUINEA ECUATORIAL','GUINEA ECUATORIAL'),
											T_TIPO_NACIONALIDAD('311','SANTO TOME Y PRINCIPE','SANTO TOME Y PRINCIPE'),
											T_TIPO_NACIONALIDAD('314','GABON ','GABON '),
											T_TIPO_NACIONALIDAD('318','CONGO ','CONGO '),
											T_TIPO_NACIONALIDAD('322','CONGO (ZAIRE), REPUBLICA DEMOCRATICA DEL ','CONGO (ZAIRE), REPUBLICA DEMOCRATICA DEL '),
											T_TIPO_NACIONALIDAD('324','RUANDA','RUANDA'),
											T_TIPO_NACIONALIDAD('328','BURUNDI ','BURUNDI '),
											T_TIPO_NACIONALIDAD('329','SANTA ELENA, ASCENSIÓN Y TRISTAN DA CUNHA','SANTA ELENA, ASCENSIÓN Y TRISTAN DA CUNHA'),
											T_TIPO_NACIONALIDAD('330','ANGOLA','ANGOLA'),
											T_TIPO_NACIONALIDAD('334','ETIOPIA ','ETIOPIA '),
											T_TIPO_NACIONALIDAD('336','ERITREA ','ERITREA '),
											T_TIPO_NACIONALIDAD('338','YIBUTI','YIBUTI'),
											T_TIPO_NACIONALIDAD('342','SOMALIA ','SOMALIA '),
											T_TIPO_NACIONALIDAD('346','KENIA ','KENIA '),
											T_TIPO_NACIONALIDAD('350','UGANDA','UGANDA'),
											T_TIPO_NACIONALIDAD('352','TANZANIA','TANZANIA'),
											T_TIPO_NACIONALIDAD('355','SEYCHELLES  ','SEYCHELLES  '),
											T_TIPO_NACIONALIDAD('357','TERRITORIO BRITANICO DEL OCEANO INDICO ','TERRITORIO BRITANICO DEL OCEANO INDICO '),
											T_TIPO_NACIONALIDAD('366','MOZAMBIQUE  ','MOZAMBIQUE  '),
											T_TIPO_NACIONALIDAD('370','MADAGASCAR  ','MADAGASCAR  '),
											T_TIPO_NACIONALIDAD('372','REUNION ','REUNION '),
											T_TIPO_NACIONALIDAD('373','MAURICIO','MAURICIO'),
											T_TIPO_NACIONALIDAD('375','COMORAS ','COMORAS '),
											T_TIPO_NACIONALIDAD('377','MAYOTTE ','MAYOTTE '),
											T_TIPO_NACIONALIDAD('378','ZAMBIA','ZAMBIA'),
											T_TIPO_NACIONALIDAD('382','ZIMBABUE','ZIMBABUE'),
											T_TIPO_NACIONALIDAD('386','MALAUI','MALAUI'),
											T_TIPO_NACIONALIDAD('388','SUDAFRICA','SUDAFRICA'),
											T_TIPO_NACIONALIDAD('389','NAMIBIA ','NAMIBIA '),
											T_TIPO_NACIONALIDAD('391','BOTSUANA','BOTSUANA'),
											T_TIPO_NACIONALIDAD('392','SAHARA OCCIDENTAL','SAHARA OCCIDENTAL'),
											T_TIPO_NACIONALIDAD('393','SUAZILANDIA ','SUAZILANDIA '),
											T_TIPO_NACIONALIDAD('395','LESOTO','LESOTO'),
											T_TIPO_NACIONALIDAD('400','ESTADOS UNIDOS DE AMERICA','ESTADOS UNIDOS DE AMERICA'),
											T_TIPO_NACIONALIDAD('404','CANADA','CANADA'),
											T_TIPO_NACIONALIDAD('406','GROENLANDIA ','GROENLANDIA '),
											T_TIPO_NACIONALIDAD('408','SAN PEDRO Y MIQUELON','SAN PEDRO Y MIQUELON'),
											T_TIPO_NACIONALIDAD('410','COREA DEL SUR','COREA DEL SUR'),
											T_TIPO_NACIONALIDAD('412','MEXICO','MEXICO'),
											T_TIPO_NACIONALIDAD('413','BERMUDAS','BERMUDAS'),
											T_TIPO_NACIONALIDAD('416','GUATEMALA','GUATEMALA'),
											T_TIPO_NACIONALIDAD('421','BELICE','BELICE'),
											T_TIPO_NACIONALIDAD('424','HONDURAS','HONDURAS'),
											T_TIPO_NACIONALIDAD('428','EL SALVADOR ','EL SALVADOR '),
											T_TIPO_NACIONALIDAD('432','NICARAGUA','NICARAGUA'),
											T_TIPO_NACIONALIDAD('436','COSTA RICA  ','COSTA RICA  '),
											T_TIPO_NACIONALIDAD('442','PANAMA','PANAMA'),
											T_TIPO_NACIONALIDAD('446','ANGUILA ','ANGUILA '),
											T_TIPO_NACIONALIDAD('448','CUBA','CUBA'),
											T_TIPO_NACIONALIDAD('449','SAN CRISTOBAL Y NIEVES ','SAN CRISTOBAL Y NIEVES '),
											T_TIPO_NACIONALIDAD('452','HAITI ','HAITI '),
											T_TIPO_NACIONALIDAD('453','BAHAMAS ','BAHAMAS '),
											T_TIPO_NACIONALIDAD('454','TURCAS Y CAICOS, ISLAS ','TURCAS Y CAICOS, ISLAS '),
											T_TIPO_NACIONALIDAD('456','DOMINICANA, REPUBLICA','DOMINICANA, REPUBLICA'),
											T_TIPO_NACIONALIDAD('457','VIRGENES DE LOS EE.UU., ISLAS','VIRGENES DE LOS EE.UU., ISLAS'),
											T_TIPO_NACIONALIDAD('458','GUADALUPE','GUADALUPE'),
											T_TIPO_NACIONALIDAD('459','ANTIGUA Y BARBUDA','ANTIGUA Y BARBUDA'),
											T_TIPO_NACIONALIDAD('460','DOMINICA','DOMINICA'),
											T_TIPO_NACIONALIDAD('462','MARTINICA','MARTINICA'),
											T_TIPO_NACIONALIDAD('463','CAIMAN, ISLAS','CAIMAN, ISLAS'),
											T_TIPO_NACIONALIDAD('464','JAMAICA ','JAMAICA '),
											T_TIPO_NACIONALIDAD('465','SANTA LUCIA ','SANTA LUCIA '),
											T_TIPO_NACIONALIDAD('467','SAN VICENTE Y LAS GRANADINAS ','SAN VICENTE Y LAS GRANADINAS '),
											T_TIPO_NACIONALIDAD('468','VIRGENES BRITANICAS, ISLAS','VIRGENES BRITANICAS, ISLAS'),
											T_TIPO_NACIONALIDAD('469','BARBADOS','BARBADOS'),
											T_TIPO_NACIONALIDAD('470','MONTSERRAT  ','MONTSERRAT  '),
											T_TIPO_NACIONALIDAD('472','TRINIDAD Y TOBAGO','TRINIDAD Y TOBAGO'),
											T_TIPO_NACIONALIDAD('473','GRANADA ','GRANADA '),
											T_TIPO_NACIONALIDAD('474','ARUBA ','ARUBA '),
											T_TIPO_NACIONALIDAD('478','ANTILLAS NEERLANDESAS','ANTILLAS NEERLANDESAS'),
											T_TIPO_NACIONALIDAD('480','COLOMBIA','COLOMBIA'),
											T_TIPO_NACIONALIDAD('484','VENEZUELA','VENEZUELA'),
											T_TIPO_NACIONALIDAD('488','GUYANA','GUYANA'),
											T_TIPO_NACIONALIDAD('492','SURINAM ','SURINAM '),
											T_TIPO_NACIONALIDAD('496','GUAYANA FRANCESA','GUAYANA FRANCESA'),
											T_TIPO_NACIONALIDAD('500','ECUADOR ','ECUADOR '),
											T_TIPO_NACIONALIDAD('504','PERU','PERU'),
											T_TIPO_NACIONALIDAD('508','BRASIL','BRASIL'),
											T_TIPO_NACIONALIDAD('512','CHILE ','CHILE '),
											T_TIPO_NACIONALIDAD('516','BOLIVIA ','BOLIVIA '),
											T_TIPO_NACIONALIDAD('520','PARAGUAY','PARAGUAY'),
											T_TIPO_NACIONALIDAD('524','URUGUAY ','URUGUAY '),
											T_TIPO_NACIONALIDAD('528','ARGENTINA','ARGENTINA'),
											T_TIPO_NACIONALIDAD('529','MALVINAS (FALKLANDS), ISLAS  ','MALVINAS (FALKLANDS), ISLAS  '),
											T_TIPO_NACIONALIDAD('531','CURAÇAO ','CURAÇAO '),
											T_TIPO_NACIONALIDAD('534','SAN MARTÍN (parte meridional)','SAN MARTÍN (parte meridional)'),
											T_TIPO_NACIONALIDAD('535','BONAIRE, SAN EUSTAQUIO Y SABA','BONAIRE, SAN EUSTAQUIO Y SABA'),
											T_TIPO_NACIONALIDAD('600','CHIPRE','CHIPRE'),
											T_TIPO_NACIONALIDAD('604','LIBANO','LIBANO'),
											T_TIPO_NACIONALIDAD('608','SIRIA ','SIRIA '),
											T_TIPO_NACIONALIDAD('612','IRAQ','IRAQ'),
											T_TIPO_NACIONALIDAD('616','IRAN','IRAN'),
											T_TIPO_NACIONALIDAD('624','ISRAEL','ISRAEL'),
											T_TIPO_NACIONALIDAD('625','PALESTINA, ESTADO DE','PALESTINA, ESTADO DE'),
											T_TIPO_NACIONALIDAD('626','TIMOR LESTE ','TIMOR LESTE '),
											T_TIPO_NACIONALIDAD('628','JORDANIA','JORDANIA'),
											T_TIPO_NACIONALIDAD('630','PUERTO RICO ','PUERTO RICO '),
											T_TIPO_NACIONALIDAD('632','ARABIA SAUDÍ','ARABIA SAUDÍ'),
											T_TIPO_NACIONALIDAD('636','KUWAIT','KUWAIT'),
											T_TIPO_NACIONALIDAD('640','BAHREIN ','BAHREIN '),
											T_TIPO_NACIONALIDAD('644','QATAR ','QATAR '),
											T_TIPO_NACIONALIDAD('647','EMIRATOS ARABES UNIDOS ','EMIRATOS ARABES UNIDOS '),
											T_TIPO_NACIONALIDAD('649','OMAN','OMAN'),
											T_TIPO_NACIONALIDAD('652','SAN BARTOLOMÉ','SAN BARTOLOMÉ'),
											T_TIPO_NACIONALIDAD('653','YEMEN ','YEMEN '),
											T_TIPO_NACIONALIDAD('660','AFGANISTAN  ','AFGANISTAN  '),
											T_TIPO_NACIONALIDAD('662','PAKISTAN','PAKISTAN'),
											T_TIPO_NACIONALIDAD('664','INDIA ','INDIA '),
											T_TIPO_NACIONALIDAD('666','BANGLADÉS','BANGLADÉS'),
											T_TIPO_NACIONALIDAD('667','MALDIVAS','MALDIVAS'),
											T_TIPO_NACIONALIDAD('669','SRI LANKA','SRI LANKA'),
											T_TIPO_NACIONALIDAD('672','NEPAL ','NEPAL '),
											T_TIPO_NACIONALIDAD('675','BUTAN ','BUTAN '),
											T_TIPO_NACIONALIDAD('676','BIRMANIA/MYANMAR','BIRMANIA/MYANMAR'),
											T_TIPO_NACIONALIDAD('680','TAILANDIA','TAILANDIA'),
											T_TIPO_NACIONALIDAD('684','LAOS','LAOS'),
											T_TIPO_NACIONALIDAD('686','ÅLAND, ISLAS','ÅLAND, ISLAS'),
											T_TIPO_NACIONALIDAD('690','VIETNAM ','VIETNAM '),
											T_TIPO_NACIONALIDAD('696','CAMBOYA ','CAMBOYA '),
											T_TIPO_NACIONALIDAD('700','INDONESIA','INDONESIA'),
											T_TIPO_NACIONALIDAD('701','MALASIA ','MALASIA '),
											T_TIPO_NACIONALIDAD('703','BRUNEI','BRUNEI'),
											T_TIPO_NACIONALIDAD('706','SINGAPUR','SINGAPUR'),
											T_TIPO_NACIONALIDAD('708','FILIPINAS','FILIPINAS'),
											T_TIPO_NACIONALIDAD('716','MONGOLIA','MONGOLIA'),
											T_TIPO_NACIONALIDAD('720','CHINA ','CHINA '),
											T_TIPO_NACIONALIDAD('724','COREA DEL NORTE ','COREA DEL NORTE '),
											T_TIPO_NACIONALIDAD('728','SUDAN DEL SUR','SUDAN DEL SUR'),
											T_TIPO_NACIONALIDAD('729','SUDAN ','SUDAN '),
											T_TIPO_NACIONALIDAD('732','JAPON ','JAPON '),
											T_TIPO_NACIONALIDAD('736','TAIWAN','TAIWAN'),
											T_TIPO_NACIONALIDAD('740','HONG KONG','HONG KONG'),
											T_TIPO_NACIONALIDAD('743','MACAO ','MACAO '),
											T_TIPO_NACIONALIDAD('800','AUSTRALIA','AUSTRALIA'),
											T_TIPO_NACIONALIDAD('801','PAPÚA NUEVA GUINEA  ','PAPÚA NUEVA GUINEA  '),
											T_TIPO_NACIONALIDAD('802','OCEANIA AUSTRALIANA ','OCEANIA AUSTRALIANA '),
											T_TIPO_NACIONALIDAD('803','NAURU ','NAURU '),
											T_TIPO_NACIONALIDAD('804','NUEVA ZELANDA','NUEVA ZELANDA'),
											T_TIPO_NACIONALIDAD('806','SALOMON, ISLAS  ','SALOMON, ISLAS  '),
											T_TIPO_NACIONALIDAD('807','TUVALU','TUVALU'),
											T_TIPO_NACIONALIDAD('809','NUEVA CALEDONIA ','NUEVA CALEDONIA '),
											T_TIPO_NACIONALIDAD('810','OCEANIA AMERICANA','OCEANIA AMERICANA'),
											T_TIPO_NACIONALIDAD('811','WALLIS Y FUTUNA, ISLAS ','WALLIS Y FUTUNA, ISLAS '),
											T_TIPO_NACIONALIDAD('812','KIRIBATI','KIRIBATI'),
											T_TIPO_NACIONALIDAD('813','PITCAIRN','PITCAIRN'),
											T_TIPO_NACIONALIDAD('814','OCEANIA NEO-ZERLANDESA ','OCEANIA NEO-ZERLANDESA '),
											T_TIPO_NACIONALIDAD('815','FIYI','FIYI'),
											T_TIPO_NACIONALIDAD('816','VANUATU ','VANUATU '),
											T_TIPO_NACIONALIDAD('817','TONGA ','TONGA '),
											T_TIPO_NACIONALIDAD('819','SAMOA ','SAMOA '),
											T_TIPO_NACIONALIDAD('820','MARIANAS DEL NORTE, ISLAS','MARIANAS DEL NORTE, ISLAS'),
											T_TIPO_NACIONALIDAD('822','POLINESIA FRANCESA  ','POLINESIA FRANCESA  '),
											T_TIPO_NACIONALIDAD('823','MICRONESIA, FEDERACION DE ESTADOS DE ','MICRONESIA, FEDERACION DE ESTADOS DE '),
											T_TIPO_NACIONALIDAD('824','MARSHALL, ISLAS ','MARSHALL, ISLAS '),
											T_TIPO_NACIONALIDAD('825','PALAOS','PALAOS'),
											T_TIPO_NACIONALIDAD('830','SAMOA AMERICANA ','SAMOA AMERICANA '),
											T_TIPO_NACIONALIDAD('831','GUAM','GUAM'),
											T_TIPO_NACIONALIDAD('832','MENORES ALEJADAS DE LOS EE.UU,ISLAS  ','MENORES ALEJADAS DE LOS EE.UU,ISLAS  '),
											T_TIPO_NACIONALIDAD('833','COCOS (KEELING), ISLAS ','COCOS (KEELING), ISLAS '),
											T_TIPO_NACIONALIDAD('834','NAVIDAD (CHRISTMAS), ISLA','NAVIDAD (CHRISTMAS), ISLA'),
											T_TIPO_NACIONALIDAD('835','HEARD Y MCDONALD, ISLAS','HEARD Y MCDONALD, ISLAS'),
											T_TIPO_NACIONALIDAD('836','NORFOLK, ISLA','NORFOLK, ISLA'),
											T_TIPO_NACIONALIDAD('837','COOK, ISLAS ','COOK, ISLAS '),
											T_TIPO_NACIONALIDAD('838','NIUE','NIUE'),
											T_TIPO_NACIONALIDAD('839','TOKELAU ','TOKELAU '),
											T_TIPO_NACIONALIDAD('890','REGIONES POLARES','REGIONES POLARES'),
											T_TIPO_NACIONALIDAD('891','ANTARTIDA','ANTARTIDA'),
											T_TIPO_NACIONALIDAD('892','BOUVET, ISLA','BOUVET, ISLA'),
											T_TIPO_NACIONALIDAD('893','GEORGIA DEL SUR Y LAS ISLAS SANDWICH DEL SUR ','GEORGIA DEL SUR Y LAS ISLAS SANDWICH DEL SUR '),
											T_TIPO_NACIONALIDAD('894','TIERRAS AUSTRALES FRANCESAS  ','TIERRAS AUSTRALES FRANCESAS  '),
											T_TIPO_NACIONALIDAD('910','INSTITUCIONES DE LA UNION EUROPEA','INSTITUCIONES DE LA UNION EUROPEA'),
											T_TIPO_NACIONALIDAD('920','ORG. INTERN. DIST. DE LAS INST DE UE Y BCE','ORG. INTERN. DIST. DE LAS INST DE UE Y BCE'),
											T_TIPO_NACIONALIDAD('921','ORGANISMOS INTERNACIONALES','ORGANISMOS INTERNACIONALES'),
											T_TIPO_NACIONALIDAD('930','BANCO CENTRAL EUROPEO','BANCO CENTRAL EUROPEO'),
											T_TIPO_NACIONALIDAD('958','PAISES Y TERRITORIOS NO DETERMINADOS ','PAISES Y TERRITORIOS NO DETERMINADOS '),
											T_TIPO_NACIONALIDAD('972','JERSEY','JERSEY')
                                   );
								   
								   
								    V_TIPO_SEX T_ARRAY_SEX := T_ARRAY_SEX(
											T_TIPO_SEX('1','MUJER','MUJER'),
											T_TIPO_SEX('2','VARÓN','VARÓN')
                                   );
								   
		
   
   V_MSQL VARCHAR(5000);
   V_EXIST NUMBER(10);

   V_ENTIDAD_ID NUMBER(16);
   V_PEF_ID NUMBER;
  
   V_TMP_TIPO_NACIONALIDAD T_TIPO_NACIONALIDAD; 
   V_TMP_TIPO_SEX T_TIPO_SEX;
  
   err_num NUMBER;
   err_msg VARCHAR2(255);
BEGIN

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_PAIS_NACIMIENTO'); 
EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.PER_PERSONAS DISABLE CONSTRAINTS FK_PER_PAIS_NACIMIENTO');    

DBMS_OUTPUT.PUT_LINE('PERSONAS - Deshabilitamos constraints FK_PER_NACIONALIDAD'); 
EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.PER_PERSONAS DISABLE CONSTRAINTS FK_PER_NACIONALIDAD'); 



			DBMS_OUTPUT.PUT_LINE('Se borra DD_CIC_CODIGO_ISO_CIRBE - NACIONALIDAD');
	    execute immediate('DELETE FROM ' || V_ESQUEMA_M || '.DD_CIC_CODIGO_ISO_CIRBE');
		
			DBMS_OUTPUT.PUT_LINE('Se borra SEX_SEXO - SEXO');
	    execute immediate('DELETE FROM ' || V_ESQUEMA_M || '.SEX_SEXO');
    
    SELECT count(*) INTO V_ENTIDAD_ID
    FROM all_sequences
    WHERE sequence_name = 'S_DD_CIC_CODIGO_ISO_CIRBE' and sequence_owner=V_ESQUEMA_M;
    if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then    
	    EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_M || '.S_DD_CIC_CODIGO_ISO_CIRBE');
	end if;
	
	  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_M || '.S_DD_CIC_CODIGO_ISO_CIRBE
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	
    SELECT count(*) INTO V_ENTIDAD_ID
        FROM all_sequences
        WHERE sequence_name = 'S_SEX_SEXO' and sequence_owner=V_ESQUEMA_M;
        if V_ENTIDAD_ID is not null and V_ENTIDAD_ID = 1 then
       EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA_M || '.S_SEX_SEXO');
    END IF;
    EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA_M || '.S_SEX_SEXO
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
	 
   
   DBMS_OUTPUT.PUT_LINE('Creando DD_CIC_CODIGO_ISO_CIRBE NACIONALIDAD......');
   FOR I IN V_TIPO_NACIONALIDAD.FIRST .. V_TIPO_NACIONALIDAD.LAST
   LOOP
      V_MSQL := 'SELECT '||V_ESQUEMA_M||'.S_DD_CIC_CODIGO_ISO_CIRBE.NEXTVAL FROM DUAL';
      EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
      V_TMP_TIPO_NACIONALIDAD := V_TIPO_NACIONALIDAD(I);
      DBMS_OUTPUT.PUT_LINE('Creando Tipo NACIONALIDAD: '||V_TMP_TIPO_NACIONALIDAD(1));   

      V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE (DD_CIC_ID, DD_CIC_CODIGO, DD_CIC_DESCRIPCION,' ||
        'DD_CIC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                 ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_NACIONALIDAD(1)||''','''||V_TMP_TIPO_NACIONALIDAD(2)||''','''
         ||V_TMP_TIPO_NACIONALIDAD(3)||''','
         || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
      --DBMS_OUTPUT.PUT_LINE(V_MSQL);
      EXECUTE IMMEDIATE V_MSQL;
   END LOOP; --LOOP TIPO_Documento
   V_TMP_TIPO_NACIONALIDAD:= NULL;
   V_TIPO_NACIONALIDAD:= NULL;

 DBMS_OUTPUT.PUT_LINE('Creando SEX_SEXO......');
 FOR I IN V_TIPO_SEX.FIRST .. V_TIPO_SEX.LAST
 LOOP
       V_MSQL := 'SELECT '|| V_ESQUEMA_M ||'.S_SEX_SEXO.NEXTVAL FROM DUAL';
       EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
       V_TMP_TIPO_SEX := V_TIPO_SEX(I);
       DBMS_OUTPUT.PUT_LINE('Creando SEX_SEXO: '||V_TMP_TIPO_SEX(1));   
 
       V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.SEX_SEXO (DD_SEX_ID, DD_SEX_CODIGO, DD_SEX_DESCRIPCION,' ||
         'DD_SEX_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                  ' VALUES ('||  V_ENTIDAD_ID || ','''||V_TMP_TIPO_SEX(1)||''','''||V_TMP_TIPO_SEX(2)||''','''
          ||V_TMP_TIPO_SEX(3)||''','
          || '0,'''||V_USUARIO_CREAR||''',SYSDATE,0)';
       --DBMS_OUTPUT.PUT_LINE(V_MSQL);
       EXECUTE IMMEDIATE V_MSQL;
    END LOOP; --LOOP SEX
    V_TMP_TIPO_SEX:= NULL;
    V_TIPO_SEX:= NULL;

DBMS_OUTPUT.PUT_LINE('PERSONAS - Habilitamos constraints FK_PER_PAIS_NACIMIENTO'); 
EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.PER_PERSONAS ENABLE CONSTRAINTS FK_PER_PAIS_NACIMIENTO');    

DBMS_OUTPUT.PUT_LINE('PERSONAS - Habilitamos constraints FK_PER_NACIONALIDAD'); 
EXECUTE IMMEDIATE('ALTER TABLE ' || V_ESQUEMA || '.PER_PERSONAS ENABLE CONSTRAINTS FK_PER_NACIONALIDAD'); 


   
   DBMS_OUTPUT.PUT_LINE('Script ejecutado correctamente'); 

EXCEPTION

WHEN OTHERS THEN  
  err_num := SQLCODE;
  err_msg := SQLERRM;

  DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line(err_msg);
  
  ROLLBACK;
  RAISE;
END;
/
EXIT;

