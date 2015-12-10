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
--##                               , esquema #ESQUEMA#. Con estructura correcta
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
 TYPE T_TRE IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_TRE IS TABLE OF T_TRE;

 
  
  

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 TABLADD1 VARCHAR(30) :='DD_MIG_TRE_TIPO_RELACION';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);

 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_TRE T_ARRAY_TRE := T_ARRAY_TRE(
    T_TRE('01','Está incluido en la demanda','Está incluido en la demanda','0','MIG','SYSDATE','0')

 );
 
 
 


 V_TMP_TRE T_TRE;
 
 
	   
	


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
 
 
 
 


 
 EXECUTE IMMEDIATE('DELETE FROM '||TABLADD1||'');   
  DBMS_OUTPUT.PUT_LINE('Limpieza de datos '||TABLADD1||' ');

  
   
  
  

 
 COMMIT;
 
 
 FOR I IN V_TRE.FIRST .. V_TRE.LAST
 LOOP
   V_TMP_TRE := V_TRE(I);
   V_EXISTE:=0; 
   DBMS_OUTPUT.PUT_LINE('Creando '||TABLADD1||': '||V_TMP_TRE(1));   
   
  
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||TABLADD1||' 
                    (DD_TRE_ID, DD_TRE_CODIGO, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||TABLADD1||'.NEXTVAL,'''
                        ||V_TMP_TRE(1)||q'[',']'
                        ||V_TMP_TRE(2)||q'[',']'
                        ||V_TMP_TRE(3)||q'[',]'
                        ||V_TMP_TRE(4)||q'[,']'
                        ||V_TMP_TRE(5)||q'[',]' 
                        ||V_TMP_TRE(6)||q'[,]' 
                        ||V_TMP_TRE(7)||q'[)]' 
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
