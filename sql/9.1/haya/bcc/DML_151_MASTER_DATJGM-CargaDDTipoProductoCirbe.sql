--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20151030
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.9
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: CreaciÃ³n de TABLAS DE DICCIONARIOS DE TIPO PRODUCTO CIRBE
--##                   
--##                             
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:0.1 Versión Inicial
--##        
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE


 -- #ESQUEMA_MASTER#.DD_TPC_TIPO_PRODUCTO_CIRBE;
 TYPE T_TPC IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TPC IS TABLE OF T_TPC;
 
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLA VARCHAR(30) :='DD_TPC_TIPO_PRODUCTO_CIRBE'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;
 V_ENTIDAD_ID  NUMBER(16);

-- DEFINICION CURSORES.

 V_TPC T_ARRAY_TPC := T_ARRAY_TPC(
                   T_TPC ('A','RIESGO COMERCIAL','RIESGO COMERCIAL','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('B','FINANCIERO','FINANCIERO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('C','AVALES POR CREDITOS DE DINERO','AVALES POR CREDITOS DE DINERO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('D','AVALES POR CREDITOS DE FIRMA','AVALES POR CREDITOS DE FIRMA','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('E','AVALES RESTO DE AVALES','AVALES RESTO DE AVALES','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('F','CREDITO DOCUMENTARIO','CREDITO DOCUMENTARIO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('G','VALORES DE RENTA FIJA','VALORES DE RENTA FIJA','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('H','INDIRECTO ACEPTANTE DE EFECTOS','INDIRECTO ACEPTANTE DE EFECTOS','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('I','INDIRECTO RESTO DE SITUACIONES','INDIRECTO RESTO DE SITUACIONES','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('J','INTERES FINANCIERO','INTERES FINANCIERO','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('K','LEASING','LEASING','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('L','FACTORING SIN RECURSO CON INVERS','FACTORING SIN RECURSO CON INVERS','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('M','FACTORING SIN RECUR. SIN INVERSION','FACTORING SIN RECUR. SIN INVERSION','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('N','VALORES-ACCIONES���NO ADMITADAS A COTIZA','VALORES-ACCIONES���NO ADMITADAS A COTIZA','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('O','VALORES-ACCIONES���ADMITIDAS A COTIZACION','VALORES-ACCIONES���ADMITIDAS A COTIZACION','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('P','VALORES-ACCIONES���ADMI. COTI. PREFERENTES','VALORES-ACCIONES���ADMI. COTI. PREFERENTES','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('Q','PR-CR TRANSFERIDOS 3��','PR-CR TRANSFERIDOS 3��','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('R','PRESTAMOS DE VALORES','PRESTAMOS DE VALORES','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('S','ADQUISIC. TEMP. ACTIVOS','ADQUISIC. TEMP. ACTIVOS','0','INICIAL','SYSDATE','null','null','null','null','0')
                        , T_TPC ('X','DISPONIBLE','DISPONIBLE','0','INICIAL','SYSDATE','null','null','null','null','0')
 );


 V_TMP_TPC T_TPC;


BEGIN 

 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLA and sequence_owner= V_ESQUEMA_M;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA_M|| '.S_'||TABLA||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;

 FOR I IN V_TPC.FIRST .. V_TPC.LAST
 LOOP
   V_TMP_TPC := V_TPC(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLA||': CODIGO '|| V_TMP_TPC(1));   
   
  
   V_MSQL1 := 'SELECT COUNT(*) FROM ' || V_ESQUEMA_M || '.'||TABLA||' WHERE DD_TPC_CODIGO = ''' || V_TMP_TPC(1) || '''';
   EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
   
  if V_EXISTE is not null and V_EXISTE = 1 then
      DBMS_OUTPUT.PUT_LINE('[ATENCION] '||TABLA||' CON CODIGO - '||V_TMP_TPC(1) || ' YA EXISTE');
  ELSE
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLA||' 
                    ( DD_TPC_ID, DD_TPC_CODIGO, DD_TPC_DESCRIPCION, DD_TPC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO)
                   VALUES (   S_'||TABLA||'.NEXTVAL,'''
                        ||V_TMP_TPC(1)||q'[',']'
                        ||V_TMP_TPC(2)||q'[',']'
                        ||V_TMP_TPC(3)||q'[',]'
                        ||V_TMP_TPC(4)||q'[,']'
                        ||V_TMP_TPC(5)||q'[',]' 
                        ||V_TMP_TPC(6)||q'[,]' 
                        ||V_TMP_TPC(7)||q'[,]'
                        ||V_TMP_TPC(8)||q'[,]'
                        ||V_TMP_TPC(9)||q'[,]'
                        ||V_TMP_TPC(10)||q'[,]'
                        ||V_TMP_TPC(11)||q'[)]'  
                        ;


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
