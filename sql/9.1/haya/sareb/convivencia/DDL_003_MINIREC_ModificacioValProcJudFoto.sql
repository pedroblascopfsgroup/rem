--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=20160406
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-911
--## PRODUCTO=NO
--## 
--## Finalidad: Modificacion columna en VAL_PROC_JUDICIAL_FOTO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA_MINIREC#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='VAL_PROC_JUDICIAL_FOTO';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_LENGTH_MOTIVO_CIERRE VARCHAR(2500);



BEGIN 

  V_LENGTH_MOTIVO_CIERRE:=0;
  

  BEGIN 
	  -- MIRA DE CUANTOS CARACTERES ES LA COLUMNA
	  select  CHAR_LENGTH INTO V_LENGTH_MOTIVO_CIERRE
	  from ALL_TAB_COLUMNS
	  WHERE TABLE_NAME = ||TABLA
		  AND COLUMN_NAME = 'MOTIVO_CIERRE';
  
	  DBMS_OUTPUT.PUT_LINE('LA COLUMNA MOTIVO_CIERRE TIENE '||V_LENGTH_HITO_ACTUAL||' CARACTERES');
  
	  -- CAMBIA A CARACTER CORRECTO COD_HITO_ACTUAL
	   IF V_LENGTH_MOTIVO_CIERRE <=2500 then
		   DBMS_OUTPUT.put_line('COD_HITO_ACTUAL YA ES TIENE 2500 CARATERES');
	   ELSE
		   V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||TABLA||' MODIFY MOTIVO_CIERRE VARCHAR2(2500)';
		   EXECUTE IMMEDIATE V_MSQL;
		   DBMS_OUTPUT.put_line('MOTIVO_CIERRE SE HA MODIFICADO A 2500 CARACTERES');
	   END IF;
      EXECUTE IMMEDIATE V_MSQL;
  END;
 
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
EXIT;
