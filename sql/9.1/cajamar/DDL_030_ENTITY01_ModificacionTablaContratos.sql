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

 V_ESQUEMA VARCHAR(25) := 'CM01';
 TABLA VARCHAR(30) :='CNT_CONTRATOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
                CNT_COD_OFI_OP NUMBER(12)
              , CNT_NUM_ESPEC NUMBER(15)
              , CNT_POS_VIVA_NO_VENCIDA NUMBER(15,2)
              , CNT_POS_VIVA_VENCIDA NUMBER(15,2)
              , CNT_DEUDA_IRREGULAR NUMBER(15,2)
              , CNT_INT_REMUNERATORIOS NUMBER(15,2)
              , CNT_INT_MORATORIOS NUMBER(15,2)
              , CNT_COMISIONES NUMBER(15,2)
              , CNT_GASTOS NUMBER(15,2)
              , CNT_IMPUESTOS NUMBER(15,2)
              , CNT_ENTREGAS NUMBER(15,2)
              , CNT_INTERESES_ENTREGAS NUMBER(15,2)
              , CNT_CUOTAS_VENCIDAS_IMP NUMBER(3)
              , CNT_PTE_DESEMBOLSO NUMBER(15,2)
              , CNT_SALDO_EXCE NUMBER(15,2)
              , CNT_LIMITE_DESC NUMBER(15,2)
              , CNT_LTV_INI NUMBER(5,2)
              , CNT_LTV_FIN NUMBER(5,2)
              , CNT_SALDO_PASIVO NUMBER(15,2)
              , SALDO_PASIVO_OTROS NUMBER(15,2)
              , CNT_SALDO_DUDOSO NUMBER(15,2)
              , CNT_SALDO_MUY_DUDOSO NUMBER(15,2)
              , CNT_PROVISION NUMBER(15,2)
              , CNT_PORCEN_PROVISION NUMBER(5,2)
              , CNT_RIESGO NUMBER(15,2)
              , CNT_RIESGO_GARANT NUMBER(15,2)
              , CNT_FECHA_INI_EPI_IRREG DATE
              , CNT_FECHA_POS_VENCIDA DATE
              , CNT_FECHA_DUDOSO DATE
              , CNT_SCORING VARCHAR2(40)
              , CNT_FECHA_RECIBO_DEV_ANT DATE
              , CNT_SALDO_VENC_NO_RECLAM NUMBER(15,2)
              , CONTRATO_PADRE_NIVEL_1 NUMBER(22)
              , CONTRATO_PADRE_NIVEL_2 NUMBER(22)
            )';

     
	 EXECUTE IMMEDIATE V_MSQL;

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