--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2314
--## PRODUCTO=NO
--## 
--## Finalidad: Garantía núm. operación bien 
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='D_BIE_NUM_OPERACION';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||'  ADD (GARANTIA_NUM_OPE_BIE_ID NUMBER(16))';

EXECUTE IMMEDIATE V_MSQL;

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.D_PRC  ADD (GESTOR_PRC_HAYA_ID NUMBER(16), CON_POSTORES_ID NUMBER(16,0))';

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
