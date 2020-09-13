--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20200712
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11161
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
	  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'CFG_PVE_PREDETERMINADO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
      T_TIPO_DATA('01','02','01','01','2',1),
      T_TIPO_DATA('01','02','01','01','5',0),
      T_TIPO_DATA('01','02','01','02','5',1),
      T_TIPO_DATA('01','02','01','03','12',1),
      T_TIPO_DATA('01','02','01','04','20',1),
      T_TIPO_DATA('01','02','01','05','21',1),
      T_TIPO_DATA('01','02','01','06','24',1),
      T_TIPO_DATA('01','02','01','07','25',1),
      T_TIPO_DATA('01','02','02','13','26',1),
      T_TIPO_DATA('01','02','02','14','29',1),
      T_TIPO_DATA('01','02','02','15','34',1),
      T_TIPO_DATA('01','02','02','16','36',1),
      T_TIPO_DATA('01','02','02','17','37',1),
      T_TIPO_DATA('01','02','02','18','42',1),
      T_TIPO_DATA('01','02','02','19','54',1),
      T_TIPO_DATA('01','02','02','20','160',1),
      T_TIPO_DATA('01','02','02','21','164',1),
      T_TIPO_DATA('01','02','02','22','174',1),
      T_TIPO_DATA('01','02','02','23','180',1),
      T_TIPO_DATA('01','02','02','24','193',1),
      T_TIPO_DATA('01','02','02','25','200',1),
      T_TIPO_DATA('01','02','03','ACO','477',1),
      T_TIPO_DATA('01','02','03','FOT','518',1),
      T_TIPO_DATA('01','02','03','INT','1647',1),
      T_TIPO_DATA('01','02','03','PAQ','2769',1),
      T_TIPO_DATA('01','02','03','RAN','3000',1),
      T_TIPO_DATA('01','02','03','SIN','3047',1),
      T_TIPO_DATA('01','02','03','VAL','3996',1),
      T_TIPO_DATA('01','02','03','100','4123',1),
      T_TIPO_DATA('01','02','03','101','4491',1),
      T_TIPO_DATA('01','02','03','102','4538',1),
      T_TIPO_DATA('01','02','03','103','4547',1),
      T_TIPO_DATA('01','02','03','104','4563',1),
      T_TIPO_DATA('01','02','03','105','10294',1),
      T_TIPO_DATA('01','02','03','106','87585',1),
      T_TIPO_DATA('01','02','03','107','9991196',1),
      T_TIPO_DATA('01','02','03','108','9991210',1),
      T_TIPO_DATA('01','02','03','109','9991259',1),
      T_TIPO_DATA('01','02','03','110','9991288',1),
      T_TIPO_DATA('01','02','03','111','9991343',1),
      T_TIPO_DATA('01','02','03','112','9991360',1),
      T_TIPO_DATA('01','02','03','113','9991370',1),
      T_TIPO_DATA('01','02','03','114','9991381',1),
      T_TIPO_DATA('01','02','03','115','9994193',1),
      T_TIPO_DATA('01','02','03','116','10004235',1),
      T_TIPO_DATA('01','02','03','117','10004247',1),
      T_TIPO_DATA('01','02','03','118','10004261',1),
      T_TIPO_DATA('01','02','03','119','10004312',1),
      T_TIPO_DATA('01','02','03','120','10004399',1),
      T_TIPO_DATA('01','02','03','121','10004480',1),
      T_TIPO_DATA('01','02','03','122','10004495',1),
      T_TIPO_DATA('01','02','03','123','10004498',1),
      T_TIPO_DATA('01','02','03','124','10004555',1),
      T_TIPO_DATA('01','02','03','125','10004576',1),
      T_TIPO_DATA('01','02','03','126','10004584',1),
      T_TIPO_DATA('01','02','03','127','10004591',1),
      T_TIPO_DATA('01','02','03','128','10004633',1),
      T_TIPO_DATA('01','02','03','129','10004690',1),
      T_TIPO_DATA('01','02','03','26','10004879',1),
      T_TIPO_DATA('01','02','03','27','10004905',1),
      T_TIPO_DATA('01','02','03','28','10004919',1),
      T_TIPO_DATA('01','02','03','29','10005008',1),
      T_TIPO_DATA('01','02','03','30','10005056',1),
      T_TIPO_DATA('01','02','03','31','10005066',1),
      T_TIPO_DATA('01','02','03','32','10005139',1),
      T_TIPO_DATA('01','02','03','33','10005153',1),
      T_TIPO_DATA('01','02','03','34','10005225',1),
      T_TIPO_DATA('01','02','03','35','10005238',1),
      T_TIPO_DATA('01','02','03','36','10005251',1),
      T_TIPO_DATA('01','02','03','37','10005289',1),
      T_TIPO_DATA('01','02','03','38','10005387',1),
      T_TIPO_DATA('01','02','03','39','10005411',1),
      T_TIPO_DATA('01','02','03','40','10005431',1),
      T_TIPO_DATA('01','02','03','41','10005448',1),
      T_TIPO_DATA('01','02','03','57','10005620',1),
      T_TIPO_DATA('01','02','03','58','10005624',1),
      T_TIPO_DATA('01','02','03','59','10005636',1),
      T_TIPO_DATA('01','02','03','60','10005657',1),
      T_TIPO_DATA('01','02','03','61','10005734',1),
      T_TIPO_DATA('01','02','03','62','10005789',1),
      T_TIPO_DATA('01','02','03','63','10005793',1),
      T_TIPO_DATA('01','02','03','64','10005812',1),
      T_TIPO_DATA('01','02','03','65','10005823',1),
      T_TIPO_DATA('01','02','03','66','10005834',1),
      T_TIPO_DATA('01','02','03','67','10005846',1),
      T_TIPO_DATA('01','02','03','68','10005886',1),
      T_TIPO_DATA('01','02','03','69','10005904',1),
      T_TIPO_DATA('01','02','03','70','10005907',1),
      T_TIPO_DATA('01','02','03','71','10005941',1),
      T_TIPO_DATA('01','02','03','72','10005976',1),
      T_TIPO_DATA('01','02','03','73','10005978',1),
      T_TIPO_DATA('01','02','04','42','10005981',1),
      T_TIPO_DATA('01','02','04','43','10006003',1),
      T_TIPO_DATA('01','02','04','44','10006014',1),
      T_TIPO_DATA('01','02','04','45','10006015',1),
      T_TIPO_DATA('01','02','04','46','10006018',1),
      T_TIPO_DATA('01','02','04','47','10006088',1),
      T_TIPO_DATA('01','02','05','48','10006106',1),
      T_TIPO_DATA('01','02','05','49','10006152',1),
      T_TIPO_DATA('01','02','05','50','10006189',1),
      T_TIPO_DATA('01','02','05','51','10006197',1),
      T_TIPO_DATA('01','02','05','52','10006285',1),
      T_TIPO_DATA('01','02','05','53','10006293',1),
      T_TIPO_DATA('01','02','06','55','10006294',1),
      T_TIPO_DATA('01','02','06','56','10006323',1),
      T_TIPO_DATA('01','02','07','130','10006331',1),
      T_TIPO_DATA('01','02','07','131','10006351',1),
      T_TIPO_DATA('01','02','07','132','10006373',1),
      T_TIPO_DATA('01','02','07','133','10006378',1),
      T_TIPO_DATA('01','02','07','134','10006381',1),
      T_TIPO_DATA('01','02','07','135','10006384',1),
      T_TIPO_DATA('01','02','07','136','10006396',1),
      T_TIPO_DATA('01','02','07','137','10006411',1),
      T_TIPO_DATA('01','02','07','138','10006456',1),
      T_TIPO_DATA('01','02','07','139','10006462',1),
      T_TIPO_DATA('01','02','07','140','10006482',1),
      T_TIPO_DATA('01','02','07','141','10006495',1),
      T_TIPO_DATA('01','02','07','142','10006500',1),
      T_TIPO_DATA('01','02','07','143','10006508',1),
      T_TIPO_DATA('01','02','07','144','10006513',1),
      T_TIPO_DATA('01','02','07','145','10006533',1),
      T_TIPO_DATA('01','01','01','01','10006540',1),
      T_TIPO_DATA('01','01','01','02','10006542',1),
      T_TIPO_DATA('01','01','01','03','10006547',1),
      T_TIPO_DATA('01','01','01','04','10006548',1),
      T_TIPO_DATA('01','01','01','05','10006553',1),
      T_TIPO_DATA('01','01','01','06','10006555',1),
      T_TIPO_DATA('01','01','01','07','10006562',1),
      T_TIPO_DATA('01','01','02','13','10006572',1),
      T_TIPO_DATA('01','01','02','14','10006576',1),
      T_TIPO_DATA('01','01','02','15','10006599',1),
      T_TIPO_DATA('01','01','02','16','10006606',1),
      T_TIPO_DATA('01','01','02','17','10006607',1),
      T_TIPO_DATA('01','01','02','18','10006621',1),
      T_TIPO_DATA('01','01','02','19','10006623',1),
      T_TIPO_DATA('01','01','02','20','10006635',1),
      T_TIPO_DATA('01','01','02','21','10006648',1),
      T_TIPO_DATA('01','01','02','22','10006650',1),
      T_TIPO_DATA('01','01','02','23','10006687',1),
      T_TIPO_DATA('01','01','02','24','10006724',1),
      T_TIPO_DATA('01','01','02','25','10006734',1),
      T_TIPO_DATA('01','01','03','ACO','10006751',1),
      T_TIPO_DATA('01','01','03','FOT','10006777',1),
      T_TIPO_DATA('01','01','03','INT','10006807',1),
      T_TIPO_DATA('01','01','03','PAQ','10006852',1),
      T_TIPO_DATA('01','01','03','RAN','10006876',1),
      T_TIPO_DATA('01','01','03','SIN','10006902',1),
      T_TIPO_DATA('01','01','03','VAL','10006916',1),
      T_TIPO_DATA('01','01','03','100','10006942',1),
      T_TIPO_DATA('01','01','03','101','10006984',1),
      T_TIPO_DATA('01','01','03','102','10007027',1),
      T_TIPO_DATA('01','01','03','103','10007028',1),
      T_TIPO_DATA('01','01','03','104','10007049',1),
      T_TIPO_DATA('01','01','03','105','10007076',1),
      T_TIPO_DATA('01','01','03','106','10007099',1),
      T_TIPO_DATA('01','01','03','107','10007151',1),
      T_TIPO_DATA('01','01','03','108','10007166',1),
      T_TIPO_DATA('01','01','03','109','10007181',1),
      T_TIPO_DATA('01','01','03','110','10007184',1),
      T_TIPO_DATA('01','01','03','111','10007232',1),
      T_TIPO_DATA('01','01','03','112','10007267',1),
      T_TIPO_DATA('01','01','03','113','10007269',1),
      T_TIPO_DATA('01','01','03','114','10007273',1),
      T_TIPO_DATA('01','01','03','115','10007285',1),
      T_TIPO_DATA('01','01','03','116','10007291',1),
      T_TIPO_DATA('01','01','03','117','10007315',1),
      T_TIPO_DATA('01','01','03','118','10007334',1),
      T_TIPO_DATA('01','01','03','119','10007335',1),
      T_TIPO_DATA('01','01','03','120','10007348',1),
      T_TIPO_DATA('01','01','03','121','10007360',1),
      T_TIPO_DATA('01','01','03','122','10007365',1),
      T_TIPO_DATA('01','01','03','123','10007366',1),
      T_TIPO_DATA('01','01','03','124','10007405',1),
      T_TIPO_DATA('01','01','03','125','10007437',1),
      T_TIPO_DATA('01','01','03','126','10007470',1),
      T_TIPO_DATA('01','01','03','127','10007488',1),
      T_TIPO_DATA('01','01','03','128','10007496',1),
      T_TIPO_DATA('01','01','03','129','10007498',1),
      T_TIPO_DATA('01','01','03','26','10007533',1),
      T_TIPO_DATA('01','01','03','27','10007535',1),
      T_TIPO_DATA('01','01','03','28','10007538',1),
      T_TIPO_DATA('01','01','03','29','10007548',1),
      T_TIPO_DATA('01','01','03','30','10007550',1),
      T_TIPO_DATA('01','01','03','31','10007566',1),
      T_TIPO_DATA('01','01','03','32','10007567',1),
      T_TIPO_DATA('01','01','03','33','10007576',1),
      T_TIPO_DATA('01','01','03','34','10007579',1),
      T_TIPO_DATA('01','01','03','35','10007608',1),
      T_TIPO_DATA('01','01','03','36','10007609',1),
      T_TIPO_DATA('01','01','03','37','10007611',1),
      T_TIPO_DATA('01','01','03','38','10007625',1),
      T_TIPO_DATA('01','01','03','39','10007628',1),
      T_TIPO_DATA('01','01','03','40','10007634',1),
      T_TIPO_DATA('01','01','03','41','10007635',1),
      T_TIPO_DATA('01','01','03','57','10007638',1),
      T_TIPO_DATA('01','01','03','58','10007669',1),
      T_TIPO_DATA('01','01','03','59','10007670',1),
      T_TIPO_DATA('01','01','03','60','10007723',1),
      T_TIPO_DATA('01','01','03','61','10007776',1),
      T_TIPO_DATA('01','01','03','62','10007790',1),
      T_TIPO_DATA('01','01','03','63','10007809',1),
      T_TIPO_DATA('01','01','03','64','10007819',1),
      T_TIPO_DATA('01','01','03','65','10007915',1),
      T_TIPO_DATA('01','01','03','66','10007937',1),
      T_TIPO_DATA('01','01','03','67','10007941',1),
      T_TIPO_DATA('01','01','03','68','10007979',1),
      T_TIPO_DATA('01','01','03','69','10008117',1),
      T_TIPO_DATA('01','01','03','70','10008242',1),
      T_TIPO_DATA('01','01','03','71','10008439',1),
      T_TIPO_DATA('01','01','03','72','10008446',1),
      T_TIPO_DATA('01','01','03','73','10008817',1),
      T_TIPO_DATA('01','01','04','42','10008823',1),
      T_TIPO_DATA('01','01','04','43','10008944',1),
      T_TIPO_DATA('01','01','04','44','10009085',1),
      T_TIPO_DATA('01','01','04','45','10009093',1),
      T_TIPO_DATA('01','01','04','46','10009365',1),
      T_TIPO_DATA('01','01','04','47','10009485',1),
      T_TIPO_DATA('01','01','05','48','10009512',1),
      T_TIPO_DATA('01','01','05','49','10009514',1),
      T_TIPO_DATA('01','01','05','50','10009549',1),
      T_TIPO_DATA('01','01','05','51','10009594',1),
      T_TIPO_DATA('01','01','05','52','10009620',1),
      T_TIPO_DATA('01','01','05','53','10009658',1),
      T_TIPO_DATA('01','01','06','55','10009706',1),
      T_TIPO_DATA('01','01','06','56','10009764',1),
      T_TIPO_DATA('01','01','07','130','10009767',1),
      T_TIPO_DATA('01','01','07','131','10009977',1),
      T_TIPO_DATA('01','01','07','132','10010061',1),
      T_TIPO_DATA('01','01','07','133','10010063',1),
      T_TIPO_DATA('01','01','07','134','10010295',1),
      T_TIPO_DATA('01','01','07','135','10010327',1),
      T_TIPO_DATA('01','01','07','136','10010436',1),
      T_TIPO_DATA('01','01','07','137','10010449',1),
      T_TIPO_DATA('01','01','07','138','10010495',1),
      T_TIPO_DATA('01','01','07','139','10010499',1),
      T_TIPO_DATA('01','01','07','140','10010725',1),
      T_TIPO_DATA('01','01','07','141','10010836',1),
      T_TIPO_DATA('01','01','07','142','10010907',1),
      T_TIPO_DATA('01','01','07','143','10010908',1),
      T_TIPO_DATA('01','01','07','144','10011095',1),
      T_TIPO_DATA('01','01','07','145','10011110',1),
      T_TIPO_DATA('02','04','01','01','10011889',1),
      T_TIPO_DATA('02','04','01','02','10012148',1),
      T_TIPO_DATA('02','04','01','03','10012216',1),
      T_TIPO_DATA('02','04','01','04','10033526',1),
      T_TIPO_DATA('02','04','01','05','10033547',1),
      T_TIPO_DATA('02','04','01','06','110050818',1),
      T_TIPO_DATA('02','04','01','07','110061028',1),
      T_TIPO_DATA('02','04','02','13','110064911',1),
      T_TIPO_DATA('02','04','02','14','110065072',1),
      T_TIPO_DATA('02','04','02','15','110065073',1),
      T_TIPO_DATA('02','04','02','16','110065090',1),
      T_TIPO_DATA('02','04','02','17','110065129',1),
      T_TIPO_DATA('02','04','02','18','110073131',1),
      T_TIPO_DATA('02','04','02','19','110073950',1),
      T_TIPO_DATA('02','04','02','20','110073951',1),
      T_TIPO_DATA('02','04','02','21','110073971',1),
      T_TIPO_DATA('02','04','02','22','110074141',1),
      T_TIPO_DATA('02','04','02','23','110074370',1),
      T_TIPO_DATA('02','04','02','24','110074602',1),
      T_TIPO_DATA('02','04','02','25','110076930',1),
      T_TIPO_DATA('02','04','03','ACO','110077900',1),
      T_TIPO_DATA('02','04','03','FOT','110077965',1),
      T_TIPO_DATA('02','04','03','INT','110082198',1),
      T_TIPO_DATA('02','04','03','PAQ','110082511',1),
      T_TIPO_DATA('02','04','03','RAN','110082671',1),
      T_TIPO_DATA('02','04','03','SIN','110082719',1),
      T_TIPO_DATA('02','04','03','VAL','110097602',1),
      T_TIPO_DATA('02','04','03','100','110098137',1),
      T_TIPO_DATA('02','04','03','101','110103313',1),
      T_TIPO_DATA('02','04','03','102','110103592',1),
      T_TIPO_DATA('02','04','03','103','110105168',1),
      T_TIPO_DATA('02','04','03','104','110105187',1),
      T_TIPO_DATA('02','04','03','105','110105189',1),
      T_TIPO_DATA('02','04','03','106','110105200',1),
      T_TIPO_DATA('02','04','03','107','110105207',1),
      T_TIPO_DATA('02','04','03','108','110105209',1),
      T_TIPO_DATA('02','04','03','109','110105220',1),
      T_TIPO_DATA('02','04','03','110','110105221',1),
      T_TIPO_DATA('02','04','03','111','110105223',1),
      T_TIPO_DATA('02','04','03','112','110105228',1),
      T_TIPO_DATA('02','04','03','113','110105234',1),
      T_TIPO_DATA('02','04','03','114','110105255',1),
      T_TIPO_DATA('02','04','03','115','110105264',1),
      T_TIPO_DATA('02','04','03','116','110105271',1),
      T_TIPO_DATA('02','04','03','117','110105285',1),
      T_TIPO_DATA('02','04','03','118','110105310',1),
      T_TIPO_DATA('02','04','03','119','110105314',1),
      T_TIPO_DATA('02','04','03','120','110105336',1),
      T_TIPO_DATA('02','04','03','121','110105337',1),
      T_TIPO_DATA('02','04','03','122','110105359',1),
      T_TIPO_DATA('02','04','03','123','110105372',1),
      T_TIPO_DATA('02','04','03','124','110105388',1),
      T_TIPO_DATA('02','04','03','125','110105407',1),
      T_TIPO_DATA('02','04','03','126','110105412',1),
      T_TIPO_DATA('02','04','03','127','110105414',1),
      T_TIPO_DATA('02','04','03','128','110105428',1),
      T_TIPO_DATA('02','04','03','129','110105450',1),
      T_TIPO_DATA('02','04','03','26','110105473',1),
      T_TIPO_DATA('02','04','03','27','110105486',1),
      T_TIPO_DATA('02','04','03','28','110105535',1)

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
					WHERE 
          DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0) 
          AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0)
          AND DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND BORRADO = 0) 
          AND DD_STR_ID = (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(4))||''' AND BORRADO = 0)
          AND PVE_ID = (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(5))||''' AND BORRADO = 0)';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: El valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' y '''||TRIM(V_TMP_TIPO_DATA(2))||''' ya existe');
        ELSE
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
              CPP_ID,
              DD_CRA_ID,
              DD_SCR_ID,
              DD_TTR_ID,
              DD_STR_ID,
              PVE_ID,
              PROVEEDOR_DEFECTO,
              VERSION,
              USUARIOCREAR,
              FECHACREAR,
              BORRADO
              ) VALUES (
              '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL,
              (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0),
              (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0),
              (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO WHERE DD_TTR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0),
              (SELECT DD_STR_ID FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO WHERE DD_STR_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(2))||''' AND BORRADO = 0),
              (SELECT PVE_ID FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR WHERE PVE_COD_REM = '''||TRIM(V_TMP_TIPO_DATA(5))||''' AND BORRADO = 0),
              '||TRIM(V_TMP_TIPO_DATA(6))||',
              0,
              ''HREOS-11161'',
              SYSDATE,
              0
                        )';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO]: Se ha insertado el valor '''||TRIM(V_TMP_TIPO_DATA(1))||''' y '''||TRIM(V_TMP_TIPO_DATA(2))||'''');

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
