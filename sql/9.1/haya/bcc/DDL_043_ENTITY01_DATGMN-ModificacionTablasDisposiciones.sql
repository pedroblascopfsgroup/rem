--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150909
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-738
--## PRODUCTO=NO
--## 
--## Finalidad: Se incluyen campos para tablas disposiciones DSP_DISPOSICIONES,  DSP_DISPOSICIONES_DUB
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 V_ESQUEMA_M VARCHAR(25) := '#ESQUEMA_MASTER#'; 
 TABLA1 VARCHAR(30) :='DSP_DISPOSICIONES';
 TABLA2 VARCHAR(30):='DSP_DISPOSICIONES_DUB'; 
 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(500 CHAR);
 V_MSQL2 VARCHAR2(500 CHAR);


BEGIN 
  

  V_MSQL1 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  ADD
             (
                 DSP_DATE_EXTRA3 DATE
               , DSP_NUM_EXTRA3 NUMBER(16,2)
            )';

     
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
                 DSP_DATE_EXTRA3 DATE
               , DSP_NUM_EXTRA3 NUMBER(14,2)
            )';
              
             
              
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');
         EXECUTE IMMEDIATE V_MSQL2;	 
         DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada');
         
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