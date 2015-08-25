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
 TABLA VARCHAR(30) :='CPE_CONTRATOS_PERSONAS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);


BEGIN 
  

  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD
             (
                CNT_PER_EDO_CICLO_VIDA_REL VARCHAR2(40)
              , CNT_PER_FEC_CLO_VIDA_REL DATE
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