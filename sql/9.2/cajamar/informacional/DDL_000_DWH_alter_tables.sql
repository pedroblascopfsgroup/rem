--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160627
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BI-131 y BI-123
--## PRODUCTO=NO
--## 
--## Finalidad:  Gestores, supervisores; y nuevos detalles expediente-contratos, expediente-personas.
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 TABLA VARCHAR(30) :='TMP_EXP_CNT';
 
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD (CNT_ES_PASE_ID NUMBER(16,0))';

EXECUTE IMMEDIATE V_MSQL;


COMMIT;
DBMS_OUTPUT.PUT_LINE('ALTER OK');


--Excepciones
          

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
EXIT
