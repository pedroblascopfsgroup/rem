--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16682
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
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16682';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	V_NUM NUMBER;
	V_FLAG_VACIADO NUMBER := 0;
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --DD_ETG_CODIGO  Elemento PEP	CLASE/GRUPO	  TIPO	SUBTIPO	DD_TGA_CODIGO	DD_STG_CODIGO	DD_TCO_CODIGO	DD_EAL_CODIGO	DD_TTR_CODIGO	PRIMERA POSESION
		T_TABLA('185','XXXX-22-2-COM','22','00','2','05','26','01','','','null'),
		T_TABLA('186','XXXX-22-2-COM','22','00','2','05','26','02','','','null'),
		T_TABLA('187','XXXX-22-2-COM','22','00','2','05','27','01','','','null'),
		T_TABLA('188','XXXX-22-2-COM','22','00','2','05','27','02','','','null'),
		T_TABLA('189','XXXX-22-2-A-COM','22','00','3','05','26','03','','','null'),
		T_TABLA('190','XXXX-22-2-A-COM','22','00','3','05','27','03','','','null'),
		T_TABLA('191','XXXX-22-2-IBI','22','00','7','01','01','01','','','null'),
		T_TABLA('192','XXXX-22-2-IBI','22','00','7','01','01','02','','','null'),
		T_TABLA('193','XXXX-22-2-A-IBI','22','00','9','01','01','03','','','null'),
		T_TABLA('194','XXXX-22-2-LIMP','22','00','13','15','73','01','','','null'),
		T_TABLA('195','XXXX-22-2-A-ROT','22','00','31','15','73','03','02','','null'),
		T_TABLA('196','XXXX-22-2-A-INC','22','00','30','15','73','03','01','','null'),
		T_TABLA('197','XXXX-22-2-LIMP','22','00','13','15','73','02','','','null'),
		T_TABLA('198','XXXX-22-2-A-ROT','22','00','31','15','73','02','02','','null'),
		T_TABLA('199','XXXX-22-2-A-INC','22','00','30','15','73','02','01','','null'),
		T_TABLA('200','XXXX-22-2-LIMP','22','00','13','15','75','01','','','null'),
		T_TABLA('201','XXXX-22-2-A-ROT','22','00','31','15','75','03','02','','null'),
		T_TABLA('202','XXXX-22-2-A-INC','22','00','30','15','75','03','01','','null'),
		T_TABLA('203','XXXX-22-2-LIMP','22','00','13','15','75','02','','','null'),
		T_TABLA('204','XXXX-22-2-A-ROT','22','00','31','15','75','02','02','','null'),
		T_TABLA('205','XXXX-22-2-A-ROT','22','00','30','15','75','02','01','','null'),
		T_TABLA('206','XXXX-22-2-LIMP','22','00','13','15','74','01','','','null'),
		T_TABLA('207','XXXX-22-2-A-ROT','22','00','31','15','74','03','02','','null'),
		T_TABLA('208','XXXX-22-2-A-INC','22','00','30','15','74','03','01','','null'),
		T_TABLA('209','XXXX-22-2-LIMP','22','00','13','15','74','02','','','null'),
		T_TABLA('210','XXXX-22-2-A-ROT','22','00','31','15','74','02','02','','null'),
		T_TABLA('211','XXXX-22-2-A-INC','22','00','30','15','74','02','01','','null'),
		T_TABLA('212','XXXX-22-2-REP POST 1','22','00','16','15','84','','','TR1','null'),
		T_TABLA('213','XXXX-22-2-REP POST 2','22','00','17','15','84','','','TR2','null'),
		T_TABLA('214','XXXX-22-2-MNT INC','22','00','21','15','78','01','','','null'),
		T_TABLA('215','XXXX-22-2-A-ROT','22','00','31','15','78','03','02','','null'),
		T_TABLA('216','XXXX-22-2-A-INC','22','00','30','15','78','03','01','','null'),
		T_TABLA('217','XXXX-22-2-MNT INC','22','00','21','15','78','02','','','null'),
		T_TABLA('218','XXXX-22-2-A-ROT','22','00','31','15','78','02','02','','null'),
		T_TABLA('219','XXXX-22-2-A-INC','22','00','30','15','78','02','01','','null'),
		T_TABLA('220','XXXX-22-3-REQ-SAN','22','00','23','04','24','','','','null'),
		T_TABLA('221','XXXX-22-2-MNT CERR','22','00','27','15','70','','','','null'),
		T_TABLA('222','XXXX-22-2-RC','22','00','34','10','40','01','','','null'),
		T_TABLA('223','XXXX-22-2-A-RC','22','00','35','10','40','03','','','null'),
		T_TABLA('224','XXXX-22-2-RC','22','00','34','10','40','02','','','null'),
		T_TABLA('225','XXXX-22-2-D.PRIMB','22','00','38','10','39','01','','','null'),
		T_TABLA('226','XXXX-22-2-A-D.PRIMB','22','00','39','10','39','03','','','null'),
		T_TABLA('227','XXXX-22-2-D.PRIMB','22','00','38','10','39','02','','','null'),
		T_TABLA('228','XXXX-22-2-ELEC','22','00','41','09','35','01','','','null'),
		T_TABLA('228','XXXX-22-2-A-ELEC','22','00','42','09','35','03','','','null'),
		T_TABLA('230','XXXX-22-2-ELEC','22','00','41','09','35','02','','','null'),
		T_TABLA('231','XXXX-22-2-AGUA','22','00','43','09','36','01','','','null'),
		T_TABLA('232','XXXX-22-2-A-AGUA','22','00','44','09','36','03','','','null'),
		T_TABLA('233','XXXX-22-2-AGUA','22','00','43','09','36','02','','','null'),
		T_TABLA('234','XXXX-22-2-OTROS','22','00','45','09','38','01','','','null'),
		T_TABLA('235','XXXX-22-2-A-OTROS','22','00','46','09','38','03','','','null'),
		T_TABLA('236','XXXX-22-2-OTROS','22','00','45','09','38','02','','','null'),
		T_TABLA('237','XXXX-22-1-PUE','22','00','48','15','82','','','','0'),
		T_TABLA('238','XXXX-22-1-ALA','22','00','49','16','86','','','','0'),
		T_TABLA('239','XXXX-22-1-VIGILANCIA','22','00','50','16','85','','','','null'),
		T_TABLA('240','XXXX-22-2-INF MNTO','22','00','52','14','68','01','','','null'),
		T_TABLA('241','XXXX-22-3-ASESORIA','22','00','69','11','49','01','','','null'),
		T_TABLA('242','XXXX-22-3-A-ASESORIA','22','00','70','11','49','03','','','null'),
		T_TABLA('243','XXXX-22-3-ASESORIA','22','00','69','11','49','02','','','null'),
		T_TABLA('244','XXXX-22-3-ABO RES','22','00','79','11','96','01','','','null'),
		T_TABLA('245','XXXX-22-3-A-ABO RES','22','00','80','11','96','03','','','null'),
		T_TABLA('246','XXXX-22-3-ABO RES','22','00','79','11','96','02','','','null'),
		T_TABLA('247','XXXX-22-3-NOT NEG','22','00','93','11','44','01','','','null'),
		T_TABLA('248','XXXX-22-3-A-NOT NEG','22','00','94','11','44','03','','','null'),
		T_TABLA('249','XXXX-22-3-NOT NEG','22','00','93','11','44','02','','','null'),
		T_TABLA('250','XXXX-22-2-IAE','22','01','7','01','05','01','','','null'),
		T_TABLA('251','XXXX-22-2-A-IAE','22','01','8','01','05','03','','','null'),
		T_TABLA('252','XXXX-22-2-IAE','22','01','7','01','05','02','','','null'),
		T_TABLA('253','XXXX-22-2-HON.GEST','22','01','17','12','53','01','','','null'),
		T_TABLA('254','XXXX-22-2-A-HON.GEST','22','01','18','12','53','03','','','null'),
		T_TABLA('255','XXXX-22-2-HON.GEST','22','01','17','12','53','02','','','null'),
		T_TABLA('256','XXXX-22-3-TAS','22','01','26','11','51','01','','','null'),
		T_TABLA('257','XXXX-22-3-A-TAS','22','01','32','11','51','03','','','null'),
		T_TABLA('258','XXXX-22-3-TAS','22','01','26','11','51','02','','','null'),
		T_TABLA('259','XXXX-22-3-TAS V TC','22','01','30','11','50','01','','','null'),
		T_TABLA('260','XXXX-22-3-A-TAS V TC','22','01','36','11','50','03','','','null'),
		T_TABLA('261','XXXX-22-3-TAS V TC','22','01','30','11','50','02','','','null'),
		T_TABLA('262','XXXX-22-2-PUB RES','22','01','52','17','88','01','','','null'),
		T_TABLA('263','XXXX-22-2-A-PUB RES','22','01','53','17','88','03','','','null'),
		T_TABLA('264','XXXX-22-2-PUB RES','22','01','52','17','88','02','','','null'),
		T_TABLA('265','XXXX-22-2-PLUSV','22','01','65','01','04','01','','','null'),
		T_TABLA('266','XXXX-22-2-A-PLUSV','22','01','66','01','04','03','','','null'),
		T_TABLA('267','XXXX-22-2-PLUSV','22','01','65','01','04','02','','','null'),
		T_TABLA('268','XXXX-22-3-I-CERT V','22','02','31','14','60','01','','','null'),
		T_TABLA('269','XXXX-22-3-A-I-CRT V','22','02','33','14','60','03','','','null'),
		T_TABLA('270','XXXX-22-3-I-CERT V','22','02','31','14','60','02','','','null'),
		T_TABLA('271','XXXX-22-3-I-MNT INC','22','02','22','15','80','01','','','null'),
		T_TABLA('272','XXXX-22-3-A-I-MNTINC','22','02','24','15','80','03','02','','null'),
		T_TABLA('273','XXXX-22-3-I-PUE','22','02','26','15','123','01','','','1'),
		T_TABLA('274','XXXX-22-3-A-I-PUE','22','02','28','15','123','03','','','1'),
		T_TABLA('275','XXXX-22-3-I-PUE','22','02','26','15','123','02','','','1'),
		T_TABLA('276','XXXX-22-3-I-ALA','22','02','27','16','124','01','','','1'),
		T_TABLA('277','XXXX-22-3-A-I-ALA','22','02','29','16','124','03','','','1'),
		T_TABLA('278','XXXX-22-3-I-ALA','22','02','27','16','124','02','','','1')




    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
  V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA_AUX||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;
  
  IF V_NUM_REGISTROS > 0 THEN

    FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
      LOOP
	  V_TMP_TABLA := M_TABLA(I);

	    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX||' WHERE 
						DD_ETG_CODIGO = '''||V_TMP_TABLA(1)||'''
	    ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTÁ INSERTADO EL REGISTRO, SE MODIFICA');
		V_SQL := 'UPDATE  '||V_ESQUEMA||'.'||V_TABLA||' SET				
				    DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(6)||''')
				  , DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(7)||''')
				  , DD_ETG_DESCRIPCION_POS = '''||V_TMP_TABLA(2)||'''
				  , DD_ETG_DESCRIPCION_LARGA_POS = '''||V_TMP_TABLA(2)||'''
				  , COGRUG_POS = '''||V_TMP_TABLA(3)||'''
				  , COTACA_POS = '''||V_TMP_TABLA(4)||'''
				  , COSBAC_POS = '''||V_TMP_TABLA(5)||'''
				  , COGRUG_NEG = '''||V_TMP_TABLA(3)||''' 
				  , COTACA_NEG = '''||V_TMP_TABLA(4)||'''
				  , COSBAC_NEG = '''||V_TMP_TABLA(5)||'''
				  , USUARIOMODIFICAR = ''HREOS-16682''
				  , FECHAMODIFICAR = SYSDATE
				  , PRO_ID = NULL
				  , DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TABLA(8)||''') 
				  , DD_EAL_ID = (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = '''||V_TMP_TABLA(9)||''')
				  , DD_TTR_ID = (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRANSMISION WHERE DD_TTR_CODIGO = '''||V_TMP_TABLA(10)||''') 
				  , PRIM_TOMA_POSESION = '||V_TMP_TABLA(11)||'
				  , EJE_ID = (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
				  , ELEMENTO_PEP = '''||V_TMP_TABLA(2)||'''
				  WHERE DD_ETG_CODIGO = '''||V_TMP_TABLA(1)||'''
		'; 
		EXECUTE IMMEDIATE V_SQL;	
		V_NUM_REGISTROS := V_NUM_REGISTROS + sql%rowcount;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualzado en total '||V_NUM_REGISTROS||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
        
    ELSE
		
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO '|| V_TABLA);

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'(
				  DD_ETG_ID
				, DD_TGA_ID
				, DD_STG_ID
				, DD_ETG_CODIGO
				, DD_ETG_DESCRIPCION_POS
				, DD_ETG_DESCRIPCION_LARGA_POS
				, COGRUG_POS
				, COTACA_POS
				, COSBAC_POS
				, COGRUG_NEG
				, COTACA_NEG
				, COSBAC_NEG
				, VERSION
				, USUARIOCREAR
				, FECHACREAR
				, BORRADO
				, PRO_ID
				, DD_TCO_ID
				, DD_EAL_ID
				, DD_TTR_ID
				, PRIM_TOMA_POSESION
				, EJE_ID
				, ELEMENTO_PEP
		  ) VALUES (
			  	'||V_ESQUEMA||'.S_DD_ETG_EQV_TIPO_GASTO_RU.NEXTVAL
				  , (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(6)||''')
				  , (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(7)||''')
				  , '''||V_TMP_TABLA(1)||'''
				  , '''||V_TMP_TABLA(2)||'''
				  , '''||V_TMP_TABLA(2)||'''
				  , '''||V_TMP_TABLA(3)||'''
				  , '''||V_TMP_TABLA(4)||'''
				  , '''||V_TMP_TABLA(5)||'''
				  , '''||V_TMP_TABLA(3)||''' 
				  , '''||V_TMP_TABLA(4)||'''
				  , '''||V_TMP_TABLA(5)||'''
				  , 0
				  , ''HREOS-16682''
				  , SYSDATE
				  , 0
				  , NULL
				  , (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = '''||V_TMP_TABLA(8)||''') 
				  , (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = '''||V_TMP_TABLA(9)||''')
				  , (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRANSMISION WHERE DD_TTR_CODIGO = '''||V_TMP_TABLA(10)||''') 
				  , '||V_TMP_TABLA(11)||'
				  , (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'')
				  , '''||V_TMP_TABLA(2)||'''
		)';
		EXECUTE IMMEDIATE V_SQL;	
		V_NUM_REGISTROS := V_NUM_REGISTROS + sql%rowcount;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en total '||V_NUM_REGISTROS||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
	
	END IF;
	END LOOP;
  END IF;
	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
	commit;


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
