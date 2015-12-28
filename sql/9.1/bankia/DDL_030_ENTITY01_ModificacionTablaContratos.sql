--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO / JOSEVI
--## FECHA_CREACION=20150820
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-447
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación campos contratos para cajamar
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Toque abs2

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='CNT_CONTRATOS';
 COLUMNA VARCHAR(50) :='';
 TIPO VARCHAR(50) :='';
 V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 


BEGIN 

--  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
--             (
--                SALDO_PASIVO_OTROS NUMBER(15,2)
--              , CNT_SALDO_MUY_DUDOSO NUMBER(15,2)
--              , CNT_SALDO_VENC_NO_RECLAM NUMBER(15,2)
--              , CONTRATO_PADRE_NIVEL_2 NUMBER(22)
--            )';


  COLUMNA := 'SALDO_PASIVO_OTROS';
  TIPO := 'NUMBER(15,2)';
  V_MSQL := 'select count(1) from all_tab_cols where column_name = '''||COLUMNA||'''  and owner = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 0 THEN            

    V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
               ( '||COLUMNA||' '||TIPO||' )';
       
    EXECUTE IMMEDIATE V_MSQL2;
    DBMS_OUTPUT.put_line('[INFO] Agregada nueva columna '||TABLA||'.'||COLUMNA||' - OK');

  ELSE        
    DBMS_OUTPUT.put_line('[INFO] Ya existe el la columna '||COLUMNA||'. NO SE REALIZAN CAMBIOS. ');
  END IF ;




  COLUMNA := 'CNT_SALDO_MUY_DUDOSO';
  TIPO := 'NUMBER(15,2)';
  V_MSQL := 'select count(1) from all_tab_cols where column_name = '''||COLUMNA||'''  and owner = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 0 THEN            

    V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
               ( '||COLUMNA||' '||TIPO||' )';
       
    EXECUTE IMMEDIATE V_MSQL2;
    DBMS_OUTPUT.put_line('[INFO] Agregada nueva columna '||TABLA||'.'||COLUMNA||' - OK');

  ELSE        
    DBMS_OUTPUT.put_line('[INFO] Ya existe el la columna '||COLUMNA||'. NO SE REALIZAN CAMBIOS. ');
  END IF ;




  COLUMNA := 'CNT_SALDO_VENC_NO_RECLAM';
  TIPO := 'NUMBER(15,2)';
  V_MSQL := 'select count(1) from all_tab_cols where column_name = '''||COLUMNA||'''  and owner = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 0 THEN            

    V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
               ( '||COLUMNA||' '||TIPO||' )';
       
    EXECUTE IMMEDIATE V_MSQL2;
    DBMS_OUTPUT.put_line('[INFO] Agregada nueva columna '||TABLA||'.'||COLUMNA||' - OK');

  ELSE        
    DBMS_OUTPUT.put_line('[INFO] Ya existe el la columna '||COLUMNA||'. NO SE REALIZAN CAMBIOS. ');
  END IF ;




  COLUMNA := 'CONTRATO_PADRE_NIVEL_2';
  TIPO := 'NUMBER(22)';
  V_MSQL := 'select count(1) from all_tab_cols where column_name = '''||COLUMNA||'''  and owner = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS = 0 THEN            

    V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
               ( '||COLUMNA||' '||TIPO||' )';
       
    EXECUTE IMMEDIATE V_MSQL2;
    DBMS_OUTPUT.put_line('[INFO] Agregada nueva columna '||TABLA||'.'||COLUMNA||' - OK');

  ELSE        
    DBMS_OUTPUT.put_line('[INFO] Ya existe el la columna '||COLUMNA||'. NO SE REALIZAN CAMBIOS. ');
  END IF ;



DBMS_OUTPUT.PUT_LINE(''||TABLA||' Modificada');

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
