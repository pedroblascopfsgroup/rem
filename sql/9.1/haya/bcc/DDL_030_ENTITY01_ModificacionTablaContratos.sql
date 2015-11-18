--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
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

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='CNT_CONTRATOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR); 


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
                SALDO_PASIVO_OTROS NUMBER(15,2)
              , CNT_SALDO_MUY_DUDOSO NUMBER(15,2)
              , CNT_SALDO_VENC_NO_RECLAM NUMBER(15,2)
              , CONTRATO_PADRE_NIVEL_2 NUMBER(22)
            )';

  V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  MODIFY
             (     
                  CNT_CUOTA_IMPORTE	     NUMBER(15,2)
                , CNT_DISPUESTO              NUMBER(15,2)
                , CNT_LIMITE_INI	     NUMBER (15,2)
                , CNT_LIMITE_FIN	     NUMBER(15,2)
                , CNT_SISTEMA_AMORTIZACION   VARCHAR2(32)
                , CNT_INTERES_FIJO_VAR	     VARCHAR2(4)
                , CNT_CCC_DOMICILIACION	     VARCHAR2(80)
                , CNT_DOMICI_EXT	     VARCHAR2(4)
                , CNT_COD_OFICINA	     NUMBER(12)
              )';
     
	 EXECUTE IMMEDIATE V_MSQL;
	 EXECUTE IMMEDIATE V_MSQL2;	 

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