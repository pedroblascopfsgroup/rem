--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20151028
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


 -- DD_MOS_MOTIVO_SUSPENSION
 TYPE T_MOS IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_MOS IS TABLE OF T_MOS;

 --DD_EPR_ESTADO_PROCEDIMIENTO
  TYPE T_EPR IS TABLE OF VARCHAR2(1000);
 TYPE T_ARRAY_EPR IS TABLE OF T_EPR;

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(30) :='DD_MOS_MOTIVO_SUSPENSION';
 TABLADD2 VARCHAR(30) :='DD_EPR_ESTADO_PROCEDIMIENTO'; 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);

 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_MOS T_ARRAY_MOS := T_ARRAY_MOS(
    T_MOS('ACUERDO','ACUERDO','ACUERDO','0','MIG','SYSDATE','0'),
	T_MOS('MIGRACION','MIGRACION','MIGRACION','0','MIG','SYSDATE','0'),
	T_MOS('DEFECTO_PROCESAL','DEFECTO_PROCESAL','DEFECTO_PROCESAL','0','MIG','SYSDATE','0'),
	T_MOS('FALTA_NOT','FALTA NOTIFICACIÓN','FALTA NOTIFICACIÓN','0','MIG','SYSDATE','0')
 );
 
 V_EPR T_ARRAY_EPR := T_ARRAY_EPR(
 T_EPR('01','ADMITIDO','ADMITIDO','MIG','SYSDATE','0'),
 T_EPR('02','INADMITIDO','INADMITIDO','MIG','SYSDATE','0'),
 T_EPR('03','PARALIZADO','PARALIZADO','MIG','SYSDATE','0'),
 T_EPR('04','SUSPENDIDO','SUSPENDIDO','MIG','SYSDATE','0'),
 T_EPR('05','CANCELADO','CANCELADO','MIG','SYSDATE','0'),
 T_EPR('06','FINALIZADO','FINALIZADO','MIG','SYSDATE','0'),
 T_EPR('07','ARCHIVADO','ARCHIVADO','MIG','SYSDATE','0')


 );
 


 V_TMP_MOS T_MOS;
 
  V_TMP_EPR T_EPR;
  
	   
	


BEGIN 
/*
 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD1 and sequence_owner= V_ESQUEMA_M;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA_M|| '.S_'||TABLADD1||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 */
 
   V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||TABLADD2 and sequence_owner= V_ESQUEMA_M;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA_M|| '.S_'||TABLADD2||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
 
 


 /*
 EXECUTE IMMEDIATE('DELETE FROM '||TABLADD1||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD1||' ');
 */ 
   EXECUTE IMMEDIATE('DELETE FROM '||TABLADD2||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD2||' ');

 
  
  

 
 COMMIT;
 
 /*
 FOR I IN V_MOS.FIRST .. V_MOS.LAST
 LOOP
   V_TMP_MOS := V_MOS(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_MOS(1));   
   
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLADD1||' 
                    (DD_MOS_ID, DD_MOS_CODIGO, DD_MOS_DESCRIPCION, DD_MOS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD1||'.NEXTVAL,'''
                        ||V_TMP_MOS(1)||q'[',']'
                        ||V_TMP_MOS(2)||q'[',']'
                        ||V_TMP_MOS(3)||q'[',]'
                        ||V_TMP_MOS(4)||q'[,']'
                        ||V_TMP_MOS(5)||q'[',]' 
                        ||V_TMP_MOS(6)||q'[,]' 
                        ||V_TMP_MOS(7)||q'[)]' 
                        ;
       
      EXECUTE IMMEDIATE V_MSQL1;
 END LOOP; 
 */
 
  FOR I IN V_EPR.FIRST .. V_EPR.LAST
 LOOP
   V_TMP_EPR := V_EPR(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD2||': '||V_TMP_EPR(1));   
   
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA_M|| '.'||TABLADD2||' 
                    (DD_EPR_ID, DD_EPR_CODIGO, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA,USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD2||'.NEXTVAL,'''
                        ||V_TMP_EPR(1)||q'[',']'
                        ||V_TMP_EPR(2)||q'[',']'
                        ||V_TMP_EPR(3)||q'[',']'
                        ||V_TMP_EPR(4)||q'[',]'
                        ||V_TMP_EPR(5)||q'[,]' 
                        ||V_TMP_EPR(6)||q'[)]' 
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
