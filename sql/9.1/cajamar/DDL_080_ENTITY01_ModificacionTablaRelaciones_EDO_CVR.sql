--##########################################
--## AUTOR=Enrique Jim�nez D�az
--## FECHA_CREACION=20151015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-915
--## PRODUCTO=NO
--## 
--## Finalidad: Modificaci�n campos contratos para cajamar
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versi�n inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR(25) := '#ESQUEMA#';
 TABLA VARCHAR(30) :='CPE_CONTRATOS_PERSONAS';
 err_num NUMBER;
 err_msg VARCHAR2(2048);
 V_MSQL VARCHAR2(2500 CHAR);
 V_MSQL2 VARCHAR2(2500 CHAR);


BEGIN


  V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||TABLA||' SET CNT_PER_EDO_CICLO_VIDA_REL = NULL';


 EXECUTE IMMEDIATE V_MSQL;
 
 DBMS_OUTPUT.PUT_LINE('Ejecutado el UPDATE');
  
 
 V_MSQL2 := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  MODIFY
             (
                CNT_PER_EDO_CICLO_VIDA_REL  NUMBER(10)
             )';


 EXECUTE IMMEDIATE V_MSQL2;


 DBMS_OUTPUT.PUT_LINE('Ejecutado el ALTER');


 V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||TABLA||q'[ SET CNT_PER_EDO_CICLO_VIDA_REL = (select DD_ECV_ID from DD_ECV_ESTADO_CICLO_VIDA where DD_ECV_CODIGO = 'VIVA')]';

 EXECUTE IMMEDIATE V_MSQL;

 DBMS_OUTPUT.PUT_LINE('Ejecutado el UPDATE POR ID');



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
