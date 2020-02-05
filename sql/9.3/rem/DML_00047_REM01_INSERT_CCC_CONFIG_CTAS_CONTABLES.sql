--/*
--######################################### 
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9235
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TABLA VARCHAR2(30 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-9235';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    -- CODIGO_STG,		CODIGO_CRA,		CODIGO_SCR,		CUENTA_CONTABLE,		ANYO_EJE 		
	T_TIPO_DATA('84','07','138','6222000030','2020'),
	T_TIPO_DATA('70','07','138','6222000030','2020'),
	T_TIPO_DATA('82','07','138','6222000030','2020'),
	T_TIPO_DATA('81','07','138','6222000030','2020'),
	T_TIPO_DATA('73','07','138','6222000031','2020'),
	T_TIPO_DATA('76','07','138','6222000031','2020'),
	T_TIPO_DATA('75','07','138','6222000031','2020'),
	T_TIPO_DATA('74','07','138','6222000031','2020'),
	T_TIPO_DATA('83','07','138','6222000030','2020'),
	T_TIPO_DATA('80','07','138','6060000000','2020'),
	T_TIPO_DATA('79','07','138','6222000030','2020'),
	T_TIPO_DATA('72','07','138','6222000031','2020'),
	T_TIPO_DATA('77','07','138','6222000030','2020'),
	T_TIPO_DATA('71','07','138','6222000030','2020'),
	T_TIPO_DATA('78','07','138','6222000030','2020'),
	T_TIPO_DATA('27','07','138','6220000000','2020'),
	T_TIPO_DATA('28','07','138','6220000000','2020'),
	T_TIPO_DATA('29','07','138','6220000000','2020'),
	T_TIPO_DATA('93','07','138','6220000000','2020'),
	T_TIPO_DATA('26','07','138','6220000000','2020'),
	T_TIPO_DATA('53','07','138','6230600080','2020'),
	T_TIPO_DATA('54','07','138','6230600080','2020'),
	T_TIPO_DATA('05','07','138','6310000140','2020'),
	T_TIPO_DATA('02','07','138','6310000001','2020'),
	T_TIPO_DATA('02','07','138','6310000000','2020'),
	T_TIPO_DATA('02','07','138','6311000002','2020'),
	T_TIPO_DATA('01','07','138','6310000001','2020'),
	T_TIPO_DATA('01','07','138','6310000000','2020'),
	T_TIPO_DATA('01','07','138','6311000002','2020'),
	T_TIPO_DATA('06','07','138','6310000110','2020'),
	T_TIPO_DATA('07','07','138','6310000160','2020'),
	T_TIPO_DATA('03','07','138','6310000110','2020'),
	T_TIPO_DATA('04','07','138','6320000001','2020'),
	T_TIPO_DATA('92','07','138','6780100000','2020'),
	T_TIPO_DATA('92','07','138','6780000010','2020'),
	T_TIPO_DATA('62','07','138','6230600090','2020'),
	T_TIPO_DATA('60','07','138','6230600090','2020'),
	T_TIPO_DATA('58','07','138','6230700010','2020'),
	T_TIPO_DATA('61','07','138','6230600090','2020'),
	T_TIPO_DATA('69','07','138','6230600090','2020'),
	T_TIPO_DATA('57','07','138','6230600090','2020'),
	T_TIPO_DATA('68','07','138','6230600090','2020'),
	T_TIPO_DATA('59','07','138','6230600090','2020'),
	T_TIPO_DATA('64','07','138','6230600001','2020'),
	T_TIPO_DATA('63','07','138','6230600090','2020'),
	T_TIPO_DATA('67','07','138','6230600090','2020'),
	T_TIPO_DATA('66','07','138','6230600090','2020'),
	T_TIPO_DATA('65','07','138','6230600090','2020'),
	T_TIPO_DATA('31','07','138','6220000000','2020'),
	T_TIPO_DATA('30','07','138','6220000000','2020'),
	T_TIPO_DATA('33','07','138','6220000000','2020'),
	T_TIPO_DATA('32','07','138','6220000000','2020'),
	T_TIPO_DATA('34','07','138','6220000000','2020'),
	T_TIPO_DATA('90','07','138','6230600020','2020'),
	T_TIPO_DATA('98','07','138','6230600020','2020'),
	T_TIPO_DATA('99','07','138','6230600020','2020'),
	T_TIPO_DATA('89','07','138','6280000020','2020'),
	T_TIPO_DATA('19','07','138','6310000110','2020'),
	T_TIPO_DATA('20','07','138','6310000110','2020'),
	T_TIPO_DATA('88','07','138','6270000000','2020'),
	T_TIPO_DATA('24','07','138','6780100010','2020'),
	T_TIPO_DATA('25','07','138','6780100010','2020'),
	T_TIPO_DATA('23','07','138','6780100010','2020'),
	T_TIPO_DATA('22','07','138','6780100010','2020'),
	T_TIPO_DATA('21','07','138','6780100010','2020'),
	T_TIPO_DATA('42','07','138','6250000020','2020'),
	T_TIPO_DATA('41','07','138','6250000020','2020'),
	T_TIPO_DATA('40','07','138','6250000020','2020'),
	T_TIPO_DATA('39','07','138','6250000020','2020'),
	T_TIPO_DATA('97','07','138','6230600020','2020'),
	T_TIPO_DATA('96','07','138','6230600020','2020'),
	T_TIPO_DATA('95','07','138','6230600020','2020'),
	T_TIPO_DATA('48','07','138','6230600020','2020'),
	T_TIPO_DATA('49','07','138','6230600080','2020'),
	T_TIPO_DATA('94','07','138','6230600080','2020'),
	T_TIPO_DATA('44','07','138','6230600011','2020'),
	T_TIPO_DATA('52','07','138','6230600080','2020'),
	T_TIPO_DATA('47','07','138','6230600020','2020'),
	T_TIPO_DATA('46','07','138','6230600020','2020'),
	T_TIPO_DATA('43','07','138','6230600001','2020'),
	T_TIPO_DATA('51','07','138','6230000001','2020'),
	T_TIPO_DATA('50','07','138','6230600080','2020'),
	T_TIPO_DATA('36','07','138','6280000010','2020'),
	T_TIPO_DATA('35','07','138','6280000000','2020'),
	T_TIPO_DATA('37','07','138','6280000020','2020'),
	T_TIPO_DATA('38','07','138','6280000020','2020'),
	T_TIPO_DATA('10','07','138','6310000110','2020'),
	T_TIPO_DATA('09','07','138','6310000110','2020'),
	T_TIPO_DATA('08','07','138','6310000110','2020'),
	T_TIPO_DATA('12','07','138','6310000110','2020'),
	T_TIPO_DATA('14','07','138','6310000110','2020'),
	T_TIPO_DATA('16','07','138','6310000110','2020'),
	T_TIPO_DATA('15','07','138','6310000110','2020'),
	T_TIPO_DATA('18','07','138','6310000110','2020'),
	T_TIPO_DATA('17','07','138','6310000110','2020'),
	T_TIPO_DATA('13','07','138','6310000110','2020'),
	T_TIPO_DATA('11','07','138','6310000110','2020'),
	T_TIPO_DATA('86','07','138','6291100000','2020'),
	T_TIPO_DATA('87','07','138','6291100000','2020'),
	T_TIPO_DATA('85','07','138','6291100000','2020'),
    T_TIPO_DATA('84','07','151','6220000','2020'),
    T_TIPO_DATA('70','07','151','6220000','2020'),
    T_TIPO_DATA('82','07','151','6220000','2020'),
    T_TIPO_DATA('81','07','151','6220000','2020'),
    T_TIPO_DATA('73','07','151','6221000','2020'),
    T_TIPO_DATA('76','07','151','6221000','2020'),
    T_TIPO_DATA('75','07','151','6221000','2020'),
    T_TIPO_DATA('74','07','151','6221000','2020'),
    T_TIPO_DATA('83','07','151','6220000','2020'),
    T_TIPO_DATA('80','07','151','6060000','2020'),
    T_TIPO_DATA('79','07','151','6220000','2020'),
    T_TIPO_DATA('72','07','151','6221000','2020'),
    T_TIPO_DATA('77','07','151','6220000','2020'),
    T_TIPO_DATA('71','07','151','6220000','2020'),
    T_TIPO_DATA('78','07','151','6220000','2020'),
    T_TIPO_DATA('27','07','151','6222000','2020'),
    T_TIPO_DATA('28','07','151','6222000','2020'),
    T_TIPO_DATA('29','07','151','6222000','2020'),
    T_TIPO_DATA('93','07','151','6222000','2020'),
    T_TIPO_DATA('26','07','151','6222000','2020'),
    T_TIPO_DATA('53','07','151','6235000','2020'),
    T_TIPO_DATA('54','07','151','6235000','2020'),
    T_TIPO_DATA('05','07','151','6310000','2020'),
    T_TIPO_DATA('02','07','151','6311003','2020'),
    T_TIPO_DATA('02','07','151','6311001','2020'),
    T_TIPO_DATA('02','07','151','6311000','2020'),
    T_TIPO_DATA('01','07','151','6311003','2020'),
    T_TIPO_DATA('01','07','151','6311001','2020'),
    T_TIPO_DATA('01','07','151','6311000','2020'),
    T_TIPO_DATA('06','07','151','6312000','2020'),
    T_TIPO_DATA('07','07','151','6319000','2020'),
    T_TIPO_DATA('03','07','151','6312000','2020'),
    T_TIPO_DATA('04','07','151','6312001','2020'),
    T_TIPO_DATA('92','07','151','6315000','2020'),
    T_TIPO_DATA('92','07','151','6780000','2020'),
    T_TIPO_DATA('62','07','151','6233011','2020'),
    T_TIPO_DATA('60','07','151','6233011','2020'),
    T_TIPO_DATA('58','07','151','6233006','2020'),
    T_TIPO_DATA('61','07','151','6233011','2020'),
    T_TIPO_DATA('69','07','151','6233011','2020'),
    T_TIPO_DATA('57','07','151','6233011','2020'),
    T_TIPO_DATA('68','07','151','6233011','2020'),
    T_TIPO_DATA('59','07','151','6233011','2020'),
    T_TIPO_DATA('64','07','151','6230004','2020'),
    T_TIPO_DATA('63','07','151','6233011','2020'),
    T_TIPO_DATA('67','07','151','6233011','2020'),
    T_TIPO_DATA('66','07','151','6233011','2020'),
    T_TIPO_DATA('65','07','151','6233011','2020'),
    T_TIPO_DATA('31','07','151','6222000','2020'),
    T_TIPO_DATA('30','07','151','6222000','2020'),
    T_TIPO_DATA('33','07','151','6222000','2020'),
    T_TIPO_DATA('32','07','151','6222000','2020'),
    T_TIPO_DATA('34','07','151','6222000','2020'),
    T_TIPO_DATA('90','07','151','6230000','2020'),
    T_TIPO_DATA('98','07','151','6230000','2020'),
    T_TIPO_DATA('99','07','151','6230000','2020'),
    T_TIPO_DATA('89','07','151','6282000','2020'),
    T_TIPO_DATA('19','07','151','6312000','2020'),
    T_TIPO_DATA('20','07','151','6312000','2020'),
    T_TIPO_DATA('88','07','151','6270000','2020'),
    T_TIPO_DATA('24','07','151','6780005','2020'),
    T_TIPO_DATA('25','07','151','6780005','2020'),
    T_TIPO_DATA('23','07','151','6780005','2020'),
    T_TIPO_DATA('22','07','151','6780005','2020'),
    T_TIPO_DATA('21','07','151','6780005','2020'),
    T_TIPO_DATA('42','07','151','6250000','2020'),
    T_TIPO_DATA('41','07','151','6250000','2020'),
    T_TIPO_DATA('40','07','151','6250000','2020'),
    T_TIPO_DATA('39','07','151','6250000','2020'),
    T_TIPO_DATA('97','07','151','6230000','2020'),
    T_TIPO_DATA('96','07','151','6230000','2020'),
    T_TIPO_DATA('95','07','151','6230000','2020'),
    T_TIPO_DATA('48','07','151','6230000','2020'),
    T_TIPO_DATA('49','07','151','6235000','2020'),
    T_TIPO_DATA('94','07','151','6235000','2020'),
    T_TIPO_DATA('44','07','151','6230003','2020'),
    T_TIPO_DATA('52','07','151','6235000','2020'),
    T_TIPO_DATA('47','07','151','6230000','2020'),
    T_TIPO_DATA('46','07','151','6230000','2020'),
    T_TIPO_DATA('43','07','151','6230004','2020'),
    T_TIPO_DATA('51','07','151','6233004','2020'),
    T_TIPO_DATA('50','07','151','6235000','2020'),
    T_TIPO_DATA('36','07','151','6281000','2020'),
    T_TIPO_DATA('35','07','151','6280000','2020'),
    T_TIPO_DATA('37','07','151','6282000','2020'),
    T_TIPO_DATA('38','07','151','6282000','2020'),
    T_TIPO_DATA('10','07','151','6312000','2020'),
    T_TIPO_DATA('09','07','151','6312000','2020'),
    T_TIPO_DATA('08','07','151','6312000','2020'),
    T_TIPO_DATA('12','07','151','6312000','2020'),
    T_TIPO_DATA('14','07','151','6312000','2020'),
    T_TIPO_DATA('16','07','151','6312000','2020'),
    T_TIPO_DATA('15','07','151','6312000','2020'),
    T_TIPO_DATA('18','07','151','6312000','2020'),
    T_TIPO_DATA('17','07','151','6312000','2020'),
    T_TIPO_DATA('13','07','151','6312000','2020'),
    T_TIPO_DATA('11','07','151','6312000','2020'),
    T_TIPO_DATA('86','07','151','6295000','2020'),
    T_TIPO_DATA('87','07','151','6295000','2020'),
    T_TIPO_DATA('85','07','151','6295000','2020'),
    T_TIPO_DATA('84','07','152','6220000','2020'),
    T_TIPO_DATA('70','07','152','6220000','2020'),
    T_TIPO_DATA('82','07','152','6220000','2020'),
    T_TIPO_DATA('81','07','152','6220000','2020'),
    T_TIPO_DATA('73','07','152','6221000','2020'),
    T_TIPO_DATA('76','07','152','6221000','2020'),
    T_TIPO_DATA('75','07','152','6221000','2020'),
    T_TIPO_DATA('74','07','152','6221000','2020'),
    T_TIPO_DATA('83','07','152','6220000','2020'),
    T_TIPO_DATA('80','07','152','6060000','2020'),
    T_TIPO_DATA('79','07','152','6220000','2020'),
    T_TIPO_DATA('72','07','152','6221000','2020'),
    T_TIPO_DATA('77','07','152','6220000','2020'),
    T_TIPO_DATA('71','07','152','6220000','2020'),
    T_TIPO_DATA('78','07','152','6220000','2020'),
    T_TIPO_DATA('27','07','152','6222000','2020'),
    T_TIPO_DATA('28','07','152','6222000','2020'),
    T_TIPO_DATA('29','07','152','6222000','2020'),
    T_TIPO_DATA('93','07','152','6222000','2020'),
    T_TIPO_DATA('26','07','152','6222000','2020'),
    T_TIPO_DATA('53','07','152','6235000','2020'),
    T_TIPO_DATA('54','07','152','6235000','2020'),
    T_TIPO_DATA('05','07','152','6310000','2020'),
    T_TIPO_DATA('02','07','152','6311003','2020'),
    T_TIPO_DATA('02','07','152','6311001','2020'),
    T_TIPO_DATA('02','07','152','6311000','2020'),
    T_TIPO_DATA('01','07','152','6311003','2020'),
    T_TIPO_DATA('01','07','152','6311001','2020'),
    T_TIPO_DATA('01','07','152','6311000','2020'),
    T_TIPO_DATA('06','07','152','6312000','2020'),
    T_TIPO_DATA('07','07','152','6319000','2020'),
    T_TIPO_DATA('03','07','152','6312000','2020'),
    T_TIPO_DATA('04','07','152','6312001','2020'),
    T_TIPO_DATA('92','07','152','6315000','2020'),
    T_TIPO_DATA('92','07','152','6780000','2020'),
    T_TIPO_DATA('62','07','152','6233011','2020'),
    T_TIPO_DATA('60','07','152','6233011','2020'),
    T_TIPO_DATA('58','07','152','6233006','2020'),
    T_TIPO_DATA('61','07','152','6233011','2020'),
    T_TIPO_DATA('69','07','152','6233011','2020'),
    T_TIPO_DATA('57','07','152','6233011','2020'),
    T_TIPO_DATA('68','07','152','6233011','2020'),
    T_TIPO_DATA('59','07','152','6233011','2020'),
    T_TIPO_DATA('64','07','152','6230004','2020'),
    T_TIPO_DATA('63','07','152','6233011','2020'),
    T_TIPO_DATA('67','07','152','6233011','2020'),
    T_TIPO_DATA('66','07','152','6233011','2020'),
    T_TIPO_DATA('65','07','152','6233011','2020'),
    T_TIPO_DATA('31','07','152','6222000','2020'),
    T_TIPO_DATA('30','07','152','6222000','2020'),
    T_TIPO_DATA('33','07','152','6222000','2020'),
    T_TIPO_DATA('32','07','152','6222000','2020'),
    T_TIPO_DATA('34','07','152','6222000','2020'),
    T_TIPO_DATA('90','07','152','6230000','2020'),
    T_TIPO_DATA('98','07','152','6230000','2020'),
    T_TIPO_DATA('99','07','152','6230000','2020'),
    T_TIPO_DATA('89','07','152','6282000','2020'),
    T_TIPO_DATA('19','07','152','6312000','2020'),
    T_TIPO_DATA('20','07','152','6312000','2020'),
    T_TIPO_DATA('88','07','152','6270000','2020'),
    T_TIPO_DATA('24','07','152','6780005','2020'),
    T_TIPO_DATA('25','07','152','6780005','2020'),
    T_TIPO_DATA('23','07','152','6780005','2020'),
    T_TIPO_DATA('22','07','152','6780005','2020'),
    T_TIPO_DATA('21','07','152','6780005','2020'),
    T_TIPO_DATA('42','07','152','6250000','2020'),
    T_TIPO_DATA('41','07','152','6250000','2020'),
    T_TIPO_DATA('40','07','152','6250000','2020'),
    T_TIPO_DATA('39','07','152','6250000','2020'),
    T_TIPO_DATA('97','07','152','6230000','2020'),
    T_TIPO_DATA('96','07','152','6230000','2020'),
    T_TIPO_DATA('95','07','152','6230000','2020'),
    T_TIPO_DATA('48','07','152','6230000','2020'),
    T_TIPO_DATA('49','07','152','6235000','2020'),
    T_TIPO_DATA('94','07','152','6235000','2020'),
    T_TIPO_DATA('44','07','152','6230003','2020'),
    T_TIPO_DATA('52','07','152','6235000','2020'),
    T_TIPO_DATA('47','07','152','6230000','2020'),
    T_TIPO_DATA('46','07','152','6230000','2020'),
    T_TIPO_DATA('43','07','152','6230004','2020'),
    T_TIPO_DATA('51','07','152','6233004','2020'),
    T_TIPO_DATA('50','07','152','6235000','2020'),
    T_TIPO_DATA('36','07','152','6281000','2020'),
    T_TIPO_DATA('35','07','152','6280000','2020'),
    T_TIPO_DATA('37','07','152','6282000','2020'),
    T_TIPO_DATA('38','07','152','6282000','2020'),
    T_TIPO_DATA('10','07','152','6312000','2020'),
    T_TIPO_DATA('09','07','152','6312000','2020'),
    T_TIPO_DATA('08','07','152','6312000','2020'),
    T_TIPO_DATA('12','07','152','6312000','2020'),
    T_TIPO_DATA('14','07','152','6312000','2020'),
    T_TIPO_DATA('16','07','152','6312000','2020'),
    T_TIPO_DATA('15','07','152','6312000','2020'),
    T_TIPO_DATA('18','07','152','6312000','2020'),
    T_TIPO_DATA('17','07','152','6312000','2020'),
    T_TIPO_DATA('13','07','152','6312000','2020'),
    T_TIPO_DATA('11','07','152','6312000','2020'),
    T_TIPO_DATA('86','07','152','6295000','2020'),
    T_TIPO_DATA('87','07','152','6295000','2020'),
    T_TIPO_DATA('85','07','152','6295000','2020')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;  
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
    -- LOOP para insertar los valores en CPS_CONFIG_SUBPTDAS_PRE -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN CCC_CONFIG_CTAS_CONTABLES] ');
    
    
    -- Recogemos el valor id de la cartera, porque es el mismo para todos
    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''07''';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
    
   -- Recogemos el valor id del año, porque es el mismo para todos
   V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2020';
   EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;
    
        
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);    
        
        --Comprobamos el dato a insertar
	   	V_SQL :=   'SELECT COUNT(1) 
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
										FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO								
										WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
					AND DD_CRA_ID = '||V_DD_CRA_ID||' 
					AND DD_SCR_ID = (SELECT DD_SCR_ID 
										FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA								
										WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
					AND CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(4))||''' 
					AND EJE_ID = '||V_EJE_ID||' 
					AND CCC_ARRENDAMIENTO = 0';
					
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
        
       --Si no existe, lo insertamos
        IF V_NUM_TABLAS = 0 THEN            
         V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CCC_ID
                            , DD_STG_ID
                            , DD_CRA_ID
                            , DD_SCR_ID
                            , VERSION
                            , USUARIOCREAR
                            , FECHACREAR
                            , BORRADO
                            , CCC_CUENTA_CONTABLE
                            , EJE_ID
                            , CCC_ARRENDAMIENTO                          
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
                            , (SELECT DD_STG_ID 
								FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG								
								WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''')
                            , '||V_DD_CRA_ID||'
                            , (SELECT DD_SCR_ID 
										FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR								
										WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''')
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_TIPO_DATA(4))||'
                            , '||V_EJE_ID||'
                            , 0                           
                        )';
						
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CCC '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''  '''|| TRIM(V_TMP_TIPO_DATA(4)) ||''' INSERTADO CORRECTAMENTE');
          
        
        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto con código '||TRIM(V_TMP_TIPO_DATA(1))||' en la cuenta contable '||TRIM(V_TMP_TIPO_DATA(4))||' para el año '||TRIM(V_TMP_TIPO_DATA(5))||'.');		
          
       END IF;
      END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado correctamente');
    
    
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
EXIT
