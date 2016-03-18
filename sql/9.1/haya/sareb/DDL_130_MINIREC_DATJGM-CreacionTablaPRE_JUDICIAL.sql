--/*
--##########################################
--## AUTOR=JUAN GALLEGO MOLERO
--## FECHA_CREACION=09032016
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HR-2009
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla PRE_JUDICIAL
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;



DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 			      -- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		      -- Configuracion Esquema Master
 TABLA VARCHAR(30) :='PRE_JUDICIAL';
 TABLA_H VARCHAR (30) := 'H_PRE_JUDICIAL';
 err_num NUMBER;
 err_msg VARCHAR2(2048 CHAR); 
 V_MSQL VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1);
 



BEGIN 

--Validamos si la tabla existe antes de crearla

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA;
  

  
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||' 
   (	
	ID_ASUNTO_HRE 			NUMBER(16,0),		   
	NUM_CUENTA 			NUMBER(38,0), 
	ID_USUARIO_HAYA 		VARCHAR2(50 CHAR),
	FC_WF_SANCION_PASE_A_LITIGIO 	DATE,
	FC_ALTA_PRECONTENCIOSO 		DATE,
	FC_SOLICITUD_DOCUMENTACION 	DATE,
	IN_TITULOS 			VARCHAR2(2 CHAR),
	FC_PENDIENTE_LIQUIDAR 		DATE,
	FC_ENVIO_NOTARIA 		DATE,
	FC_RECIBO_NOTARIA 		DATE,
	FC_BUROFAX_REMITIDO 		DATE,
	FC_ACUSE_BUROFAX 		DATE,
	FC_WF_ENVIO_LITIGIO 		DATE,
	FC_WF_LITIGIO_SANCION_SAREB 	DATE,
	FC_TURNADO 			DATE,
	FC_PARALIZADO 			DATE
   )';
 
 
  IF V_EXISTE = 0 THEN     
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA||' BORRADA');  
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA||' CREADA');  
    
  END IF;   
  
  
--Validamos si la tabla existe antes de crearla (HISTORICO)

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA_H;
  
  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA_H||' 
   (	
  FECHA_HISTORICO DATE,
	ID_ASUNTO_HRE 			NUMBER(16,0),		   
	NUM_CUENTA 			NUMBER(38,0), 
	ID_USUARIO_HAYA 		VARCHAR2(50 CHAR),
	FC_WF_SANCION_PASE_A_LITIGIO 	DATE,
	FC_ALTA_PRECONTENCIOSO 		DATE,
	FC_SOLICITUD_DOCUMENTACION 	DATE,
	IN_TITULOS 			VARCHAR2(2 CHAR),
	FC_PENDIENTE_LIQUIDAR 		DATE,
	FC_ENVIO_NOTARIA 		DATE,
	FC_RECIBO_NOTARIA 		DATE,
	FC_BUROFAX_REMITIDO 		DATE,
	FC_ACUSE_BUROFAX 		DATE,
	FC_WF_ENVIO_LITIGIO 		DATE,
	FC_WF_LITIGIO_SANCION_SAREB 	DATE,
	FC_TURNADO 			DATE,
	FC_PARALIZADO 			DATE
   )';
   
  IF V_EXISTE = 0 THEN     
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA_H||' CREADA');
  ELSE   
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA_H||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA_H||' BORRADA');  
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('TABLA '||V_ESQUEMA||'.'||TABLA_H||' CREADA');  
    
  END IF;   

--Fin crear tabla

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
