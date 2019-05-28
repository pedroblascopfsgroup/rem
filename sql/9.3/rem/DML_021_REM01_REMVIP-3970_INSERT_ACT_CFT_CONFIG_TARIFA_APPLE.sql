--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3970
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CFT_CONFIG_TARIFA los datos añadidos en T_ARRAY_DATA.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

ALTER SESSION SET NLS_NUMERIC_CHARACTERS = ',.';

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia actual.
  	V_NUM_MAXID NUMBER(16); -- Vble. auxiliar para almacenar el número de secuencia máxima utilizada en los registros.

    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'ACT_CFT_CONFIG_TARIFA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''REMVIP-3970'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 char);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    --	TIPO_TARIFA_CODIGO		TIPO_TRABAJO_CODIGO		TIPO_SUBTRABAJO_CODIGO		CARTERA_CODIGO		SUBCARTERA_CODIGO			PRECIO_UNITARIO			UNIDAD_MEDIDA
		T_TIPO_DATA('OM1',  '03',  '37', '07',  '138',  '34,65'  ,'€/h'),
		T_TIPO_DATA('VER1',  '03',  '36', '07',  '138',  '57,56073'  ,'€/ud'),
		T_TIPO_DATA('OM3',  '03',  '37', '07',  '138',  '21,58914'  ,'€/ud'),
		T_TIPO_DATA('OM4',  '03',  '37', '07',  '138',  '9,50582'  ,'€/ud'),
		T_TIPO_DATA('OM5',  '03',  '37', '07',  '138',  '129,56577'  ,'€/ud'),
		T_TIPO_DATA('OM6',  '03',  '37', '07',  '138',  '88,09895'  ,'€/ud'),
		T_TIPO_DATA('OM7',  '03',  '37', '07',  '138',  '87,635'  ,'€/ud'),
		T_TIPO_DATA('OM8',  '03',  '37', '07',  '138',  '117,534'  ,'€/ud'),
		T_TIPO_DATA('OM9',  '03',  '37', '07',  '138',  '92,09923'  ,'€/ml'),
		T_TIPO_DATA('OM10',  '03',  '37', '07',  '138',  '116,17308'  ,'€/ml'),
		T_TIPO_DATA('OM11',  '03',  '37', '07',  '138',  '28,07413'  ,'€/ud '),
		T_TIPO_DATA('OM12',  '03',  '37', '07',  '138',  '48,37452'  ,'€/ud '),
		T_TIPO_DATA('OM13',  '03',  '37', '07',  '138',  '64,04572'  ,'€/ud '),
		T_TIPO_DATA('OM14',  '03',  '37', '07',  '138',  '10,79457'  ,'€/ud'),
		T_TIPO_DATA('OM15',  '03',  '37', '07',  '138',  '38,43568'  ,'€/ud'),
		T_TIPO_DATA('OM16',  '03',  '37', '07',  '138',  '44,05463'  ,'€/ud'),
		T_TIPO_DATA('OM17',  '03',  '37', '07',  '138',  '60,3135'  ,'€/ud'),
		T_TIPO_DATA('OM18',  '03',  '37', '07',  '138',  '78,8715'  ,'€/ud'),
		T_TIPO_DATA('OM19',  '03',  '37', '07',  '138',  '147,9485'  ,'€/ud'),
		T_TIPO_DATA('OM20',  '03',  '37', '07',  '138',  '70,108'  ,'€/ud'),
		T_TIPO_DATA('OM21',  '03',  '37', '07',  '138',  '99,55336'  ,'€/ud'),
		T_TIPO_DATA('OM22',  '03',  '37', '07',  '138',  '140,57685'  ,'€/ud'),
		T_TIPO_DATA('OM23',  '03',  '37', '07',  '138',  '212,91181'  ,'€/ud'),
		T_TIPO_DATA('OM24',  '03',  '37', '07',  '138',  '111,8635'  ,'€/ud'),
		T_TIPO_DATA('OM25',  '03',  '37', '07',  '138',  '152,23746'  ,'€/ud '),
		T_TIPO_DATA('OM26',  '03',  '37', '07',  '138',  '90,64552'  ,'€/ud'),
		T_TIPO_DATA('OM27',  '03',  '37', '07',  '138',  '16,41352'  ,'€/ud'),
		T_TIPO_DATA('OM28',  '03',  '37', '07',  '138',  '90,64552'  ,'€/ud'),
		T_TIPO_DATA('OM29',  '03',  '37', '07',  '138',  '26,99158'  ,'€/ud'),
		T_TIPO_DATA('OM30',  '03',  '37', '07',  '138',  '25,69252'  ,'€/ud'),
		T_TIPO_DATA('OM31',  '03',  '37', '07',  '138',  '39,61102'  ,'€/ud'),
		T_TIPO_DATA('OM32',  '03',  '37', '07',  '138',  '23,6'  ,'€/ud'),
		T_TIPO_DATA('OM33',  '03',  '37', '07',  '138',  '29,6'  ,'€/ud'),
		T_TIPO_DATA('OM34',  '03',  '37', '07',  '138',  '39,178'  ,'€/ud'),
		T_TIPO_DATA('OM35',  '03',  '37', '07',  '138',  '36,28089'  ,'€/ud'),
		T_TIPO_DATA('OM36',  '03',  '37', '07',  '138',  '22,1665'  ,'€/ud'),
		T_TIPO_DATA('OM37',  '03',  '37', '07',  '138',  '21,39325'  ,'€/ud'),
		T_TIPO_DATA('OM38',  '03',  '37', '07',  '138',  '82,48'  ,'€/ud'),
		T_TIPO_DATA('OM39',  '03',  '37', '07',  '138',  '107,224'  ,'€/ud'),
		T_TIPO_DATA('OM40',  '03',  '37', '07',  '138',  '46,23004'  ,'€/ud'),
		T_TIPO_DATA('OM41',  '03',  '37', '07',  '138',  '2,96928'  ,'€/m2'),
		T_TIPO_DATA('OM42',  '03',  '37', '07',  '138',  '34,62098'  ,'€/ud'),
		T_TIPO_DATA('OM43',  '03',  '37', '07',  '138',  '3,41261'  ,'€/m2'),
		T_TIPO_DATA('OM44',  '03',  '37', '07',  '138',  '86,37718'  ,'€/ud'),
		T_TIPO_DATA('OM45',  '03',  '37', '07',  '138',  '4,14462'  ,'€/m2'),
		T_TIPO_DATA('OM46',  '03',  '37', '07',  '138',  '32,4765'  ,'€/ud'),
		T_TIPO_DATA('OM47',  '03',  '37', '07',  '138',  '4,20648'  ,'€/m2'),
		T_TIPO_DATA('OM48',  '03',  '37', '07',  '138',  '79,64475'  ,'€/ud'),
		T_TIPO_DATA('OM49',  '03',  '37', '07',  '138',  '4,9488'  ,'€/m2'),
		T_TIPO_DATA('OM50',  '03',  '37', '07',  '138',  '89,89289'  ,'€/ud'),
		T_TIPO_DATA('OM51',  '03',  '37', '07',  '138',  '6,06228'  ,'€/m2'),
		T_TIPO_DATA('OM52',  '03',  '37', '07',  '138',  '80,8304'  ,'€/ud'),
		T_TIPO_DATA('OM53',  '03',  '37', '07',  '138',  '5,155'  ,'€/m2'),
		T_TIPO_DATA('OM54',  '03',  '37', '07',  '138',  '86,8102'  ,'€/ud'),
		T_TIPO_DATA('OM55',  '03',  '37', '07',  '138',  '6,37158'  ,'€/m2'),
		T_TIPO_DATA('OM56',  '03',  '37', '07',  '138',  '40,60078'  ,'€/ud'),
		T_TIPO_DATA('OM57',  '03',  '37', '07',  '138',  '50,94171'  ,'€/ud'),
		T_TIPO_DATA('OM58',  '03',  '37', '07',  '138',  '63,4065'  ,'€/ud'),
		T_TIPO_DATA('OM59',  '03',  '37', '07',  '138',  '84,70696'  ,'€/ud'),
		T_TIPO_DATA('OM60',  '03',  '37', '07',  '138',  '24,09447'  ,'€/m2'),
		T_TIPO_DATA('OM61',  '03',  '37', '07',  '138',  '31,53829'  ,'€/ud'),
		T_TIPO_DATA('OM62',  '03',  '37', '07',  '138',  '10,05225'  ,'€/ml'),
		T_TIPO_DATA('OM63',  '03',  '37', '07',  '138',  '20,62'  ,'€/ud'),
		T_TIPO_DATA('OM64',  '03',  '37', '07',  '138',  '29,14637'  ,'€/ud'),
		T_TIPO_DATA('OM65',  '03',  '37', '07',  '138',  '22,1665'  ,'€/ud'),
		T_TIPO_DATA('OM66',  '03',  '37', '07',  '138',  '33,5075'  ,'€/ud'),
		T_TIPO_DATA('OM67',  '03',  '37', '07',  '138',  '79,9025'  ,'€/ud'),
		T_TIPO_DATA('OM68',  '03',  '37', '07',  '138',  '103,1'  ,'€/ud'),
		T_TIPO_DATA('OM69',  '03',  '37', '07',  '138',  '23,9666666666667'  ,'€/m2'),
		T_TIPO_DATA('OM70',  '03',  '37', '07',  '138',  '21,2'  ,'€/m2'),
		T_TIPO_DATA('OM71',  '03',  '37', '07',  '138',  '65,21075'  ,'€/ud'),
		T_TIPO_DATA('OM72',  '03',  '37', '07',  '138',  '66,10772'  ,'€/ud'),
		T_TIPO_DATA('OM73',  '03',  '37', '07',  '138',  '96,54284'  ,'€/ud'),
		T_TIPO_DATA('OM74',  '03',  '37', '07',  '138',  '119,70941'  ,'€/ud'),
		T_TIPO_DATA('OM75',  '03',  '37', '07',  '138',  '18,74358'  ,'€/m2'),
		T_TIPO_DATA('OM76',  '03',  '37', '07',  '138',  '12,372'  ,'€/m2'),
		T_TIPO_DATA('OM77',  '03',  '37', '07',  '138',  '8,248'  ,'€/m2'),
		T_TIPO_DATA('OM78',  '03',  '37', '07',  '138',  '8,6604'  ,'€/m2'),
		T_TIPO_DATA('OM79',  '03',  '37', '07',  '138',  '8,6604'  ,'€/m2'),
		T_TIPO_DATA('OM80',  '03',  '37', '07',  '138',  '8,248'  ,'€/m2'),
		T_TIPO_DATA('OM81',  '03',  '37', '07',  '138',  '23,74393'  ,'€/m2'),
		T_TIPO_DATA('OM82',  '03',  '37', '07',  '138',  '30,93'  ,'€/ud'),
		T_TIPO_DATA('OM83',  '03',  '37', '07',  '138',  '20,62'  ,'€/m2'),
		T_TIPO_DATA('OM84',  '03',  '37', '07',  '138',  '30,93'  ,'€/m2'),
		T_TIPO_DATA('OM85',  '03',  '37', '07',  '138',  '36,085'  ,'€/m2'),
		T_TIPO_DATA('OM86',  '03',  '37', '07',  '138',  '41,24'  ,'€/m2'),
		T_TIPO_DATA('OM87',  '03',  '37', '07',  '138',  '46,395'  ,'€/m2'),
		T_TIPO_DATA('OM88',  '03',  '37', '07',  '138',  '78,21'  ,'€/m2'),
		T_TIPO_DATA('OM89',  '03',  '37', '07',  '138',  '92,33'  ,'€/m2'),
		T_TIPO_DATA('OM90',  '03',  '37', '07',  '138',  '145,04'  ,'€/m2'),
		T_TIPO_DATA('OM91',  '03',  '37', '07',  '138',  '67,015'  ,'€/m2'),
		T_TIPO_DATA('OM92',  '03',  '37', '07',  '138',  '86,8102'  ,'€/m2'),
		T_TIPO_DATA('OM93',  '03',  '37', '07',  '138',  '94,44991'  ,'€/m2'),
		T_TIPO_DATA('OM94',  '03',  '37', '07',  '138',  '84,63479'  ,'€/m2'),
		T_TIPO_DATA('OM95',  '03',  '37', '07',  '138',  '61,97341'  ,'€/m2'),
		T_TIPO_DATA('OM96',  '03',  '37', '07',  '138',  '83,3048'  ,'€/m2'),
		T_TIPO_DATA('OM97',  '03',  '37', '07',  '138',  '95,18192'  ,'€/m2'),
		T_TIPO_DATA('OM98',  '03',  '37', '07',  '138',  '105,13107'  ,'€/m2'),
		T_TIPO_DATA('OM99',  '03',  '37', '07',  '138',  '137,123'  ,'€/m2'),
		T_TIPO_DATA('OM100',  '03',  '37', '07',  '138',  '341,69402'  ,'€/m2'),
		T_TIPO_DATA('OM101',  '03',  '37', '07',  '138',  '90,82'  ,'€/m2'),
		T_TIPO_DATA('OM102',  '03',  '37', '07',  '138',  '107,33'  ,'€/m2'),
		T_TIPO_DATA('OM103',  '03',  '37', '07',  '138',  '120,91568'  ,'€/m2'),
		T_TIPO_DATA('OM104',  '03',  '37', '07',  '138',  '104,4403'  ,'€/m2'),
		T_TIPO_DATA('OM105',  '03',  '37', '07',  '138',  '146,83502'  ,'€/m2'),
		T_TIPO_DATA('OM106',  '03',  '37', '07',  '138',  '209,83943'  ,'€/m2'),
		T_TIPO_DATA('OM107',  '03',  '37', '07',  '138',  '14,89795'  ,'€/ud'),
		T_TIPO_DATA('OM108',  '03',  '37', '07',  '138',  '4,10338'  ,'€/ud'),
		T_TIPO_DATA('OM109',  '03',  '37', '07',  '138',  '5,83546'  ,'€/ud'),
		T_TIPO_DATA('OM110',  '03',  '37', '07',  '138',  '22,69231'  ,'€/ud'),
		T_TIPO_DATA('OM111',  '03',  '37', '07',  '138',  '37,76553'  ,'€/ud'),
		T_TIPO_DATA('OM112',  '03',  '37', '07',  '138',  '35,86849'  ,'€/ud'),
		T_TIPO_DATA('OM113',  '03',  '37', '07',  '138',  '43,07518'  ,'€/ud'),
		T_TIPO_DATA('OM114',  '03',  '37', '07',  '138',  '56,46787'  ,'€/ud'),
		T_TIPO_DATA('OM115',  '03',  '37', '07',  '138',  '69,20072'  ,'€/ud'),
		T_TIPO_DATA('OM116',  '03',  '37', '07',  '138',  '67,12841'  ,'€/ud'),
		T_TIPO_DATA('OM117',  '03',  '37', '07',  '138',  '60,28257'  ,'€/ud'),
		T_TIPO_DATA('OM118',  '03',  '37', '07',  '138',  '66,57167'  ,'€/ud'),
		T_TIPO_DATA('OM119',  '03',  '37', '07',  '138',  '77,38686'  ,'€/ud'),
		T_TIPO_DATA('OM120',  '03',  '37', '07',  '138',  '24,48625'  ,'€/ud'),
		T_TIPO_DATA('OM121',  '03',  '37', '07',  '138',  '20,42411'  ,'€/ud'),
		T_TIPO_DATA('OM122',  '03',  '37', '07',  '138',  '27,2184'  ,'€/ud'),
		T_TIPO_DATA('OM123',  '03',  '37', '07',  '138',  '31,53829'  ,'€/ud'),
		T_TIPO_DATA('OM124',  '03',  '37', '07',  '138',  '36,02314'  ,'€/ud'),
		T_TIPO_DATA('OM125',  '03',  '37', '07',  '138',  '5,59833'  ,'€/ml'),
		T_TIPO_DATA('OM126',  '03',  '37', '07',  '138',  '6,91801'  ,'€/ml'),
		T_TIPO_DATA('OM127',  '03',  '37', '07',  '138',  '10,86674'  ,'€/ml'),
		T_TIPO_DATA('OM128',  '03',  '37', '07',  '138',  '8,71195'  ,'€/ml'),
		T_TIPO_DATA('OM129',  '03',  '37', '07',  '138',  '9,94915'  ,'€/ml'),
		T_TIPO_DATA('OM130',  '03',  '37', '07',  '138',  '25,26981'  ,'€/ud'),
		T_TIPO_DATA('OM131',  '03',  '37', '07',  '138',  '60,49908'  ,'€/ud'),
		T_TIPO_DATA('OM132',  '03',  '37', '07',  '138',  '80,49908'  ,'€/ud'),
		T_TIPO_DATA('OM133',  '03',  '37', '07',  '138',  '142,11304'  ,'€/ud'),
		T_TIPO_DATA('OM134',  '03',  '37', '07',  '138',  '210,28276'  ,'€/ud'),
		T_TIPO_DATA('OM135',  '03',  '37', '07',  '138',  '36,40461'  ,'€/ud'),
		T_TIPO_DATA('OM136',  '03',  '37', '07',  '138',  '42,80712'  ,'€/ud'),
		T_TIPO_DATA('OM137',  '03',  '37', '07',  '138',  '68,81925'  ,'€/ud'),
		T_TIPO_DATA('OM138',  '03',  '37', '07',  '138',  '42,271'  ,'€/ud'),
		T_TIPO_DATA('CM-CER1',  '03',  '26', '07',  '138',  '77,7374'  ,'€/ud'),
		T_TIPO_DATA('CM-CER2',  '03',  '26', '07',  '138',  '113,28628'  ,'€/ud'),
		T_TIPO_DATA('CM-CER3',  '03',  '26', '07',  '138',  '127,02951'  ,'€/ud'),
		T_TIPO_DATA('CM-CER4',  '03',  '26', '07',  '138',  '169,69229'  ,'€/ud'),
		T_TIPO_DATA('CM-CER5',  '03',  '26', '07',  '138',  '89,85165'  ,'€/ud'),
		T_TIPO_DATA('CM-CER6',  '03',  '26', '07',  '138',  '43,302'  ,'€/ud'),
		T_TIPO_DATA('OM145',  '03',  '37', '07',  '138',  '28,07413'  ,'€/ud'),
		T_TIPO_DATA('OM146',  '03',  '37', '07',  '138',  '41,24'  ,'€/ud'),
		T_TIPO_DATA('OM147',  '03',  '37', '07',  '138',  '49,23025'  ,'€/ud'),
		T_TIPO_DATA('OM148',  '03',  '37', '07',  '138',  '56,14826'  ,'€/ud'),
		T_TIPO_DATA('OM149',  '03',  '37', '07',  '138',  '24,9502'  ,'€/ud'),
		T_TIPO_DATA('OM150',  '03',  '37', '07',  '138',  '31,1362'  ,'€/ud'),
		T_TIPO_DATA('OM151',  '03',  '37', '07',  '138',  '39,7966'  ,'€/ud'),
		T_TIPO_DATA('OM152',  '03',  '37', '07',  '138',  '47,68375'  ,'€/ud'),
		T_TIPO_DATA('OM153',  '03',  '37', '07',  '138',  '25,775'  ,'€/ud'),
		T_TIPO_DATA('OM154',  '03',  '37', '07',  '138',  '30,93'  ,'€/ud'),
		T_TIPO_DATA('OM155',  '03',  '37', '07',  '138',  '41,24'  ,'€/ud'),
		T_TIPO_DATA('OM156',  '03',  '37', '07',  '138',  '50,61179'  ,'€/ud'),
		T_TIPO_DATA('OM157',  '03',  '37', '07',  '138',  '36,085'  ,'€/ud'),
		T_TIPO_DATA('OM158',  '03',  '37', '07',  '138',  '24,5378'  ,'€/ud'),
		T_TIPO_DATA('OM159',  '03',  '37', '07',  '138',  '25,775'  ,'€/ud'),
		T_TIPO_DATA('OM160',  '03',  '37', '07',  '138',  '18,7642'  ,'€/ud'),
		T_TIPO_DATA('OM161',  '03',  '37', '07',  '138',  '27,20809'  ,'€/ud'),
		T_TIPO_DATA('OM162',  '03',  '37', '07',  '138',  '19,43435'  ,'€/ud'),
		T_TIPO_DATA('OM163',  '03',  '37', '07',  '138',  '6,76336'  ,'€/ud'),
		T_TIPO_DATA('OM164',  '03',  '37', '07',  '138',  '30,90938'  ,'€/ud'),
		T_TIPO_DATA('OM165',  '03',  '37', '07',  '138',  '30,90938'  ,'€/ud'),
		T_TIPO_DATA('OM166',  '03',  '37', '07',  '138',  '22,7851'  ,'€/ud'),
		T_TIPO_DATA('OM167',  '03',  '37', '07',  '138',  '6,47468'  ,'€/m2'),
		T_TIPO_DATA('OM168',  '03',  '37', '07',  '138',  '178,23928'  ,'€/ud'),
		T_TIPO_DATA('OM169',  '03',  '37', '07',  '138',  '13,403'  ,'€/m2'),
		T_TIPO_DATA('OM170',  '03',  '37', '07',  '138',  '25,16671'  ,'€/m2'),
		T_TIPO_DATA('OM171',  '03',  '37', '07',  '138',  '49,7973'  ,'€/m2'),
		T_TIPO_DATA('OM172',  '03',  '37', '07',  '138',  '35,83756'  ,'€/m2'),
		T_TIPO_DATA('OM173',  '03',  '37', '07',  '138',  '61,38574'  ,'€/m2'),
		T_TIPO_DATA('OM174',  '03',  '37', '07',  '138',  '43,302'  ,'€/m2'),
		T_TIPO_DATA('OM175',  '03',  '37', '07',  '138',  '41,24'  ,'€/m2'),
		T_TIPO_DATA('OM176',  '03',  '37', '07',  '138',  '73,77836'  ,'€/m2'),
		T_TIPO_DATA('OM177',  '03',  '37', '07',  '138',  '76,86105'  ,'€/m2'),
		T_TIPO_DATA('OM178',  '03',  '37', '07',  '138',  '5,89732'  ,'€/ml'),
		T_TIPO_DATA('OM179',  '03',  '37', '07',  '138',  '7,48506'  ,'€/ml'),
		T_TIPO_DATA('OM180',  '03',  '37', '07',  '138',  '8,69133'  ,'€/ml'),
		T_TIPO_DATA('OM181',  '03',  '37', '07',  '138',  '3,51571'  ,'€/ml'),
		T_TIPO_DATA('OM182',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM183',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM184',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM185',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM186',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM187',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM188',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM189',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM190',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM191',  '03',  '37', '07',  '138',  '18,94978'  ,'€/h'),
		T_TIPO_DATA('OM192',  '03',  '37', '07',  '138',  '17,6301'  ,'€/h'),
		T_TIPO_DATA('OM193',  '03',  '37', '07',  '138',  '16,23825'  ,'€/h'),
		T_TIPO_DATA('OM194',  '03',  '37', '07',  '138',  '28,1463'  ,'€/h'),
		T_TIPO_DATA('OM195',  '03',  '37', '07',  '138',  '20,94992'  ,'€/h'),
		T_TIPO_DATA('OM196',  '03',  '37', '07',  '138',  '17,3208'  ,'€/h'),
		T_TIPO_DATA('OM197',  '03',  '37', '07',  '138',  '16,78468'  ,'€/h'),
		T_TIPO_DATA('OM198',  '03',  '37', '07',  '138',  '16,23825'  ,'€/h'),
		T_TIPO_DATA('OM199',  '03',  '37', '07',  '138',  '16,23825'  ,'€/h'),
		T_TIPO_DATA('OM200',  '03',  '37', '07',  '138',  '125'  ,'€/h'),
		T_TIPO_DATA('OM201',  '03',  '37', '07',  '138',  '75,25'  ,'€/h'),
		T_TIPO_DATA('OM202',  '03',  '37', '07',  '138',  '42,50813'  ,'€/h'),
		T_TIPO_DATA('OM203',  '03',  '37', '07',  '138',  '0,36'  ,'€/m2'),
		T_TIPO_DATA('OM204',  '03',  '37', '07',  '138',  '0,77'  ,'€/m2'),
		T_TIPO_DATA('SOL1',  '03',  '32', '07',  '138',  '35'  ,'€/m3'),
		T_TIPO_DATA('OM206',  '03',  '37', '07',  '138',  '0,12'  ,'€/m2'),
		T_TIPO_DATA('OM207',  '03',  '37', '07',  '138',  '2,63936'  ,'€/m2'),
		T_TIPO_DATA('OM208',  '03',  '37', '07',  '138',  '17,78475'  ,'€/ml'),
		T_TIPO_DATA('OM209',  '03',  '37', '07',  '138',  '54,3'  ,'€/ml'),
		T_TIPO_DATA('OM210',  '03',  '37', '07',  '138',  '179,666666666667'  ,'€/ud'),
		T_TIPO_DATA('OM211',  '03',  '37', '07',  '138',  '280'  ,'€/ud'),
		T_TIPO_DATA('OM212',  '03',  '37', '07',  '138',  '66,75725'  ,'€/ud'),
		T_TIPO_DATA('OM213',  '03',  '37', '07',  '138',  '194,49815'  ,'€/ud'),
		T_TIPO_DATA('OM214',  '03',  '37', '07',  '138',  '120,365'  ,'€/ud'),
		T_TIPO_DATA('OM215',  '03',  '37', '07',  '138',  '166,666666666667'  ,'€/ud'),
		T_TIPO_DATA('SOL2',  '03',  '32', '07',  '138',  '256,066666666667'  ,'€/ud'),
		T_TIPO_DATA('SOL3',  '03',  '32', '07',  '138',  '264,316666666667'  ,'€/ud'),
		T_TIPO_DATA('OM218',  '03',  '37', '07',  '138',  '19,3243333333333'  ,'€/m2'),
		T_TIPO_DATA('OM219',  '03',  '37', '07',  '138',  '11,9466666666667'  ,'€/m2'),
		T_TIPO_DATA('OM220',  '03',  '37', '07',  '138',  '14,9333333333333'  ,'€/m2'),
		T_TIPO_DATA('OM221',  '03',  '37', '07',  '138',  '21,3333333333333'  ,'€/m2'),
		T_TIPO_DATA('OTR2',  '02',  '25', '07',  '138',  '38,5'  ,'€/h'),
		T_TIPO_DATA('OTR1',  '02',  '25', '07',  '138',  '45,5'  ,'€/h'),
		T_TIPO_DATA('BOL4',  '02',  '22', '07',  '138',  '90'  ,'€/ud'),
		T_TIPO_DATA('BOL5',  '02',  '24', '07',  '138',  '120'  ,'€/ud'),
		T_TIPO_DATA('CED1',  '02',  '20', '07',  '138',  '103,1'  ,'€/ud'),
		T_TIPO_DATA('CED2',  '02',  '20', '07',  '138',  '40'  ,'€/ud'),
		T_TIPO_DATA('INF4',  '02',  '14', '07',  '138',  '21,651'  ,'€/ud'),
		T_TIPO_DATA('OM229',  '03',  '37', '07',  '138',  '119,0805'  ,'€/ud'),
		T_TIPO_DATA('OM230',  '03',  '37', '07',  '138',  '107,224'  ,'€/ud'),
		T_TIPO_DATA('OM231',  '03',  '37', '07',  '138',  '34,60036'  ,'€/ud'),
		T_TIPO_DATA('OM232',  '03',  '37', '07',  '138',  '31,91976'  ,'€/ud'),
		T_TIPO_DATA('OM233',  '03',  '37', '07',  '138',  '355,2'  ,'€/ud'),
		T_TIPO_DATA('OM234',  '03',  '37', '07',  '138',  '220,64'  ,'€/ud'),
		T_TIPO_DATA('OM235',  '03',  '37', '07',  '138',  '288,066666666667'  ,'€/ud'),
		T_TIPO_DATA('OM236',  '03',  '37', '07',  '138',  '216,51'  ,'€/ud'),
		T_TIPO_DATA('OM237',  '03',  '37', '07',  '138',  '61,86'  ,'€/ud'),
		T_TIPO_DATA('OM238',  '03',  '37', '07',  '138',  '30,93'  ,'€/ud'),
		T_TIPO_DATA('OM239',  '03',  '37', '07',  '138',  '162,30002'  ,'€/ud'),
		T_TIPO_DATA('OM240',  '03',  '37', '07',  '138',  '9,279'  ,'€/ud'),
		T_TIPO_DATA('OM241',  '03',  '37', '07',  '138',  '90,1983333333333'  ,'€/ud'),
		T_TIPO_DATA('OM242',  '03',  '37', '07',  '138',  '74,1081666666667'  ,'€/ud'),
		T_TIPO_DATA('OM243',  '03',  '37', '07',  '138',  '135,416666666667'  ,'€/ud'),
		T_TIPO_DATA('OM244',  '03',  '37', '07',  '138',  '30,925'  ,'€/ud'),
		T_TIPO_DATA('OM245',  '03',  '37', '07',  '138',  '39,0315'  ,'€/ud'),
		T_TIPO_DATA('OM246',  '03',  '37', '07',  '138',  '9,279'  ,'€/ud'),
		T_TIPO_DATA('OM247',  '03',  '37', '07',  '138',  '40'  ,'€/ud'),
		T_TIPO_DATA('OM248',  '03',  '37', '07',  '138',  '5,6705'  ,'€/m2'),
		T_TIPO_DATA('OM249',  '03',  '37', '07',  '138',  '5,6705'  ,'€/m2'),
		T_TIPO_DATA('OM250',  '03',  '37', '07',  '138',  '49,488'  ,'€/ud'),
		T_TIPO_DATA('OM251',  '03',  '37', '07',  '138',  '1488,33333333333'  ,'€/ud'),
		T_TIPO_DATA('OM252',  '03',  '37', '07',  '138',  '788,715'  ,'€/ud'),
		T_TIPO_DATA('OM253',  '03',  '37', '07',  '138',  '23'  ,'€/m2'),
		T_TIPO_DATA('OM254',  '03',  '37', '07',  '138',  '34'  ,'€/m2'),
		T_TIPO_DATA('OM255',  '03',  '37', '07',  '138',  '10,7366666666667'  ,'€/m2'),
		T_TIPO_DATA('OM256',  '03',  '37', '07',  '138',  '20,47566'  ,'€/m2'),
		T_TIPO_DATA('OM257',  '03',  '37', '07',  '138',  '73,7165'  ,'€/m2'),
		T_TIPO_DATA('OM258',  '03',  '37', '07',  '138',  '73,62371'  ,'€/m2'),
		T_TIPO_DATA('OM259',  '03',  '37', '07',  '138',  '14,1173333333333'  ,'€/ud'),
		T_TIPO_DATA('OM260',  '03',  '37', '07',  '138',  '92,6869'  ,'€/ud'),
		T_TIPO_DATA('OM261',  '03',  '37', '07',  '138',  '8,29955'  ,'€/ud'),
		T_TIPO_DATA('OM262',  '03',  '37', '07',  '138',  '241,29524'  ,'€/ud'),
		T_TIPO_DATA('OM263',  '03',  '37', '07',  '138',  '350,75651'  ,'€/ud'),
		T_TIPO_DATA('OM264',  '03',  '37', '07',  '138',  '80,7273'  ,'€/ud'),
		T_TIPO_DATA('OM265',  '03',  '37', '07',  '138',  '90,4187'  ,'€/ud'),
		T_TIPO_DATA('OM266',  '03',  '37', '07',  '138',  '216,86054'  ,'€/m2'),
		T_TIPO_DATA('OM267',  '03',  '37', '07',  '138',  '236,00621'  ,'€/m2'),
		T_TIPO_DATA('OM268',  '03',  '37', '07',  '138',  '80,42831'  ,'€/ud'),
		T_TIPO_DATA('OM269',  '03',  '37', '07',  '138',  '33,73432'  ,'€/m2'),
		T_TIPO_DATA('OM270',  '03',  '37', '07',  '138',  '19,3828'  ,'€/ml'),
		T_TIPO_DATA('OM271',  '03',  '37', '07',  '138',  '13,51'  ,'€/m2'),
		T_TIPO_DATA('OM272',  '03',  '37', '07',  '138',  '53,12743'  ,'€/ud'),
		T_TIPO_DATA('OM273',  '03',  '37', '07',  '138',  '22,88'  ,'€/m2'),
		T_TIPO_DATA('OM274',  '03',  '37', '07',  '138',  '24,5086666666667'  ,'€/m2'),
		T_TIPO_DATA('OM275',  '03',  '37', '07',  '138',  '73,4716666666666'  ,'€/ml'),
		T_TIPO_DATA('OM276',  '03',  '37', '07',  '138',  '82,83054'  ,'€/m2'),
		T_TIPO_DATA('OM277',  '03',  '37', '07',  '138',  '175,27'  ,'€/ud'),
		T_TIPO_DATA('OM278',  '03',  '37', '07',  '138',  '350,54'  ,'€/ud'),
		T_TIPO_DATA('OM279',  '03',  '37', '07',  '138',  '1,84'  ,'€/ud'),
		T_TIPO_DATA('OM280',  '03',  '37', '07',  '138',  '4,7'  ,'€/ud'),
		T_TIPO_DATA('OM281',  '03',  '37', '07',  '138',  '19,83644'  ,'€/m2'),
		T_TIPO_DATA('OM282',  '03',  '37', '07',  '138',  '27,56'  ,'€/m2'),
		T_TIPO_DATA('OM283',  '03',  '37', '07',  '138',  '2,06866666666667'  ,'€/ml'),
		T_TIPO_DATA('OM284',  '03',  '37', '07',  '138',  '3,04145'  ,'€/ml'),
		T_TIPO_DATA('OM285',  '03',  '37', '07',  '138',  '56,88027'  ,'€/ud'),
		T_TIPO_DATA('OM286',  '03',  '37', '07',  '138',  '46,0013333333333'  ,'€/ud'),
		T_TIPO_DATA('OM287',  '03',  '37', '07',  '138',  '121,55'  ,'€/ud'),
		T_TIPO_DATA('OM288',  '03',  '37', '07',  '138',  '36,085'  ,'€/ud'),
		T_TIPO_DATA('OM289',  '03',  '37', '07',  '138',  '118,58562'  ,'€/ud'),
		T_TIPO_DATA('OM290',  '03',  '37', '07',  '138',  '75,72695'  ,'€/ud'),
		T_TIPO_DATA('OM291',  '03',  '37', '07',  '138',  '570,35951'  ,'€/ud'),
		T_TIPO_DATA('OM292',  '03',  '37', '07',  '138',  '455,91851'  ,'€/ud'),
		T_TIPO_DATA('OM293',  '03',  '37', '07',  '138',  '170,36244'  ,'€/ud'),
		T_TIPO_DATA('OM294',  '03',  '37', '07',  '138',  '110,27576'  ,'€/m3'),
		T_TIPO_DATA('OM295',  '03',  '37', '07',  '138',  '7,43351'  ,'€/m2'),
		T_TIPO_DATA('OM296',  '03',  '37', '07',  '138',  '8,11397'  ,'€/m3'),
		T_TIPO_DATA('OM297',  '03',  '37', '07',  '138',  '14,3309'  ,'€/m3'),
		T_TIPO_DATA('OM298',  '03',  '37', '07',  '138',  '3,48478'  ,'€/m3'),
		T_TIPO_DATA('OM299',  '03',  '37', '07',  '138',  '15,88771'  ,'€/m3'),
		T_TIPO_DATA('OM300',  '03',  '37', '07',  '138',  '109,1829'  ,'€/ud'),
		T_TIPO_DATA('OM301',  '03',  '37', '07',  '138',  '47,37445'  ,'€/ud'),
		T_TIPO_DATA('OM302',  '03',  '37', '07',  '138',  '240,5323'  ,'€/ud'),
		T_TIPO_DATA('OM303',  '03',  '37', '07',  '138',  '8,248'  ,'€/m2'),
		T_TIPO_DATA('OM304',  '03',  '37', '07',  '138',  '7,5'  ,'€/ud'),
		T_TIPO_DATA('OM305',  '03',  '37', '07',  '138',  '20'  ,'€/ud'),
		T_TIPO_DATA('OM306',  '03',  '37', '07',  '138',  '20'  ,'€/ud'),
		T_TIPO_DATA('OM307',  '03',  '37', '07',  '138',  '35'  ,'€/ud'),
		T_TIPO_DATA('OM308',  '03',  '37', '07',  '138',  '75'  ,'€/ud'),
		T_TIPO_DATA('OM309',  '03',  '37', '07',  '138',  '48,25'  ,'€/ud'),
		T_TIPO_DATA('OM310',  '03',  '37', '07',  '138',  '175'  ,'€/ud'),
		T_TIPO_DATA('OM311',  '03',  '37', '07',  '138',  '245,6'  ,'€/ud'),
		T_TIPO_DATA('OM312',  '03',  '37', '07',  '138',  '557,51'  ,'€/ud'),
		T_TIPO_DATA('OM313',  '03',  '37', '07',  '138',  '5,11'  ,'€/ml'),
		T_TIPO_DATA('OM314',  '03',  '37', '07',  '138',  '3,5'  ,'€/ud'),
		T_TIPO_DATA('OM315',  '03',  '37', '07',  '138',  '5'  ,'€/ud'),
		T_TIPO_DATA('OM316',  '03',  '37', '07',  '138',  '51,01'  ,'€/m2'),
		T_TIPO_DATA('OM317',  '03',  '37', '07',  '138',  '3,47'  ,'€/m2'),
		T_TIPO_DATA('OM318',  '03',  '37', '07',  '138',  '45'  ,'€/ud'),
		T_TIPO_DATA('OM319',  '03',  '37', '07',  '138',  '250'  ,'€/ud'),
		T_TIPO_DATA('OM320',  '03',  '37', '07',  '138',  '315'  ,'€/ud'),
		T_TIPO_DATA('OM321',  '03',  '37', '07',  '138',  '8,3'  ,'€/ml'),
		T_TIPO_DATA('OM322',  '03',  '37', '07',  '138',  '29,22'  ,'€/ml'),
		T_TIPO_DATA('OM323',  '03',  '37', '07',  '138',  '29,22'  ,'€/ml'),
		T_TIPO_DATA('OM324',  '03',  '37', '07',  '138',  '32,47'  ,'€/ml'),
		T_TIPO_DATA('OM325',  '03',  '37', '07',  '138',  '0,04'  ,'%PEM'),
		T_TIPO_DATA('OM326',  '03',  '37', '07',  '138',  '0,03'  ,'%PEM'),
		T_TIPO_DATA('OTR3',  '02',  '25', '07',  '138',  '400'  ,'€/ud'),
		T_TIPO_DATA('OTR4',  '02',  '25', '07',  '138',  '0,04'  ,'%PEM'),
		T_TIPO_DATA('OTR5',  '02',  '25', '07',  '138',  '0,07'  ,'%PEM'),
		T_TIPO_DATA('OTR6',  '02',  '25', '07',  '138',  '0,05'  ,'%PEM'),
		T_TIPO_DATA('OM331',  '03',  '37', '07',  '138',  '250'  ,'€/ud'),
		T_TIPO_DATA('OM332',  '03',  '37', '07',  '138',  '0,0115'  ,'%PEM'),
		T_TIPO_DATA('OTR7',  '02',  '25', '07',  '138',  '300'  ,'€/dia'),
		T_TIPO_DATA('OM334',  '03',  '37', '07',  '138',  '120'  ,'€/ud'),
		T_TIPO_DATA('OM335',  '03',  '37', '07',  '138',  '360'  ,'€/ud'),
		T_TIPO_DATA('OM336',  '03',  '37', '07',  '138',  '75'  ,'€/ud'),
		T_TIPO_DATA('OM337',  '03',  '37', '07',  '138',  '12,1'  ,'€/ud'),
		T_TIPO_DATA('OM338',  '03',  '37', '07',  '138',  '27,15'  ,'€/ud'),
		T_TIPO_DATA('OM339',  '03',  '37', '07',  '138',  '8,3'  ,'€/ud'),
		T_TIPO_DATA('OM340',  '03',  '37', '07',  '138',  '60'  ,'€/ud'),
		T_TIPO_DATA('OM341',  '03',  '37', '07',  '138',  '55,96'  ,'€/ud'),
		T_TIPO_DATA('OM342',  '03',  '37', '07',  '138',  '439,2'  ,'€/ud'),
		T_TIPO_DATA('OM343',  '03',  '37', '07',  '138',  '549,31'  ,'€/ud'),
		T_TIPO_DATA('OM344',  '03',  '37', '07',  '138',  '658,8'  ,'€/ud'),
		T_TIPO_DATA('OM345',  '03',  '37', '07',  '138',  '823,5'  ,'€/ud'),
		T_TIPO_DATA('OM346',  '03',  '37', '07',  '138',  '220'  ,'€/ud'),
		T_TIPO_DATA('OM347',  '03',  '37', '07',  '138',  '250'  ,'€/ud'),
		T_TIPO_DATA('OM348',  '03',  '37', '07',  '138',  '250'  ,'€/ud'),
		T_TIPO_DATA('OM349',  '03',  '37', '07',  '138',  '750'  ,'€/ud'),
		T_TIPO_DATA('OM350',  '03',  '37', '07',  '138',  '72,75'  ,'€/ud'),
		T_TIPO_DATA('BOL8',  '02',  '23', '07',  '138',  '550'  ,'€/ud'),
		T_TIPO_DATA('OM352',  '03',  '37', '07',  '138',  '150'  ,'€/ud'),
		T_TIPO_DATA('OM353',  '03',  '37', '07',  '138',  '1755'  ,'€/ud'),
		T_TIPO_DATA('OM354',  '03',  '37', '07',  '138',  '2003'  ,'€/ud'),
		T_TIPO_DATA('OM355',  '03',  '37', '07',  '138',  '1955'  ,'€/ud'),
		T_TIPO_DATA('OM356',  '03',  '37', '07',  '138',  '2203'  ,'€/ud'),
		T_TIPO_DATA('OM357',  '03',  '37', '07',  '138',  '2038,74'  ,'€/ud'),
		T_TIPO_DATA('OM358',  '03',  '37', '07',  '138',  '2328,14'  ,'€/ud'),
		T_TIPO_DATA('OM359',  '03',  '37', '07',  '138',  '2339,99'  ,'€/ud'),
		T_TIPO_DATA('OM360',  '03',  '37', '07',  '138',  '2629,39'  ,'€/ud'),
		T_TIPO_DATA('OM361',  '03',  '37', '07',  '138',  '6,1'  ,'€/ml'),
		T_TIPO_DATA('OM362',  '03',  '37', '07',  '138',  '5,09'  ,'€/ml'),
		T_TIPO_DATA('OM363',  '03',  '37', '07',  '138',  '5,09'  ,'€/ml'),
		T_TIPO_DATA('OM364',  '03',  '37', '07',  '138',  '1,91'  ,'€/m2'),
		T_TIPO_DATA('OM365',  '03',  '37', '07',  '138',  '8,248'  ,'€/m2'),
		T_TIPO_DATA('OM366',  '03',  '37', '07',  '138',  '33,51'  ,'€/ud'),
		T_TIPO_DATA('OM367',  '03',  '37', '07',  '138',  '21,81'  ,'€/m2'),
		T_TIPO_DATA('OM368',  '03',  '37', '07',  '138',  '30,63'  ,'€/m2'),
		T_TIPO_DATA('BOL1',  '02',  '23', '07',  '138',  '150'  ,'€/ud'),
		T_TIPO_DATA('BOL2',  '02',  '23', '07',  '138',  '257,75'  ,'€/ud'),
		T_TIPO_DATA('BOL3',  '02',  '23', '07',  '138',  '412,4'  ,'€/ud'),
		T_TIPO_DATA('OM372',  '03',  '37', '07',  '138',  '412,4'  ,'€/ud'),
		T_TIPO_DATA('OM373',  '03',  '37', '07',  '138',  '412,4'  ,'€/ud'),
		T_TIPO_DATA('OM374',  '03',  '37', '07',  '138',  '300'  ,'€/ud'),
		T_TIPO_DATA('OM375',  '03',  '37', '07',  '138',  '258,41'  ,'€/ml'),
		T_TIPO_DATA('OM376',  '03',  '37', '07',  '138',  '145,166666666667'  ,'€/ml'),
		T_TIPO_DATA('OM377',  '03',  '37', '07',  '138',  '58,767'  ,'€/ml'),
		T_TIPO_DATA('OM378',  '03',  '37', '07',  '138',  '157,743'  ,'€/ud'),
		T_TIPO_DATA('OM379',  '03',  '37', '07',  '138',  '210,324'  ,'€/ud'),
		T_TIPO_DATA('OM380',  '03',  '37', '07',  '138',  '262,905'  ,'€/ud'),
		T_TIPO_DATA('OM381',  '03',  '37', '07',  '138',  '265,65'  ,'€/ud'),
		T_TIPO_DATA('OM382',  '03',  '37', '07',  '138',  '165,75'  ,'€/ud'),
		T_TIPO_DATA('OM383',  '03',  '37', '07',  '138',  '184,0335'  ,'€/ud'),
		T_TIPO_DATA('OM384',  '03',  '37', '07',  '138',  '113,9255'  ,'€/ud'),
		T_TIPO_DATA('OM385',  '03',  '37', '07',  '138',  '131,4525'  ,'€/ud'),
		T_TIPO_DATA('OM386',  '03',  '37', '07',  '138',  '157,743'  ,'€/ud'),
		T_TIPO_DATA('OM387',  '03',  '37', '07',  '138',  '227,851'  ,'€/ud'),
		T_TIPO_DATA('OM388',  '03',  '37', '07',  '138',  '21,90875'  ,'€/ud'),
		T_TIPO_DATA('OM389',  '03',  '37', '07',  '138',  '39,43575'  ,'€/ud'),
		T_TIPO_DATA('OM390',  '03',  '37', '07',  '138',  '74,48975'  ,'€/ud'),
		T_TIPO_DATA('CEE1',  '02',  '18', '07',  '138',  '70'  ,'(1-30) €/unidad'),
		T_TIPO_DATA('CEE10',  '02',  '18', '07',  '138',  '730'  ,'Más de 121 €/promoción'),
		T_TIPO_DATA('CEE11',  '02',  '18', '07',  '138',  '550'  ,'(4-30) €/promoción'),
		T_TIPO_DATA('CEE12',  '02',  '18', '07',  '138',  '660'  ,'(31-60) €/promoción'),
		T_TIPO_DATA('CEE13',  '02',  '18', '07',  '138',  '760'  ,'(61-120) €/promoción'),
		T_TIPO_DATA('CEE14',  '02',  '18', '07',  '138',  '840'  ,'Más de 121 €/promoción'),
		T_TIPO_DATA('CEE15',  '02',  '18', '07',  '138',  '101'  ,'< 10 Oficinas €/unidad'),
		T_TIPO_DATA('CEE16',  '02',  '18', '07',  '138',  '94'  ,'(10-50) €/unidad'),
		T_TIPO_DATA('CEE17',  '02',  '18', '07',  '138',  '87'  ,'> 50 €/unidad'),
		T_TIPO_DATA('CEE18',  '02',  '18', '07',  '138',  '113'  ,'<10 €/unidad'),
		T_TIPO_DATA('CEE19',  '02',  '18', '07',  '138',  '104'  ,'(10-50) €/unidad'),
		T_TIPO_DATA('CEE2',  '02',  '18', '07',  '138',  '70'  ,'(31-60) €/unidad'),
		T_TIPO_DATA('CEE20',  '02',  '18', '07',  '138',  '97'  ,'>50 €/unidad'),
		T_TIPO_DATA('CEE3',  '02',  '18', '07',  '138',  '70'  ,'Más de 60 €/unidad'),
		T_TIPO_DATA('CEE4',  '02',  '18', '07',  '138',  '70'  ,'(1-30) €/unidad'),
		T_TIPO_DATA('CEE5',  '02',  '18', '07',  '138',  '70'  ,'(31-60) €/unidad'),
		T_TIPO_DATA('CEE6',  '02',  '18', '07',  '138',  '70'  ,'Más de 60 €/unidad'),
		T_TIPO_DATA('CEE7',  '02',  '18', '07',  '138',  '450'  ,'(4-30) €/promoción'),
		T_TIPO_DATA('CEE8',  '02',  '18', '07',  '138',  '550'  ,'(31-60) €/promoción'),
		T_TIPO_DATA('CEE9',  '02',  '18', '07',  '138',  '590'  ,'(61-120) €/promoción'),
		T_TIPO_DATA('AP-VACI-LIMP-CER1',  '03',  '31', '07',  '138',  '1038'  ,'€/unidad'),
		T_TIPO_DATA('AP-VACI-LIMP-CER2',  '03',  '31', '07',  '138',  '336'  ,'€/unidad'),
		T_TIPO_DATA('AP-VACI-LIMP-CER3',  '03',  '31', '07',  '138',  '222'  ,'€/unidad'),
		T_TIPO_DATA('AP-VACI-LIMP-CER4',  '03',  '31', '07',  '138',  '60'  ,'€/unidad')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	/*
	--BORRAMOS TODO EL TARIFARIO PREVIO QUE HUBIERA PARA APPLE:
	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA T1 
			   WHERE EXISTS (
					SELECT 1 
					FROM '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA CFT
					JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA                 CRA ON CRA.DD_CRA_ID = CFT.DD_CRA_ID 
					JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA              SCR ON SCR.DD_SCR_ID = CFT.DD_SCR_ID 
					WHERE CRA.DD_CRA_CODIGO IN (''07'')
					  AND SCR.DD_SCR_CODIGO IN (''138'')
					  AND CFT.CFT_ID = T1.CFT_ID
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO]: '||sql%rowcount||' Tarifas de APPLE borradas.');
	*/

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		-- Comprobar el dato a insertar.
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE DD_TTF_ID = (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''') '||
		'AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''') '||
		'AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''') '||
		'AND DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''') '||
		'AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||''')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

			-- Comprobar secuencias de la tabla.
			V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
		
			V_SQL := 'SELECT NVL(MAX(CFT_ID), 0) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||'';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
			   
			WHILE V_NUM_SEQUENCE <= V_NUM_MAXID LOOP
				V_SQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
			END LOOP;

			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'');

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
                      'CFT_ID, DD_TTF_ID, DD_TTR_ID, DD_STR_ID, DD_CRA_ID, DD_SCR_ID, CFT_PRECIO_UNITARIO, CFT_UNIDAD_MEDIDA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' ||
                      'SELECT '|| V_NUM_SEQUENCE || ', (SELECT DD_TTF_ID FROM '||V_ESQUEMA||'.DD_TTF_TIPO_TARIFA WHERE DD_TTF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''), '||
                      '(SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||'''), '||
                      '(SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||'''), '||
                      '(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||'''), '||
                      '(SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(5))||'''), '||
                      ''''||TRIM(V_TMP_TIPO_DATA(6))||''', '''||TRIM(V_TMP_TIPO_DATA(7))||''', 0, '|| V_USU_MODIFICAR ||', SYSDATE, 0 FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL;
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);

		END IF;
	END LOOP;

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Tabla '||V_TEXT_TABLA||' actualizada correctamente.');


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
