--/*
--#########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20211028
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15516
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-15516';
	V_NUM_REGISTROS NUMBER; -- Cuenta registros 
	V_FLAG_VACIADO NUMBER := 0;
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
	
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --DD_STG_ID|COGRUG_POS|COTACA_POS|COSBAC_POS|COGRUG_NEG|COTACA_NEG|COSBAC_NEG|Descrip Pos| Descrip Neg-----
		T_TABLA('15','70','01','3','42','4','','','','Servicio Control Y Mnto. Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('15','82','02','3','42','4','','','','Servicio Alquiler Puertas Anti-Ocupa Mayo-Dic 2018'),
		T_TABLA('15','73','03','3','42','4','','','','Servicio Control Y Mnto. Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('15','74','04','3','42','4','','','','Servicio Control Y Mnto. Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('15','79','05','3','42','4','','','','Ren.Servicios Activos Adjudicados/Toma Posesion'),
		T_TABLA('06','29','06','2','2','4','','','','Comunidades De Propietarios'),
		T_TABLA('06','28','07','2','2','3','','','','Comunidades De Propietarios'),
		T_TABLA('05','93','08','2','2','1','','','','Comunidades De Propietarios'),
		T_TABLA('05','27','09','2','2','2','2','2','52','Comunidades De Propietarios'),
		T_TABLA('05','26','10','2','2','1','2','2','51','Comunidades De Propietarios'),
		T_TABLA('12','53','11','3','49','4','','','','Serv.Gestorias, Notarias Asun.Diversos Activos Inmobiliarios'),
		T_TABLA('12','54','12','3','35','2','','','','Servicio De Gestorías Fase Iii- Venta De Activos'),
		T_TABLA('01','02','13','2','1','9','2','1','59','Tributos'),
		T_TABLA('01','01','14','2','1','1','2','1','51','Ibi'),
		T_TABLA('01','06','15','2','1','6','','','','Ibi'),
		T_TABLA('01','04','16','1','1','50','','','','Plusvalia Municipal Venta Inmovilizado Ajd'),
		T_TABLA('14','60','17','3','42','8','','','','Renov. Servicio Tramitacion Obtencion Cedulas Habitabilidad'),
		T_TABLA('14','58','18','3','45','5','','','','Servicio Control Y Mnto. Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('14','61','19','3','45','2','','','','Servicio Actuac.Tecnicas Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('14','57','20','3','45','2','','','','Servicio Actuac.Tecnicas Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('14','59','21','3','45','2','','','','Servicio Actuac.Tecnicas Activos Adjudicados Nov.17-Dic.18'),
		T_TABLA('14','63','22','3','45','2','','','','Serv.Gestorias, Notarias Asun.Diversos Activos Inmobiliarios'),
		T_TABLA('07','31','23','3','44','5','','','','Comunidades De Propietarios'),
		T_TABLA('07','30','24','3','44','5','','','','Gestion Activos - Comunidades De Propietarios'),
		T_TABLA('08','33','25','2','2','2','','','','Gestion Activos - Comunidades De Propietarios'),
		T_TABLA('08','32','26','2','2','1','','','','Comunidades De Propietarios'),
		T_TABLA('08','34','27','2','2','20','2','2','50','Comunidades De Propietarios'),
		T_TABLA('18','98','28','2','2','6','2','2','56','Comunidades De Propietarios'),
		T_TABLA('18','99','29','3','42','4','','','','Ampliación Comunidades Propietarios'),
		T_TABLA('18','89','30','2','2','2','','','','Ampli. Comunidad De Propietarios'),
		T_TABLA('03','19','31','2','1','5','2','1','55','Ibi'),
		T_TABLA('03','20','32','2','1','6','2','1','56','Ibi'),
		T_TABLA('17','88','33','3','48','7','','','','Haya Real Estate: Campaña Anual 2018'),
		T_TABLA('04','24','34','2','1','6','','','','Ibi'),
		T_TABLA('04','25','35','2','1','6','','','','Ibi'),
		T_TABLA('04','23','36','2','1','6','','','','Ibi'),
		T_TABLA('04','22','37','2','1','6','2','1','56','Ibi'),
		T_TABLA('04','21','38','2','1','6','','','','Ibi'),
		T_TABLA('10','40','39','3','42','6','','','','Impago Alquileres'),
		T_TABLA('11','97','40','3','21','10','','','','Reclamacion Judicial Plusvalias Municipales'),
		T_TABLA('11','96','41','3','21','10','','','','Serv. Gestion Situaciones Ocupacionales Activos Adjudicados'),
		T_TABLA('11','95','42','3','21','10','','','','Serv. Gestion Situaciones Ocupacionales Activos Adjudicados'),
		T_TABLA('11','44','43','3','60','2','','','','Renovación Asesoram. Jurídico Gestión Activos Inmob. Bankia'),
		T_TABLA('11','47','44','3','21','10','','','','Ampliación Gestión De Situaciones Ocupacionales De Activos'),
		T_TABLA('11','46','45','3','21','12','','','','Ratificacion Servicio Contratado Despachos'),
		T_TABLA('11','51','46','3','22','1','','','','Activos Disponibles Para La Venta'),
		T_TABLA('09','36','47','2','3','2','2','3','52','Suministros Bankia'),
		T_TABLA('09','35','48','2','3','1','2','3','51','Suministros Bankia'),
		T_TABLA('09','37','49','2','3','3','','','','Suministros Bankia'),
		T_TABLA('09','38','50','2','3','0','','','','Suministros Bankia'),
		T_TABLA('02','10','51','2','1','4','2','1','54','Tributos'),
		T_TABLA('02','09','52','2','1','3','2','1','53','Ampliación Ibi'),
		T_TABLA('02','08','53','2','1','2','2','1','52','Ampliación Ibi'),
		T_TABLA('02','12','54','2','1','8','2','1','58','Ibi'),
		T_TABLA('02','14','55','2','1','6','2','1','56','Ibi'),
		T_TABLA('02','16','56','2','1','6','','','','Ibi'),
		T_TABLA('02','15','57','2','1','6','2','1','56','Ampliación Ibi'),
		T_TABLA('02','18','58','2','1','1','2','1','56','Ibi'),
		T_TABLA('02','17','59','2','1','6','2','1','56','Tributos'),
		T_TABLA('02','13','60','2','1','6','2','1','56','Ibi'),
		T_TABLA('02','11','61','2','1','7','2','1','57','Ibi'),
		T_TABLA('16','86','62','3','42','5','','','','Mantenimiento C/ Incendio -Edificios Plataforma- May15_abr16'),
		T_TABLA('16','87','63','3','42','5','','','','Mto Seg. Edif. Electronica, Cra, Cctv Y Control Accesos'),
		T_TABLA('16','85','64','3','42','5','','','','Mantenimiento C/ Incendio -Edificios Plataforma- May15_abr16')

    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN

  V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
  EXECUTE IMMEDIATE V_SQL;	
    
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
		  ,BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_ETG_EQV_TIPO_GASTO_RU.NEXTVAL, (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TABLA(1)||'''), (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TABLA(2)||''')
		  ,'''||V_TMP_TABLA(3)||''', '''||V_TMP_TABLA(10)||''', '''||V_TMP_TABLA(10)||'''
		  ,'''||V_TMP_TABLA(4)||''', '''||V_TMP_TABLA(5)||''', '''||V_TMP_TABLA(6)||''', '''||V_TMP_TABLA(7)||''' , '''||V_TMP_TABLA(8)||''', '''||V_TMP_TABLA(9)||''', 0, ''HREOS-15516'',SYSDATE,0)';
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
