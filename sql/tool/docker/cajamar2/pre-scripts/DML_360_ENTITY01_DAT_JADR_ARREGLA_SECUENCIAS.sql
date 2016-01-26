--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20160104
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-947
--## PRODUCTO=NO
--## 
--## Finalidad: ARREGLAR SECUENCIAS EN CM01
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 VersiÃ³n inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

-- VARIABLES
 V_ESQUEMA VARCHAR2(25 CHAR):=   'CM01';               -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'CMMASTER';         -- Configuracion Esquema Master 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 

 V_MSQL1 VARCHAR2(8500 CHAR);
  V_MSQL2 VARCHAR2(8500 CHAR);
  
  V_MSQL3 VARCHAR2(8500 CHAR);
   

 
 V_NEXT1 NUMBER(35);
 V_NEXT2 NUMBER(35);
 V_NEXT3 NUMBER(35);
  
SECUENCIA  VARCHAR2(35 CHAR);
TABLA  VARCHAR2(35 CHAR);
MAX_VALOR NUMBER(35);
MIN_VALOR NUMBER(35);
CACHE_SIZE NUMBER(35);
TOTAL number:=null;
CAMPO_ID VARCHAR2(35 CHAR);
SEQ_ACTUAL NUMBER(35);
SEQNEXT NUMBER(35);


CURSOR SEQ_TAB 
    IS
    select 
seq.sequence_name,
tab.table_name,
seq.MIN_VALUE,
SEQ.cache_size
from ALL_SEQUENCES seq,
all_tables tab
where sequence_owner = V_ESQUEMA
AND TAB.OWNER = V_ESQUEMA
and tab.table_name  = SUBSTR(seq.sequence_name,3) 
AND INCREMENT_BY > 0
AND SEQ.SEQUENCE_NAME NOT IN ('S_H_RAS_RANKING_SUBCARTERA','S_H_RECOBRO_DETALLE_FACTURA','S_H_RECOBRO_DETALLE_FACTURA_CO','S_H_RSD_RANKING_SUBCAR_DETALLE')
;



BEGIN






 OPEN SEQ_TAB;
    FETCH SEQ_TAB INTO SECUENCIA,TABLA,MIN_VALOR,CACHE_SIZE;
    WHILE SEQ_TAB%found
    LOOP 
        
    


 
 
 

  
    

EXECUTE IMMEDIATE 'select  '|| V_ESQUEMA ||'.'||SECUENCIA||'.nextval from dual' INTO V_NEXT1;


IF V_NEXT1 = MIN_VALOR THEN


V_MSQL3 := 'select '|| V_ESQUEMA ||'.'||SECUENCIA||'.CURRVAL from dual';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL3);
     EXECUTE IMMEDIATE V_MSQL3 INTO SEQ_ACTUAL;
     


ELSE 
    
EXECUTE IMMEDIATE 'alter sequence '|| V_ESQUEMA ||'.'||SECUENCIA||' increment by -1';


EXECUTE IMMEDIATE 'select  '|| V_ESQUEMA ||'.'||SECUENCIA||'.nextval from dual' INTO V_NEXT2;


EXECUTE IMMEDIATE 'alter sequence '|| V_ESQUEMA ||'.'||SECUENCIA||' increment by 1';


V_MSQL3 := 'select '|| V_ESQUEMA ||'.'||SECUENCIA||'.CURRVAL from dual';
    --DBMS_OUTPUT.PUT_LINE(V_MSQL3);
     EXECUTE IMMEDIATE V_MSQL3 INTO SEQ_ACTUAL;
     

      
      END IF;
   
   
   
  
  V_MSQL2 := 'SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||TABLA||''' 
  AND COLUMN_ID = (SELECT MIN(COLUMN_ID) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = '''||TABLA||''')
  AND OWNER = '''||V_ESQUEMA||'''
  ';
 --DBMS_OUTPUT.PUT_LINE(V_MSQL2);
 
 EXECUTE IMMEDIATE V_MSQL2 INTO CAMPO_ID;
  
 

  
    
 
 V_MSQL1 := 'SELECT MAX('||CAMPO_ID||') FROM '|| V_ESQUEMA ||'.'||TABLA||'';
 EXECUTE IMMEDIATE V_MSQL1 INTO MAX_VALOR;
 
 
  
 



 IF MAX_VALOR IS NULL THEN

 DBMS_OUTPUT.PUT_LINE('TABLA '||TABLA||' SIN DATOS');
 
 ELSIF SEQ_ACTUAL >= MAX_VALOR THEN
 
  DBMS_OUTPUT.PUT_LINE('SECUENCIA CORRECTA');
  

  
  ELSE
  
    TOTAL:= MAX_VALOR - SEQ_ACTUAL;
  
  DBMS_OUTPUT.PUT_LINE('SECUENCIA INCORRECTA Y HAY QUE SETEARLA CON EL VALOR INCREMENTAL DE '||TOTAL||'' );
  
  
  EXECUTE IMMEDIATE 'alter sequence '|| V_ESQUEMA ||'.'||SECUENCIA||' increment by '||TOTAL||'';
  
    EXECUTE IMMEDIATE 'select '|| V_ESQUEMA ||'.'||SECUENCIA||'.nextval from dual' INTO V_NEXT3;
    
      EXECUTE IMMEDIATE 'alter sequence '|| V_ESQUEMA ||'.'||SECUENCIA||' increment by 1';
  
  

  
    END IF;
    
    
  
   FETCH SEQ_TAB INTO SECUENCIA,TABLA,MIN_VALOR,CACHE_SIZE;
    END LOOP; 
    CLOSE SEQ_TAB;
 
-- FIN INSERT / LOOP

-- EXCEPCIONES


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
 
 


 


