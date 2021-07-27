--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210726
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14759
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_TABLA VARCHAR2(100 CHAR) := 'DD_ETG_EQV_TIPO_GASTO'; -- Tabla Destino
	V_TABLA_AUX VARCHAR2(100 CHAR) := 'DD_ETG_EQV_TIPO_GASTO'; -- Tabla origen
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-14759';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	V_FLAG_VACIADO NUMBER := 0;
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --DD_STG_ID|COGRUG_POS|COTACA_POS|COSBAC_POS|COGRUG_NEG|COTACA_NEG|COSBAC_NEG|Descrip Pos| Descrip Neg-----
		T_TABLA('09','10','100','2','3','52','2','3','2'),
		T_TABLA('06','29','101','2','2','4','2','2','54'),
		T_TABLA('06','28','102','2','2','3','2','2','53'),
		T_TABLA('05','93','103','2','2','1','','',''),
		T_TABLA('05','27','104','2','2','2','2','2','52'),
		T_TABLA('05','26','105','2','2','1','2','2','51'),
		T_TABLA('14','68','106','2','2','1','2','2','51'),
		T_TABLA('07','31','107','3','44','2','','',''),
		T_TABLA('07','30','108','3','44','2','','',''),
		T_TABLA('08','33','109','2','2','2','2','2','52'),
		T_TABLA('08','32','110','2','2','1','2','2','51'),
		T_TABLA('08','34','111','2','2','20','2','2','50'),
		T_TABLA('18','98','112','2','2','6','2','2','56'),
		T_TABLA('12','54','113','3','35','2','','',''),
		T_TABLA('09','35','114','2','3','1','2','3','51'),
		T_TABLA('12','53','115','3','49','4','','',''),
		T_TABLA('01','02','116','2','1','9','2','1','59'),
		T_TABLA('01','01','117','2','1','1','2','1','51'),
		T_TABLA('01','06','118','2','1','6','2','1','56'),
		T_TABLA('14','65','119','2','1','6','2','1','56'),
		T_TABLA('03','19','120','2','1','5','2','1','55'),
		T_TABLA('03','20','121','2','1','6','2','1','56'),
		T_TABLA('04','24','122','2','1','6','2','1','56'),
		T_TABLA('04','25','123','2','1','6','2','1','56'),
		T_TABLA('04','23','124','2','1','6','2','1','56'),
		T_TABLA('04','22','125','2','1','6','2','1','56'),
		T_TABLA('04','21','126','2','1','6','2','1','56'),
		T_TABLA('02','10','127','2','1','4','2','1','54'),
		T_TABLA('02','09','128','2','1','3','2','1','53'),
		T_TABLA('02','08','129','2','1','2','2','1','52'),
		T_TABLA('02','12','130','2','1','8','2','1','58'),
		T_TABLA('02','14','131','2','1','6','2','1','56'),
		T_TABLA('02','16','132','2','1','6','2','1','56'),
		T_TABLA('02','15','133','2','1','6','2','1','56'),
		T_TABLA('02','18','134','2','1','6','2','1','56'),
		T_TABLA('02','17','135','2','1','6','2','1','56'),
		T_TABLA('02','13','136','2','1','6','2','1','56'),
		T_TABLA('02','11','137','2','1','7','2','1','57'),
		T_TABLA('14','60','138','3','42','8','','',''),
		T_TABLA('14','58','139','3','45','5','','',''),
		T_TABLA('14','62','140','3','45','2','','',''),
		T_TABLA('14','61','141','3','45','2','','',''),
		T_TABLA('14','69','142','3','45','2','','',''),
		T_TABLA('14','57','143','3','45','2','','',''),
		T_TABLA('14','59','144','3','45','2','','',''),
		T_TABLA('14','63','145','3','45','2','','',''),
		T_TABLA('11','97','146','3','21','10','','',''),
		T_TABLA('11','96','147','3','21','10','','',''),
		T_TABLA('11','95','148','3','21','10','','',''),
		T_TABLA('11','47','149','3','21','10','','',''),
		T_TABLA('15','70','150','3','42','4','','',''),
		T_TABLA('15','82','151','3','42','4','','',''),
		T_TABLA('15','81','152','3','43','1','','',''),
		T_TABLA('15','73','153','3','42','4','','',''),
		T_TABLA('15','74','154','3','42','4','','',''),
		T_TABLA('15','76','155','3','42','4','','',''),
		T_TABLA('15','75','156','3','42','9','','',''),
		T_TABLA('15','83','157','3','42','4','','',''),
		T_TABLA('15','80','158','3','43','1','','',''),
		T_TABLA('15','79','159','3','42','4','','',''),
		T_TABLA('15','72','160','3','42','4','','',''),
		T_TABLA('15','77','161','3','42','4','','',''),
		T_TABLA('15','71','162','3','42','4','','',''),
		T_TABLA('15','78','163','3','42','4','','',''),
		T_TABLA('18','99','164','3','42','4','','',''),
		T_TABLA('11','94','165','3','44','3','','',''),
		T_TABLA('11','50','166','3','45','3','','',''),
		T_TABLA('11','44','167','3','49','3','','',''),
		T_TABLA('11','43','168','3','49','3','','',''),
		T_TABLA('09','37','169','2','3','3','2','3','53'),
		T_TABLA('09','38','170','2','3','0','2','3','50'),
		T_TABLA('01','04','171','1','1','0','1','1','50'),
		T_TABLA('11','46','172','3','21','12','','',''),
		T_TABLA('17','88','173','3','48','2','','',''),
		T_TABLA('10','40','174','3','42','6','','',''),
		T_TABLA('10','39','175','3','42','6','','',''),
		T_TABLA('11','51','176','3','22','1','','',''),
		T_TABLA('16','86','177','3','42','5','','',''),
		T_TABLA('16','87','178','3','42','5','','',''),
		T_TABLA('16','85','178','3','42','5','','',''),
		T_TABLA('13','56','180','3','2','0','','',''),
		T_TABLA('13','55','181','3','2','0','','','')


    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
  V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA_AUX||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;
  
  IF V_NUM_REGISTROS > 0 THEN
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO '|| V_TABLA);
    FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
      LOOP
	  V_TMP_TABLA := M_TABLA(I);
		
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(DD_ETG_ID, DD_TGA_ID, DD_STG_ID
		  ,DD_ETG_CODIGO,DD_ETG_DESCRIPCION_POS,DD_ETG_DESCRIPCION_LARGA_POS
		  ,COGRUG_POS,COTACA_POS,COSBAC_POS, COGRUG_NEG, COTACA_NEG, COSBAC_NEG
		  ,VERSION,USUARIOCREAR,FECHACREAR
		  ,BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_ETG_EQV_TIPO_GASTO_RU.NEXTVAL, (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(1)||'''), (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_ID = '''||V_TMP_TABLA(2)||''')
		  ,'''||V_TMP_TABLA(3)||''', null, null
		  ,'''||V_TMP_TABLA(4)||''', '''||V_TMP_TABLA(5)||''', '''||V_TMP_TABLA(6)||''', '''||V_TMP_TABLA(7)||''' , '''||V_TMP_TABLA(8)||''', '''||V_TMP_TABLA(9)||''', 0, ''HREOS-14759'',SYSDATE,0)';
		EXECUTE IMMEDIATE V_SQL;	
		V_NUM_REGISTROS := V_NUM_REGISTROS + sql%rowcount;
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualzado en total '||V_NUM_REGISTROS||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
	COMMIT;
  END IF;
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
