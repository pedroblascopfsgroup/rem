--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20151229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-1505
--## PRODUCTO=NO
--## 
--## Finalidad: Se inserta RD, PDTE RESOLUCIÓN OTRAS OPERACIONES en DD_DPA_DECISION_PARALIZAR si no existe.
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
 TYPE T_GES IS TABLE OF VARCHAR2(2000);
 TYPE T_ARRAY_GES IS TABLE OF T_GES;

  
  

--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#';             -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master 
 V_TABLADD1 VARCHAR(30) :='DD_DPA_DECISION_PARALIZAR';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);

 V_EXISTE NUMBER (1):=null;

-- DEFINICION CURSORES.

 V_GES T_ARRAY_GES := T_ARRAY_GES(
    T_GES('RD','PDTE RESOLUCIÓN OTRAS OPERACIONES','PDTE RESOLUCIÓN OTRAS OPERACIONES','0','DD',' TO_TIMESTAMP(SYSDATE,''DD/MM/YYYY fmHH24fm:MI:SS.FF'')','0')
 );
 
 V_TMP_GES T_GES;


BEGIN 

 V_EXISTE:=0;
 SELECT count(*) INTO V_EXISTE
 FROM all_sequences
 WHERE sequence_name = 'S_'||V_TABLADD1 and sequence_owner= V_ESQUEMA;

 if V_EXISTE is null OR V_EXISTE = 0 then
     EXECUTE IMMEDIATE('CREATE SEQUENCE '||V_ESQUEMA|| '.S_'||V_TABLADD1||'
     START WITH 1
     MAXVALUE 999999999999999999999999999
     MINVALUE 1
     NOCYCLE
     CACHE 20
     NOORDER');
 end if;
 
 
 V_EXISTE:=0; 
 V_MSQL1 := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLADD1||' WHERE DD_DPA_CODIGO = ''RD''';

 EXECUTE IMMEDIATE V_MSQL1 INTO V_EXISTE;
 
 FOR I IN V_GES.FIRST .. V_GES.LAST
 LOOP
   V_TMP_GES := V_GES(I);

   DBMS_OUTPUT.PUT_LINE('Creando '||V_TABLADD1||': '||V_TMP_GES(1));   
    
        V_MSQL1 := 'INSERT INTO ' ||V_ESQUEMA|| '.'||V_TABLADD1||' 
                    (DD_DPA_ID, DD_DPA_CODIGO, DD_DPA_DESCRIPCION, DD_DPA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
                   VALUES (   S_'||V_TABLADD1||'.NEXTVAL,'''
                        ||V_TMP_GES(1)||q'[',']'
                        ||V_TMP_GES(2)||q'[',']'
                        ||V_TMP_GES(3)||q'[',]'
                        ||V_TMP_GES(4)||q'[,']'
                        ||V_TMP_GES(5)||q'[',]' 
                        ||V_TMP_GES(6)||q'[,]' 
                        ||V_TMP_GES(7)||q'[)]' 
                        ;
   
   IF V_EXISTE = 0 THEN   
      EXECUTE IMMEDIATE V_MSQL1;
   ELSE   
      DBMS_OUTPUT.PUT_LINE('YA EXISTE EL DD_GES_CODIGO = RD EN LA TABLA '||V_TABLADD1||'');
   END IF;     
 
 END LOOP; 
 
 
 
 COMMIT; 


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
