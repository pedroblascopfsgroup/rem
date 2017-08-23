--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2029
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_PAI_PAISES los datos añadidos en T_ARRAY_DATA
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

    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('01', 'Australia'),
        T_TIPO_DATA('02', 'Austria'),
        T_TIPO_DATA('03', 'Azerbaiyán'),
        T_TIPO_DATA('04', 'Anguilla'),
        T_TIPO_DATA('05', 'Argentina'),
        T_TIPO_DATA('06', 'Armenia'),
        T_TIPO_DATA('07', 'Bielorrusia'),
        T_TIPO_DATA('08', 'Belice'),
        T_TIPO_DATA('09', 'Bélgica'),
        T_TIPO_DATA('10', 'Bermudas'),
        T_TIPO_DATA('11', 'Bulgaria'),
		T_TIPO_DATA('12', 'Brasil'),
		T_TIPO_DATA('13', 'Reino Unido'),
		T_TIPO_DATA('14', 'Hungría'),
		T_TIPO_DATA('15', 'Vietnam'),
		T_TIPO_DATA('16', 'Haiti'),
		T_TIPO_DATA('17', 'Guadalupe'),
		T_TIPO_DATA('18', 'Alemania'),
		T_TIPO_DATA('19', 'Países Bajos, Holanda'),
		T_TIPO_DATA('20', 'Grecia'),
		T_TIPO_DATA('21', 'Georgia'),
		T_TIPO_DATA('22', 'Dinamarca'),
		T_TIPO_DATA('23', 'Egipto'),
		T_TIPO_DATA('24', 'Israel'),
		T_TIPO_DATA('25', 'India'),
		T_TIPO_DATA('26', 'Irán'),
		T_TIPO_DATA('27', 'Irlanda'),
		T_TIPO_DATA('28', 'España'),
		T_TIPO_DATA('29', 'Italia'),
		T_TIPO_DATA('30', 'Kazajstán'),
		T_TIPO_DATA('31', 'Camerún'),
		T_TIPO_DATA('32', 'Canadá'),
		T_TIPO_DATA('33', 'Chipre'),
		T_TIPO_DATA('34', 'Kirguistán'),
		T_TIPO_DATA('35', 'China'),
		T_TIPO_DATA('36', 'Costa Rica'),
		T_TIPO_DATA('37', 'Kuwait'),
		T_TIPO_DATA('38', 'Letonia'),
		T_TIPO_DATA('39', 'Libia'),
		T_TIPO_DATA('40', 'Lituania'),
		T_TIPO_DATA('41', 'Luxemburgo'),
		T_TIPO_DATA('42', 'México'),
		T_TIPO_DATA('43', 'Moldavia'),
		T_TIPO_DATA('44', 'Mónaco'),
		T_TIPO_DATA('45', 'Nueva Zelanda'),
		T_TIPO_DATA('46', 'Noruega'),
		T_TIPO_DATA('47', 'Polonia'),
		T_TIPO_DATA('48', 'Portugal'),
		T_TIPO_DATA('49', 'Reunión'),
		T_TIPO_DATA('50', 'Rusia'),
		T_TIPO_DATA('51', 'El Salvador'),
		T_TIPO_DATA('52', 'Eslovaquia'),
		T_TIPO_DATA('53', 'Eslovenia'),
		T_TIPO_DATA('54', 'Surinam'),
		T_TIPO_DATA('55', 'Estados Unidos'),
		T_TIPO_DATA('56', 'Tadjikistan'),
		T_TIPO_DATA('57', 'Turkmenistan'),
		T_TIPO_DATA('58', 'Islas Turcas y Caicos'),
		T_TIPO_DATA('59', 'Turquía'),
		T_TIPO_DATA('60', 'Uganda'),
		T_TIPO_DATA('61', 'Uzbekistán'),
		T_TIPO_DATA('62', 'Ucrania'),
		T_TIPO_DATA('63', 'Finlandia'),
		T_TIPO_DATA('64', 'Francia'),
		T_TIPO_DATA('65', 'República Checa'),
		T_TIPO_DATA('66', 'Suiza'),
		T_TIPO_DATA('67', 'Suecia'),
		T_TIPO_DATA('68', 'Estonia'),
		T_TIPO_DATA('69', 'Corea del Sur'),
		T_TIPO_DATA('70', 'Japón'),
		T_TIPO_DATA('71', 'Croacia'),
		T_TIPO_DATA('72', 'Rumanía'),
		T_TIPO_DATA('73', 'Hong Kong'),
		T_TIPO_DATA('74', 'Indonesia'),
		T_TIPO_DATA('75', 'Jordania'),
		T_TIPO_DATA('76', 'Malasia'),
		T_TIPO_DATA('77', 'Singapur'),
		T_TIPO_DATA('78', 'Taiwan'),
		T_TIPO_DATA('79', 'Bosnia y Herzegovina'),
		T_TIPO_DATA('80', 'Bahamas'),
		T_TIPO_DATA('81', 'Chile'),
		T_TIPO_DATA('82', 'Colombia'),
		T_TIPO_DATA('83', 'Islandia'),
		T_TIPO_DATA('84', 'Corea del Norte'),
		T_TIPO_DATA('85', 'Macedonia'),
		T_TIPO_DATA('86', 'Malta'),
		T_TIPO_DATA('87', 'Pakistán'),
		T_TIPO_DATA('88', 'Papúa-Nueva Guinea'),
		T_TIPO_DATA('89', 'Perú'),
		T_TIPO_DATA('90', 'Filipinas'),
		T_TIPO_DATA('91', 'Arabia Saudita'),
		T_TIPO_DATA('92', 'Tailandia'),
		T_TIPO_DATA('93', 'Emiratos árabes Unidos'),
		T_TIPO_DATA('94', 'Groenlandia'),
		T_TIPO_DATA('95', 'Venezuela'),
		T_TIPO_DATA('96', 'Zimbabwe'),
		T_TIPO_DATA('97', 'Kenia'),
		T_TIPO_DATA('98', 'Algeria'),
		T_TIPO_DATA('99', 'Líbano'),
		T_TIPO_DATA('100', 'Botsuana'),
		T_TIPO_DATA('101', 'Tanzania'),
		T_TIPO_DATA('102', 'Namibia'),
		T_TIPO_DATA('103', 'Ecuador'),
		T_TIPO_DATA('104', 'Marruecos'),
		T_TIPO_DATA('105', 'Ghana'),
		T_TIPO_DATA('106', 'Siria'),
		T_TIPO_DATA('107', 'Nepal'),
		T_TIPO_DATA('108', 'Mauritania'),
		T_TIPO_DATA('109', 'Seychelles'),
		T_TIPO_DATA('110', 'Paraguay'),
		T_TIPO_DATA('111', 'Uruguay'),
		T_TIPO_DATA('112', 'Congo (Brazzaville)'),
		T_TIPO_DATA('113', 'Cuba'),
		T_TIPO_DATA('114', 'Albania'),
		T_TIPO_DATA('115', 'Nigeria'),
		T_TIPO_DATA('116', 'Zambia'),
		T_TIPO_DATA('117', 'Mozambique'),
		T_TIPO_DATA('119', 'Angola'),
		T_TIPO_DATA('120', 'Sri Lanka'),
		T_TIPO_DATA('121', 'Etiopía'),
		T_TIPO_DATA('122', 'Túnez'),
		T_TIPO_DATA('123', 'Bolivia'),
		T_TIPO_DATA('124', 'Panamá'),
		T_TIPO_DATA('125', 'Malawi'),
		T_TIPO_DATA('126', 'Liechtenstein'),
		T_TIPO_DATA('127', 'Bahrein'),
		T_TIPO_DATA('128', 'Barbados'),
		T_TIPO_DATA('130', 'Chad'),
		T_TIPO_DATA('131', 'Man, Isla de'),
		T_TIPO_DATA('132', 'Jamaica'),
		T_TIPO_DATA('133', 'Malí'),
		T_TIPO_DATA('134', 'Madagascar'),
		T_TIPO_DATA('135', 'Senegal'),
		T_TIPO_DATA('136', 'Togo'),
		T_TIPO_DATA('137', 'Honduras'),
		T_TIPO_DATA('138', 'República Dominicana'),
		T_TIPO_DATA('139', 'Mongolia'),
		T_TIPO_DATA('140', 'Irak'),
		T_TIPO_DATA('141', 'Sudáfrica'),
		T_TIPO_DATA('142', 'Aruba'),
		T_TIPO_DATA('143', 'Gibraltar'),
		T_TIPO_DATA('144', 'Afganistán'),
		T_TIPO_DATA('145', 'Andorra'),
		T_TIPO_DATA('147', 'Antigua y Barbuda'),
		T_TIPO_DATA('149', 'Bangladesh'),
		T_TIPO_DATA('151', 'Benín'),
		T_TIPO_DATA('152', 'Bután'),
		T_TIPO_DATA('154', 'Islas Virgenes Británicas'),
		T_TIPO_DATA('155', 'Brunéi'),
		T_TIPO_DATA('156', 'Burkina Faso'),
		T_TIPO_DATA('157', 'Burundi'),
		T_TIPO_DATA('158', 'Camboya'),
		T_TIPO_DATA('159', 'Cabo Verde'),
		T_TIPO_DATA('164', 'Comores'),
		T_TIPO_DATA('165', 'Congo (Kinshasa)'),
		T_TIPO_DATA('166', 'Cook, Islas'),
		T_TIPO_DATA('168', 'Costa de Marfil'),
		T_TIPO_DATA('169', 'Djibouti, Yibuti'),
		T_TIPO_DATA('171', 'Timor Oriental'),
		T_TIPO_DATA('172', 'Guinea Ecuatorial'),
		T_TIPO_DATA('173', 'Eritrea'),
		T_TIPO_DATA('175', 'Feroe, Islas'),
		T_TIPO_DATA('176', 'Fiyi'),
		T_TIPO_DATA('178', 'Polinesia Francesa'),
		T_TIPO_DATA('180', 'Gabón'),
		T_TIPO_DATA('181', 'Gambia'),
		T_TIPO_DATA('184', 'Granada'),
		T_TIPO_DATA('185', 'Guatemala'),
		T_TIPO_DATA('186', 'Guernsey'),
		T_TIPO_DATA('187', 'Guinea'),
		T_TIPO_DATA('188', 'Guinea-Bissau'),
		T_TIPO_DATA('189', 'Guyana'),
		T_TIPO_DATA('193', 'Jersey'),
		T_TIPO_DATA('195', 'Kiribati'),
		T_TIPO_DATA('196', 'Laos'),
		T_TIPO_DATA('197', 'Lesotho'),
		T_TIPO_DATA('198', 'Liberia'),
		T_TIPO_DATA('200', 'Maldivas'),
		T_TIPO_DATA('201', 'Martinica'),
		T_TIPO_DATA('202', 'Mauricio'),
		T_TIPO_DATA('205', 'Myanmar'),
		T_TIPO_DATA('206', 'Nauru'),
		T_TIPO_DATA('207', 'Antillas Holandesas'),
		T_TIPO_DATA('208', 'Nueva Caledonia'),
		T_TIPO_DATA('209', 'Nicaragua'),
		T_TIPO_DATA('210', 'Níger'),
		T_TIPO_DATA('212', 'Norfolk Island'),
		T_TIPO_DATA('213', 'Omán'),
		T_TIPO_DATA('215', 'Isla Pitcairn'),
		T_TIPO_DATA('216', 'Qatar'),
		T_TIPO_DATA('217', 'Ruanda'),
		T_TIPO_DATA('218', 'Santa Elena'),
		T_TIPO_DATA('219', 'San Cristobal y Nevis'),
		T_TIPO_DATA('220', 'Santa Lucía'),
		T_TIPO_DATA('221', 'San Pedro y Miquelón'),
		T_TIPO_DATA('222', 'San Vincente y Granadinas'),
		T_TIPO_DATA('223', 'Samoa'),
		T_TIPO_DATA('224', 'San Marino'),
		T_TIPO_DATA('225', 'San Tomé y Príncipe'),
		T_TIPO_DATA('226', 'Serbia y Montenegro'),
		T_TIPO_DATA('227', 'Sierra Leona'),
		T_TIPO_DATA('228', 'Islas Salomón'),
		T_TIPO_DATA('229', 'Somalia'),
		T_TIPO_DATA('232', 'Sudán'),
		T_TIPO_DATA('234', 'Swazilandia'),
		T_TIPO_DATA('235', 'Tokelau'),
		T_TIPO_DATA('236', 'Tonga'),
		T_TIPO_DATA('237', 'Trinidad y Tobago'),
		T_TIPO_DATA('239', 'Tuvalu'),
		T_TIPO_DATA('240', 'Vanuatu'),
		T_TIPO_DATA('241', 'Wallis y Futuna'),
		T_TIPO_DATA('242', 'Sáhara Occidental'),
		T_TIPO_DATA('243', 'Yemen'),
		T_TIPO_DATA('246', 'Puerto Rico')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP para insertar los valores en DD_PAI_PAISES -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN DD_PAI_PAISES] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    
        --Comprobamos el dato a insertar
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PAI_PAISES WHERE DD_PAI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        --Si existe lo modificamos
        IF V_NUM_TABLAS > 0 THEN				
          
          DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
       	  V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.DD_PAI_PAISES '||
                    'SET DD_PAI_DESCRIPCION = '''||TRIM(V_TMP_TIPO_DATA(2))||''''|| 
					', DD_PAI_DESCRIPCION_LARGA = '''||TRIM(V_TMP_TIPO_DATA(2))||''''||
					', USUARIOMODIFICAR = ''DML'' , FECHAMODIFICAR = SYSDATE '||
					'WHERE DD_PAI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
          
       --Si no existe, lo insertamos   
       ELSE
       
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_MSQL := 'SELECT '|| V_ESQUEMA ||'.S_DD_PAI_PAISES.NEXTVAL FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL INTO V_ID;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.DD_PAI_PAISES (' ||
                      'DD_PAI_ID, DD_PAI_CODIGO, DD_PAI_DESCRIPCION, DD_PAI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_ID || ','''||V_TMP_TIPO_DATA(1)||''','''||TRIM(V_TMP_TIPO_DATA(2))||''','''||TRIM(V_TMP_TIPO_DATA(2))||''', 0, ''DML'',SYSDATE,0 FROM DUAL';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
        
       END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO DD_PAI_PAISES ACTUALIZADO CORRECTAMENTE ');
   

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



   