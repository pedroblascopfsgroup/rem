--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de TABLAS DE DICCIONARIOS DE VENCIDOS Y PRODUCCION
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- DD_SPO_SITUACION_POSESORIA
 TYPE T_SPO IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TVE IS TABLE OF T_SPO;

 -- DD_EAD_ENTIDAD_ADJUDICA
 TYPE T_EAD IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_EAD IS TABLE OF T_EAD;
 
 -- DD_DRR_RESULTADO_RESOL
 TYPE T_DRR IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_DRR IS TABLE OF T_DRR;
 
 -- DD_TRA_TASADORA
  TYPE T_TRA IS TABLE OF VARCHAR2(2000);
  TYPE T_ARRAY_TRA IS TABLE OF T_TRA;
  
  

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER';         -- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='VEN_VENCIDOS';
 TABLADD1 VARCHAR(30) :='DD_SPO_SITUACION_POSESORIA';
 TABLADD2 VARCHAR(30) :='DD_EAD_ENTIDAD_ADJUDICA'; 
 TABLADD3 VARCHAR(30) :='DD_DRR_RESULTADO_RESOL'; 
 TABLADD4 VARCHAR(30) :='DD_TRA_TASADORA'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);

 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_SPO T_ARRAY_TVE := T_ARRAY_TVE(
    T_SPO('PPT','PROPIETARIO O BENEFICIARIO','PROPIETARIO O BENEFICIARIO','0','MIG','SYSDATE','0'),
	T_SPO('PPR','PROPIETARIO REGISTRAL','PROPIETARIO REGISTRAL','0','MIG','SYSDATE','0'),
	T_SPO('USU','USUFRUCTUARIO','USUFRUCTUARIO','0','MIG','SYSDATE','0'),
	T_SPO('EMB','EMBARGANTE','EMBARGANTE','0','MIG','SYSDATE','0'),
	T_SPO('HIP','ACREEDOR HIPOTECARIO','ACREEDOR HIPOTECARIO','0','MIG','SYSDATE','0'),
	T_SPO('PER','PERITO','PERITO','0','MIG','SYSDATE','0'),
	T_SPO('NCV','NOTARIO COMPRA-VENTA','NOTARIO COMPRA-VENTA','0','MIG','SYSDATE','0'),
	T_SPO('ADJ','ADJUDICATARIO','ADJUDICATARIO','0','MIG','SYSDATE','0'),
	T_SPO('OTR','OTRA PERSONA','OTRA PERSONA','0','MIG','SYSDATE','0'),
	T_SPO('RES','RESERVA DE DOMINIO','RESERVA DE DOMINIO','0','MIG','SYSDATE','0'),
	T_SPO('ARD','ARRENDATARIO','ARRENDATARIO','0','MIG','SYSDATE','0'),
	T_SPO('CRE','CONDICION RESOLUTORIA','CONDICION RESOLUTORIA','0','MIG','SYSDATE','0'),
	T_SPO('NUP','NUDA PROPIEDAD','NUDA PROPIEDAD','0','MIG','SYSDATE','0'),
	T_SPO('PIN','PROINDIVISO','PROINDIVISO','0','MIG','SYSDATE','0'),
	T_SPO('NOTCDP','NOTARIO CERTF. POLIZA Y DEUDA','NOTARIO CERTF. POLIZA Y DEUDA','0','MIG','SYSDATE','0'),
	T_SPO('TPO','TERCER POSEEDOR','TERCER POSEEDOR','0','MIG','SYSDATE','0'),
	T_SPO('TAD','TERCER ADQUIRIENTE','TERCER ADQUIRIENTE','0','MIG','SYSDATE','0'),
	T_SPO('HDA','HIPOTECANTE POR DEUDA AJENA','HIPOTECANTE POR DEUDA AJENA','0','MIG','SYSDATE','0')

 );
 
 V_EAD T_ARRAY_EAD := T_ARRAY_EAD(
    T_EAD('CAJAMAR','CAJAMAR','CAJAMAR','0','MIG','SYSDATE','0')
 );
 
 V_DRR T_ARRAY_DRR := T_ARRAY_DRR(
    T_DRR('1','FAVORABLE','FAVORABLE','0','MIG','SYSDATE','0'),
	T_DRR('2','DESFAVORABLE','DESFAVORABLE','0','MIG','SYSDATE','0')
 );
 
 V_TRA T_ARRAY_TRA := T_ARRAY_TRA(
    T_TRA('01','VALMESA-VALORACIONES DEL MEDITERRANEO S.A.','VALMESA-VALORACIONES DEL MEDITERRANEO S.A.','0','MIG','SYSDATE','0'),
	T_TRA('02','SOCIEDAD DE TASACION S.A.','SOCIEDAD DE TASACION S.A.','0','MIG','SYSDATE','0'),
	T_TRA('07','TASACIONES INMOBILIARIAS, S.A. (TINSA)','TASACIONES INMOBILIARIAS, S.A. (TINSA)','0','MIG','SYSDATE','0'),
	T_TRA('11','ARCO VALORACIONES, S.A.','ARCO VALORACIONES, S.A.','0','MIG','SYSDATE','0'),
	T_TRA('12','ALIA TASACIONES','ALIA TASACIONES','0','MIG','SYSDATE','0'),
	T_TRA('13','AFES TASACIONES','AFES TASACIONES','0','MIG','SYSDATE','0'),
	T_TRA('14','IBERTASA','IBERTASA','0','MIG','SYSDATE','0'),
	T_TRA('15','GESVALT','GESVALT','0','MIG','SYSDATE','0'),
	T_TRA('16','EUROVALORACIONES S.A.','EUROVALORACIONES S.A.','0','MIG','SYSDATE','0'),
	T_TRA('17','TERRA VT SOCIEDAD DE TASACIONES INMOBILIARIAS, S.A','TERRA VT SOCIEDAD DE TASACIONES INMOBILIARIAS, S.A','0','MIG','SYSDATE','0'),
	T_TRA('18','TÉCNICOS EN TASACIÓN S.A (TECNITASA)','TÉCNICOS EN TASACIÓN S.A (TECNITASA)','0','MIG','SYSDATE','0'),
	T_TRA('19','KRATA, S.A. SOCIEDAD DE TASACIÓN','KRATA, S.A. SOCIEDAD DE TASACIÓN','0','MIG','SYSDATE','0'),
	T_TRA('20','OFICINA DE TASACIONES S.A.','OFICINA DE TASACIONES S.A.','0','MIG','SYSDATE','0')

 );
 
 


 V_TMP_SPO T_SPO;
 
  V_TMP_EAD T_EAD;
  
    V_TMP_DRR T_DRR;
	
	   V_TMP_TRA T_TRA;
	   
	


BEGIN 

 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD1 and sequence_owner= V_ESQUEMA;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLADD1||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
  V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD2 and sequence_owner= V_ESQUEMA;
 
 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLADD2||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
  V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD3 and sequence_owner= V_ESQUEMA;
 
 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLADD3||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD4 and sequence_owner= V_ESQUEMA;
 
 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||TABLADD4||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
 


 
 EXECUTE IMMEDIATE('DELETE FROM '||TABLADD1||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD1||' ');

 EXECUTE IMMEDIATE('DELETE FROM '||TABLADD2||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD2||' '); 
  
   EXECUTE IMMEDIATE('DELETE FROM '||TABLADD3||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD3||' '); 
  
     EXECUTE IMMEDIATE('DELETE FROM '||TABLADD4||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD4||' ');
  
  

 
 COMMIT;
 
 
 FOR I IN V_SPO.FIRST .. V_SPO.LAST
 LOOP
   V_TMP_SPO := V_SPO(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_SPO(1));   
   
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD1||' 
                    (DD_SPO_ID, DD_SPO_CODIGO, DD_SPO_DESCRIPCION, DD_SPO_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD1||'.NEXTVAL,'''
                        ||V_TMP_SPO(1)||q'[',']'
                        ||V_TMP_SPO(2)||q'[',']'
                        ||V_TMP_SPO(3)||q'[',]'
                        ||V_TMP_SPO(4)||q'[,']'
                        ||V_TMP_SPO(5)||q'[',]' 
                        ||V_TMP_SPO(6)||q'[,]' 
                        ||V_TMP_SPO(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 
 
 FOR I IN V_EAD.FIRST .. V_EAD.LAST
 LOOP
   V_TMP_EAD := V_EAD(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD2||': '||V_TMP_EAD(1));   
   
   
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD2||' 
                    (DD_EAD_ID, DD_EAD_CODIGO, DD_EAD_DESCRIPCION, DD_EAD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD2||'.NEXTVAL,'''
                        ||V_TMP_EAD(1)||q'[',']'
                        ||V_TMP_EAD(2)||q'[',']'
                        ||V_TMP_EAD(3)||q'[',]'
                        ||V_TMP_EAD(4)||q'[,']'
                        ||V_TMP_EAD(5)||q'[',]' 
                        ||V_TMP_EAD(6)||q'[,]' 
                        ||V_TMP_EAD(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 
 FOR I IN V_DRR.FIRST .. V_DRR.LAST
 LOOP
   V_TMP_DRR := V_DRR(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD3||': '||V_TMP_DRR(1));   
   
   
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD3||' 
                    (DD_DRR_ID, DD_DRR_CODIGO, DD_DRR_DESCRIPCION, DD_DRR_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD3||'.NEXTVAL,'''
                        ||V_TMP_DRR(1)||q'[',']'
                        ||V_TMP_DRR(2)||q'[',']'
                        ||V_TMP_DRR(3)||q'[',]'
                        ||V_TMP_DRR(4)||q'[,']'
                        ||V_TMP_DRR(5)||q'[',]' 
                        ||V_TMP_DRR(6)||q'[,]' 
                        ||V_TMP_DRR(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 
 
 
 FOR I IN V_TRA.FIRST .. V_TRA.LAST
 LOOP
   V_TMP_TRA := V_TRA(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD4||': '||V_TMP_TRA(1));   
   
   
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD4||' 
                    (DD_TRA_ID, DD_TRA_CODIGO, DD_TRA_DESCRIPCION, DD_TRA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD4||'.NEXTVAL,'''
                        ||V_TMP_TRA(1)||q'[',']'
                        ||V_TMP_TRA(2)||q'[',']'
                        ||V_TMP_TRA(3)||q'[',]'
                        ||V_TMP_TRA(4)||q'[,']'
                        ||V_TMP_TRA(5)||q'[',]' 
                        ||V_TMP_TRA(6)||q'[,]' 
                        ||V_TMP_TRA(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 
 
 


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
