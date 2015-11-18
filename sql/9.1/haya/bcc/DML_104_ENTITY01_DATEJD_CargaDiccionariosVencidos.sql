--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de TABLAS DE DICCIONARIOS DE VENCIDOS Y PRODUCCION
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- DD_TVE_TIPO_VENCIDO
 TYPE T_TVE IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TVE IS TABLE OF T_TVE;

 -- MOTIVO ALTA DUDOSO
 TYPE T_MAD IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_MAD IS TABLE OF T_MAD;

-- MOTIVO BAJA DUDOSO
 TYPE T_MBD IS TABLE OF VARCHAR2(500);
 TYPE T_ARRAY_MBD IS TABLE OF T_MBD;


--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='VEN_VENCIDOS';
 TABLADD1 VARCHAR(30) :='DD_TVE_TIPO_VENCIDO';
 TABLADD2 VARCHAR(30) :='DD_MAD_MOTIVO_ALTA_DUDOSO';
 TABLADD3 VARCHAR(30) :='DD_MBD_MOTIVO_BAJA_DUDOSO';  
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES. TIPO DE VENCIDO

 V_TVE T_ARRAY_TVE := T_ARRAY_TVE(
      T_TVE('VENCI','Vencidos','Vencidos: Operaciones que van entrando en impago en el mes en curso.','0','DD','SYSDATE','0')
    , T_TVE('PREVI','Previo pre-proyectado','Previo pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 2.','0','DD','SYSDATE','0')
    , T_TVE('SEGESP','Seguimiento Especial','Seguimiento Especial','0','DD','SYSDATE','0')
    , T_TVE('PRE','Pre-proyectado','Pre-proyectado: Operaciones que entrarán en dudoso en el mes en curso + 1','0','DD','SYSDATE','0')
    , T_TVE('PRO','Proyectado','Proyectado: Operaciones que entrarán en dudoso en el mes en curso.','0','DD','SYSDATE','0')
    , T_TVE('DUD','Dudosos','Dudosos: Operaciones que ya están en dudoso. Aquí puede darse el caso que una operación esté en dudoso y además, al no ser morosa, pueda estar también en otro de los tramos anteriores.','0','DD','SYSDATE','0')
 );


 V_TMP_TVE T_TVE;


-- DEFINICION CURSORES. MOTIVO ALTA DUDOSO

 V_MAD T_ARRAY_MAD := T_ARRAY_MAD(
      T_MAD('001','AVALES EJECUTADOS','AVALES EJECUTADOS','0','DD','SYSDATE','0')
    , T_MAD('002','ARRASTRE /  LITIGIO','ARRASTRE /  LITIGIO','0','DD','SYSDATE','0')
    , T_MAD('003','CONCURSOS','CONCURSOS','0','DD','SYSDATE','0')
    , T_MAD('004','ORDEN MANUAL CLIENTE','ORDEN MANUAL CLIENTE','0','DD','SYSDATE','0')
    , T_MAD('005','ORDEN MANUAL OPERACION','ORDEN MANUAL OPERACION','0','DD','SYSDATE','0')
    , T_MAD('006','POR MOROSIDAD','POR MOROSIDAD','0','DD','SYSDATE','0')
    , T_MAD('007','REFINANCIACIONES','REFINANCIACIONES','0','DD','SYSDATE','0')
    , T_MAD('008','ORDEN AUTAMTICA OPERACIÓN','ORDEN AUTAMTICA OPERACIÓN','0','DD','SYSDATE','0')
    , T_MAD('009','RETROCESION FALLIDO','RETROCESION FALLIDO','0','DD','SYSDATE','0')
    , T_MAD('010','VARIACION DUDOSO','VARIACION DUDOSO','0','DD','SYSDATE','0')
 );


 V_TMP_MAD T_MAD;
 
 -- DEFINICION CURSORES. MOTIVO BAJA DUDOSO

 V_MBD T_ARRAY_MBD := T_ARRAY_MBD(
      T_MBD('000','PAGO CLIENTE','PAGO CLIENTE','0','DD','SYSDATE','0')
    , T_MBD('001','ADJUDICADOS','ADJUDICADOS','0','DD','SYSDATE','0')
    , T_MBD('002','COMPRAVENTAS/DACIONES','COMPRAVENTAS/DACIONES','0','DD','SYSDATE','0')
    , T_MBD('003','FALLIDOS','FALLIDOS','0','DD','SYSDATE','0')
    , T_MBD('004','CONCURSOS','CONCURSOS','0','DD','SYSDATE','0')
    , T_MBD('005','REINSTRUMENTACION','REINSTRUMENTACION','0','DD','SYSDATE','0')
    , T_MBD('006','ORDENES OPERACION MANUAL','ORDENES OPERACION MANUAL','0','DD','SYSDATE','0')
    , T_MBD('007','QUITAS','QUITAS','0','DD','SYSDATE','0')
    , T_MBD('008','ORDENES OPERACION AUTOMATICA','ORDENES OPERACION AUTOMATICA','0','DD','SYSDATE','0')  
 );


 V_TMP_MBD T_MBD;



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

 FOR I IN V_TVE.FIRST .. V_TVE.LAST
 LOOP
   V_TMP_TVE := V_TVE(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_TVE(1));   
   
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLADD1||' WHERE DD_TVE_CODIGO = ''' || V_TMP_TVE(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLADD1||' - '||V_TMP_TVE(1) || ' YA EXISTE');
  ELSE
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD1||' 
                    (DD_TVE_ID, DD_TVE_CODIGO, DD_TVE_DESCRIPCION, DD_TVE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD1||'.NEXTVAL,'''
                        ||V_TMP_TVE(1)||q'[',']'
                        ||V_TMP_TVE(2)||q'[',']'
                        ||V_TMP_TVE(3)||q'[',]'
                        ||V_TMP_TVE(4)||q'[,']'
                        ||V_TMP_TVE(5)||q'[',]' 
                        ||V_TMP_TVE(6)||q'[,]' 
                        ||V_TMP_TVE(7)||q'[)]' 
                        ;
             
      /*
      DBMS_OUTPUT.PUT_LINE ('QUERY:> '||V_MSQL1);      
      DBMS_OUTPUT.PUT_LINE ('VERSION:> '||V_TMP_TVE(4));
      DBMS_OUTPUT.PUT_LINE ('USUARIOCREAR:> '||V_TMP_TVE(5));
      DBMS_OUTPUT.PUT_LINE ('FECHACREAR:> '||V_TMP_TVE(6));
      DBMS_OUTPUT.PUT_LINE ('BORRADO:> '||V_TMP_TVE(7));
      */
      EXECUTE IMMEDIATE V_MSQL1;
    END IF;
    
 END LOOP; 


 FOR I IN V_MAD.FIRST .. V_MAD.LAST
 LOOP
   V_TMP_MAD := V_MAD(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD2||': '||V_TMP_MAD(1));   
   
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLADD2||' WHERE DD_MAD_CODIGO = ''' || V_TMP_MAD(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLADD2||' - '||V_TMP_MAD(1) || ' YA EXISTE');
  ELSE
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD2||' 
                    (DD_MAD_ID, DD_MAD_CODIGO, DD_MAD_DESCRIPCION, DD_MAD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD2||'.NEXTVAL,'''
                        ||V_TMP_MAD(1)||q'[',']'
                        ||V_TMP_MAD(2)||q'[',']'
                        ||V_TMP_MAD(3)||q'[',]'
                        ||V_TMP_MAD(4)||q'[,']'
                        ||V_TMP_MAD(5)||q'[',]' 
                        ||V_TMP_MAD(6)||q'[,]' 
                        ||V_TMP_MAD(7)||q'[)]' 
                        ;
             
      /*
      DBMS_OUTPUT.PUT_LINE ('QUERY:> '||V_MSQL1);      
      DBMS_OUTPUT.PUT_LINE ('VERSION:> '||V_TMP_TVE(4));
      DBMS_OUTPUT.PUT_LINE ('USUARIOCREAR:> '||V_TMP_TVE(5));
      DBMS_OUTPUT.PUT_LINE ('FECHACREAR:> '||V_TMP_TVE(6));
      DBMS_OUTPUT.PUT_LINE ('BORRADO:> '||V_TMP_TVE(7));
      */
      EXECUTE IMMEDIATE V_MSQL1;
    END IF;
    
 END LOOP;


FOR I IN V_MBD.FIRST .. V_MBD.LAST
 LOOP
   V_TMP_MBD := V_MBD(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD3||': '||V_TMP_MBD(1));   
   
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA || '.'||TABLADD3||' WHERE DD_MBD_CODIGO = ''' || V_TMP_MBD(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLADD3||' - '||V_TMP_MBD(1) || ' YA EXISTE');
  ELSE
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD3||' 
                    (DD_MBD_ID, DD_MBD_CODIGO, DD_MBD_DESCRIPCION, DD_MBD_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD3||'.NEXTVAL,'''
                        ||V_TMP_MBD(1)||q'[',']'
                        ||V_TMP_MBD(2)||q'[',']'
                        ||V_TMP_MBD(3)||q'[',]'
                        ||V_TMP_MBD(4)||q'[,']'
                        ||V_TMP_MBD(5)||q'[',]' 
                        ||V_TMP_MBD(6)||q'[,]' 
                        ||V_TMP_MBD(7)||q'[)]' 
                        ;
             
      /*
      DBMS_OUTPUT.PUT_LINE ('QUERY:> '||V_MSQL1);      
      DBMS_OUTPUT.PUT_LINE ('VERSION:> '||V_TMP_TVE(4));
      DBMS_OUTPUT.PUT_LINE ('USUARIOCREAR:> '||V_TMP_TVE(5));
      DBMS_OUTPUT.PUT_LINE ('FECHACREAR:> '||V_TMP_TVE(6));
      DBMS_OUTPUT.PUT_LINE ('BORRADO:> '||V_TMP_TVE(7));
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
