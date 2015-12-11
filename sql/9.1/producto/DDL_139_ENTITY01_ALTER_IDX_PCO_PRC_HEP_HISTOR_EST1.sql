--/*
--##########################################
--## AUTOR=Alberto b	
--## FECHA_CREACION=20151211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc33
--## INCIDENCIA_LINK=CMREC-1500
--## PRODUCTO=SI
--## 
--## Finalidad: Creación de indice 
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE
 
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;
 


BEGIN 

--Validamos si la tabla existe antes de crearla
  V_MSQL := 'SELECT COUNT(1) FROM USER_INDEXES WHERE INDEX_NAME = ''IDX_PCO_PRC_HEP_HISTOR_EST1''';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
	
	IF V_EXISTE > 0 THEN
		V_MSQL := 'DROP INDEX IDX_PCO_PRC_HEP_HISTOR_EST1';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('INDICE BORRADO');
		
		V_MSQL := 'CREATE INDEX IDX_PCO_PRC_HEP_HISTOR_EST1 ON '||V_ESQUEMA||'.PCO_PRC_HEP_HISTOR_EST_PREP(PCO_PRC_HEP_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('INDICE CREADO');
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('NO EXISTE EL INDICE');
		
	END IF;	
	
	COMMIT;



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

