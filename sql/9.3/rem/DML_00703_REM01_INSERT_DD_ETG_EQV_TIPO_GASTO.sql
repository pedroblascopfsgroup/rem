--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220201
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17087
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-16682]- Alejandra García
--##        0.2 Sustituir el DD_TCO_ID por el DD_CBC_ID - [HREOS-16765]- Alejandra García
--##        0.3 Añadir PEPs de IAEs - [HREOS-16896]- Alejandra García
--##        0.4 Modificación del array porque el PEP XXXX-22-2-A-INC debe de tener un contrato vigente de alquiler y el -ROT (rotacional) no - [HREOS-16900]- Alejandra García
--##        0.4 Quitar el PEP XXXX-22-2-A-ROT  - [HREOS-16900]- Alejandra García
--##        0.5 Cambio de cógidos porque se pisaban las descripciones debido al HREOS-16512 - [HREOS-16953] - Alejandra García
--##        0.6 Añadir dos líneas nuevas de Alarmas y Colocación puerta antiocupa, y modificación códigos Alarmas y Duplicado Cédula Habitabilidad - [HREOS-16953] - Alejandra García
--##        0.7 Añadir Promociones y cambiar todos los códigos de los subtipos nuevos del PEP - [HREOS-17018] - Alejandra García
--##        0.8 Modificar códigos gastos IAE - [HREOS-17087] - Alejandra García
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16900';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	V_NUM NUMBER;
	V_FLAG_VACIADO NUMBER := 0;
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --DD_ETG_CODIGO  Elemento PEP	CLASE/GRUPO	  TIPO	SUBTIPO	DD_TGA_CODIGO	DD_STG_CODIGO	DD_CBC_CODIGO	DD_EAL_CODIGO	DD_TTR_CODIGO	PRIMERA POSESION    DD_SED_CODIGO    PROMOCION
		T_TABLA('185','XXXX-22-2-COM','22','00','2','05','26','01','','','null','','null'),
		T_TABLA('186','XXXX-22-2-COM','22','00','2','05','27','01','','','null','','null'),
		T_TABLA('187','XXXX-22-2-A-COM','22','00','3','05','26','03','','','null','','null'),
		T_TABLA('188','XXXX-22-2-A-COM','22','00','3','05','27','03','','','null','','null'),
		T_TABLA('189','XXXX-22-2-IBI','22','00','7','01','01','01','','','null','','null'),
		T_TABLA('190','XXXX-22-2-A-IBI','22','00','9','01','01','03','','','null','','null'),
		T_TABLA('191','XXXX-22-2-LIMP','22','00','13','15','73','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','73','01','01','','null','','null'),
		T_TABLA('192','XXXX-22-2-A-INC','22','00','30','15','73','03','02','','null','','null'),
		T_TABLA('193','XXXX-22-2-LIMP','22','00','13','15','75','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','75','01','01','','null','','null'),
		T_TABLA('194','XXXX-22-2-A-INC','22','00','30','15','75','03','02','','null','','null'),
		T_TABLA('195','XXXX-22-2-LIMP','22','00','13','15','74','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','74','01','01','','null','','null'),
		T_TABLA('196','XXXX-22-2-A-INC','22','00','30','15','74','03','02','','null','','null'),
		T_TABLA('197','XXXX-22-2-REP POST 1','22','00','16','15','84','','','TR1','null','','null'),
		T_TABLA('198','XXXX-22-2-REP POST 2','22','00','17','15','84','','','TR2','null','','null'),
		T_TABLA('199','XXXX-22-2-MNT INC','22','00','21','15','78','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','78','01','01','','null','','null'),
		T_TABLA('200','XXXX-22-2-A-INC','22','00','30','15','78','03','02','','null','','null'),
		T_TABLA('201','XXXX-22-3-REQ-SAN','22','00','23','04','24','','','','null','','null'),
		T_TABLA('202','XXXX-22-2-MNT CERR','22','00','27','15','70','','','','null','','null'),
		T_TABLA('203','XXXX-22-2-RC','22','00','34','10','40','01','','','null','','null'),
		T_TABLA('204','XXXX-22-2-A-RC','22','00','35','10','40','03','','','null','','null'),
		T_TABLA('205','XXXX-22-2-D.PRIMB','22','00','38','10','39','01','','','null','','null'),
		T_TABLA('206','XXXX-22-2-A-D.PRIMB','22','00','39','10','39','03','','','null','','null'),
		T_TABLA('207','XXXX-22-2-ELEC','22','00','41','09','35','01','','','null','','null'),
		T_TABLA('208','XXXX-22-2-A-ELEC','22','00','42','09','35','03','','','null','','null'),
		T_TABLA('209','XXXX-22-2-AGUA','22','00','43','09','36','01','','','null','','null'),
		T_TABLA('210','XXXX-22-2-A-AGUA','22','00','44','09','36','03','','','null','','null'),
		T_TABLA('211','XXXX-22-2-OTROS','22','00','45','09','38','01','','','null','','null'),
		T_TABLA('212','XXXX-22-2-A-OTROS','22','00','46','09','38','03','','','null','','null'),
		T_TABLA('213','XXXX-22-1-PUE','22','00','48','15','82','01','','','0','','null'),
		T_TABLA('315','XXXX-22-1-PUE','22','00','48','15','82','03','','','0','','null'),
		T_TABLA('214','XXXX-22-1-ALA','22','00','49','16','86','01','','','0','','null'),
		T_TABLA('316','XXXX-22-1-ALA','22','00','49','16','86','03','','','0','','null'),
		T_TABLA('215','XXXX-22-1-VIGILANCIA','22','00','50','16','85','','','','null','','null'),
		T_TABLA('216','XXXX-22-2-INF MNTO','22','00','52','14','68','01','','','null','','null'),
		T_TABLA('217','XXXX-22-3-ASESORIA','22','00','69','11','49','01','','','null','','null'),
		T_TABLA('218','XXXX-22-3-A-ASESORIA','22','00','70','11','49','03','','','null','','null'),
		T_TABLA('219','XXXX-22-3-ABO RES','22','00','79','11','96','01','','','null','','null'),
		T_TABLA('220','XXXX-22-3-A-ABO RES','22','00','80','11','96','03','','','null','','null'),
		T_TABLA('221','XXXX-22-3-NOT NEG','22','00','93','11','44','01','','','null','','null'),
		T_TABLA('222','XXXX-22-3-A-NOT NEG','22','00','94','11','44','03','','','null','','null'),
		T_TABLA('223','XXXX-22-2-IAE','22','01','7','01','05','01','','','null','','null'),
		T_TABLA('224','XXXX-22-2-A-IAE','22','01','8','01','05','03','','','null','','null'),
		T_TABLA('225','XXXX-22-2-HON.GEST','22','01','17','12','53','01','','','null','','null'),
		T_TABLA('226','XXXX-22-2-A-HON.GEST','22','01','18','12','53','03','','','null','','null'),
		T_TABLA('227','XXXX-22-3-TAS','22','01','26','11','51','01','','','null','','null'),
		T_TABLA('228','XXXX-22-3-A-TAS','22','01','32','11','51','03','','','null','','null'),
		T_TABLA('229','XXXX-22-3-TAS V TC','22','01','30','11','50','01','','','null','','null'),
		T_TABLA('230','XXXX-22-3-A-TAS V TC','22','01','36','11','50','03','','','null','','null'),
		T_TABLA('231','XXXX-22-2-PUB RES','22','01','52','17','88','01','','','null','','null'),
		T_TABLA('232','XXXX-22-2-A-PUB RES','22','01','53','17','88','03','','','null','','null'),
		T_TABLA('233','XXXX-22-2-PLUSV','22','01','65','01','04','01','','','null','','null'),
		T_TABLA('234','XXXX-22-2-A-PLUSV','22','01','66','01','04','03','','','null','','null'),
		T_TABLA('235','XXXX-22-3-I-CERT V','22','02','31','14','60','01','','','null','','null'),
		T_TABLA('236','XXXX-22-3-A-I-CRT V','22','02','33','14','60','03','','','null','','null'),
		--Subtipologías nuevas
		T_TABLA('237','XXXX-22-2-COM MON','22','00','4','05','183','01','','','null','','null'),
		T_TABLA('238','XXXX-22-2-A-COM MON','22','00','5','05','183','03','','','null','','null'),
		T_TABLA('239','XXXX-22-2-MNT DER','22','00','20','15','184','','','','null','','null'),
		T_TABLA('240','XXXX-22-3-I-MNT INC','22','02','22','15','174','01','','','null','','null'),
		T_TABLA('241','XXXX-22-3-A-I-ADC OT','22','02','19','15','174','03','02','','null','','null'),
		T_TABLA('242','XXXX-22-3-A-I-MNTINC','22','02','24','15','174','03','01','','null','','null'),
		T_TABLA('243','XXXX-22-3-REQ DERR','22','00','24','15','189','','','','null','','null'),
		T_TABLA('244','XXXX-22-3-REQ LIMP','22','00','25','15','190','','','','null','','null'),
		T_TABLA('245','XXXX-22-3-REQ OTROS','22','00','26','15','191','','','','null','','null'),
		T_TABLA('246','XXXX-22-2-TAR.PL','22','00','28','13','192','01','','','null','','null'),
		T_TABLA('247','XXXX-22-2-A-TAR.PL','22','00','32','13','192','03','','','null','','null'),
		T_TABLA('248','XXXX-22-2-COM.BROK','22','00','36','10','193','01','','','null','','null'),
		T_TABLA('249','XXXX-22-2-A-COM.BROK','22','00','37','10','193','03','','','null','','null'),
		T_TABLA('250','XXXX-22-3-I-PUE','22','02','26','15','82','01','','','1','','null'),
		T_TABLA('251','XXXX-22-3-A-I-PUE','22','02','28','15','82','03','','','1','','null'),
		T_TABLA('252','XXXX-22-3-I-ALA','22','02','27','16','86','01','','','1','','null'),
		T_TABLA('253','XXXX-22-3-A-I-ALA','22','02','29','16','86','03','','','1','','null'),
		T_TABLA('254','XXXX-22-2-A-INF ROT','22','00','54','14','194','03','','','null','','null'),
		T_TABLA('255','XXXX-22-2-A-INF LOC','22','00','55','14','157','03','','','null','','null'),--157
		T_TABLA('256','XXXX-22-2-A-INF OCU','22','00','56','14','158','03','','','null','','null'),
		T_TABLA('257','XXXX-22-2-INF-REOCU','22','00','58','14','159','','','','null','','null'),
		T_TABLA('258','XXXX-22-3-ABO FIS','22','00','83','11','160','01','','','null','','null'),
		T_TABLA('259','XXXX-22-3-A-ABO FIS','22','00','84','11','160','03','','','null','','null'),
		T_TABLA('260','XXXX-22-3-ABO LEY','22','00','87','11','161','01','','','null','','null'),
		T_TABLA('261','XXXX-22-3-A-ABO LEY','22','00','88','11','161','03','','','null','','null'),
		T_TABLA('262','XXXX-22-3-A-DES','22','01','1','11','162','03','','','null','','null'),
		T_TABLA('263','XXXX-22-3-A-T JD DES','22','01','2','02','163','03','','','null','','null'),
		T_TABLA('264','XXXX-22-3-REO','22','01','4','11','164','','','','null','','null'),
		T_TABLA('265','XXXX-22-3-T.JUD.REO','22','01','5','02','165','','','','null','','null'),
		T_TABLA('266','XXXX-22-2-A-HON ALT','22','01','19','13','166','03','','','null','','null'),
		T_TABLA('267','XXXX-22-2-FERIAS','22','01','50','17','167','01','','','null','','null'),
		T_TABLA('268','XXXX-22-2-A-FERIAS','22','01','51','17','167','03','','','null','','null'),
		T_TABLA('269','XXXX-22-2-COM VT','22','01','57','13','168','01','','','null','','null'),
		T_TABLA('270','XXXX-22-2-A-COM VT','22','01','58','13','168','03','','','null','','null'),
		T_TABLA('271','XXXX-22-2-COM VT GS','22','01','59','12','169','01','','','null','','null'),
		T_TABLA('272','XXXX-22-2-A-CM VT GS','22','01','60','12','169','03','','','null','','null'),
		T_TABLA('273','XXXX-22-2-CAMPAÑAS','22','01','62','17','170','01','','','null','','null'),
		T_TABLA('274','XXXX-22-2-A-CAMPAÑAS','22','01','63','17','170','03','','','null','','null'),
		T_TABLA('275','XXXX-22-2-C-COM','22','02','6','05','171','01','','','null','','null'),
		T_TABLA('276','XXXX-22-2-A-C-COM','22','02','7','05','171','03','','','null','','null'),
		T_TABLA('277','XXXX-22-2-C-IBIS','22','02','8','01','172','01','','','null','','null'),
		T_TABLA('278','XXXX-22-2-A-C-IBIS','22','02','9','01','172','03','','','null','','null'),
		T_TABLA('279','XXXX-22-3-I-ADC HB','22','02','16','15','173','01','','','null','','null'),
		T_TABLA('280','XXXX-22-3-A-I-ADC HB','22','02','18','15','173','03','','','null','','null'),
		T_TABLA('281','XXXX-22-3-I-MNT-REAH','22','02','21','15','175','','','','null','','null'),
		T_TABLA('282','XXXX-22-2-HSTK0%','22','01','20','13','176','','','','null','','null'),
		T_TABLA('283','XXXX-22-2-A-HSTK0%','22','01','21','13','176','','','','null','','null'),
		T_TABLA('284','XXXX-22-2-HSTK100%','22','02','44','13','177','','','','null','','null'),
		T_TABLA('285','XXXX-22-2-A-HSTK100%','22','02','41','13','177','','','','null','','null'),
		T_TABLA('286','XXXX-22-2-CGG0%','22','02','49','13','178','','','','null','','null'),
		T_TABLA('287','XXXX-22-2-A-CGG0%','22','02','51','13','178','','','','null','','null'),
		T_TABLA('288','XXXX-22-2-CGG100%','22','02','50','13','179','','','','null','','null'),
		T_TABLA('289','XXXX-22-2-A-CGG100%','22','02','52','13','179','','','','null','','null'),
		T_TABLA('290','XXXX-22-2-CGGF','22','02','53','13','180','','','','null','','null'),
		T_TABLA('291','XXXX-22-2-TP0%','22','00','28','13','181','','','','null','','null'),
		T_TABLA('292','XXXX-22-2-A-TP0%','22','00','32','13','181','','','','null','','null'),
		T_TABLA('293','XXXX-22-2-TP100%','22','02','42','13','182','','','','null','','null'),
		T_TABLA('294','XXXX-22-2-A-TP100%','22','02','43','13','182','','','','null','','null'),
		--Nuevos registros
		T_TABLA('295','XXXX-22-2-MNT INC','22','00','21','15','186','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','186','01','01','','null','','null'),
		T_TABLA('296','XXXX-22-2-A-INC','22','00','30','15','186','03','02','','null','','null'),
		T_TABLA('297','XXXX-22-2-MNT INC','22','00','21','15','79','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','79','01','01','','null','','null'),
		T_TABLA('298','XXXX-22-2-A-INC','22','00','30','15','79','03','02','','null','','null'),
		T_TABLA('299','XXXX-22-2-MNT INC','22','00','21','15','77','01','','','null','','null'),
		--T_TABLA('','XXXX-22-2-A-ROT','22','00','31','15','77','01','01','','null','','null'),
		T_TABLA('300','XXXX-22-2-A-INC','22','00','30','15','77','03','02','','null','','null'),
		T_TABLA('301','XXXX-22-3-REQ-SAN','22','00','23','04','25','','','','null','','null'),
		T_TABLA('302','XXXX-22-3-REQ-SAN','22','00','23','04','23','','','','null','','null'),
		T_TABLA('303','XXXX-22-3-REQ-SAN','22','00','23','04','22','','','','null','','null'),
		T_TABLA('304','XXXX-22-3-REQ-SAN','22','00','23','04','21','','','','null','','null'),
		T_TABLA('305','XXXX-22-1-PUE','22','00','48','15','71','','','','null','','null'),
		T_TABLA('306','XXXX-22-2-INF MNTO','22','00','52','14','57','','','','null','','null'),
		T_TABLA('307','XXXX-22-2-INF MNTO','22','00','52','15','187','','','','null','','null'),
		T_TABLA('308','XXXX-22-2-INF MNTO','22','00','52','11','188','','','','null','','null'),
		T_TABLA('309','XXXX-22-2-A-INF ROT','22','00','54','14','185','','','','null','','null'),
		T_TABLA('310','XXXX-22-3-NOT NEG','22','00','93','11','43','01','','','null','','null'),
		T_TABLA('311','XXXX-22-3-A-NOT NEG','22','00','94','11','43','03','','','null','','null'),
		--Registros IAEs
		T_TABLA('312','XXXX-22-2-IAE','22','01','7','01','238','','','','null','','null'),
		T_TABLA('313','XXXX-22-2-A_IAE','22','01','8','01','239','','','','null','','null'),
		T_TABLA('314','XXXX-22-2-IAE_CF','22','01','9','01','237','','','','null','','null'),
		--Promociones
		T_TABLA('315','0015-22-4-10017966_OP','22','02','82','','','','','','null','01','10017966'),
		T_TABLA('316','0015-22-4-5933434_OP','22','03','32','','','','','','null','01','5933434'),
		T_TABLA('317','0015-22-4-10017966_A1','22','02','83','','','','','','null','02','10017966'),
		T_TABLA('318','0015-22-4-5933434_A1','22','03','33','','','','','','null','02','5933434'),
		T_TABLA('319','0015-22-4-10017966_A2','22','02','84','','','','','','null','03','10017966'),
		T_TABLA('320','0015-22-4-5933434_A2','22','03','34','','','','','','null','03','5933434'),
		T_TABLA('321','0015-22-4-10017966_UB','22','02','85','','','','','','null','04','10017966'),
		T_TABLA('322','0015-22-4-5933434_UB','22','03','35','','','','','','null','04','5933434'),
		T_TABLA('323','0015-22-4-10017966_CC','22','02','86','','','','','','null','05','10017966'),
		T_TABLA('324','0015-22-4-5933434_CC','22','03','36','','','','','','null','05','5933434'),
		T_TABLA('325','0015-22-4-10017966_CE','22','02','87','','','','','','null','06','10017966'),
		T_TABLA('326','0015-22-4-5933434_CE','22','03','37','','','','','','null','06','5933434'),
		T_TABLA('327','0015-22-4-10017966_CA','22','02','88','','','','','','null','07','10017966'),
		T_TABLA('328','0015-22-4-5933434_CA','22','03','38','','','','','','null','07','5933434'),
		T_TABLA('329','0015-22-4-10017966_CG','22','02','89','','','','','','null','08','10017966'),
		T_TABLA('330','0015-22-4-5933434_CG','22','03','39','','','','','','null','08','5933434'),
		T_TABLA('331','0015-22-4-10017966_CT','22','02','90','','','','','','null','09','10017966'),
		T_TABLA('332','0015-22-4-5933434_CT','22','03','40','','','','','','null','09','5933434'),
		T_TABLA('333','0015-22-4-10017966_CO','22','02','91','','','','','','null','10','10017966'),
		T_TABLA('334','0015-22-4-5933434_CO','22','03','41','','','','','','null','10','5933434'),
		T_TABLA('335','0015-22-4-10017966_TA','22','02','92','','','','','','null','11','10017966'),
		T_TABLA('336','0015-22-4-5933434_TA','22','03','42','','','','','','null','11','5933434'),
		T_TABLA('337','0015-22-4-10017966_DT','22','02','94','','','','','','null','12','10017966'),
		T_TABLA('338','0015-22-4-5933434_DT','22','03','44','','','','','','null','12','5933434'),
		T_TABLA('339','0015-22-4-10017966_PB','22','02','95','','','','','','null','13','10017966'),
		T_TABLA('340','0015-22-4-5933434_PB','22','03','45','','','','','','null','13','5933434'),
		T_TABLA('341','0015-22-4-10017966_PU','22','02','96','','','','','','null','14','10017966'),
		T_TABLA('342','0015-22-4-5933434_PU','22','03','46','','','','','','null','14','5933434'),
		T_TABLA('343','0015-22-4-10017966_EP','22','02','97','','','','','','null','15','10017966'),
		T_TABLA('344','0015-22-4-5933434_EP','22','03','47','','','','','','null','15','5933434'),
		T_TABLA('345','0015-22-4-10017966_AR','22','02','98','','','','','','null','16','10017966'),
		T_TABLA('346','0015-22-4-5933434_AR','22','03','48','','','','','','null','16','5933434'),
		T_TABLA('347','0015-22-4-10017966_AP','22','02','99','','','','','','null','17','10017966'),
		T_TABLA('348','0015-22-4-5933434_AP','22','03','49','','','','','','null','17','5933434'),
		T_TABLA('349','0015-22-4-10017966_SS','22','03','1','','','','','','null','18','10017966'),
		T_TABLA('350','0015-22-4-5933434_SS','22','03','50','','','','','','null','18','5933434'),
		T_TABLA('351','0015-22-4-10017966_PM','22','03','2','','','','','','null','19','10017966'),
		T_TABLA('352','0015-22-4-5933434_PM','22','03','51','','','','','','null','19','5933434'),
		T_TABLA('353','0015-22-4-10017966_PC','22','03','3','','','','','','null','20','10017966'),
		T_TABLA('354','0015-22-4-5933434_PC','22','03','52','','','','','','null','20','5933434'),
		T_TABLA('355','0015-22-4-10017966_OC','22','03','4','','','','','','null','21','10017966'),
		T_TABLA('356','0015-22-4-5933434_OC','22','03','53','','','','','','null','21','5933434'),
		T_TABLA('357','0015-22-4-10017966_TP','22','03','5','','','','','','null','22','10017966'),
		T_TABLA('358','0015-22-4-5933434_TP','22','03','54','','','','','','null','22','5933434'),
		T_TABLA('359','0015-22-4-10017966_GT','22','03','6','','','','','','null','23','10017966'),
		T_TABLA('360','0015-22-4-5933434_GT','22','03','55','','','','','','null','23','5933434'),
		T_TABLA('361','0015-22-4-10017966_RP','22','03','7','','','','','','null','24','10017966'),
		T_TABLA('362','0015-22-4-5933434_RP','22','03','56','','','','','','null','24','5933434'),
		T_TABLA('363','0015-22-4-10017966_EJ','22','03','8','','','','','','null','25','10017966'),
		T_TABLA('364','0015-22-4-5933434_EJ','22','03','57','','','','','','null','25','5933434'),
		T_TABLA('365','0015-22-4-10017966_OH','22','03','9','','','','','','null','26','10017966'),
		T_TABLA('366','0015-22-4-5933434_OH','22','03','58','','','','','','null','26','5933434'),
		T_TABLA('367','0015-22-4-10017966_GS','22','03','10','','','','','','null','27','10017966'),
		T_TABLA('368','0015-22-4-5933434_GS','22','03','59','','','','','','null','27','5933434'),
		T_TABLA('369','0015-22-4-10017966_SD','22','03','12','','','','','','null','28','10017966'),
		T_TABLA('370','0015-22-4-5933434_SD','22','03','61','','','','','','null','28','5933434'),
		T_TABLA('371','0015-22-4-10017966_DH','22','03','13','','','','','','null','29','10017966'),
		T_TABLA('372','0015-22-4-5933434_DH','22','03','62','','','','','','null','29','5933434'),
		T_TABLA('373','0015-22-4-10017966_ON','22','03','14','','','','','','null','30','10017966'),
		T_TABLA('374','0015-22-4-5933434_ON','22','03','63','','','','','','null','30','5933434'),
		T_TABLA('375','0015-22-4-10017966_AF','22','03','15','','','','','','null','31','10017966'),
		T_TABLA('376','0015-22-4-5933434_AF','22','03','64','','','','','','null','31','5933434'),
		T_TABLA('377','0015-22-4-10017966_SA','22','03','16','','','','','','null','32','10017966'),
		T_TABLA('378','0015-22-4-5933434_SA','22','03','65','','','','','','null','32','5933434'),
		T_TABLA('379','0015-22-4-10017966_OT','22','03','17','','','','','','null','33','10017966'),
		T_TABLA('380','0015-22-4-5933434_OT','22','03','66','','','','','','null','33','5933434'),
		T_TABLA('381','0015-22-4-10017966_LO','22','03','18','','','','','','null','34','10017966'),
		T_TABLA('382','0015-22-4-5933434_LO','22','03','67','','','','','','null','34','5933434'),
		T_TABLA('383','0015-22-4-10017966_IC','22','03','19','','','','','','null','35','10017966'),
		T_TABLA('384','0015-22-4-5933434_IC','22','03','68','','','','','','null','35','5933434'),
		T_TABLA('385','0015-22-4-10017966_L1','22','03','20','','','','','','null','36','10017966'),
		T_TABLA('386','0015-22-4-5933434_L1','22','03','69','','','','','','null','36','5933434'),
		T_TABLA('387','0015-22-4-10017966_OO','22','03','21','','','','','','null','37','10017966'),
		T_TABLA('388','0015-22-4-5933434_OO','22','03','70','','','','','','null','37','5933434'),
		T_TABLA('389','0015-22-4-10017966_AJ','22','03','23','','','','','','null','38','10017966'),
		T_TABLA('390','0015-22-4-5933434_AJ','22','03','72','','','','','','null','38','5933434'),
		T_TABLA('391','0015-22-4-10017966_IP','22','03','25','','','','','','null','42','10017966'),
		T_TABLA('392','0015-22-4-5933434_IP','22','03','74','','','','','','null','42','5933434')
		/*T_TABLA('393','0015-22-4-10017966_PV','22','03','27','','','','','','null','???','10017966'),
		T_TABLA('394','0015-22-4-5933434_PV','22','03','76','','','','','','null','???','5933434'),
		T_TABLA('395','0015-22-4-10017966_SG','22','03','29','','','','','','null','???','10017966'),
		T_TABLA('396','0015-22-4-5933434_SG','22','03','78','','','','','','null','???','5933434')*/--FALTA SABER EL DD_SED_CODIGO


    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
  V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||V_TABLA_AUX||'''';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

    
  
  	IF V_NUM_REGISTROS > 0 THEN


	--Se borran todos los registros de la DD_ETG_EQV_TIPO_GASTO con el ELEMENTO_PEP relleno y cuyo año de ejercicio sea el 2022
	DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO '|| V_TABLA);

	V_SQL := 'DELETE
			  FROM '||V_ESQUEMA||'.'||V_TABLA||' ETG
			  WHERE ETG.ELEMENTO_PEP IS NOT NULL
			  AND ETG.EJE_ID = (SELECT EJE_ID FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO WHERE EJE_ANYO=''2022'')
		';
	EXECUTE IMMEDIATE V_SQL;	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado en la tabla '||V_ESQUEMA||'.'||V_TABLA||' (' || sql%rowcount || ') registros');

	FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
    LOOP
	V_TMP_TABLA := M_TABLA(I);	

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTANDO '|| V_TABLA);

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
				, DD_CBC_ID
				, DD_EAL_ID
				, DD_TTR_ID
				, PRIM_TOMA_POSESION
				, EJE_ID
				, ELEMENTO_PEP
				, DD_SED_ID
				, PROMOCION
		  ) VALUES (
			  	'||V_ESQUEMA||'.S_DD_ETG_EQV_TIPO_GASTO_RU.NEXTVAL
				  , (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(6)||''' AND BORRADO = 0 )
				  , (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(7)||''' AND BORRADO = 0 )
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
				  ,  '''||V_USUARIO||'''
				  , SYSDATE
				  , 0
				  , (SELECT DD_CBC_ID FROM '||V_ESQUEMA||'.DD_CBC_CARTERA_BC WHERE DD_CBC_CODIGO = '''||V_TMP_TABLA(8)||''' AND BORRADO = 0 ) 
				  , (SELECT DD_EAL_ID FROM '||V_ESQUEMA||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = '''||V_TMP_TABLA(9)||''' AND BORRADO = 0 )
				  , (SELECT DD_TTR_ID FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRANSMISION WHERE DD_TTR_CODIGO = '''||V_TMP_TABLA(10)||''' AND BORRADO = 0 ) 
				  , '||V_TMP_TABLA(11)||'
				  , (SELECT EJE2.EJE_ID FROM '|| V_ESQUEMA ||'.ACT_EJE_EJERCICIO EJE2 WHERE EJE2.EJE_ANYO = ''2022'' AND EJE2.BORRADO = 0 )
				  , '''||V_TMP_TABLA(2)||'''
				  , (SELECT DD_SED_ID FROM '||V_ESQUEMA||'.DD_SED_SUBPARTIDA_EDIFICACION WHERE DD_SED_CODIGO = '''||V_TMP_TABLA(12)||''' AND BORRADO = 0 )
				  , '''||V_TMP_TABLA(13)||'''
		)';
		EXECUTE IMMEDIATE V_SQL;	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado en la tabla '||V_ESQUEMA||'.'||V_TABLA||' el código '||V_TMP_TABLA(1)||' ');
  	
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
