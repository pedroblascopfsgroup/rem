--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20210601
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14157
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar instrucciones
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_USUARIO VARCHAR2(50 CHAR):= 'HREOS-14157'; -- Configuracion Esquema Master
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_PAI_PAISES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('144',' AF'),
		T_TIPO_DATA('114',' AL'),
		T_TIPO_DATA('18',' DE'),
		T_TIPO_DATA('145',' AD'),
		T_TIPO_DATA('119',' AO'),
		T_TIPO_DATA('04',' AI'),
		T_TIPO_DATA('147',' AG'),
		T_TIPO_DATA('91',' SA'),
		T_TIPO_DATA('05',' AR'),
		T_TIPO_DATA('06',' AM'),
		T_TIPO_DATA('142',' AW'),
		T_TIPO_DATA('01',' AU'),
		T_TIPO_DATA('02',' AT'),
		T_TIPO_DATA('03',' AZ'),
		T_TIPO_DATA('80',' BS'),
		T_TIPO_DATA('127',' BH'),
		T_TIPO_DATA('149',' BD'),
		T_TIPO_DATA('128',' BB'),
		T_TIPO_DATA('09',' BE'),
		T_TIPO_DATA('08',' BZ'),
		T_TIPO_DATA('151',' BJ'),
		T_TIPO_DATA('10',' BM'),
		T_TIPO_DATA('07',' BY'),
		T_TIPO_DATA('123',' BO'),
		T_TIPO_DATA('79',' BA'),
		T_TIPO_DATA('100',' BW'),
		T_TIPO_DATA('12',' BR'),
		T_TIPO_DATA('155',' BN'),
		T_TIPO_DATA('11',' BG'),
		T_TIPO_DATA('156',' BF'),
		T_TIPO_DATA('157',' BI'),
		T_TIPO_DATA('152',' BT'),
		T_TIPO_DATA('159',' CV'),
		T_TIPO_DATA('158',' KH'),
		T_TIPO_DATA('31',' CM'),
		T_TIPO_DATA('32',' CA'),
		T_TIPO_DATA('260',' CC'),
		T_TIPO_DATA('82',' CO'),
		T_TIPO_DATA('164',' KM'),
		T_TIPO_DATA('166',' CK'),
		T_TIPO_DATA('84',' KP'),
		T_TIPO_DATA('69',' KR'),
		T_TIPO_DATA('168',' CI'),
		T_TIPO_DATA('36',' CR'),
		T_TIPO_DATA('71',' HR'),
		T_TIPO_DATA('113',' CU'),
		T_TIPO_DATA('130',' TD'),
		T_TIPO_DATA('65',' CZ'),
		T_TIPO_DATA('81',' CL'),
		T_TIPO_DATA('35',' CN'),
		T_TIPO_DATA('33',' CY'),
		T_TIPO_DATA('253',' CW'),
		T_TIPO_DATA('22',' DK'),
		T_TIPO_DATA('138',' DO'),
		T_TIPO_DATA('103',' EC'),
		T_TIPO_DATA('23',' EG'),
		T_TIPO_DATA('93',' AE'),
		T_TIPO_DATA('173',' ER'),
		T_TIPO_DATA('52',' SK'),
		T_TIPO_DATA('53',' SI'),
		T_TIPO_DATA('28',' ES'),
		T_TIPO_DATA('55',' US'),
		T_TIPO_DATA('68',' EE'),
		T_TIPO_DATA('121',' ET'),
		T_TIPO_DATA('175',' FO'),
		T_TIPO_DATA('90',' PH'),
		T_TIPO_DATA('63',' FI'),
		T_TIPO_DATA('176',' FJ'),
		T_TIPO_DATA('64',' FR'),
		T_TIPO_DATA('180',' GA'),
		T_TIPO_DATA('181',' GM'),
		T_TIPO_DATA('21',' GE'),
		T_TIPO_DATA('105',' GH'),
		T_TIPO_DATA('143',' GI'),
		T_TIPO_DATA('184',' GD'),
		T_TIPO_DATA('20',' GR'),
		T_TIPO_DATA('94',' GL'),
		T_TIPO_DATA('257',' GU'),
		T_TIPO_DATA('185',' GT'),
		T_TIPO_DATA('186',' GG'),
		T_TIPO_DATA('187',' GN'),
		T_TIPO_DATA('172',' GQ'),
		T_TIPO_DATA('188',' GW'),
		T_TIPO_DATA('189',' GY'),
		T_TIPO_DATA('16',' HT'),
		T_TIPO_DATA('137',' HN'),
		T_TIPO_DATA('73',' HK'),
		T_TIPO_DATA('14',' HU'),
		T_TIPO_DATA('25',' IN'),
		T_TIPO_DATA('74',' ID'),
		T_TIPO_DATA('26',' IR'),
		T_TIPO_DATA('140',' IQ'),
		T_TIPO_DATA('27',' IE'),
		T_TIPO_DATA('131',' IM'),
		T_TIPO_DATA('83',' IS'),
		T_TIPO_DATA('24',' IL'),
		T_TIPO_DATA('29',' IT'),
		T_TIPO_DATA('132',' JM'),
		T_TIPO_DATA('70',' JP'),
		T_TIPO_DATA('193',' JE'),
		T_TIPO_DATA('75',' JO'),
		T_TIPO_DATA('30',' KZ'),
		T_TIPO_DATA('97',' KE'),
		T_TIPO_DATA('34',' KG'),
		T_TIPO_DATA('195',' KI'),
		T_TIPO_DATA('37',' KW'),
		T_TIPO_DATA('196',' LA'),
		T_TIPO_DATA('197',' LS'),
		T_TIPO_DATA('38',' LV'),
		T_TIPO_DATA('99',' LB'),
		T_TIPO_DATA('198',' LR'),
		T_TIPO_DATA('39',' LY'),
		T_TIPO_DATA('126',' LI'),
		T_TIPO_DATA('40',' LT'),
		T_TIPO_DATA('41',' LU'),
		T_TIPO_DATA('85',' MK'),
		T_TIPO_DATA('134',' MG'),
		T_TIPO_DATA('76',' MY'),
		T_TIPO_DATA('125',' MW'),
		T_TIPO_DATA('200',' MV'),
		T_TIPO_DATA('133',' ML'),
		T_TIPO_DATA('86',' MT'),
		T_TIPO_DATA('104',' MA'),
		T_TIPO_DATA('202',' MU'),
		T_TIPO_DATA('108',' MR'),
		T_TIPO_DATA('42',' MX'),
		T_TIPO_DATA('258',' FM'),
		T_TIPO_DATA('43',' MD'),
		T_TIPO_DATA('44',' MC'),
		T_TIPO_DATA('139',' MN'),
		T_TIPO_DATA('117',' MZ'),
		T_TIPO_DATA('205',' MM'),
		T_TIPO_DATA('102',' NA'),
		T_TIPO_DATA('206',' NR'),
		T_TIPO_DATA('107',' NP'),
		T_TIPO_DATA('209',' NI'),
		T_TIPO_DATA('210',' NE'),
		T_TIPO_DATA('115',' NG'),
		T_TIPO_DATA('251',' NU'),
		T_TIPO_DATA('212',' NF'),
		T_TIPO_DATA('46',' NO'),
		T_TIPO_DATA('208',' NC'),
		T_TIPO_DATA('45',' NZ'),
		T_TIPO_DATA('213',' OM'),
		T_TIPO_DATA('19',' NL'),
		T_TIPO_DATA('87',' PK'),
		T_TIPO_DATA('259',' PW'),
		T_TIPO_DATA('124',' PA'),
		T_TIPO_DATA('88',' PG'),
		T_TIPO_DATA('110',' PY'),
		T_TIPO_DATA('89',' PE'),
		T_TIPO_DATA('215',' PN'),
		T_TIPO_DATA('178',' PF'),
		T_TIPO_DATA('47',' PL'),
		T_TIPO_DATA('48',' PT'),
		T_TIPO_DATA('246',' PR'),
		T_TIPO_DATA('216',' QA'),
		T_TIPO_DATA('13',' GB'),
		T_TIPO_DATA('217',' RW'),
		T_TIPO_DATA('72',' RO'),
		T_TIPO_DATA('50',' RU'),
		T_TIPO_DATA('228',' SB'),
		T_TIPO_DATA('51',' SV'),
		T_TIPO_DATA('256',' AS'),
		T_TIPO_DATA('219',' KN'),
		T_TIPO_DATA('224',' SM'),
		T_TIPO_DATA('254',' SX'),
		T_TIPO_DATA('221',' PM'),
		T_TIPO_DATA('222',' VC'),
		T_TIPO_DATA('218',' SH'),
		T_TIPO_DATA('220',' LC'),
		T_TIPO_DATA('225',' ST'),
		T_TIPO_DATA('135',' SN'),
		T_TIPO_DATA('109',' SC'),
		T_TIPO_DATA('227',' SL'),
		T_TIPO_DATA('77',' SG'),
		T_TIPO_DATA('106',' SY'),
		T_TIPO_DATA('229',' SO'),
		T_TIPO_DATA('120',' LK'),
		T_TIPO_DATA('234',' SZ'),
		T_TIPO_DATA('141',' ZA'),
		T_TIPO_DATA('232',' SD'),
		T_TIPO_DATA('252',' SS'),
		T_TIPO_DATA('67',' SE'),
		T_TIPO_DATA('66',' CH'),
		T_TIPO_DATA('54',' SR'),
		T_TIPO_DATA('92',' TH'),
		T_TIPO_DATA('78',' TW'),
		T_TIPO_DATA('101',' TZ'),
		T_TIPO_DATA('56',' TJ'),
		T_TIPO_DATA('136',' TG'),
		T_TIPO_DATA('235',' TK'),
		T_TIPO_DATA('236',' TO'),
		T_TIPO_DATA('237',' TT'),
		T_TIPO_DATA('122',' TN'),
		T_TIPO_DATA('58',' TC'),
		T_TIPO_DATA('57',' TM'),
		T_TIPO_DATA('59',' TR'),
		T_TIPO_DATA('239',' TV'),
		T_TIPO_DATA('62',' UA'),
		T_TIPO_DATA('60',' UG'),
		T_TIPO_DATA('111',' UY'),
		T_TIPO_DATA('61',' UZ'),
		T_TIPO_DATA('240',' VU'),
		T_TIPO_DATA('261',' VA'),
		T_TIPO_DATA('95',' VE'),
		T_TIPO_DATA('15',' VN'),
		T_TIPO_DATA('154',' VG'),
		T_TIPO_DATA('241',' WF'),
		T_TIPO_DATA('243',' YE'),
		T_TIPO_DATA('169',' DJ'),
		T_TIPO_DATA('116',' ZM'),
		T_TIPO_DATA('96',' ZW')
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
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PAI
					WHERE PAI.DD_PAI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND PAI.DD_PAI_COD_ISO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND PAI.BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' para el campo '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' PAI SET
              PAI.DD_PAI_COD_ISO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''
              , PAI.USUARIOMODIFICAR = '''||V_USUARIO||'''
              , PAI.FECHAMODIFICAR = SYSDATE
            WHERE PAI.DD_PAI_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha actualizado el valor '''||TRIM(V_TMP_TIPO_DATA(2))||''' para '''||TRIM(V_TMP_TIPO_DATA(1))||'''');
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
