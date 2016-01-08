--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20150904
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Se incluyen campos para validations en TMP_PER_PERSONAS
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := 'CM01';
 TABLA1 VARCHAR(30) :='TMP_PER_PERSONAS';
 TABLA2 VARCHAR(30):='TMP_CNT_PER'; 
 TABLA3 VARCHAR(30):='TMP_PER_GCL';
 TABLA4 VARCHAR(30):='TMP_ALE_ALERTAS'; 
 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(500 CHAR);
 V_MSQL2 VARCHAR2(500 CHAR);
 V_MSQL3 VARCHAR2(500 CHAR);
 V_MSQL4 VARCHAR2(500 CHAR);


BEGIN 
  

  V_MSQL1 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA1||'  ADD
             (
                 TMP_DD_TIPO_TELEFONO_2 VARCHAR2(20)
               , TMP_DD_TIPO_TELEFONO_3 VARCHAR2(20)
               , TMP_DD_TIPO_TELEFONO_4 VARCHAR2(20)                
               , TMP_DD_TIPO_TELEFONO_5 VARCHAR2(20)                
               , TMP_DD_TIPO_TELEFONO_6 VARCHAR2(20)                               
            )';

     
  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA2||'  ADD
             (
                TMP_CNT_PER_NUM_ESPEC NUMBER(15)
            )';
     

  V_MSQL3 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA3||'  ADD
           (
               TMP_PER_GCL_COD_CLI NUMBER(15)
             , TMP_GCL_TIPO_GRUPO VARCHAR2(20 CHAR)
             , TMP_PER_GCL_TIPO_RELACION VARCHAR2(20 CHAR) 
           )';
     
  V_MSQL4 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA4||'  ADD
           (
               TMP_COD_CENTRO_CNT NUMBER(11) 
             , TMP_COD_CENTRO_ALE NUMBER(11)
           )';
     
     
        
         EXECUTE IMMEDIATE V_MSQL1;
         DBMS_OUTPUT.PUT_LINE(''||TABLA1||' Modificada');
         EXECUTE IMMEDIATE V_MSQL2;	 
         DBMS_OUTPUT.PUT_LINE(''||TABLA2||' Modificada');
         EXECUTE IMMEDIATE V_MSQL3;
         DBMS_OUTPUT.PUT_LINE(''||TABLA3||' Modificada');
         EXECUTE IMMEDIATE V_MSQL4;
         DBMS_OUTPUT.PUT_LINE(''||TABLA4||' Modificada');         

         
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