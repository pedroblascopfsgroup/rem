--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160211
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=GC-1103
--## PRODUCTO=NO
--## 
--## Finalidad: Update insolventes
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_DATASTAGE#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='CARGAR_TABLA_PARAMETROS';
 ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);

BEGIN 

V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||TABLA||' SET CLAUSULA_WHERE = ''TRUNC(A.FECHACREAR) > (select NVL(max(trunc(FECHACREAR)), TO_DATE(''''01/01/1900'''', ''''dd/mm/yyyy'''')) from EXT_IAC_INFO_ADD_CONTRATO) and DD_IFC_ID in (7, 10, 46, 48)'' where nombre_tabla_destino = ''EXT_IAC_INFO_ADD_CONTRATO''';

EXECUTE IMMEDIATE V_MSQL;
COMMIT;
DBMS_OUTPUT.PUT_LINE('UPDATE OK');


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
