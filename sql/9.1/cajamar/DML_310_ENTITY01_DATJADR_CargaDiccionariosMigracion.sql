--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--##
--## Finalidad: CARGA DE DICCIONARIOS DE MIGRACION CAJAMAR
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 --DD_SPO_SITUACION_POSESORIA
 TYPE T_SPO IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TPS IS TABLE OF T_SPO;


 -- DD_TVE_TIPO_VENCIDO
 TYPE T_TVE IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TVE IS TABLE OF T_TVE;

 -- DD_TPV_TRAMO_PREV_VENCIDO
 TYPE T_TPV IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_TPV IS TABLE OF T_TPV;

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='VEN_VENCIDOS';
 TABLADD1 VARCHAR(30) :='DD_SPO_SITUACION_POSESORIA';
 TABLADD2 VARCHAR(30) :='DD_TPV_TRAMO_PREV_VENCIDO'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_TVE T_ARRAY_TVE := T_ARRAY_TVE(
      T_TVE('VENCIDO','Vencidos','Vencidos: Operaciones que van entrando en impago en el mes en curso.','0','DD','SYSDATE','0')
    , T_TVE('ANTPREPROY','Previo pre-proyectado','Previo pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 2.','0','DD','SYSDATE','0')
    , T_TVE('PREPROYECT','Pre-proyectado','Pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 1','0','DD','SYSDATE','0')
    , T_TVE('PROYECTADO','Proyectado','Proyectado: Operaciones que entrarán en dudoso en el mes en curso.','0','DD','SYSDATE','0')
    , T_TVE('DUDOSOS','Dudosos','Dudosos: Operaciones que ya están en dudoso. Aquí puede darse el caso que una operación esté en dudoso y además, al no ser morosa, pueda estar también en otro de los tramos anteriores.','0','DD','SYSDATE','0')
 );

 V_TMP_TVE T_TVE;


V_SPO T_ARRAY_TPS := T_ARRAY_TPS(
	T_SPO('PPT','PROPIETARIO O BENEFICIARIO','0','DD','SYSDATE','0'),
	T_SPO('PPR','PROPIETARIO REGISTRAL','0','DD','SYSDATE','0'),
	T_SPO('USU','USUFRUCTUARIO','0','DD','SYSDATE','0'),
	T_SPO('EMB','EMBARGANTE','0','DD','SYSDATE','0'),
	T_SPO('HIP','ACREEDOR HIPOTECARIO','0','DD','SYSDATE','0'),
	T_SPO('PER','PERITO','0','DD','SYSDATE','0'),
	T_SPO('NCV','NOTARIO COMPRA-VENTA','0','DD','SYSDATE','0'),
	T_SPO('ADJ','ADJUDICATARIO','0','DD','SYSDATE','0'),
	T_SPO('OTR','OTRA PERSONA','0','DD','SYSDATE','0'),
	T_SPO('RES','RESERVA DE DOMINIO','0','DD','SYSDATE','0'),
	T_SPO('ARD','ARRENDATARIO','0','DD','SYSDATE','0'),
	T_SPO('CRE','CONDICION RESOLUTORIA','0','DD','SYSDATE','0'),
	T_SPO('NUP','NUDA PROPIEDAD','0','DD','SYSDATE','0'),
	T_SPO('PIN','PROINDIVISO','0','DD','SYSDATE','0'),
	T_SPO('NOTCDP','NOTARIO CERTF. POLIZA Y DEUDA','0','DD','SYSDATE','0'),
	T_SPO('TPO','TERCER POSEEDOR','0','DD','SYSDATE','0'),
	T_SPO('TAD','TERCER ADQUIRIENTE','0','DD','SYSDATE','0'),
	T_SPO('HDA','HIPOTECANTE POR DEUDA AJENA','0','DD','SYSDATE','0')
);

 V_TMP_SPO T_SPO;


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

 FOR I IN V_SPO.FIRST .. V_SPO.LAST
 LOOP
   V_TMP_SPO := V_SPO(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_SPO(1));   
   
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLADD1||' WHERE DD_SPO_CODIGO = ''' || V_TMP_SPO(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLADD1||' - '||V_TMP_SPO(1) || ' YA EXISTE');
  ELSE
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
             
    
      -- DBMS_OUTPUT.PUT_LINE('Creando TPL_POLITICA: '||V_TMP_MPH(1));
      /*
      DBMS_OUTPUT.PUT_LINE ('QUERY:> '||V_MSQL1);      
      DBMS_OUTPUT.PUT_LINE ('VERSION:> '||V_TMP_SPO(4));
      DBMS_OUTPUT.PUT_LINE ('USUARIOCREAR:> '||V_TMP_SPO(5));
      DBMS_OUTPUT.PUT_LINE ('FECHACREAR:> '||V_TMP_SPO(6));
      DBMS_OUTPUT.PUT_LINE ('BORRADO:> '||V_TMP_SPO(7));
      */
      EXECUTE IMMEDIATE V_MSQL1;
    END IF;
    
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
