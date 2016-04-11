--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20160210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1942
--## PRODUCTO=NO
--## 
--## Finalidad: Iniciar secuencia de asuntos en 300000001 para HRE
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

 V_ESQUEMA VARCHAR2(25 CHAR):=   'HAYA02'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; 		-- Configuracion Esquema Master
 TABLA VARCHAR(30) :='ASU_ASUNTOS';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 S_MSQL VARCHAR2(8500 CHAR);
 S_MSQL1 VARCHAR2(8500 CHAR); 
 V_EXISTE NUMBER (1);
 SECUENCIA VARCHAR(30) :='S_ASU_ASUNTOS';


BEGIN 

--Validamos si la secuencia existe para hacer la secuencia.

  SELECT COUNT(*) INTO V_EXISTE 
  FROM user_sequences 
  WHERE sequence_name = ''||SECUENCIA||'';

     S_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||SECUENCIA||' 
     INCREMENT BY 1 
     START WITH 300000001 
     MINVALUE 300000001 
     MAXVALUE 999999999999999999999999999 
     CACHE 100 NOORDER  
     NOCYCLE ';

     S_MSQL1 := 'DROP SEQUENCE '||V_ESQUEMA||'.'||SECUENCIA;


IF V_EXISTE = 0 THEN   
    
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE(SECUENCIA||' CREADA');
ELSE 

     EXECUTE IMMEDIATE S_MSQL1;
     DBMS_OUTPUT.PUT_LINE('SECUENCIA BORRADA '||SECUENCIA||'');      
     DBMS_OUTPUT.PUT_LINE(SECUENCIA||' CREADA');
     EXECUTE IMMEDIATE S_MSQL;
     DBMS_OUTPUT.PUT_LINE(SECUENCIA||' CREADA');
     
END IF; 

--Fin crear secuencia

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

